import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileImage extends ConsumerWidget {
  final double size;
  const ProfileImage({required this.size, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    return user?.photoURL != null
        ? CachedNetworkImage(
          imageUrl: user!.photoURL!,
          width: size,
          height: size,
          imageBuilder: (context, imageProvider) {
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            );
          },
          placeholder:
              (context, url) =>
                  Image.asset('assets/profile.png', width: size, height: size),
          errorWidget:
              (context, url, error) =>
                  Image.asset('assets/profile.png', width: size, height: size),
        )
        : Image.asset('assets/profile.png', width: size, height: size);
  }
}
