import 'package:flutter/material.dart';

class ImageFromMinio extends StatefulWidget {
  const ImageFromMinio({super.key});

  @override
  State<ImageFromMinio> createState() => _ImageFromMinioState();
}

class _ImageFromMinioState extends State<ImageFromMinio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("dsofjsao"),
      ),
      body: Center(
        child: Image.network(
          "http://127.0.0.1:9000/coc/post_images/scaled_IMG_20231012_135913_1697095777499.jpg?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=2BEO08X6RLFIGUB1QF10%2F20231012%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20231012T080948Z&X-Amz-Expires=604800&X-Amz-Security-Token=eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3NLZXkiOiIyQkVPMDhYNlJMRklHVUIxUUYxMCIsImV4cCI6MTY5NzEzOTE0OSwicGFyZW50IjoibWluaW9hZG1pbiJ9.htWEAko758wYTIGpoljdhpVtNnGKPvAM3WjmF6RDfzj-nQq5uRHWSO_jUU65kv9ofUU_9t53nSggZ-ePN7VpHA&X-Amz-SignedHeaders=host&versionId=null&X-Amz-Signature=1719e4a6443cb9d75099adb1ea84d97fae5b27328cf3961f26b974bdc61e7e43",
        ),
      ),
    );
  }
}