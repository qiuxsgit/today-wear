import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme_tokens.dart';
import '../theme/app_text_style.dart';
import '../database/database.dart';
import '../repositories/outfit_repository.dart';
import '../models/outfit.dart';
import '../theme/tag_colors.dart';
import '../services/image_service.dart';
import '../widgets/app_toast.dart';

/// 添加/编辑穿搭页面
/// 
/// 支持图片选择、标签管理和备注输入
/// 支持编辑模式（传入 outfit 参数）
class AddOutfitPage extends StatefulWidget {
  /// 数据保存成功后的回调
  final VoidCallback? onDataSaved;
  
  /// 编辑模式时传入的 outfit 数据（null 表示新建模式）
  final Outfit? outfit;
  
  const AddOutfitPage({
    super.key,
    this.onDataSaved,
    this.outfit,
  });
  
  @override
  State<AddOutfitPage> createState() => AddOutfitPageState();
}

class AddOutfitPageState extends State<AddOutfitPage> {
  late final OutfitRepository _repository;
  late final AppDatabase _db;
  AppLocalizations get _l10n => AppLocalizations.of(context)!;
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  
  /// 最多可选择的图片数量
  static const int maxImages = 9;
  
  /// 是否为编辑模式
  late final bool _isEditMode;
  
  /// 编辑时的 outfit ID
  int? _editingOutfitId;
  
  /// 已选择的图片文件（新建模式）或现有图片路径（编辑模式）
  /// 编辑模式下，字符串格式为 `path:relativePath` 或 `file:tempPath`
  List<String> _selectedImageRefs = [];
  final List<File> _tempImageFiles = []; // 临时文件引用

  /// 图片文件缓存，避免 FutureBuilder 在 rebuild 时重复加载
  final Map<String, File?> _imageFileCache = {};

  List<String> _selectedTags = [];
  List<String> _availableTags = [];
  bool _isSaving = false;
  bool _isLoadingTags = true;
  bool _isLoadingExistingData = false;
  
  @override
  void initState() {
    super.initState();
    _isEditMode = widget.outfit != null;
    _db = AppDatabase();
    _repository = OutfitRepository(_db);
    
    if (_isEditMode) {
      _editingOutfitId = widget.outfit!.id;
      _loadExistingData();
    } else {
      _loadAvailableTags();
    }
  }
  
  @override
  void dispose() {
    _descriptionController.dispose();
    _tagController.dispose();
    // 清理临时文件
    for (final file in _tempImageFiles) {
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    super.dispose();
  }
  
  /// 加载已有穿搭数据（编辑模式）
  Future<void> _loadExistingData() async {
    setState(() => _isLoadingExistingData = true);
    
    try {
      final outfit = widget.outfit!;
      
      _descriptionController.text = outfit.description;
      _selectedTags = List.from(outfit.tags);
      
      // 加载现有图片路径
      _selectedImageRefs = outfit.photoPaths.map((path) => "path:$path").toList();

      // 预加载图片文件到缓存，避免 FutureBuilder 在 rebuild 时重复加载
      for (final path in outfit.photoPaths) {
        _imageFileCache["path:$path"] = await ImageService.instance.getImageFile(path);
      }

      await _loadAvailableTags();
      
      setState(() {
        _isLoadingExistingData = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingExistingData = false;
      });
      AppToast.error(_l10n.errLoadData(e.toString()));
    }
  }
  
  /// 加载可用标签列表
  Future<void> _loadAvailableTags() async {
    try {
      final tags = await _db.tagDao.getAllTags();
      setState(() {
        _availableTags = tags.map((t) => t.name).toList();
        _isLoadingTags = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingTags = false;
      });
      AppToast.error(_l10n.errLoadTags(e.toString()));
    }
  }
  
  /// 从相册选择多张图片
  Future<void> _pickImagesFromGallery() async {
    try {
      // 检查是否已达到最大数量
      if (_selectedImageRefs.length >= maxImages) {
        AppToast.warning(_l10n.warnImageLimit(maxImages));
        return;
      }

      List<XFile> images = [];
      
      // 优先尝试多选
      try {
        images = await _imagePicker.pickMultiImage();
      } catch (e) {
        // 如果多选不支持或失败，尝试单选
        final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          images = [image];
        }
      }
      
      if (images.isNotEmpty) {
        final remainingSlots = maxImages - _selectedImageRefs.length;
        
        if (images.length > remainingSlots) {
          images = images.take(remainingSlots).toList();
          AppToast.warning(_l10n.warnImageLimitExceeded(maxImages, remainingSlots));
        }
        
        setState(() {
          for (final xfile in images) {
            final ref = "file:${xfile.path}";
            final file = File(xfile.path);
            _selectedImageRefs.add(ref);
            _tempImageFiles.add(file);
            _imageFileCache[ref] = file; // 缓存文件，避免重复加载
          }
        });
      }
    } catch (e) {
      AppToast.error(_l10n.errSelectImage(e.toString()));
    }
  }
  
