import os

def combine_dotnet_source_to_txt(project_path, output_file):
    """
    Combines source code files from a .NET project into a single text file.

    Args:
        project_path (str): The root path of the .NET project directory.
        output_file (str): The path to the output text file to be created.
    """
    # Common .NET source file extensions to include
    source_extensions = ('.cs', '.xaml', '.config', '.resx', '.csproj', '.sln', '.vb', '.fs')
    # Folders to ignore
    ignore_dirs = ('bin', 'obj')
    found_source_file = False # Flag to check if any files were actually added

    try:
        with open(output_file, 'w', encoding='utf-8') as outfile:
            for root, dirs, files in os.walk(project_path):
                # Modify dirs in-place to prevent os.walk from traversing ignored directories
                dirs[:] = [d for d in dirs if d not in ignore_dirs]

                for file in files:
                    if file.endswith(source_extensions):
                        found_source_file = True # Mark that we processed at least one file
                        file_path = os.path.join(root, file)
                        # Use raw string for the path in the marker for clarity if needed
                        relative_path = os.path.relpath(file_path, project_path)

                        # Write a header marker for the file
                        outfile.write(f'\n--- Start of {relative_path} ---\n\n')

                        # Write the file content
                        try:
                            # Use errors='ignore' to skip problematic characters if any
                            with open(file_path, 'r', encoding='utf-8', errors='ignore') as infile:
                                outfile.write(infile.read())
                        except Exception as e:
                            # Log error reading specific file but continue
                            error_message = f"*** Error reading file {relative_path}: {e} ***"
                            outfile.write(f"{error_message}\n")
                            print(f"Warning: {error_message}") # Also print to console

                        # Write a footer marker for the file
                        outfile.write(f'\n\n--- End of {relative_path} ---\n')

        if found_source_file:
            print(f"Successfully combined source files into {output_file}")
        else:
             print(f"Warning: No source files matching the specified extensions found in '{project_path}' (excluding {ignore_dirs}). The output file is empty.")

    except FileNotFoundError:
        print(f"Error: The project path '{project_path}' was not found.")
    except Exception as e:
        print(f"An unexpected error occurred: {e}")

# --- How to Use ---
# 1. Replace the placeholder paths below with your actual project path and desired output file name.
# 2. Using raw strings (r'...') for Windows paths is recommended to avoid issues with backslashes.
# 3. Run the script from your command line (e.g., python your_script_name.py).

# Example usage (replace with your actual paths):
project_directory = r'P:\Projects\GITHUB\PokerRL\backend\TexasHoldemPoker.API\TexasHoldemPoker.API'
output_text_file = 'combined_source_code.txt' # You can change the output file name if needed
combine_dotnet_source_to_txt(project_directory, output_text_file)
