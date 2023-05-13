/**
 * 
 * await changes in database to update current values!
 * 
 * 
 * DatabaseReference starCountRef =
        FirebaseDatabase.instance.ref('posts/$postId/starCount');
    starCountRef.onValue.listen((DatabaseEvent event) {
    final data = event.snapshot.value;
    updateStarCount(data);
});
 */