import 'package:flutter/material.dart';

class MapSearchBar extends StatefulWidget {
  final String hint;
  final ValueChanged<String> onChanged;

  const MapSearchBar({
    super.key,
    required this.hint,
    required this.onChanged,
  });

  @override
  State<MapSearchBar> createState() => _MapSearchBarState();
}

class _MapSearchBarState extends State<MapSearchBar> {
  final TextEditingController _controller = TextEditingController();
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Container(
      constraints: BoxConstraints(
        maxWidth: isTablet ? 600 : double.infinity,
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: Icon(
            Icons.search,
            size: isTablet ? 28 : 24,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    widget.onChanged('');
                    setState(() {});
                  },
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            vertical: isTablet ? 18 : 14,
            horizontal: isTablet ? 20 : 16,
          ),
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(
            fontSize: isTablet ? 18 : 16,
            color: Colors.grey.shade500,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isTablet ? 18 : 14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isTablet ? 18 : 14),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(isTablet ? 18 : 14),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
        style: TextStyle(
          fontSize: isTablet ? 18 : 16,
        ),
      ),
    );
  }
}