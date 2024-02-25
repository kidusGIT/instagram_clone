import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchField extends StatelessWidget {
  final TextEditingController searchController;
  final void Function()? searchUser;

  const SearchField(
      {super.key, required this.searchController, required this.searchUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: secondarySearchColor,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: searchUser,
            icon: const Icon(Icons.search, size: 30),
          ),
          Expanded(
            child: TextField(
              onChanged: (value) {
                print(value);
                searchUser!();
              },
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }
}
