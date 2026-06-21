from fastapi import FastAPI
# For Presidio
from presidio_analyzer import AnalyzerEngine
from presidio_anonymizer import AnonymizerEngine, OperatorConfig
from pydantic import BaseModel

app = FastAPI()



analyzer = AnalyzerEngine()

anonymizer = AnonymizerEngine()

class RedactRequest(BaseModel):
    text: str


@app.post("/")
def redact_pii(req:RedactRequest) -> str | None:
    text = req.text
    results = analyzer.analyze(text,language="en")
    pii_count = len(results)
    if(pii_count == 0):
        return text
    else:
        return anonymizer.anonymize(text=text, analyzer_results=results,operators={"DATE_TIME": OperatorConfig("keep")}).text
