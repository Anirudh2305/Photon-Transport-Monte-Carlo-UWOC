# Channel Modelling for Underwater Optical Communication using Monte Carlo Simulation.
The code models underwater photon transport using the Monte Carlo simulation. The source is taken as a diveregent circular beam. Link distance and receiver aperture 
diamater has been varied for different readings. The scattering angles are calculated using Henyey-Greenstein Phase function. The project involves plots for Intensity
vs Link distance and also the Channel Impulse Response which is the intensity received vs time of flight of photon.
# Usage
***Photon.m*** is a user-defined structure for the Photons. It contains functions for updating the coordinates and direction cosines. 

***Monte_carlo.m*** contains all the parameters and gives the intensity for a particular link distance and aperture distance.

***MCScript.m*** gives Intensity vs Link distance plot for a particluar aperture diameter.

***Hen_Green.m*** returns the polar angle theta.

***Channel_Impulse_response.m*** gives a plot of CIR for a particluar link distance and receiver aperture.

***Novelty.m*** contains an extra addition to the mechanism. Here we consider the medium to be finite along Y-axis and model reflection of light due to TIR.
