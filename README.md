# QA Automation Assessment (Robot Framework)

UI and API tests written with **Robot Framework**.

| Part | Target | Libraries | Tests |
|------|--------|-----------|-------|
| A - UI | [Demo Web Shop](https://demowebshop.tricentis.com) (public demo shop) | SeleniumLibrary (headless Chrome) | 1. Home page verification, 2. Category navigation, 3. Search |
| B - API | [Swagger Petstore](https://petstore.swagger.io/) `/v2/pet` | RequestsLibrary | 4. Create, 5. Read, 6. Update, 7. Delete + confirm 404 |

- UI tests only use public pages (no login, payment or account creation).
- API tests generate a unique pet ID and name on every run.
- Full-page screenshots are saved in `verification/`.

## Prerequisites
- Python 3.9+
- Google Chrome installed (Selenium Manager downloads the matching driver automatically)

## Setup
```bash
python -m venv venv
# Windows: venv\Scripts\activate    macOS/Linux: source venv/bin/activate
pip install -r requirements.txt
```

## Run
```bash
robot --outputdir results tests/ui      # UI tests (writes screenshots to verification/)
robot --outputdir results tests/api     # API tests
robot --outputdir results tests         # everything
```
Open `results/report.html` and `results/log.html` for the reports.

## Structure
```
tests/ui/shop.robot          UI tests 1-3
tests/api/pet.robot          API tests 4-7
resources/common.resource    browser setup, full-page screenshot keyword
verification/                screenshots from UI tests
requirements.txt             Python dependencies
```

## Notes
The Petstore is a shared public service and can be eventually consistent, so the API tests retry for up to 20 seconds after writes before asserting.
