# stats.swiss dataflows

Every dataflow published by the Swiss Stats Explorer, as of the last
`discover` workflow run: **216** dataflows across
29 agencies.

Each row is a candidate OpenTSI archive: copy this repository, change the
constants named in [docs/PLAYBOOK.md](../../docs/PLAYBOOK.md) section 5, and
rebuild the metadata. Rows whose id ends in `_MONTHLY`, `_QUARTERLY` or
`_ANNUAL` are explicitly periodic and therefore the easiest starting points;
for the others, check the `FREQ` codelist before committing to one repo.

Regenerate with: Actions -> Discover stats.swiss structure -> Run workflow.

## CH1.AHBB

| dataflow | version | title |
|---|---|---|
| `DF_AHBB_BEITRAG` | 1.0.0 | Federal grants for individuals in higher vocational training: grants by field of education |
| `DF_AHBB_KANDIDAT` | 1.0.0 | Federal grants for individuals in higher vocational training: examination candidates and recipients by field of educatio |
| `DF_AHBB_KURSE` | 1.0.0 | Federal grants for individuals in higher vocational training: Course providers and courses by field of education |

## CH1.AREA

| dataflow | version | title |
|---|---|---|
| `DF_AREA_IMPV` | 1.0.0 | Soil sealing, in hectares |
| `DF_AREA_NOAS` | 1.1.0 | Swiss Land Use Statistics: standard nomenclature, in hectares |
| `DF_AREA_NOLC` | 1.1.0 | Swiss Land Use Statistics: land cover, in hectares |
| `DF_AREA_NOLU` | 1.1.0 | Swiss Land Use Statistics: land use, in hectares |
| `DF_AREA_SFE` | 1.1.0 | Settlement area in m2 per inhabitant |
| `DF_AREA_SFEV` | 1.1.0 | Settlement area in m2 per inhabitant and job |

## CH1.ARMUT

| dataflow | version | title |
|---|---|---|
| `DF_ARMUT_OVERVIEW` | 1.0.0 | Poverty before and after social transfers, risk of poverty and deprivation |

## CH1.ASSTAT

| dataflow | version | title |
|---|---|---|
| `DF_ASSTAT_CONSULARSTATE` | 1.0.0 | Swiss citizens living abroad by Consular District |
| `DF_ASSTAT_RESIDENCESTATE` | 1.0.0 | Swiss citizens living abroad by country of residence |

## CH1.AVIA

| dataflow | version | title |
|---|---|---|
| `DF_AVIA_LC_FRE` | 1.0.0 | Air freight and mail on scheduled and charter flights (tonnage) |
| `DF_AVIA_LC_MOV` | 1.0.0 | Aircraft movements (arrivals and departures), scheduled and charter flights |
| `DF_AVIA_LC_PAX` | 1.0.0 | Air passengers on scheduled and charter flights |
| `DF_AVIA_LC_PFD` | 1.0.0 | Air passengers on scheduled and charter flights by final destination (departing local passengers only) |

## CH1.BEVNAT

