# Load the GGPLOT2 and PLYR libraries
library(plyr)
library(ggplot2)

# Read the source data from the file
NEI <- readRDS("data/summarySCC_PM25.rds")

# Subset our NEI dataset to get Baltimore's data (where fips = "24510")
baltimore_emissions <- subset(NEI, fips == "24510")

# Use plyr to get total emissions per year per type for the subset
baltimore_emissions_source_year <- ddply(baltimore_emissions, .(year, type), function(x) sum(x$Emissions))
# Set our column heading for the aggregated data
colnames(baltimore_emissions_source_year)[1] <- "Year"
colnames(baltimore_emissions_source_year)[2] <- "Type"
colnames(baltimore_emissions_source_year)[3] <- "Emissions"

# Plot to PNG
png("plot3.png") 
print(ggplot(data = baltimore_emissions_source_year, aes(x = Year, y = Emissions, col = Type)) + geom_line() + xlab("Year") + ylab(expression(PM[2.5] ~ "emissions (in tons)")) + ggtitle(expression("Baltimore" ~ PM[2.5] ~ "emissions per type per year")))
dev.off()