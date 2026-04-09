#!/usr/bin/env python3

''''
This script is used in Zapier to compile the information in a Google Sheet to a single message to be sent to a manager
concerning their directs' compliance with Time Together
'''

managers = input_data['managers'].split(",")
employees = input_data['employees'].split(",")
days = input_data['days'].split(",")
compliance = input_data['compliance'].split(",")

report = {}

for manager, name, day, comp in zip(managers, employees, days, compliance):
    if manager not in report:
        report[manager] = {
            "name": [],
            "days in": [],
            "compliance": []
        }
    report[manager]["name"].append(name)
    report[manager]["days in"].append(day)
    report[manager]["compliance"].append(comp)

compliance_rate = 80

output_managers = []
output_messages = []

for manager, data in report.items():
    out_of_compliance_emps = []
    for name, day, comp in zip(data["name"], data["days in"], data["compliance"]):
        comp_value = float(comp.replace('%', ''))
        if comp_value < compliance_rate:
            out_of_compliance_emps.append(f"{name} ({comp}% - {day} days)")
    if out_of_compliance_emps:
        combined_names = ", ".join(out_of_compliance_emps)
        message = f"Action Required: The following employees are out of compliance: {combined_names}."
    else:
        continue

    output_managers.append(manager)
    output_messages.append(message)

return {
    "manager": output_managers,
    "message": output_messages
}