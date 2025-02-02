FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements.txt file to the working directory
COPY requirements.txt .

# Install the required libraries
RUN pip install --no-cache-dir -r requirements.txt

# Copy the test suite and resources to the working directory
COPY . /app

# Set the entry point to run the Robot Framework tests
ENTRYPOINT ["robot"]

# Specify the default command to run the tests
CMD ["tests/"]