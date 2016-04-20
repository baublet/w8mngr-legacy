# Tests

I'm committed to Test Driven Development for this app since I'm a single developer
on this project. Having a huge test suite will be absolutely essential for me to
make this project sustainable for me.

That said, I'm being specific about what my certain tests cover.

## Model Tests

- Unit-style tests on models and their methods
- Any models that work together
- Malicious inputs passed into models

## Controller Tests

- Routes
- Responses (that proper controllers are called)
- Interactions between controllers
- Which templates are rendered (not how, just which)
- Malicious inputs passed from users
- JSON API requests

## Integration Tests

- Full tests of models, views, and controllers working together
- Focused on happy path useages