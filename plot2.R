# Read the source data from the file
NEI <- readRDS("data/summarySCC_PM25.rds")

# Subset our NEI dataset to get Baltimore's data (where fips = "24510")
baltimore_emissions <- subset(NEI, fips == "24510")

# Now sum up the emissions per year
baltimore_emissions_year <- tapply(baltimore_emissions$Emissions, baltimore_emissions$year, sum)

# Plot to PNG
png("plot2.png")
plot(names(baltimore_emissions_year), baltimore_emissions_year, type="l", xlab="Year", ylab=expression(PM[2.5] ~ "emissions (tons)"), main=expression("Total" ~ PM[2.5] ~ "emissions per year for Baltimore"))
dev.off()