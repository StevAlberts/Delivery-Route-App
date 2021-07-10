# load_n_go

A new Flutter Load and Go Coding Challenge.

## Getting Started

##Problem 1: Sorting & Filtering**

Design a screen displaying a list of dummy orders and name it ‘All Orders’.

This screen should be interactive, e.g. Mobile user touches any one of the orders, it opens into an order description screen, name this screen ‘Order Description’.

‘Order Description’ screen should contain the following information:

- Order Number, Order Info, Order Weight, Quantity, Pickup Date, Pickup Address, Pickup Postal Code, Delivery Date, Delivery Address 1, Delivery Address 2, Delivery Postal Code, Customer First Name, Customer Last Name, Customer Phone Number, Customer Company, Merchant Name, Approval Status

Dummy data has been provided in the email attachments.

##Q1. Simple Sort**

Design a dropdown sorting widget for your ’All Orders’ screen, with sorting criterias of:

1. Area Code (First 2 digits of Postal Code)

2. Pickup Date

3. Delivery Date

4. Merchant Name

Be sure to differentiate between Pickup Date and Delivery Date when sorting.

##Q2. Filter**

Design a button in ‘All Orders’ screen to perform Filtering.

- Hint: It can be a floating button, or a button in the appbar.

Upon clicking, filter conditions should be selectable as follows:

1. Area Code (First 2 digits of Postal Code)

2. Pickup Date

3. Delivery Date

4. Merchant Name

Your filter has to be able to supporting filtering through more than 1 of the aforementioned conditions. E.g. Merchant Name = Merchant 1, Pickup Date = ‘1/1/2021’, Area Code = ‘05’

##Problem 2: Search & Edit**

Design a search button in the appbar, conveniently allowing the user to search through ‘All Orders’ screen with the following:

1. Order Number

2. Merchant Name

3. Pickup/Delivery Date.

Allow all rows in ‘All Orders’ to be selectable.

##Q2. Edit**

Upon selection of multiple rows, allow user to:

1. Delete all selected rows

2. Update ‘Approval Status’ column to ‘Yes’ for all rows.

3. Export rows to CSV file, with the same format as the rows in ‘dummy_lng_data.csv’. Upon selection of single row, allow user to:

1. Edit row, any of the ‘Order Information’

2. Update ‘Approval Status’ column to ‘Yes’

3. Delete row

##Problem 3: APIs**

Create a ‘My Deliveries’ screen with the same format as ‘All Orders’ screen.

Using https://www.solvice.io/ , or any other stateful route optimisation algorithm, optimise the best route for 2 drivers using the Delivery Postal Codes provided in ‘dummy_lng_data.csv’.

Allocate for users to optimise their routes by clicking on a floating button on the ‘My Deliveries’ screen.

During the review of this coding challenge, we will ask to insert an additional deliveries into the mix and re-optimisation
samples, guidance on mobile development, and a full API reference.
