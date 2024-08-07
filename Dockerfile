# Use an official Node.js runtime as the base image
FROM node:14

# Set the working directory
WORKDIR /usr/src/app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install the application dependencies
RUN npm install

# Copy the rest of the application source code
COPY . .

# Expose the application port
EXPOSE 3000

# Define the command to run the application
CMD ["node", "index.js"]
