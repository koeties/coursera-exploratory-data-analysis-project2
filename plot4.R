# Load the GGPLOT2 and PLYR libraries
library(plyr)
library(ggplot2)

# Read the source data from the files
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")

# First extract all data for coal emissions from the SCC data. The Short.Name and EI.Sector columns contain content for rows regarding coal emissions.
coal_emissions1 <- subset(SCC, grepl("Comb", Short.Name) & grepl("Coal", Short.Name))
coal_emissions2 <- subset(SCC, EI.Sector %in% c("Fuel Comb - Comm/Institutional - Coal", "Fuel Comb - Electric Generation - Coal", "Fuel Comb - Industrial Boilers, ICEs - Coal"))

# Union the 2 data sets so that we get all the codes for coal emissions
coal_emissions_codes <- union(coal_emissions1$SCC, coal_emissions2$SCC)

# Now get the subset of data for coal emissions
all_coal_emissions <- subset(NEI, SCC %in% coal_emissions_codes)

# Aggregate our PM25 values per year and type
all_coal_emissions_year_type <- ddply(all_coal_emissions, .(year, type), function(x) sum(x$Emissions))

# Rename the columns
colnames(all_coal_emissions_year_type)[1] <- "Year"
colnames(all_coal_emissions_year_type)[2] <- "Type"
colnames(all_coal_emissions_year_type)[3] <- "Emissions"

# Plot to PNG
png("plot4.png")
print(ggplot(data = all_coal_emissions_year_type, aes(x = Year, y = Emissions, col = Type)) + geom_line() + xlab("Year") + ylab(expression(PM[2.5] ~ "emissions (in tons)")) + ggtitle(expression("Coal" ~ PM[2.5] ~ "emissions per type per year")) + stat_summary(fun.y = "sum", fun.ymin = "sum", fun.ymax = "sum", color = "black", aes(shape="Total"), geom="line") + geom_line(aes(size="Total", shape = NA)))
dev.off()