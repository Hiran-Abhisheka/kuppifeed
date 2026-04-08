import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/full_image_screen.dart';
import '../screens/comments_screen.dart';

class PostCard extends StatefulWidget {
  final String postId;
  final String title;
  final String description;
  final List<String> imageUrls;
  final String username;
  final String createdAt;

  const PostCard({
    super.key,
    required this.postId,
    required this.title,
    required this.description,
    required this.imageUrls,
    required this.username,
    required this.createdAt,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int _currentImageIndex = 0;
  bool _isDownloading = false;
  int _likeCount = 0;
  int _commentCount = 0;
  bool _isLiked = false;
  String? _currentUserId;

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final prefs = await SharedPreferences.getInstance();
    _currentUserId = prefs.getString('user_id');
    _fetchLikeCount();
    _fetchCommentCount();
    _checkIfLiked();
  }

  Future<void> _fetchLikeCount() async {
    try {
      final response =
          await supabase.from('likes').select().eq('post_id', widget.postId);
      if (mounted) {
        setState(() {
          _likeCount = response.length;
        });
      }
    } catch (e) {
      debugPrint('Error fetching like count: $e');
    }
  }

  Future<void> _fetchCommentCount() async {
    try {
      final response =
          await supabase.from('comments').select().eq('post_id', widget.postId);
      if (mounted) {
        setState(() {
          _commentCount = response.length;
        });
      }
    } catch (e) {
      debugPrint('Error fetching comment count: $e');
    }
  }

  Future<void> _checkIfLiked() async {
    if (_currentUserId == null) return;
    try {
      final response = await supabase
          .from('likes')
          .select()
          .eq('post_id', widget.postId)
          .eq('user_id', _currentUserId!)
          .maybeSingle();
      if (mounted) {
        setState(() {
          _isLiked = response != null;
        });
      }
    } catch (e) {
      debugPrint('Error checking like: $e');
    }
  }

  Future<void> _toggleLike() async {
    if (_currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to like posts')),
      );
      return;
    }

    try {
      if (_isLiked) {
        // Unlike
        await supabase
            .from('likes')
            .delete()
            .eq('post_id', widget.postId)
            .eq('user_id', _currentUserId!);
        if (mounted) {
          setState(() {
            _isLiked = false;
            _likeCount--;
          });
        }
      } else {
        // Like
        await supabase.from('likes').insert({
          'post_id': widget.postId,
          'user_id': _currentUserId,
        });
        if (mounted) {
          setState(() {
            _isLiked = true;
            _likeCount++;
          });
        }
      }
    } catch (e) {
      debugPrint('Error toggling like: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _downloadImages() async {
    if (widget.imageUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No images to download')),
      );
      return;
    }

    setState(() {
      _isDownloading = true;
    });

    try {
      int successCount = 0;
      for (int i = 0; i < widget.imageUrls.length; i++) {
        final imageUrl = widget.imageUrls[i];
        try {
          final response = await http.get(Uri.parse(imageUrl));
          if (response.statusCode == 200) {
            await Gal.putImageBytes(response.bodyBytes,
                name: '${widget.title}_$i');
            successCount++;
          }
        } catch (e) {
          debugPrint('Error downloading image $i: $e');
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Downloaded $successCount/${widget.imageUrls.length} images'),
          backgroundColor: successCount > 0 ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Download failed: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE0E0E0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFB2A4FF),
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(
              widget.username,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _formatDate(widget.createdAt),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        _isDownloading
                            ? Icons.hourglass_bottom
                            : Icons.download,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(_isDownloading ? 'Downloading...' : 'Download'),
                    ],
                  ),
                  enabled: !_isDownloading,
                  onTap: _downloadImages,
                ),
              ],
              child: Icon(
                  _isDownloading ? Icons.hourglass_bottom : Icons.more_vert),
            ),
          ),
          // Image carousel
          if (widget.imageUrls.isNotEmpty)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullImageScreen(
                      imageUrls: widget.imageUrls,
                      initialIndex: _currentImageIndex,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.imageUrls[_currentImageIndex],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.image_not_supported,
                                size: 60, color: Color(0xFFE0E0E0)),
                          );
                        },
                      ),
                    ),
                  ),
                  // Image indicators
                  if (widget.imageUrls.length > 1)
                    Positioned(
                      bottom: 16,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          widget.imageUrls.length,
                          (index) => Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            Container(
              height: 180,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Icon(Icons.insert_drive_file,
                    size: 60, color: Color(0xFFE0E0E0)),
              ),
            ),
          // Title and description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      widget.description,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          // Navigation and actions
          if (widget.imageUrls.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () {
                      setState(() {
                        _currentImageIndex =
                            (_currentImageIndex - 1) % widget.imageUrls.length;
                      });
                    },
                  ),
                  const Spacer(),
                  // Like button with count
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.red : null,
                        ),
                        onPressed: _toggleLike,
                      ),
                      Text('$_likeCount'),
                    ],
                  ),
                  // Comment button with count
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                postId: widget.postId,
                                postTitle: widget.title,
                              ),
                            ),
                          ).then((_) {
                            _fetchCommentCount();
                          });
                        },
                      ),
                      Text('$_commentCount'),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 20),
                    onPressed: () {
                      setState(() {
                        _currentImageIndex =
                            (_currentImageIndex + 1) % widget.imageUrls.length;
                      });
                    },
                  ),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // Like button with count
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isLiked ? Icons.favorite : Icons.favorite_border,
                          color: _isLiked ? Colors.red : null,
                        ),
                        onPressed: _toggleLike,
                      ),
                      Text('$_likeCount'),
                    ],
                  ),
                  // Comment button with count
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chat_bubble_outline),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                postId: widget.postId,
                                postTitle: widget.title,
                              ),
                            ),
                          ).then((_) {
                            _fetchCommentCount();
                          });
                        },
                      ),
                      Text('$_commentCount'),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inSeconds < 60) {
        return 'just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        return '${date.month}/${date.day}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }
}
