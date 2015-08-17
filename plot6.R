# Load the GGPLOT2 and PLYR libraries
library(plyr)
library(ggplot2)

# Read the source data from the files
#NEI <- readRDS("data/summarySCC_PM25.rds")
#SCC <- readRDS("data/Source_Classification_Code.rds")

# Subset for "ON-ROAD" emissions for fips = "24510" or "06037" (Baltimore and LA motor vehicle emissions)
motor_vehicle_emissions <- subset(NEI, (fips == "24510" | fips == "06037") & type=="ON-ROAD")

# Add a Region column with the city and county names
motor_vehicle_emissions <- transform(motor_vehicle_emissions, Region = ifelse(fips == "24510", "Baltimore City", "Los Angeles County"))

# Aggregate our PM25 values per year and type
motor_vehicle_emissions_region_year <- ddply(motor_vehicle_emissions, .(year, Region), function(x) sum(x$Emissions))

# Rename the columns
colnames(motor_vehicle_emissions_region_year)[1] <- "Year"
colnames(motor_vehicle_emissions_region_year)[2] <- "Region"
colnames(motor_vehicle_emissions_region_year)[3] <- "Emissions"

# Plot to PNG
png("plot6.png")
print(ggplot(data = motor_vehicle_emissions_region_year, aes(x = Year, y = Emissions, col = Region)) + geom_line() + xlab("Year") + ylab(expression(PM[2.5] ~ "emissions (in tons)")) + ggtitle(expression("Motor vehicle" ~ PM[2.5] ~ "emissions per region per year")))
dev.off()