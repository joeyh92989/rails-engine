# Rails Engine

[![forthebadge](http://forthebadge.com/images/badges/made-with-ruby.svg)](http://forthebadge.com)
[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)

# Table of contents

- [Usage](#usage)
- [Installation](#installation)
- [Contributing](#contributing)


# Usage
The Rails engine is an a app that allows a user to return data from a series of endpoints. The data respesents a sample of merchants, customers, invoices, and, transactions. The endpoints can be addressed via:
## Merchants
1. Return all Merchants;
 * GET `/api/v1/merchants`
 * Query params accepted: `per_page`, `page`
2. Return one Merchant
 * GET `/api/v1/merchants/:id`
 * Query params accepted: none
3. Return all Items associated with a Merchant
 * GET `/api/v1/merchants/:id/items`
 * Query params accepted: none
## Items
1. Return all Items
 * GET `/api/v1/items`
 * Query params accepted: `per_page`, `page`
2. Return one Item
 * GET `/api/v1/items/:id`
 * Query params accepted: none
3. Create an Item
 * POST `/api/v1/items`
 * Query params required: `item:{name: STRING, description: STRING, unit_price: FLOAT, merchant_id: INTEGER}`
4. Update an Item
 * PATCH `/api/v1/items/:id`
 * Query params accepted: `item:{name: STRING, description: STRING, unit_price: FLOAT, merchant_id: INTEGER}`
5. Destroy an Item
 * DESTROY `/api/v1/items/:id`
 * Query params accepted: none
6. Return an Item's Merchant
 * GET `/api/v1/items/:id/merchant`
 * Query params accepted: none
## Search 
1. Find all Merchants
 * GET `/api/vi/merchants/find_all`
 * Query params accepted: none
2. Find an Item
 * GET `/api/v1/items/find`
 * Query params accepted: `name= STRING`, `min_price = FLOAT`, `max_price= FLOAT`, `max_price&min_price`
## Calculations
1. Merchants with the most revenue
 * GET `/api/v1/revenue/merchants`
 * Query params accepted: `quantity= INTEGER`
2. Total revenue for a Merchant
 * GET `/api/v1/revenue/merchants/:id`
 * Query params accepted: none
3. Items ranked by revenue
 * GET `/api/v1/revenue/items`
 * Query params: `quantity=INTEGER`
4. Potential revenue of unshipped Items
 * GET `/api/v1/revenue/unshipped`
 * Query params accepted: `quantity=INTEGER`



# Installation

[(Back to top)](#table-of-contents)

## Local Install
1. Install Ruby (preferably, version >= 2.5.3)
2. clone repo to your local
3. run `bundle install`
4. run `rake db:{drop,create,migrate,seed}`
5. run `rails db:schema:dump`
6. run `rails s`
7. hit endpoints either from your browser or postman

## Heroku
From your browser:
`https://joey-railsengine.herokuapp.com/`



# Contributing

[(Back to top)](#table-of-contents)

* Thank you to Turing School of Software and Design for the inspiration and direction in building this application
* Developed by Joey Haas
 * [Git Hub](https://github.com/joeyh92989) 
 * [LinkedIn](https://www.linkedin.com/in/haasjoseph/) 