| dataflow | version | title |
|---|---|---|
| `DF_BEVNAT_ADOPTIONS_1` | 1.0.0 | Adoptions by canton, sex, age and citizenship (selection) before adoption of the adopted person and the status of the ad |
| `DF_BEVNAT_DECES_1` | 1.0.0 | Deaths by institutional units, sex, citizenship (category), marital status and age class |
| `DF_BEVNAT_DECES_2` | 1.0.0 | Deaths by sex, citizenship, marital status and age |
| `DF_BEVNAT_DECES_3` | 1.0.0 | Deaths by sex, age class, citizenship (category) and marital status |
| `DF_BEVNAT_DISSOLUTIONS_1` | 1.0.0 | Dissolved partnerships by canton, duration of the partnership, sex and constellation of citizenship (category) of the co |
| `DF_BEVNAT_DIVORCES_2` | 1.0.0 | Divorces by canton, duration of marriage and age class of both partners |
| `DF_BEVNAT_DIVORCES_3` | 1.0.0 | Divorces by institutional units, duration of marriage and citizenship (category) of both partners at divorce |
| `DF_BEVNAT_DIVORCES_4` | 1.0.0 | Divorces by duration of marriage, citizenship (selection) at divorce and age class of both partners |
| `DF_BEVNAT_EVENEMENTS_1` | 1.0.0 | Vital statistics by canton and year, month and day of the event |
| `DF_BEVNAT_MARIAGES_1` | 1.1.0 | Marriages by type of marriage and citizenship of the spouses |
| `DF_BEVNAT_MARIAGES_2` | 1.0.0 | Marriages by institutional units, constellation of gender of the couple and nationality (category) of the spouses |
| `DF_BEVNAT_MARIAGES_3` | 1.0.0 | Marriages by canton, type of marriage and age of both partners |
| `DF_BEVNAT_MARIAGES_4` | 1.0.0 | Marriages by age class, citizenship (selection) and marital status of both partners |
| `DF_BEVNAT_MORTINAISSANCES_1` | 1.0.0 | Stillbirths by sex and citizenship (category) of the child and marital status (category) of the mother |
| `DF_BEVNAT_NAISSANCES_1` | 1.0.0 | Live births by institutional units, sex and citizenship (category) of the child and age class of the mother |
| `DF_BEVNAT_NAISSANCES_2` | 1.0.0 | Live births by sex and birth order of the child, citizenship and marital status of the mother (category) and by age clas |
| `DF_BEVNAT_NAISSANCES_3` | 1.0.0 | Live births by sex and citizenship (category) of the child and marital status of the mother |
| `DF_BEVNAT_PARTENARIATS_1` | 1.0.0 | Registered partnerships by canton, marital status before partnership, citizenship (category) and age class of both partn |
| `DF_BEVNAT_PRENOMS_1` | 1.0.0 | Male first names of newborns by language region and canton |
| `DF_BEVNAT_PRENOMS_2` | 1.0.0 | Female first names of newborns by language region and canton |
| `DF_BEVNAT_RECONNAISSANCES_1` | 1.0.0 | Acknowledgements of paternity by canton, sex and age class of the child and citizenship (category) of the parents |

## CH1.CITYSTAT

| dataflow | version | title |
|---|---|---|
| `DF_CITYSTAT_1` | 1.0.0 | City Statistics: Ausgewählte Variablen nach Städten und Agglomerationen 2020 |
| `DF_CITYSTAT_2` | 1.0.0 | Lebensqualität in den Städten und Agglomerationen (Agglo2020): Arbeitsmarkt, Wohnen, Bildung - kumulierte Daten der Stru |
| `DF_CITYSTAT_3` | 1.0.0 | Lebensqualität in den Quartieren der City Statistics Städten: Demografischer Kontext und Wohnsituation |
| `DF_CITYSTAT_CHURB_1` | 1.0.0 | Urbane Schweiz: Ausgewählte Variablen nach Agglomerationen 2020 |
| `DF_CITYSTAT_CHURB_2` | 1.0.0 | Urbane Schweiz: Ausgewählte Variablen nach statistischen Städten 2020 |
| `DF_CITYSTAT_CHURB_3` | 1.0.0 | Urbane Schweiz: Ausgewählte Variablen nach dem Raum mit städtischem Charakter 2020 |
| `DF_CITYSTAT_CHURB_4` | 1.0.0 | Urbane Schweiz: Ausgewählte Variablen nach der Stadt/Land-Typologie 2020 |
| `DF_CITYSTAT_CHURB_5` | 1.0.0 | Urbane Schweiz: Ausgewählte Variablen nach Arbeitsmarktregionen und Arbeitsmarktgrossregionen 2018 |

## CH1.COU

| dataflow | version | title |
|---|---|---|
| `DF_COU_HEALTH_COSTS` | 1.0.0 | Costs of health care |
| `DF_COU_HEALTH_FINANCING` | 1.0.0 | Financing of health care |

## CH1.FE_BUND

| dataflow | version | title |
|---|---|---|
| `DF_FE_BUND_DEP` | 1.0.0 | Confederation R&D expenditure |
| `DF_FE_BUND_PERS` | 1.0.0 | Confederation R&D personnel |

## CH1.GE

| dataflow | version | title |
|---|---|---|
| `DF_VOTATION` | 1.0 | Electeurs, votants selon le sexe et l'âge |

## CH1.GGS

