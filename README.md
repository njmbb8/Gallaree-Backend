# API Backend for Art Websites

This repo is the code that supports an api for artist's websites that will serve as an ecommerce platform, image host and blog. This project is still in the very early stages, but will eventually serve as a one stop shop for all of a visual artist's digital needs.

## Software used
There are many technologies used which can be found in the gem file; the heavy lifting, however, is done by: 

- Rails
- ActiveRecord
- ActiveStorage
- PostgreSQL
- Puma
- Stripe

## Currently Implemented

- User registration and authentication
- Storage of artworks and information surrounding them
- Storage of data needed for an about page
- A blog  with a photo per post and comments
- Cart and checkout are processed on the back end using Stripe
- Messaging
- Automate email notifications for receipts, new messages, etc. 

## To Do
- Multitenancy to turn this into a Saas sidehustle
