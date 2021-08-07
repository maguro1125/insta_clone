import 'package:flutter/material.dart';

class Comment{
  String commentID;
  String postID;
  String commentUserID;
  String comment;
  DateTime commentDateTime;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  Comment({
    required this.commentID,
    required this.postID,
    required this.commentUserID,
    required this.comment,
    required this.commentDateTime,
  });

  Comment copyWith({
    String? commentID,
    String? postID,
    String? commentUserID,
    String? comment,
    DateTime? commentDateTime,
  }) {
    return new Comment(
      commentID: commentID ?? this.commentID,
      postID: postID ?? this.postID,
      commentUserID: commentUserID ?? this.commentUserID,
      comment: comment ?? this.comment,
      commentDateTime: commentDateTime ?? this.commentDateTime,
    );
  }

  @override
  String toString() {
    return 'Comment{commentID: $commentID, postID: $postID, commentUserID: $commentUserID, comment: $comment, commentDateTime: $commentDateTime}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Comment &&
          runtimeType == other.runtimeType &&
          commentID == other.commentID &&
          postID == other.postID &&
          commentUserID == other.commentUserID &&
          comment == other.comment &&
          commentDateTime == other.commentDateTime);

  @override
  int get hashCode =>
      commentID.hashCode ^
      postID.hashCode ^
      commentUserID.hashCode ^
      comment.hashCode ^
      commentDateTime.hashCode;

  factory Comment.fromMap(Map<String, dynamic> map) {
    return new Comment(
      commentID: map['commentID'] as String,
      postID: map['postID'] as String,
      commentUserID: map['commentUserID'] as String,
      comment: map['comment'] as String,
      commentDateTime: DateTime.parse(map['commentDateTime'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'commentID': this.commentID,
      'postID': this.postID,
      'commentUserID': this.commentUserID,
      'comment': this.comment,
      'commentDateTime': this.commentDateTime.toIso8601String(),
    } as Map<String, dynamic>;
  }

//</editor-fold>

}