| dataflow | version | title |
|---|---|---|
| `DF_GGS_1` | 1.0.0 | Foreign cross-border commuters by canton of employment, economic activity, country of residence and gender |
| `DF_GGS_2` | 1.1.0 | Cross-border commuters of foreign nationality by place of work and gender |
| `DF_GGS_3` | 1.0.0 | Foreign cross-border commuters by place of residence, canton of work and gender |
| `DF_GGS_4` | 1.0.0 | Foreign cross-border commuters by economic divison and employment status |
| `DF_GGS_5` | 1.0.0 | Foreign cross-border commuters by canton of employment, activity status, permit validity and gender |
| `DF_GGS_6` | 1.0.0 | Foreign cross-border commuters by canton of employment, age group and gender |

## CH1.GVS

| dataflow | version | title |
|---|---|---|
| `DF_GVS_INPATIENT_DELIVERY` | 1.0.0 | Deliveries and cesarean sections in hospitals |
| `DF_GVS_INPATIENT_ENCOUNTER` | 1.0.0 | Patients in hospitals |
| `DF_GVS_PRACTICES_GENERAL` | 1.0.0 | Medical practices and outpatient centers: facilities, sites, and physicians |

## CH1.GWS

| dataflow | version | title |
|---|---|---|
| `DF_GWS_REG1` | 1.0.0 | Buildings by geographical institutional levels (canton, municipality), building category and construction period |
| `DF_GWS_REG2` | 1.0.0 | Buildings by canton, building category, number of storeys, number of dwellings and construction period |
| `DF_GWS_REG3` | 1.0.0 | Buildings by geographical institutional levels (canton, municipality), heating energy source, building category and cons |
| `DF_GWS_REG4` | 1.0.0 | Buildings by canton, building category, main energy source for heating, main energy source for hot water and constructio |
| `DF_GWS_REG5` | 1.0.0 | Dwellings by geographical institutional levels (canton, municipality), building category, number of rooms, and construct |
| `DF_GWS_REG6` | 1.0.0 | Dwellings by canton, building category, number of rooms, floor space and construction period |
| `DF_GWS_REG7` | 1.0.0 | Dwellings by geographical institutional levels (canton, municipality), building category, floor space, and construction  |

## CH1.JUSAS

| dataflow | version | title |
|---|---|---|
| `DF_JUSAS_DECISIONS` | 1.0.0 | Juveniles: Convictions and other types of conflict resolution |
| `DF_JUSAS_MAINSCTN_DURATION_CAT` | 1.0.0 | Minors: Main sanction according to type and duration |
| `DF_JUSAS_MAINSCTN_SOCIODEM` | 1.0.0 | Juveniles: Main sanction and characteristics of the convicted person |
| `DF_JUSAS_PERSONS` | 1.0.0 | Juveniles: Convicted persons by offence |
| `DF_JUSAS_PREDECISIONS` | 1.0.0 | Juveniles: Provisionally ordered out-patient measure |
| `DF_JUSAS_SNCTN_MEASURES` | 1.0.0 | Juveniles: Sentences involving a measure |
| `DF_JUSAS_VIOLENCE` | 1.0.0 | Juveniles: Convictions for an offence of violence |

## CH1.KEU

| dataflow | version | title |
|---|---|---|
| `DF_KEU_A1` | 1.0.0 | Turnover for the secondary and tertiary sectors - annual series |
| `DF_KEU_M1` | 1.0.0 | Turnover for the secondary and tertiary sectors - monthly series |
| `DF_KEU_Q1` | 1.0.0 | Turnover for the secondary and tertiary sectors - quarterly series |

## CH1.LWZ

| dataflow | version | title |
|---|---|---|
| `DF_LWZ_1` | 1.0.0 | Vacant dwellings by region, canton, district, municipality, number of rooms and type of vacant dwelling |

## CH1.MFZ_IVS

