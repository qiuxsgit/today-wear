import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:today_wear/l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../database/database.dart';
import '../repositories/outfit_repository.dart';
import '../models/outfit.dart';

/// 添加穿搭页面
/// 
/// 支持图片选择、标签管理和备注输入
class AddOutfitPage extends StatefulWidget {
  /// 数据保存成功后的回调
  final VoidCallback? onDataSaved;
  
  const AddOutfitPage({
    super.key,
    this.onDataSaved,
  });
  
  @override
  State<AddOutfitPage> createState() => AddOutfitPageState();
}

class AddOutfitPageState extends State<AddOutfitPage> {
  late final OutfitRepository _repository;
  late final AppDatabase _db;
  final _descriptionController = TextEditingController();
  final _tagController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  
  /// 最多可选择的图片数量
  static const int maxImages = 9;
  
  List<File> _selectedImages = [];
  List<String> _selectedTags = [];
  List<String> _availableTags = [];
  bool _isSaving = false;
  bool _isLoadingTags = true;
  
  @override
  void initState() {
    super.initState();
    _db = AppDatabase();
    _repository = OutfitRepository(_db);
    _loadAvailableTags();
  }
  
  @override
  void dispose() {
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('加载标签失败: $e')),
        );
      }
    }
  }
  
  /// 从相册选择多张图片
  Future<void> _pickImagesFromGallery() async {
    try {
      // 检查是否已达到最大数量
      if (_selectedImages.length >= maxImages) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('最多只能选择 $maxImages 张图片')),
          );
        }
        return;
      }
      
      List<XFile> images = [];
      
      // 优先尝试多选
      try {
        images = await _imagePicker.pickMultiImage();
      } catch (e) {
        // 如果多选不支持或失败，尝试单选
        // 用户可以多次选择来添加多张图片
        final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          images = [image];
        }
      }
      
      if (images.isNotEmpty) {
        // 计算还可以添加多少张图片
        final remainingSlots = maxImages - _selectedImages.length;
        
        // 如果选择的图片超过剩余数量，只保留前面的图片
        if (images.length > remainingSlots) {
          images = images.take(remainingSlots).toList();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('最多只能选择 $maxImages 张图片，已保留前 $remainingSlots 张')),
            );
          }
        }
        
        setState(() {
          _selectedImages.addAll(images.map((xfile) => File(xfile.path)));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('选择图片失败: $e')),
        );
      }
    }
  }
  
  /// 拍照
  Future<void> _takePhoto() async {
    try {
      // 检查是否已达到最大数量
      if (_selectedImages.length >= maxImages) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('最多只能选择 $maxImages 张图片')),
          );
        }
        return;
      }
      
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
      );
      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('拍照失败: $e')),
        );
      }
    }
  }
  
  /// 显示图片选择对话框
  Future<void> _showImagePickerDialog() async {
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgPrimary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
              onTap: () {
                Navigator.pop(context);
                _pickImagesFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
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
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
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
    
    // 检查是否已存在
    if (_selectedTags.contains(tag)) {
      _tagController.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('标签已存在')),
        );
      }
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
  
  /// 清空表单数据
  void _clearForm() {
    setState(() {
      _selectedImages.clear();
      _selectedTags.clear();
      _descriptionController.clear();
      _tagController.clear();
    });
  }
  
  /// 保存穿搭记录
  Future<void> _saveOutfit() async {
    // 验证图片
    if (_selectedImages.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请至少选择一张图片')),
      );
      return;
    }
    
    // 验证备注
    if (_descriptionController.text.trim().isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入备注')),
      );
      return;
    }
    
    setState(() {
      _isSaving = true;
    });
    
    try {
      final outfit = Outfit(
        id: 0, // 新建
        date: DateTime.now(),
        description: _descriptionController.text.trim(),
        tags: _selectedTags,
        photoPaths: [], // 保存时由 repository 处理
      );
      
      await _repository.saveOutfit(outfit, imageFiles: _selectedImages);
      
      if (!mounted) return;
      
      // 显示成功消息
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('保存成功'),
          backgroundColor: AppColors.success,
        ),
      );
      
      // 清空表单数据
      _clearForm();
      
      // 通知外部数据已保存，需要刷新首页
      widget.onDataSaved?.call();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('保存失败: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: AppColors.bgPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 图片选择区域
                          _buildImageSection(),
                          const SizedBox(height: 24),
                          // 标签选择区域
                          _buildTagSection(),
                          const SizedBox(height: 24),
                          // 新标签输入区域
                          _buildNewTagInput(),
                          const SizedBox(height: 24),
                          // 备注输入区域
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
          // 底部保存按钮
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.bgPrimary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveOutfit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.textSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          l10n.save,
                          style: AppTextStyle.title.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
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
  
  /// 构建图片选择区域
  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '选择图片',
          style: AppTextStyle.title,
        ),
        const SizedBox(height: 12),
        // 图片网格（包含已选图片和添加按钮）
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          // 如果图片数量达到最大值，不显示添加按钮
          itemCount: _selectedImages.length < maxImages 
              ? _selectedImages.length + 1 
              : _selectedImages.length,
          itemBuilder: (context, index) {
            // 如果图片数量未达到最大值，且是最后一个位置，显示添加按钮
            if (_selectedImages.length < maxImages && index == _selectedImages.length) {
              return GestureDetector(
                onTap: _showImagePickerDialog,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.bgSecondary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.textSecondary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        size: 32,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '添加图片',
                        style: AppTextStyle.body.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            // 显示已选图片
            return Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImages[index],
                    fit: BoxFit.cover,
                  ),
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
  
  /// 构建标签选择区域
  Widget _buildTagSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '选择标签',
          style: AppTextStyle.title,
        ),
        const SizedBox(height: 12),
        // 可用标签列表
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
              '暂无可用标签',
              style: AppTextStyle.hint,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _availableTags.map((tag) {
              final isSelected = _selectedTags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (_) => _toggleTag(tag),
                backgroundColor: AppColors.bgSecondary,
                selectedColor: AppColors.bgTertiary,
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              );
            }).toList(),
          ),
        const SizedBox(height: 16),
        // 已选标签显示
        if (_selectedTags.isNotEmpty) ...[
          Text(
            '已选标签',
            style: AppTextStyle.body.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedTags.map((tag) {
              return Chip(
                label: Text(tag),
                onDeleted: () => _removeTag(tag),
                backgroundColor: AppColors.bgTertiary,
                deleteIcon: const Icon(
                  Icons.close,
                  size: 18,
                ),
              );
            }).toList(),
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
          '添加新标签',
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
                  hintText: '输入标签名称',
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
            ElevatedButton(
              onPressed: _addNewTag,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('添加'),
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
          '备注',
          style: AppTextStyle.title,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _descriptionController,
          enabled: true,
          autofocus: false,
          decoration: InputDecoration(
            hintText: '输入穿搭描述...',
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
