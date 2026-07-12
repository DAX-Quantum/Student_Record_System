#!/bin/bash

# -----------------------------
# Add Student
# -----------------------------
add_student() {
    echo "========== ADD STUDENT =========="

    read -p "Enter Roll Number: " roll

    if ! [[ "$roll" =~ ^[0-9]+$ ]]
    then
        echo "Error: Roll Number must contain only numbers!"
        return
    fi

    if grep -q "^$roll|" students.txt
    then
        echo "Error: Roll Number already exists!"
        return
    fi

    read -p "Enter Name: " name

    if [ -z "$name" ]
    then
        echo "Error: Name cannot be empty!"
        return
    fi

    read -p "Enter Branch: " branch

    if [ -z "$branch" ]
    then
        echo "Error: Branch cannot be empty!"
        return
    fi

    read -p "Enter CGPA: " cgpa

    if ! [[ "$cgpa" =~ ^([0-9]|10)(\.[0-9]+)?$ ]]
    then
        echo "Error: Invalid CGPA!"
        return
    fi

    echo "$roll|$name|$branch|$cgpa" >> students.txt

    echo
    echo "Student Added Successfully!"
}

# -----------------------------
# View Students
# -----------------------------
view_students() {

    echo "========== STUDENT RECORDS =========="
    echo

    if [ -s students.txt ]
    then
        printf "%-10s %-20s %-10s %-5s\n" "Roll No" "Name" "Branch" "CGPA"
        printf "%-10s %-20s %-10s %-5s\n" "--------" "--------------------" "------" "-----"

        while IFS="|" read roll name branch cgpa
        do
            printf "%-10s %-20s %-10s %-5s\n" "$roll" "$name" "$branch" "$cgpa"
        done < students.txt
    else
        echo "No student records found."
    fi
}

# -----------------------------
# Search Student
# -----------------------------
search_student() {

    echo "========== SEARCH STUDENT =========="
    echo

    read -p "Enter Roll Number: " roll

    result=$(grep "^$roll|" students.txt)

    if [ -n "$result" ]
    then
        printf "%-10s %-20s %-10s %-5s\n" "Roll No" "Name" "Branch" "CGPA"
        printf "%-10s %-20s %-10s %-5s\n" "--------" "--------------------" "------" "-----"

        echo "$result" | while IFS="|" read roll name branch cgpa
        do
            printf "%-10s %-20s %-10s %-5s\n" "$roll" "$name" "$branch" "$cgpa"
        done
    else
        echo "Student not found!"
    fi
}

# -----------------------------
# Update Student
# -----------------------------
update_student() {

    echo "========== UPDATE STUDENT =========="
    echo

    read -p "Enter Roll Number to Update: " roll

    if grep -q "^$roll|" students.txt
    then
        read -p "Enter New Name: " new_name
        read -p "Enter New Branch: " new_branch
        read -p "Enter New CGPA: " new_cgpa

        while IFS="|" read r name branch cgpa
        do
            if [ "$r" = "$roll" ]
            then
                echo "$roll|$new_name|$new_branch|$new_cgpa"
            else
                echo "$r|$name|$branch|$cgpa"
            fi
        done < students.txt > temp.txt

        mv temp.txt students.txt

        echo
        echo "Student Updated Successfully!"
    else
        echo
        echo "Student not found!"
    fi
}

# -----------------------------
# Delete Student
# -----------------------------
delete_student() {

    echo "========== DELETE STUDENT =========="
    echo

    read -p "Enter Roll Number: " roll

    if grep -q "^$roll|" students.txt
    then
        grep -v "^$roll|" students.txt > temp.txt
        mv temp.txt students.txt

        echo
        echo "Student Deleted Successfully!"
    else
        echo
        echo "Student not found!"
    fi
}

# =============================
# Main Program
# =============================

touch students.txt

while true
do
    clear

    echo "=========================================="
    echo "     STUDENT RECORD MANAGEMENT SYSTEM"
    echo "=========================================="
    echo
    echo "1. Add Student"
    echo "2. View Students"
    echo "3. Search Student"
    echo "4. Update Student"
    echo "5. Delete Student"
    echo "6. Exit"
    echo

    read -p "Enter your choice: " choice
    echo

    case $choice in
        1)
            add_student
            ;;
        2)
            view_students
            ;;
        3)
            search_student
            ;;
        4)
            update_student
            ;;
        5)
            delete_student
            ;;
        6)
            echo "Thank you for using Student Record System!"
            break
            ;;
        *)
            echo "Invalid Choice!"
            ;;
    esac

    echo
    read -p "Press Enter to continue..."
done
