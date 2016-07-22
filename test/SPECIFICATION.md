# Tests

I'm committed to Test Driven Development for this app since I'm a single developer
on this project. Having a huge test suite will be absolutely essential for me to
make this project sustainable for me.

That said, I'm being specific about what my certain tests cover.

## Model Tests

- Unit-style tests on models and their methods
- Any models that work together
- Malicious inputs passed into models

Try to avoid testing saving to the database unless absolutely required.

## Controller Tests

- Routes
- Responses (that proper controllers are called)
- Interactions between controllers
- Which templates are rendered (not how, just which)
- Malicious inputs passed from users
- JSON API requests

Exceptions: when controllers are used to manipulate models that aren't directly
associated with that controller. E.g., Faturdays manipulate the FoodEntry model,
but don't have a model corresponding to them. In this case, the Faturday
controller test would test to see if the FoodEntry model was manipulated
properly.

## Integration Tests

- Full tests of models, views, and controllers working together
- Focused on happy path useages first, then moving to testing malicious params and attempts at SQL injection
- Never test HTML/CSS here. That's an impossible task. Just test to see if certain
  requests achieve the desired behavior across all levels of the database/session.

That means that we will be testing DB access in integration tests.