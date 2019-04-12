import json
from fpdf import FPDF

def lambda_handler(event, context):
    # TODO implement
    #return {
     #   'statusCode': 200,
     #   'body': json.dumps('Hello from Lambda!')
    #}
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size=12)
    pdf.cell(200, 10, txt="Welcome to Python!", ln=1, align="C")
    pdf.output("simple_demo.pdf")