import 'package:flutter/material.dart';

var profile = "https://avatars.githubusercontent.com/u/86506519?v=4";

var populars = [
  {
    "image":
        "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "عقار",
    "price": "",
    "location": "زواره",
    "is_favorited": false,
  },
];

List recommended = [
  {
    "image":
        "https://th.bing.com/th/id/OIP.eussoTyvE71HP55GzR9ypQHaFj?rs=1&pid=ImgDetMain ",
    "name": "شقه",
    "price": "",
    "location": "ينغازي",
    "is_favorited": true,
  },
  {
    "image":
        "https://th.bing.com/th/id/OIP.vITF8qDRJ3HHm3yF0sY_BQAAAA?rs=1&pid=ImgDetMain",
    "name": "شقه",
    "price": "",
    "location": "البيضاء",
    "is_favorited": false,
  },
  {
    "image":
        "https://th.bing.com/th/id/OIP.aXHY1DIjXtghSuOYR74-uwHaGX?w=750&h=645&rs=1&pid=ImgDetMain",
    "name": "شقه",
    "price": "",
    "location": "طرابلس",
    "is_favorited": true,
  },
  {
    "image":
        "https://th.bing.com/th/id/R.8bc4b8dd7d4a25e9263334d0ff5bd11c?rik=QjEJyAsbhx6fmA&riu=http%3a%2f%2f2.bp.blogspot.com%2f-pc2QwT96MCw%2fTzf4k-IV1zI%2fAAAAAAAAB-0%2fmm-0_tMGogg%2fs1600%2f163228.jpg&ehk=qKeAvsS5JLGDSOe866TsIxJl%2bzYfQX6kt6eba8%2bdMuU%3d&risl=&pid=ImgRaw&r=0",
    "name": " استراحه",
    "price": "",
    "location": "طرابلس",
    "is_favorited": true,
  },
  {
    "image":
        "https://th.bing.com/th/id/OIP.sBBct6eK-63KGnLeNMUyrQHaJ4?rs=1&pid=ImgDetMain",
    "name": "شقه",
    "price": "",
    "location": "بنغازي",
    "is_favorited": true,
  }
];

var brokers = [
  {
    "image":
        "https://scontent.fben4-1.fna.fbcdn.net/v/t39.30808-6/363012140_298675296045653_8519607704079867340_n.jpg?_nc_cat=111&ccb=1-7&_nc_sid=5f2048&_nc_ohc=KNHqgqPdzBsQ7kNvgFVYWM-&_nc_ht=scontent.fben4-1.fna&oh=00_AYBumg4_0kANtydnVeCOWrSrZpkdjo6zOx8w49QOakprmw&oe=6656AE8E",
    "name": "John Siphron",
    "type": "Broker",
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTF8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Corey Aminoff",
    "type": "Broker",
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4,
  },
  {
    "image":
        "https://scontent.fben4-1.fna.fbcdn.net/v/t39.30808-6/403772914_361732016406647_6712640211237454267_n.jpg?stp=cp6_dst-jpg&_nc_cat=106&ccb=1-7&_nc_sid=5f2048&_nc_ohc=fYBx7pDMdOAQ7kNvgEVusxM&_nc_ht=scontent.fben4-1.fna&oh=00_AYAOx5AU4pC4s2VCeZ6d2932349NBj0J7zmi1Q_Ufa5ZHg&oe=6656BC5F",
    "name": "Siriya Aminoff",
    "type": "Broker",
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4,
  },
  {
    "image":
        "https://images.unsplash.com/photo-1545167622-3a6ac756afa4?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTB8fHByb2ZpbGV8ZW58MHx8MHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "Rubin Joe",
    "type": "Broker",
    "description":
        "Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document",
    "rate": 4,
  },
];

List<Map<String, dynamic>> nearest = [
  {
    "image":
        "https://images.unsplash.com/photo-1549517045-bc93de075e53?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "طرابلس",
    "location": "ليبيا",
    "type": "عاصمة",
    "is_favorited": false,
    "icon": Icons.domain_rounded
  },
  {
    "image":
        "https://images.unsplash.com/photo-1618221469555-7f3ad97540d6?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "بنغازي",
    "location": "ليبيا",
    "type": "مدينة",
    "is_favorited": true,
    "icon": Icons.house_siding_rounded
  },
  {
    "image":
        "https://images.unsplash.com/photo-1625602812206-5ec545ca1231?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "مصراتة",
    "location": "ليبيا",
    "type": "مدينة",
    "is_favorited": true,
    "icon": Icons.home_work_rounded
  },
  {
    "image":
        "https://images.unsplash.com/photo-1625602812206-5ec545ca1231?ixid=MXwxMjA3fDB8MHxzZWFyY2h8NHx8Zm9vZHxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60",
    "name": "الزاوية",
    "location": "ليبيا",
    "type": "مدينة",
    "is_favorited": true,
    "icon": Icons.location_city_rounded
  },
];




