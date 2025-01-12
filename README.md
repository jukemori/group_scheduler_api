# Group Scheduler API

A Rails API backend for a group calendar scheduling application that allows users to manage calendars, events, and collaborate with team members.

## System Requirements

* Ruby version: 3.2.2
* Rails version: 7.1.2
* PostgreSQL 15
* Redis (for Action Cable)

## Key Features

- User authentication with Devise Token Auth
- Google OAuth2 integration
- Calendar management
- Event scheduling with recurring events support
- Real-time notifications using Action Cable
- Calendar sharing and invitations
- Note sharing within calendars
- File attachments using Active Storage with Cloudinary/AWS S3
- RESTful JSON API

## Setup

1. Clone the repository
```bash
git clone [repository-url]
cd group-scheduler-api
```

2. Install dependencies
```bash
bundle install
```

3. Set up the database
```bash
rails db:create
rails db:migrate
rails db:seed
```


4. Environment variables
Create a `.env` file in the root directory with the following variables:
```
CLOUDINARY_URL=
GOOGLE_CLIENT_ID=
GOOGLE_CLIENT_SECRET=
```

5. Start the server
```bash
rails s
```


## API Endpoints

### Authentication
- `POST /api/v1/auth/sign_up` - User registration
- `POST /api/v1/auth/sign_in` - User login
- `DELETE /api/v1/auth/sign_out` - User logout

### Users
- `GET /api/v1/users` - List all users
- `GET /api/v1/users/:id` - Get user details
- `PUT /api/v1/users/:id` - Update user
- `GET /api/v1/users/notifications` - Get user notifications

### Calendars
- CRUD operations for calendars
- Calendar sharing functionality
- Calendar invitation system

### Events
- CRUD operations for events
- Recurring event support
- Event filtering by date range

### Calendar Notes
- CRUD operations for calendar notes
- Real-time note updates

## Deployment

The application is configured for deployment on Fly.io:
```bash
fly deploy
```
Configuration details can be found in `fly.toml`


## Dependencies

Key gems used:
- `devise` & `devise_token_auth` - Authentication
- `omniauth-google-oauth2` - Google OAuth2 integration
- `cloudinary` - Cloud image storage
- `redis` - Action Cable backend
- `rack-cors` - CORS handling
- `aws-sdk-s3` - AWS S3 storage integration

## Database Schema

The application uses PostgreSQL with the following main models:
- Users
- Calendars
- Events
- Calendar Notes
- Calendar Invitations
- Notifications

## Real-time Features

The application uses Action Cable for real-time notifications:
- Event updates
- Calendar note changes
- Calendar invitations
- User notifications
