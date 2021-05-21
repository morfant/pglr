import csv

input_file = "ELC_40phon.csv"
output_file = "ELC_40phon_header.csv"

with open(input_file, 'r', newline='') as csv_in_file:
    with open(output_file, 'w', newline='') as csv_out_file:
        reader = csv.reader(csv_in_file)
        writer = csv.writer(csv_out_file)
        header_list = ['x', 'y']
        writer.writerow(header_list)

        for row in reader:
            writer.writerow(row)