| dataflow | version | title |
|---|---|---|
| `DF_IVS_0_GENERAL` | 1.0.0 | New registrations of road vehicles by vehicle group and type |
| `DF_IVS_0_GENERAL_M` | 1.0.0 | New registrations of road vehicles by vehicle group and type, according to data status immediately after the end of the  |
| `DF_IVS_1_EMISSION` | 1.0.0 | New registrations of passenger cars by technical characteristics (2/2) |
| `DF_IVS_1_MAKE` | 1.0.0 | New registrations of passenger cars by make |
| `DF_IVS_1_TECH` | 1.0.0 | New registrations of passenger cars by technical characteristics (1/2) |
| `DF_IVS_2` | 1.0.0 | New registrations of passenger transport vehicles by technical characteristics |
| `DF_IVS_3` | 1.0.0 | New registrations of goods transport vehicles by technical characteristics |
| `DF_IVS_4` | 1.0.0 | New registrations of agricultural vehicles by technical characteristics |
| `DF_IVS_5` | 1.0.0 | New registrations of industrial vehicles by technical characteristics |
| `DF_IVS_6` | 1.0.0 | New registrations of motorcycles by technical characteristics |
| `DF_IVS_7` | 1.0.0 | New registrations of road vehicle trailers by technical characteristics |
| `DF_MFZ_0_GENERAL` | 1.0.0 | Stock of road vehicles by vehicle group and type |
| `DF_MFZ_1_EMISSION` | 1.0.0 | Stock of passenger cars by technical characteristics (2/2) |
| `DF_MFZ_1_MAKE` | 1.0.0 | Stock of passenger cars by make |
| `DF_MFZ_1_TECH` | 1.0.0 | Stock of passenger cars by technical characteristics (1/2) |
| `DF_MFZ_2` | 1.0.0 | Stock of passenger transport vehicles by technical characteristics |
| `DF_MFZ_3` | 1.0.0 | Stock of goods transport vehicles by technical characteristics |
| `DF_MFZ_4` | 1.0.0 | Stock of agricultural vehicles by technical characteristics |
| `DF_MFZ_5` | 1.0.0 | Stock of industrial vehicles by technical characteristics |
| `DF_MFZ_6` | 1.0.0 | Stock of motorcycles by technical characteristics |
| `DF_MFZ_7` | 1.0.0 | Stock of road vehicle trailers by technical characteristics |

## CH1.NRS

