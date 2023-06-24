// import 'dart:async';
// import 'dart:math';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../controller/provider/Provider.dart';



// class ImageListView extends StatefulWidget {
//   const ImageListView({super.key, required this.startIndex});

//   final int startIndex;

//   @override
//   State<ImageListView> createState() => _ImageListViewState();
// }

// class _ImageListViewState extends State<ImageListView> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     _scrollController.addListener(
//       () {
//         // implement scroll of list
//         if (_scrollController.position.atEdge) {
//           _autoScroll();
//         }

//         // adding to list
//         WidgetsBinding.instance.addPostFrameCallback(
//           (_) {
//             _autoScroll();
//           },
//         );
//       },
//     );
//     super.initState();
//   }

//   void _autoScroll() {
//     final double currentScrollPosition = _scrollController.offset;
//     final double endScrollPosition = _scrollController.position.maxScrollExtent;

//     scheduleMicrotask(
//       () {
//         _scrollController.animateTo(
//             currentScrollPosition == endScrollPosition ? 0 : endScrollPosition,
//             duration: const Duration(seconds: 10),
//             curve: Curves.linear);
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//       final ss = Provider.of<Providers>(context, listen: false);
//     return Transform.rotate(
//       angle: 1.96 * pi,
//       child: SizedBox(
//         width: MediaQuery.of(context).size.width * .6,
//         height: MediaQuery.of(context).size.height * .6,
//         child: ListView.builder(
//           controller: _scrollController,
//           physics: const BouncingScrollPhysics(),
//           itemCount:ss.s.length ,
//           itemBuilder: (context, index) {
//             return CachedNetworkImage(
//               imageUrl: products[widget.startIndex + index].productImageUrl,
//               // fit: BoxFit.cover,
//               imageBuilder: (context, imageProvider) => Container(
//                 margin: const EdgeInsets.only(
//                   left: 8.0,
//                   right: 8.0,
//                   top: 10.0,
//                 ),
//                 height: MediaQuery.of(context).size.height * .4,
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: imageProvider,
//                     fit: BoxFit.cover,
//                   ),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
// class Product {
//   final String productName;
//   final String productImageUrl;
//   final String currentPrice;
//   final String oldPrice;
//   final bool isLiked;

//   const Product({
//     required this.productName,
//     required this.productImageUrl,
//     required this.currentPrice,
//     required this.oldPrice,
//     required this.isLiked,
//   });
// }
// final products = [
//   const Product(
//     productName: "MNML - Oversized Tshirt",
//     productImageUrl:
//         "https://images.unsplash.com/photo-1588117305388-c2631a279f82?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1974&q=80",
//     currentPrice: "500",
//     oldPrice: "700",
//     isLiked: true,
//   ),
//   const Product(
//     productName: "Crop Top Hoddie",
//     productImageUrl:
//         "https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=720&q=80",
//     currentPrice: "392",
//     oldPrice: "400",
//     isLiked: false,
//   ),
//   const Product(
//     productName: "Half Tshirt",
//     productImageUrl:
//         "https://images.unsplash.com/photo-1529139574466-a303027c1d8b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
//     currentPrice: "204",
//     oldPrice: "350",
//     isLiked: true,
//   ),
//   const Product(
//     productName: "Best Fit Women Outfit",
//     productImageUrl:
//         "https://images.unsplash.com/photo-1581044777550-4cfa60707c03?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=686&q=80",
//     currentPrice: "540",
//     oldPrice: "890",
//     isLiked: true,
//   ),
//   const Product(
//     productName: "Strip Tourser",
//     productImageUrl:
//         "https://images.unsplash.com/photo-1509631179647-0177331693ae?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=688&q=80",
//     currentPrice: "230",
//     oldPrice: "750",
//     isLiked: false,
//   ),
//   const Product(
//     productName: "MNML - Jeans",
//     productImageUrl:
//         "https://images.unsplash.com/photo-1541099649105-f69ad21f3246?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80",
//     currentPrice: "240",
//     oldPrice: "489",
//     isLiked: false,
//   ),
//   const Product(
//     productName: "MNML - Jeans",
//     productImageUrl:
//         "https://images.unsplash.com/photo-1475178626620-a4d074967452?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=686&q=80",
//     currentPrice: "240",
//     oldPrice: "489",
//     isLiked: false,
//   ),
//   const Product(
//     productName: "Half Tshirt",
//     productImageUrl:
//         "https://images.unsplash.com/photo-1517298257259-f72ccd2db392?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=685&q=80",
//     currentPrice: "204",
//     oldPrice: "350",
//     isLiked: true,
//   ),
// ];
