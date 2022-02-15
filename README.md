# API Backend for Art Websites

This repo is the code that supports an api for artist's websites that will serve as an ecommerce platform, image host and blog. This project is still in the very early stages, but will eventually serve as a one stop shop for all of a visual artist's digital needs.

## Software used
There are many technologies used which can be found in the gem file; the heavy lifting, however, is done by: 

- Rails 6.1.4
- ActiveRecord
- ActiveStorage
- PostgreSQL
- Puma

## Currently Implemented

- User registration and authentication
- Upload, view, edit and delete(CRUD) access for art pieces to be displayed on the site
- CORS restrictions are ironed out for specific hosts

## To Do
- Differentiation of registration process for customers and artists
- Implementation of cart and checkout system
- Blog space for posts detailing new art pieces, events surrounding artist, etc
- Support for multiple artists' front ends