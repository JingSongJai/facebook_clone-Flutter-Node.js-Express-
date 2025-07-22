import 'dart:io';

import 'package:facebook_clone/services/auth_service.dart';
import 'package:flutter/material.dart';

class ImageGrid extends StatelessWidget {
  const ImageGrid({super.key, required this.images, this.isFile = false});
  final List<String> images;
  final bool isFile;
  @override
  Widget build(BuildContext context) {
    if (images.length == 1) {
      return AspectRatio(
        aspectRatio: 1,
        child:
            isFile
                ? Image.file(File(images.first))
                : AuthService.to.user?.avatarUrl == null
                ? SizedBox.shrink()
                : Image.network(images.first, fit: BoxFit.cover),
      );
    } else if (images.length == 2) {
      return AspectRatio(
        aspectRatio: 1,
        child: Row(
          spacing: 5,
          children: [
            Expanded(
              child:
                  isFile
                      ? Image.file(
                        File(images[0]),
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      )
                      : AuthService.to.user?.avatarUrl == null
                      ? SizedBox.shrink()
                      : Image.network(
                        images[0],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
            ),
            Expanded(
              child:
                  isFile
                      ? Image.file(
                        File(images[1]),
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      )
                      : AuthService.to.user?.avatarUrl == null
                      ? SizedBox.shrink()
                      : Image.network(
                        images[1],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
            ),
          ],
        ),
      );
    } else if (images.length == 3) {
      return AspectRatio(
        aspectRatio: 1,
        child: Row(
          spacing: 5,
          children: [
            Expanded(
              child:
                  isFile
                      ? Image.file(
                        File(images[0]),
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      )
                      : AuthService.to.user?.avatarUrl == null
                      ? SizedBox.shrink()
                      : Image.network(
                        images[0],
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      ),
            ),
            Expanded(
              child: Column(
                spacing: 5,
                children: [
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[1]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[1],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[2]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[2],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (images.length == 4) {
      return AspectRatio(
        aspectRatio: 1,
        child: Column(
          spacing: 5,
          children: [
            Expanded(
              child: Row(
                spacing: 5,
                children: [
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[0]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[0],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[1]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[1],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                spacing: 5,
                children: [
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[2]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[2],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[3]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[3],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (images.length == 5) {
      return AspectRatio(
        aspectRatio: 1,
        child: Column(
          spacing: 5,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                spacing: 5,
                children: [
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[0]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[0],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[1]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[1],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                spacing: 5,
                children: [
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[2]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[2],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[3]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[3],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[4]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[4],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: Column(
          spacing: 5,
          children: [
            Expanded(
              flex: 2,
              child: Row(
                spacing: 5,
                children: [
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[0]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[0],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[1]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[1],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                spacing: 5,
                children: [
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[2]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[2],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                  Expanded(
                    child:
                        isFile
                            ? Image.file(
                              File(images[3]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[3],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        isFile
                            ? Image.file(
                              File(images[4]),
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            )
                            : AuthService.to.user?.avatarUrl == null
                            ? SizedBox.shrink()
                            : Image.network(
                              images[4],
                              fit: BoxFit.cover,
                              height: double.infinity,
                              width: double.infinity,
                            ),
                        Container(color: Colors.black38),
                        Center(
                          child: Text(
                            '+ ${images.length - 5}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
