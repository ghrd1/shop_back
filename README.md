# Shop Backend (Rails API)

## Stack
- Ruby on Rails 7.1 (`api_only`)
- Devise + JWT authentication
- PostgreSQL

## Run locally
1. Install dependencies:
```bash
bundle install
```
2. Configure env:
- Set `DEVISE_JWT_SECRET_KEY`
- Configure database in `config/database.yml`
3. Create and migrate DB:
```bash
bin/rails db:create db:migrate
```
4. Start server:
```bash
bin/rails s
```

## Auth endpoints
- `POST /users/sign_up` - register, returns `user` + `token`
- `POST /users/sign_in` - login, returns `user` + `token`
- `DELETE /users/sign_out` - logout

## Important API auth note
This project is API-only (`ActionController::API`), so Devise browser features
like flash/redirect flows must be disabled.

Applied fixes:
- `config.navigational_formats = []` in `config/initializers/devise.rb`
- Custom JSON handling in `Users::SessionsController#create` with
  `warden.authenticate` and explicit `401` on invalid credentials

These changes prevent the error:
`NameError: undefined local variable or method 'flash' for Users::SessionsController`
when signing in again after sign out.
