# Testing

The `test/` directory includes multiple widget tests to cover basic functionality. All test cases are outlined in the table below. Test changes made to the package by executing the following from the root of the project:

```
flutter test
```

Chnages made to the default input decoration or widget layout should be manually QA tested to verify appearance.

## Test Cases for UnitNumberInput Widget

| # | Scenario                          | Given                                      | When                               | Expect                                                                 |
|---|-----------------------------------|--------------------------------------------|------------------------------------|------------------------------------------------------------------------|
| 1 | Default                           | Widget loads with no initial values/prefill | –                                  | Fields empty (or "00"), input decoration renders, validator works       |
| 2 | Toggle button                     | Toggle `minutesMode`                       | Switching on `minutesMode`         | Total seconds converts into minutes+seconds correctly                  |
|   |                                   |                                            | Switching off `minutesMode`        | Reverts to seconds mode, values persist across rebuilds                |
| 3 | No initial seconds, no prefill    | `initialSeconds = -1` and no prefill       | –                                  | Fields remain blank, validation only fails if required                  |
| 4 | No initial seconds, with prefill  | `initialSeconds` not set, but prefilled    | –                                  | Prefilled values show, total seconds reflects correctly                 |
| 5 | With initial minutes/seconds      | `initialSeconds = 125` (2m 5s)             | –                                  | Minutes = 2, Seconds = 5, totalSeconds matches                          |
|   |                                   |                                            | Editing either field               | totalSeconds updates consistently                                      |
| 6 | Field not required, not prefilled | `required = false`, no initial/prefill     | Submitting with empty fields       | Validation passes, no error                                             |
| 7 | 5 digits input for seconds        | `maxSecondsDigits = 5`                     | Entering large values (e.g. 99999) | Allows up to 5 digits, values display correctly, overflow rejected      |
