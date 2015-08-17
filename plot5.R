# Load the GGPLOT2 and PLYR libraries
library(plyr)
library(ggplot2)

# Read the source data from the files
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# Subset for "ON-ROAD" emissions for fips = "24510" (Baltimore motor vehicle emissions)
baltimore_vehicle_emissions <- subset(NEI, fips == "24510" & type=="ON-ROAD")

# Now sum up the emissions per year
baltimore_vehicle_emissions_year <- ddply(baltimore_vehicle_emissions, .(year), function(x) sum(x$Emissions))

# Rename the columns
colnames(baltimore_vehicle_emissions_year)[1] <- "Year"
colnames(baltimore_vehicle_emissions_year)[2] <- "Emissions"

# Plot to PNG
png("plot5.png")
print(ggplot(data = baltimore_vehicle_emissions_year, aes(x = Year, y = Emissions)) + geom_line() + xlab("Year") + ylab(expression(PM[2.5] ~ "emissions (in tons)")) + ggtitle(expression("Baltimore motor vehicle" ~ PM[2.5] ~ "emissions per year")))
dev.off()