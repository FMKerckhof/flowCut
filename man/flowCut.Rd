\name{flowCut}
\alias{flowCut}

\title{
       Precise and Accurate Automated Removal of Outlier Events and Flagging of Files Based on Time Versus Fluorescence Analysis.
}

\description{
       flowCut automatically removes outlier events in flow cytometry data files due to abnormal flow resulting from clogs and other common technical problems.
}

\usage{

flowCut (f, Segment = 500, Channels = NULL, Directory=NULL, FileID=NULL, Plot="None",
         MaxContin=0.1, MeanOfMeans=0.13, MaxOfMeans=0.15, MaxValleyHgt=0.1,
         MaxPercCut=0.2, LowDensityRemoval=0.1, GateLineForce=NULL,
         UseOnlyWorstChannels=FALSE, AmountMeanRangeKeep=1, AmountMeanSDKeep=2,
         PrintToConsole=FALSE, AllowFlaggedRerun=FALSE, Verbose=FALSE)
}
\arguments{
    \item{f}{
        A single flowFrame to be processed.
    }
    \item{Segment}{
        An integer value that specifies the number of events in each segment to be analyzed. A single segment is defaulted to contain 500 events.
    }
    \item{Channels}{
        A vector of indices for the channels to be cleaned. The default is NULL which will clean all non scatter and non time channels.
    }
    \item{Directory}{
        A directory that specifies where system output files are stored. If NULL, a directory will be created automatically under the current working directory.
    }
    \item{FileID}{
        A character or numeric variable of a unique ID for the file. If NULL, FileID will be randomly generated.
    }
    \item{Plot}{
        A character variable that indicates the amount of flowFrame plots that will be generated. The default is "None". Other values are "All" and "Flagged Only". "All" will generate plots for both passed and flagged files, whereas "Flagged Only" only generates plots for files that display at least one of the four flagging behaviours.
    }
    \item{MaxContin}{
        A numeric value that defines the critical value at which the difference of the mean of a given segment to the mean of an adjacent segment divided by the difference of the 98th percentile and the 2nd percentile for the whole file becomes significant, indicating a sudden change in the mean for neighbouring segments. The value is defaulted at 0.1.
    }
    \item{MeanOfMeans}{
        A numeric value that defines the critical mean value of percentage differences between the difference of the maximum and minimum mean and the difference of the 98th and 2nd percentile from all segments together. If the value exceeds the defaulted critical value of 0.13, which indicates a large gradual change of fluorescence in all channels, then the file is flagged. Formula: mean( (max(z)-min(z)) / (98th percentile - 2nd percentile) ) >= MeanOfMeans, where z is all the means of the segments.
    }
    \item{MaxOfMeans}{
        A numeric value that defines the critical maximum value of percentage differences between the difference of the maximum and minimum mean and the difference of the 98th and 2nd percentile from all segments together. If the value exceeds the defaulted critical value of 0.15, which indicates a very large gradual change of fluorescence in one channel, then the file is flagged. Formula: max( (max(z)-min(z)) / (98th percentile - 2nd percentile) ) >= MaxOfMeans, where z is all the means of the segments.
    }
    \item{MaxValleyHgt}{
        A numeric value that defines the vertical limit on the density of 8 measures of each segment. Increasing MaxValleyHgt will potentially increase the amount of events being cut. The default is 0.1.
    }
    \item{MaxPercCut}{
        A numeric value between 0 to 1 that sets the percentage of a cell population that a user is willing to potentially cut. If the file contains a lot of bad events, we suggest increasing this number to potentially cut off more deviates; usually 0.5 is sufficient in this case. The default is 0.2.
    }
    \item{LowDensityRemoval}{
        A numerical value between 0 and 1. Any events having a density of less than LowDensityRemoval are removed. The default is 0.1.
    }
    \item{GateLineForce}{
        A numeric value that forces the line in the density distribution plot to a value. This will be useful if the user runs a file once and wants to see what the cleaning process would look like if a little more or less was removed. The default is NULL.
    }
    \item{UseOnlyWorstChannels}{
        A logical value that allows for an automated detection of the worst channels. This channels will be the only ones used for cleaning. Focusing on the worst channels can often make the results more consistent with intuition. The default is FALSE.
    }
    \item{AmountMeanRangeKeep}{
        A non negative integer value (including 0) that defines the number of channels with a large range of means that would be included if UseOnlyWorstChannels is set to TRUE. The default is 1.
    }
    \item{AmountMeanSDKeep}{
        A non negative integer value (including 0) that defines the number of channels with a large standard deviation of means that would be included if UseOnlyWorstChannels is set to TRUE. The default is 2.
    }
    \item{PrintToConsole}{
        A logical value that dictates if the figure is printed to console or in the current directory. If no figure is desired, please see the Plot argument. The default is FALSE.
    }
    \item{AllowFlaggedRerun}{
        A logical value that dictates if flowCut will run a second time. However, this only occurs if the file was flagged on the first run. The default is FALSE.
    }
    \item{Verbose}{
        A logical value that dictates if computational information is printed while the code is running. The default is FALSE.
    }
}

\details{
        flowCut's methodology is based on identifying both regions of low density and segments (default size of 500 events) that are significantly different from the rest. Eight measures of each segment (mean, median, 5th, 20th, 80th and 95th percentile, second moment (variation) and third moment (skewness)) are calculated. The density of the summation of the 8 measures and two parameters (MaxValleyHgt and MaxPercCut) will determine which events are significantly different and these will be removed. We also flag files if they display any of the following: 1) not monotonically increasing in time, 2) sudden changes in fluorescence, 3) large gradual change of fluorescence in all channels or 4) very large gradual change of fluorescence in one channel.
}

\value{
        A list containing four elements. The first element, \$frame, is the flowFrame file returned after flowCut has cleaned the flowFrame. The second element, \$ind, is a vector containing indices of segments being removed. The third element, \$data, is a table containing computational information that users can access. Information includes "Is it monotonically increasing in time", "Largest continuous jump", "Continuous - Pass", "Mean of percentage of range of means divided by range of data", "Mean of \% - Pass", "Max of \% of range of means divided by range of data", "Max of \% - Pass", "Has a low density section been removed", "\% of low density removed", "How many Segments have been removed", "\% of events removed from Segments removed", "Worst Channel", "\% of events removed", "FileID", and "Has the file passed". The fourth element, \$worstChan, is the index of the channel with the most drift over time before cleaning.
}

\author{
        Maintainer: Justin Meskas <jmeskas@bccrc.ca>

        Authors: Justin Meskas, Sherrie Wang
}


\examples{
data(flowCutData)
res_flowCut <- flowCut(flowCutData[[1]])
# See plot in working directory/flowCut

# Here is an example with decreasing the MaxValleyHgt parameter.
res_flowCut <- flowCut(flowCutData[[1]], MaxValleyHgt = 0.02, Verbose = TRUE)
res_flowCut$data

# Here is an example with raising the MaxPercCut parameter.
res_flowCut <- flowCut(flowCutData[[2]], MaxPercCut = 0.5, Verbose = TRUE)
res_flowCut$data

# Alternative plotting option
library(flowDensity)
plotDens(flowCutData[[2]], c(8,3))
points(flowCutData[[2]]@exprs[res_flowCut$ind ,c(8,3)], pch=".")

}

\keyword{FlowCytData}