  /// 拍照
  Future<void> _takePhoto() async {
    try {
      if (_selectedImageRefs.length >= maxImages) {
        AppToast.warning(_l10n.warnImageLimit(maxImages));
        return;
      }

      final XFile? image = await _imagePicker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() {
          final ref = "file:${image.path}";
          final file = File(image.path);
          _selectedImageRefs.add(ref);
          _tempImageFiles.add(file);
          _imageFileCache[ref] = file; // 缓存文件，避免重复加载
        });
      }
    } catch (e) {
      AppToast.error(_l10n.errTakePhoto(e.toString()));
    }
  }
  
  /// 显示图片选择对话框
  Future<void> _showImagePickerDialog() async {
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: context.tt.page,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(_l10n.addOutfitFromGallery),
              onTap: () {
                Navigator.pop(context);
                _pickImagesFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(_l10n.addOutfitTakePhotoOption),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
  
  /// 删除图片
  void _removeImage(int index) async {
    final ref = _selectedImageRefs[index];
    
    if (ref.startsWith("path:")) {
      // 编辑模式下删除已有图片
      final imagePath = ref.substring(5);
      if (_editingOutfitId != null) {
        await _repository.removeImageFromOutfit(_editingOutfitId!, imagePath);
      }
    } else if (ref.startsWith("file:")) {
      // 删除临时文件
      final filePath = ref.substring(5);
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
      _tempImageFiles.removeWhere((f) => f.path == filePath);
    }
    
    setState(() {
      _imageFileCache.remove(ref); // 清理缓存
      _selectedImageRefs.removeAt(index);
    });
  }
  
  /// 图片重新排序
  void _reorderImages(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _selectedImageRefs.removeAt(oldIndex);
      _selectedImageRefs.insert(newIndex, item);
    });
  }
  
  /// 切换标签选择状态
  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }
  
  /// 添加新标签
  void _addNewTag() {
    final tag = _tagController.text.trim();
    if (tag.isEmpty) {
      return;
    }
    
    if (_selectedTags.contains(tag)) {
      _tagController.clear();
      AppToast.warning(_l10n.warnTagAlreadyExists);
      return;
    }
    
    setState(() {
      _selectedTags.add(tag);
      _tagController.clear();
    });
  }
  
  /// 删除已选标签
  void _removeTag(String tag) {
    setState(() {
      _selectedTags.remove(tag);
    });
  }
  
  /// 保存穿搭记录
  Future<void> _saveOutfit() async {
    // 验证图片
    if (_selectedImageRefs.isEmpty) {
      if (!mounted) return;
      AppToast.warning(_l10n.warnSelectAtLeastOneImage);
      return;
    }
    
    // 验证备注
    if (_descriptionController.text.trim().isEmpty) {
      if (!mounted) return;
      AppToast.warning(_l10n.warnEnterDescription);
      return;
    }
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      if (_isEditMode && _editingOutfitId != null) {
        // 编辑模式
        await _updateOutfit();
      } else {
        // 新建模式
        await _createOutfit();
      }
      
      if (!mounted) return;

      AppToast.success(_l10n.successOutfitSaved);
      await Future.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;

      if (_isEditMode) {
        Navigator.pop(context, true);
      } else {
        widget.onDataSaved?.call();
      }
    } catch (e) {
      if (!mounted) return;
      AppToast.error(_l10n.errSaveOutfit(e.toString()));
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
  
  /// 创建新穿搭
  Future<void> _createOutfit() async {
    // 收集实际的文件
    final imageFiles = <File>[];
    for (final ref in _selectedImageRefs) {
      if (ref.startsWith("file:")) {
        final file = File(ref.substring(5));
        if (await file.exists()) {
          imageFiles.add(file);
        }
      }
    }
    
    final outfit = Outfit(
      id: 0,
      date: DateTime.now(),
      description: _descriptionController.text.trim(),
      tags: _selectedTags,
      tagColors: List.filled(_selectedTags.length, TagColors.defaultColorHex),
      photoPaths: [],
    );
    
    await _repository.saveOutfit(outfit, imageFiles: imageFiles);
  }
  
  /// 更新已有穿搭
  Future<void> _updateOutfit() async {
    if (_editingOutfitId == null) return;
    
    // 分离已有图片路径和新添加的图片文件
    final existingPaths = <String>[];
    final newImageFiles = <File>[];
    
    for (final ref in _selectedImageRefs) {
      if (ref.startsWith("path:")) {
        existingPaths.add(ref.substring(5));
      } else if (ref.startsWith("file:")) {
        final file = File(ref.substring(5));
        if (await file.exists()) {
          newImageFiles.add(file);
        }
      }
    }
    
    // 获取现有图片
    final existingImages = await _db.imageDao.getImagesByOutfitId(_editingOutfitId!);
    final existingPathSet = existingPaths.toSet();
    
    // 删除不在新列表中的图片（文件和数据库记录）
    for (final img in existingImages) {
      if (!existingPathSet.contains(img.imagePath)) {
        await _repository.removeImageFromOutfit(_editingOutfitId!, img.imagePath);
      }
    }
    
    // 保存新图片到文件系统，并构建路径映射
    final newPathMap = <String, String>{}; // tempPath -> relativePath
    if (newImageFiles.isNotEmpty) {
      for (int i = 0; i < newImageFiles.length; i++) {
        final tempPath = newImageFiles[i].path;
        final relativePath = await ImageService.instance.saveImage(
          newImageFiles[i],
          _editingOutfitId!,
          i, // 临时顺序，后面会统一更新
          widget.outfit!.date,
        );
        newPathMap[tempPath] = relativePath;
      }
    }
    
    // 构建最终排序后的图片路径列表（按照 _selectedImageRefs 的顺序）
    final orderedPaths = <String>[];
    for (final ref in _selectedImageRefs) {
      if (ref.startsWith("path:")) {
        orderedPaths.add(ref.substring(5));
      } else if (ref.startsWith("file:")) {
        final tempPath = ref.substring(5);
        final relativePath = newPathMap[tempPath];
        if (relativePath != null) {
          orderedPaths.add(relativePath);
        }
      }
    }
    
    // 批量插入新图片的数据库记录
    if (newImageFiles.isNotEmpty) {
      final imageCompanions = <OutfitImagesCompanion>[];
      for (int i = 0; i < newImageFiles.length; i++) {
        final tempPath = newImageFiles[i].path;
        final relativePath = newPathMap[tempPath];
        if (relativePath != null) {
          // 找到这张图片在最终顺序中的位置
          final order = orderedPaths.indexOf(relativePath);
          imageCompanions.add(
            OutfitImagesCompanion.insert(
              outfitId: _editingOutfitId!,
              imagePath: relativePath,
              displayOrder: order,
            ),
          );
        }
      }
      if (imageCompanions.isNotEmpty) {
        await _db.imageDao.insertImages(imageCompanions);
      }
    }
    
    // 更新所有图片的显示顺序（确保与 UI 一致）
    await _repository.updateImageOrder(_editingOutfitId!, orderedPaths);
    
    // 更新描述和标签
    final outfit = Outfit(
      id: _editingOutfitId!,
      date: widget.outfit!.date,
      description: _descriptionController.text.trim(),
      tags: _selectedTags,
      tagColors: List.filled(_selectedTags.length, TagColors.defaultColorHex),
      photoPaths: [],
    );
    
    await _repository.saveOutfit(outfit);
  }
  
  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    if (_isEditMode && _isLoadingExistingData) {
      return Scaffold(
        backgroundColor: tt.page,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: tt.page,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildCustomTopBar(),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        behavior: HitTestBehavior.opaque,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!_isEditMode) _buildHeroSection(),
                            const SizedBox(height: 16),
                            _buildImageSection(),
                            const SizedBox(height: 24),
                            _buildTagSection(),
                            const SizedBox(height: 24),
                            _buildNewTagInput(),
                            const SizedBox(height: 24),
                            _buildDescriptionInput(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
              color: tt.page,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveOutfit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tt.ink,
                    foregroundColor: tt.page,
                    disabledBackgroundColor: tt.muted,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(tt.page),
                          ),
                        )
                      : Text(
                          _isEditMode ? _l10n.addOutfitSaveEditBtn : _l10n.addOutfitSaveBtn,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: tt.page,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTopBar() {
    final tt = context.tt;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          _RoundBtn(
            icon: Icons.arrow_back_ios_new,
            onTap: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Center(
              child: Text(
                _l10n.addOutfitTitle,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: tt.ink),
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    final tt = context.tt;
    final now = DateTime.now();
    const monthNames = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
    final monthStr = monthNames[now.month - 1];

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: tt.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x14554230), blurRadius: 28, offset: Offset(0, 10))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_l10n.addOutfitHeroEyebrow, style: AppTextStyle.eyebrow.copyWith(color: tt.muted)),
                const SizedBox(height: 8),
                Text(
                  _l10n.addOutfitHeroText,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: tt.ink, height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: const Alignment(-0.5, -1),
                end: const Alignment(0.5, 1),
                colors: [tt.accent, tt.ink],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(monthStr, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: tt.page)),
                Text('${now.day}', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w800, color: tt.page, height: 1.1)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// 构建图片选择区域（支持拖拽排序）
  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _l10n.addOutfitPhotosSection,
              style: AppTextStyle.title,
            ),
            if (_selectedImageRefs.length > 1)
              Text(
                _l10n.addOutfitDragHint,
                style: AppTextStyle.hint.copyWith(fontSize: 12),
              ),
          ],
        ),
        const SizedBox(height: 12),
        // 使用 ReorderableGridView 实现拖拽排序
        ReorderableGridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _selectedImageRefs.length < maxImages 
              ? _selectedImageRefs.length + 1 
              : _selectedImageRefs.length,
          onReorder: _reorderImages,
          itemBuilder: (context, index) {
            if (_selectedImageRefs.length < maxImages && index == _selectedImageRefs.length) {
              final tt = context.tt;
              return GestureDetector(
                key: const ValueKey('add_button'),
                onTap: _showImagePickerDialog,
                child: Container(
                  decoration: BoxDecoration(
                    color: tt.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: tt.line, style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 32, color: tt.muted),
                      const SizedBox(height: 4),
                      Text(
                        _l10n.addOutfitAddPhotoBtn,
                        style: AppTextStyle.body.copyWith(fontSize: 12, color: tt.muted),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            final ref = _selectedImageRefs[index];
            return Stack(
              key: ValueKey(ref),
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildImageWidget(ref),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _removeImage(index),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
  
  /// 构建单个图片 Widget
  Widget _buildImageWidget(String ref) {
    final tt = context.tt;
    // 优先使用缓存，避免 FutureBuilder 在 rebuild 时重复加载
    if (_imageFileCache.containsKey(ref)) {
      final file = _imageFileCache[ref];
      if (file != null && file.existsSync()) {
        return Image.file(file, fit: BoxFit.cover);
      }
      return Container(
        color: tt.mist,
        child: Icon(Icons.broken_image, color: tt.muted),
      );
    }
    if (ref.startsWith("path:")) {
      final path = ref.substring(5);
      return FutureBuilder<File?>(
        future: ImageService.instance.getImageFile(path),
        builder: (context, snapshot) {
          final t = context.tt;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: t.mist,
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          final file = snapshot.data;
          if (file != null) {
            _imageFileCache[ref] = file;
          }
          if (file == null || !file.existsSync()) {
            return Container(
              color: t.mist,
              child: Icon(Icons.broken_image, color: t.muted),
            );
          }
          return Image.file(file, fit: BoxFit.cover);
        },
      );
    } else if (ref.startsWith("file:")) {
      final path = ref.substring(5);
      final file = File(path);
      if (!file.existsSync()) {
        return Container(
          color: tt.mist,
          child: Icon(Icons.broken_image, color: tt.muted),
        );
      }
      return Image.file(file, fit: BoxFit.cover);
    }
    return Container(
      color: tt.mist,
      child: Icon(Icons.broken_image, color: tt.muted),
    );
  }
  
  /// 构建标签选择区域
  Widget _buildTagSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _l10n.addOutfitTagsSection,
          style: AppTextStyle.title,
        ),
        const SizedBox(height: 12),
        if (_isLoadingTags)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (_availableTags.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              _l10n.addOutfitNoTagsHint,
              style: AppTextStyle.hint,
            ),
          )
        else
          Builder(
            builder: (context) {
              final tt = context.tt;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableTags.map((tag) {
                  final isSelected = _selectedTags.contains(tag);
                  return FilterChip(
                    label: Text(tag),
                    selected: isSelected,
                    onSelected: (_) => _toggleTag(tag),
                    backgroundColor: tt.surface,
                    selectedColor: tt.mist,
                    checkmarkColor: tt.ink,
                    labelStyle: TextStyle(
                      color: isSelected ? tt.ink : tt.muted,
                    ),
                  );
                }).toList(),
              );
            },
          ),
        const SizedBox(height: 16),
        if (_selectedTags.isNotEmpty) ...[
          Text(
            _l10n.addOutfitSelectedTagsLabel,
            style: AppTextStyle.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Builder(
            builder: (context) {
              final tt = context.tt;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedTags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    onDeleted: () => _removeTag(tag),
                    backgroundColor: tt.mist,
                    deleteIcon: const Icon(Icons.close, size: 18),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ],
    );
  }
  
  /// 构建新标签输入区域
  Widget _buildNewTagInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _l10n.addOutfitNewTagSection,
          style: AppTextStyle.title,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tagController,
                enabled: true,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: _l10n.addOutfitTagInputHint,
                  hintStyle: AppTextStyle.hint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                style: AppTextStyle.body,
                onSubmitted: (_) => _addNewTag(),
                textInputAction: TextInputAction.done,
              ),
            ),
            const SizedBox(width: 8),
            Builder(
              builder: (context) {
                final tt = context.tt;
                return ElevatedButton(
                  onPressed: _addNewTag,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tt.ink,
                    foregroundColor: tt.page,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(_l10n.addOutfitAddTagBtn),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
  
  /// 构建备注输入区域
  Widget _buildDescriptionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _l10n.addOutfitDescSection,
          style: AppTextStyle.title,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionController,
          enabled: true,
          autofocus: false,
          decoration: InputDecoration(
            hintText: _l10n.addOutfitDescHint,
            hintStyle: AppTextStyle.hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          style: AppTextStyle.body,
          maxLines: 5,
          textInputAction: TextInputAction.newline,
        ),
      ],
    );
  }
}

class _RoundBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final tt = context.tt;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: tt.surface,
          shape: BoxShape.circle,
          border: Border.all(color: tt.line),
          boxShadow: const [BoxShadow(color: Color(0x14554230), blurRadius: 18, offset: Offset(0, 8))],
        ),
        child: Icon(icon, size: 18, color: tt.ink),
      ),
    );
  }
}
