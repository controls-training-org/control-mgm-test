#!/bin/bash

# Specify your AWS region
REGION="eu-central-1"

# Output file
OUTPUT_FILE="existing_controls_output.txt"

# Create or clear the output file
echo "" > "$OUTPUT_FILE"

# Get all the roots in your account
ROOTS_JSON=$(aws organizations list-roots --region "$REGION")

# Extract root IDs
ROOT_IDS=$(echo "$ROOTS_JSON" | jq -r '.Roots[].Id')

# Iterate through each root
for ROOT_ID in $ROOT_IDS; do
    # List the OUs for the current root
    OUS_JSON=$(aws organizations list-organizational-units-for-parent --parent-id "$ROOT_ID" --region "$REGION")

    # Extract OUs
    OUS=$(echo "$OUS_JSON" | jq -c '.OrganizationalUnits[]')

    # Do something with the OUs
    for OU in $OUS; do
        OU_ID=$(echo "$OU" | jq -r '.Id')
        OU_NAME=$(echo "$OU" | jq -r '.Name')
        OU_ARN=$(echo "$OU" | jq -r '.Arn')

        # Print to terminal and write to file
        echo "Organizational Unit ID: $OU_ID, Name: $OU_NAME" | tee -a "$OUTPUT_FILE"
        echo "-- Enabled Controls --" | tee -a "$OUTPUT_FILE"

        # Call the list_enabled_controls function
        CONTROLS_JSON=$(aws controltower list-enabled-controls --target-identifier "$OU_ARN" --max-results 100 --region "$REGION")

        # Extract enabled controls
        CONTROLS=$(echo "$CONTROLS_JSON" | jq -c '.enabledControls[]?')

        # Initialize counter
        COUNTER=1

        # Print the enabled controls
        for CONTROL in $CONTROLS; do
            CONTROL_IDENTIFIER=$(echo "$CONTROL" | jq -r '.controlIdentifier')
            echo "$COUNTER controlIdentifier: $CONTROL_IDENTIFIER" | tee -a "$OUTPUT_FILE"
            COUNTER=$((COUNTER + 1))
        done

        # Print a blank line to terminal and write to file
        echo "" | tee -a "$OUTPUT_FILE"
    done
done

echo "Output has been written to $OUTPUT_FILE"

