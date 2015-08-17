# Read the source data from the file
NEI <- readRDS("data/summarySCC_PM25.rds")

# Get a total for emissions per year
total_emissions_year <- tapply(NEI$Emissions, NEI$year, sum)

# Plot to PNG file
png("plot1.png")
plot(names(total_emissions_year), total_emissions_year, type="l", xlab="Year", ylab=expression(PM[2.5] ~ "emissions (tons)"), main=expression("Total" ~ PM[2.5] ~ "emissions per year"))
dev.off()