| dataflow | version | title |
|---|---|---|
| `DF_NRS_S1_NEURENTEN` | 1.0.0 | Beneficiaries of a new old-age and survivors' insurance (OASI) pension |
| `DF_NRS_S2_PK_FZ_KAP` | 1.0.0 | Beneficiaries of new lump-sum payment from the occupational pension plan (pension funds and vested benefits institutions |
| `DF_NRS_S2_PK_FZ_NEURENTEN` | 1.0.0 | Recipients of a new old-age pension from the occupational pension plan (pension funds and vested benefits institutions) |
| `DF_NRS_S3A_KAPITALAUSZ` | 1.0.0 | Beneficiaries of a new lump-sum payment from the Pillar 3a |
| `DF_NRS_S3B_KAPITALAUSZ` | 1.0.0 | Beneficiaries of a new lump-sum benefit from insurance 3b (private insurance) |
| `DF_NRS_S3B_NEURENTEN` | 1.0.0 | Beneficiaries of a new pension from pillar 3b (private insurance) |

## CH1.PASTA

| dataflow | version | title |
|---|---|---|
| `DF_PASTA_552_COUNTRIES` | 1.0.0 | Arrivals and overnight stays in holiday homes and collective  accommodation by country of origin |
| `DF_PASTA_552_MONTHLY` | 1.0.0 | Arrivals and overnight stays in holiday homes and collective accommodation by month |
| `DF_PASTA_552_NUTS2_DEMAND` | 1.0.0 | Arrivals and overnight stays in holiday homes and collective accommodation by major region |
| `DF_PASTA_552_NUTS2_SUPPLY` | 1.0.0 | Number of objects and beds in holiday homes and collective accommodation by major region |
| `DF_PASTA_553_COUNTRIES` | 1.0.0 | Arrivals and overnight stays at campsites by country of origin |
| `DF_PASTA_553_MONTHLY` | 1.0.0 | Arrivals and overnight stays at campsites by month |
| `DF_PASTA_553_NUTS2_DEMAND` | 1.0.0 | Arrivals and overnight stays at campsites by major region |
| `DF_PASTA_553_NUTS2_SUPPLY` | 1.0.0 | Number of campsites and pitches surveyed by major region |
| `DF_PASTA_553_TR_DEMAND` | 1.0.0 | Arrivals and overnight stays at campsites by tourist regions |
| `DF_PASTA_553_TR_SUPPLY` | 1.0.0 | Number of campsites and pitches surveyed by tourist region |

## CH1.RDISP

| dataflow | version | title |
|---|---|---|
| `DF_RDISP_1` | 1.0.0 | Regionale Disparitäten: Ausgewählte Variablen nach der Stadt/Land-Typologie 2020 |
| `DF_RDISP_2` | 1.0.0 | Regionale Disparitäten: Ausgewählte Variablen nach Arbeitsmarktregionen 2018 |

## CH1.SAKE

| dataflow | version | title |
|---|---|---|
| `DF_SAKE_TEILZEITGRUND` | 1.0.0 | Main reason for part-time employment by sex, nationality, age and educational level |

## CH1.SAKE_MOD_UA

| dataflow | version | title |
|---|---|---|
| `DF_SAKE_MOD_UA_1_ACTIVITY` | 1.0.0 | Time spent on unpaid work by type of activity or organisation in hours per week |
| `DF_SAKE_MOD_UA_1_GENERAL` | 1.0.0 | Time spent on domestic and family workload, voluntary work and paid work in hours per week |
| `DF_SAKE_MOD_UA_2` | 1.0.0 | Participation in voluntary work in % |
| `DF_SAKE_MOD_UA_3_NOCHILD` | 1.0.0 | Time spent on domestic and family workload by work situation in hours per week, households without children |
| `DF_SAKE_MOD_UA_3_WITHCHILD` | 1.0.0 | Time spent on domestic and family workload by work situation in hours per week, households with child(ren) under 25 |

## CH1.SCEN

| dataflow | version | title |
|---|---|---|
| `DF_SCEN_MENAGES` | 1.0.0 | Household scenarios by canton and household size |

## CH1.SHAF

| dataflow | version | title |
|---|---|---|
| `DF_SHAF_VERLAUF_16_55_CH` | 1.0.0 | Sozialhilfebezugsverläufe im Asyl- und Flüchtlingsbereich der bei Einreise 16-55 Jährigen |
| `DF_SHAF_VERLAUF_16_55_KT` | 1.0.0 | Sozialhilfebezugsverläufe im Asyl- und Flüchtlingsbereich der bei Einreise 16-55 Jährigen, nach Kanton |
| `DF_SHAF_VERLAUF_CH` | 1.0.0 | Sozialhilfebezugsverläufe im Asyl- und Flüchtlingsbereich |
| `DF_SHAF_VERLAUF_KT` | 1.0.0 | Sozialhilfebezugsverläufe im Asyl- und Flüchtlingsbereich, nach Kanton |

## CH1.SSV

| dataflow | version | title |
|---|---|---|
| `DF_SSV_AREA_NOAS` | 2026.1.0 | Statistik der Schweizer Städte 2026, Bodennutzungsart gemäss Arealstatistik des BFS (in Hektaren) |
| `DF_SSV_AREA_NOLC` | 2026.1.0 | Statistik der Schweizer Städte 2026, versiegelte Flächen gemäss Arealstatistik des BFS (in Hektaren) |
| `DF_SSV_BUILD_AGE` | 2026.1.0 | Statistik der Schweizer Städte 2026, Wohnungen und Gebäude nach Bauperiode |
| `DF_SSV_BUILD_BUILD` | 2026.1.0 | Statistik der Schweizer Städte 2026, jährlicher baulicher Zugang an Wohnungen nach Typ der Arbeiten |
| `DF_SSV_BUILD_CAT` | 2026.1.0 | Statistik der Schweizer Städte 2026, Gebäude nach Gebäudekategorie |
| `DF_SSV_BUILD_FLO` | 2026.1.0 | Statistik der Schweizer Städte 2026, Gebäude mit Wohnnutzung nach Geschosszahl |
| `DF_SSV_BUILD_HOUSING` | 2026.1.0 | Statistik der Schweizer Städte 2026, Wohnungen nach Anzahl Zimmer |
| `DF_SSV_BUILD_HOUSING_OC` | 2026.1.0 | Statistik der Schweizer Städte 2026, bewohnte Wohnungen nach Bewohnertyp und durchschnittlicher monatlicher Nettomiete |
| `DF_SSV_BUILD_LS` | 2026.1.0 | Statistik der Schweizer Städte 2026, Wohnfläche, Belegungs- und Wohndichte |
| `DF_SSV_BUILD_LWZ` | 2026.1.0 | Statistik der Schweizer Städte 2026, Leerwohnungen nach Zimmerzahl |
| `DF_SSV_BUILD_MOVING` | 2026.1.0 | Statistik der Schweizer Städte 2026, Anteil umgezogener Personen in der ständigen Wohnbevölkerung |
| `DF_SSV_EDUC` | 2026.1.0 | Statistik der Schweizer Städte 2026, Bestand der Lernenden |
| `DF_SSV_EDUC_LEVEL` | 2026.1.0 | Statistik der Schweizer Städte 2026, höchste abgeschlossene Ausbildung |
| `DF_SSV_EMPLOYEMENT` | 2026.1.0 | Statistik der Schweizer Städte 2026, Arbeitsstätten nach Grössenklasse und Beschäftigte nach Wirtschaftssektor |
| `DF_SSV_ENERGY_HEATING` | 2026.1.0 | Statistik der Schweizer Städte 2026, Wohnungen nach Energiequelle der Heizung |
| `DF_SSV_ENERGY_WTRGZ` | 2026.1.0 | Statistik der Schweizer Städte 2026, Wasser- und Gasversorgung |
| `DF_SSV_FIN_COM_ASS` | 2026.1.0 | Statistik der Schweizer Städte 2026, kommunale Aktiven |
| `DF_SSV_FIN_COM_DEB` | 2026.1.0 | Statistik der Schweizer Städte 2026, kommunale Passiven |
| `DF_SSV_FIN_COM_EXP` | 2026.1.0 | Statistik der Schweizer Städte 2026, kommunale Ausgaben |
| `DF_SSV_FIN_COM_EXP_CSL` | 2026.1.0 | Statistik der Schweizer Städte 2026, kommunale Ausgaben, Bereich Kultur, Sport und Freizeit |
| `DF_SSV_FIN_COM_REV` | 2026.1.0 | Statistik der Schweizer Städte 2026, kommunale Einnahmen |
| `DF_SSV_FIN_COM_REV_CSL` | 2026.1.0 | Statistik der Schweizer Städte 2026, kommunale Einnahmen, Bereich Kultur, Sport und Freizeit |
| `DF_SSV_FIN_COM_SPE` | 2026.1.0 | Statistik der Schweizer Städte 2026, kommunale Ausgaben nach Aufgabengebieten |
| `DF_SSV_LABMAR_01` | 2026.1.0 | Statistik der Schweizer Städte 2026, Anteil der Beschäftigten nach Wirtschaftsabschnitt |
| `DF_SSV_LABMAR_02` | 2026.1.0 | Statistik der Schweizer Städte 2026, Anteil der Beschäftigten nach Wirtschaftssektor und Geschlecht |
| `DF_SSV_LABMAR_03` | 2026.1.0 | Statistik der Schweizer Städte 2026, Arbeitsmarkteintritte (mit 20 Jahren) und -austritte (mit 65 Jahren) |
| `DF_SSV_LABMAR_04` | 2026.1.0 | Statistik der Schweizer Städte 2026, Beschäftigten- und Arbeitsstättendichte |
| `DF_SSV_LABMAR_06` | 2026.1.0 | Statistik der Schweizer Städte 2026, Pendlerströme |
| `DF_SSV_LABMAR_07` | 2026.1.0 | Statistik der Schweizer Städte 2026, Nettoerwerbsquote |
| `DF_SSV_LABMAR_08` | 2026.1.0 | Statistik der Schweizer Städte 2026, Arbeitswegzeit und Arbeitswegdistanz |
| `DF_SSV_MOB_CAR` | 2026.1.0 | Statistik der Schweizer Städte 2026, Strassenfahrzeuge |
| `DF_SSV_MOB_COM` | 2026.1.0 | Statistik der Schweizer Städte 2026, Pendler nach Hauptverkehrsmittel |
| `DF_SSV_POL_EXE` | 2026.1.0 | Statistik der Schweizer Städte 2026, Sitzverteilung in den städtischen Exekutiven |
| `DF_SSV_POL_LEG` | 2026.1.0 | Statistik der Schweizer Städte 2026, Sitzverteilung in den städtischen Legislativen |
| `DF_SSV_POP_1930` | 2026.1.0 | Statistik der Schweizer Städte 2026, ständige Wohnbevölkerung ab 1930 |
| `DF_SSV_POP_AGE_CLS` | 2026.1.0 | Statistik der Schweizer Städte 2026, ständige Wohnbevölkerung nach Altersklasse |
| `DF_SSV_POP_BIL` | 2026.1.0 | Statistik der Schweizer Städte 2026, Bilanz der ständigen Wohnbevölkerung |
| `DF_SSV_POP_ETR` | 2026.1.0 | Statistik der Schweizer Städte 2026, ständige Wohnbevölkerung nach Staatsangehörigkeit und Geburtsort |
| `DF_SSV_POP_ETR_AUT` | 2026.1.0 | Statistik der Schweizer Städte 2026, ständige ausländische Wohnbevölkerung nach Anwesenheitsbewilligung |
| `DF_SSV_POP_ETR_NAT` | 2026.1.0 | Statistik der Schweizer Städte 2026, ständige ausländische Wohnbevölkerung nach Staatsangehörigkeit |
| `DF_SSV_POP_HLD` | 2026.1.0 | Statistik der Schweizer Städte 2026, Privathaushalte nach Haushaltsgrösse |
| `DF_SSV_POP_SE` | 2026.1.0 | Statistik der Schweizer Städte 2026, ständige Wohnbevölkerung nach Geschlecht und Zivilstand |
| `DF_SSV_SOCIAL` | 2026.1.0 | Statistik der Schweizer Städte 2026, Sozialhilfebeziehende |
| `DF_SSV_STRU_EMP` | 2025.2 | Statistik der Schweizer Städte 2025, Beschäftigte in Landwirtschaftsbetrieben |
| `DF_SSV_STRU_EXP` | 2025.2 | Statistik der Schweizer Städte 2025, Landwirtschafsbetriebe |
| `DF_SSV_STRU_EXPO` | 2025.2 | Statistik der Schweizer Städte 2025, Landwirtschaftsbetriebe, nach betriebswirtschaftlicher Ausrichtung |
| `DF_SSV_STRU_SAU` | 2025.2 | Statistik der Schweizer Städte 2025, Landwirtschaftliche Nutzfläche (LN) nach Kulturart (in Hektaren) |
| `DF_SSV_STRU_SAU_EXP` | 2025.2 | Statistik der Schweizer Städte 2025, Landwirtschaftliche Nutzfläche (LN) pro Betrieb (in Hektaren) |
| `DF_SSV_TAX_BRDN_FOR_MAR_NC` | 2026.1.0 | Statistik der Schweizer Städte 2026, Steuerbelastung natürliche Personen: Verheiratete, ohne Kinder, Reinvermögen (in 10 |
| `DF_SSV_TAX_BRDN_REV_MAR_2C` | 2026.1.0 | Statistik der Schweizer Städte 2026, Steuerbelastung natürliche Personen: Verheiratete, ein Einkommen, mit 2 Kindern, Br |
| `DF_SSV_TAX_BRDN_REV_MAR_NC` | 2026.1.0 | Statistik der Schweizer Städte 2026, Steuerbelastung natürliche Personen: Verheiratete, ein Einkommen, ohne Kinder, Brut |
| `DF_SSV_TAX_BRDN_REV_RENT` | 2026.1.0 | Statistik der Schweizer Städte 2026, Steuerbelastung natürliche Personen: verheiratete Rentner, Bruttoarbeitseinkommen ( |
| `DF_SSV_TAX_BRDN_REV_SIN` | 2026.1.0 | Statistik der Schweizer Städte 2026, Steuerbelastung natürliche Personen: Ledige, ein Einkommen, ohne Kinder, Bruttoarbe |
| `DF_SSV_TOURISM` | 2026.1.0 | Statistik der Schweizer Städte 2026, Angebot und Nachfrage der Hotelbetriebe |
| `DF_SSV_UNEMPLOYEMENT` | 2026.1.1 | Statistik der Schweizer Städte 2026, Arbeitslose nach Geschlecht und Wirtschaftssektor |

## CH1.STATKREBS

| dataflow | version | title |
|---|---|---|
| `DF_STATKREBS_MEASURES` | 1.0.0 | Cancer: Key figures by language region, cancer site, sex and period |
| `DF_STATKREBS_NUM_RATES` | 1.0.0 | Cancer: number and rates of new cases and deaths by language region, cancer site, sex, period, and age class |

## CH1.STATPOP

| dataflow | version | title |
|---|---|---|
| `DF_STATPOP_GEO_NATCAT_ORT_SEX` | 1.0.0 | Permanent resident population by institutional units, citizenship (category), place of birth and sex |
| `DF_STATPOP_GEO_ORT_SEX_ZIVL` | 1.0.0 | Permanent resident population by institutional units, place of birth, sex and marital status |
| `DF_STATPOP_GEO_SEX_ZIVL_AGE5` | 1.0.0 | Permanent resident population by institutional units, sex, marital status and age class |
| `DF_STATPOP_KANT_AUT_ORT_SEX_AGE` | 1.0.0 | Permanent resident population by canton, residence permit, place of birth, sex and age class |
| `DF_STATPOP_NATCAT_SEX_AGE_GEO` | 1.0.0 | Permanent resident population by institutional units, citizenship (category), sex and age class |
| `DF_STATPOP_PERSPHH` | 1.0.0 | Permanent resident population in private households by institutional units, sex, age groups and household size |
| `DF_STATPOP_PHH` | 1.0.0 | Private households by institutional units and household size |
| `DF_STATPOP_REGLING` | 1.0.0 | Permanent and non-permanent resident population by language area, citizenship (category), sex and age |
| `DF_STATPOP_REGLING_PERM` | 1.0.0 | Permanent resident population by linguistic region, citizenship (category), sex and age |

## CH1.SUS

| dataflow | version | title |
|---|---|---|
| `DF_SUS_DECISIONS` | 1.0.0 | Adults: Convictions by offence |
| `DF_SUS_MAINSCTN_DURATION_CAT` | 1.0.0 | Adults: Main sanction according to type and duration |
| `DF_SUS_MAINSCTN_DURATION_STAT` | 1.0.0 | Adults: Statistical calculations on the duration in days of the main penalty |
| `DF_SUS_MAINSCTN_SOCIODEM` | 1.0.0 | Adults: Main sanction and characteristics of the convicted person |
| `DF_SUS_NATIONALITIES_ARTICLES` | 1.0.0 | Persons convicted of a crime or offence under the Swiss Criminal Code (SCC) by nationality, offence, population category |
| `DF_SUS_NATIONALITIES_LAWS` | 1.0.0 | Persons convicted by nationality, law, sex, age, population category and year of conviction |
| `DF_SUS_NEN_REVOCLIB` | 1.0.0 | Adults: Rates of revocation of conditional release |
| `DF_SUS_NEN_REVOCSRS` | 1.0.0 | Adults: Rates of revocation of suspended sentences |
| `DF_SUS_PERSONS` | 1.0.0 | Adults: Convicted persons by offence |
| `DF_SUS_PRETRIAL_DURATION` | 1.0.0 | Adults: Length of pre-trial detention imposed on convicted persons |
| `DF_SUS_PRETRIAL_SOCIODEM` | 1.0.0 | Adults: Pre-trial detention according to various sociodemographic characteristics of convicted persons |
| `DF_SUS_PROCESS` | 1.0.0 | Adults: Convictions by type of criminal procedure |
| `DF_SUS_REC_COURBREC` | 1.0.0 | Adults: Evolution of recidivism rates between six months and three years |
| `DF_SUS_REC_MODALREC` | 1.0.0 | Adults: Recidivism over three years according to different criteria |
| `DF_SUS_REC_UNVRSDPRT` | 1.0.0 | Adults: Three-year recidivism rates by different characteristics of the initial population |
| `DF_SUS_SNCTN_COMBINATIONS` | 1.0.0 | Adults: Main sanction and combination with other sanctions |
| `DF_SUS_SNCTN_MEASURES` | 1.0.0 | Adults: Sentences involving a measure |
| `DF_SUS_SNCTN_MONETARY` | 1.0.0 | Adults: Monetary penalties and fines according to amounts in CHF |
| `DF_SUS_SNCTN_PROHIBITIONS` | 1.0.0 | Adults: Convictions with prohibitions from carrying on an activity, contact prohibitions and exclusion orders |

## CH1.UGR

| dataflow | version | title |
|---|---|---|
| `DF_EWMFA_1` | 1.1.0 | Material flow accounts - Direct input flows and their aggregates |
| `DF_EWMFA_2` | 1.1.0 | Material flow accounts - Domestic Processed Output DPO |
| `DF_EWMFA_3` | 1.1.0 | Material flow accounts - Indicators |
| `DF_UGR_TAX_1` | 1.0.0 | Environmentally related taxes account by tax category and economic player |

