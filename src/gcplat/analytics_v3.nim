
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Analytics
## version: v3
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Views and manages your Google Analytics data.
## 
## https://developers.google.com/analytics/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_588466 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588466](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588466): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "analytics"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AnalyticsDataGaGet_588734 = ref object of OpenApiRestCall_588466
proc url_AnalyticsDataGaGet_588736(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsDataGaGet_588735(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Returns Analytics data for a view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
  ##   segment: JString
  ##          : An Analytics segment to be applied to data.
  ##   metrics: JString (required)
  ##          : A comma-separated list of Analytics metrics. E.g., 'ga:sessions,ga:pageviews'. At least one metric must be specified.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: JString
  ##             : A comma-separated list of Analytics dimensions. E.g., 'ga:browser,ga:city'.
  ##   ids: JString (required)
  ##      : Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of entries to include in this feed.
  ##   end-date: JString (required)
  ##           : End date for fetching Analytics data. Request can should specify an end date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is yesterday.
  ##   start-date: JString (required)
  ##             : Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   filters: JString
  ##          : A comma-separated list of dimension or metric filters to be applied to Analytics data.
  ##   include-empty-rows: JBool
  ##                     : The response will include empty rows if this parameter is set to true, the default is true
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   samplingLevel: JString
  ##                : The desired sampling level.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   output: JString
  ##         : The selected format for the response. Default format is JSON.
  section = newJObject()
  var valid_588848 = query.getOrDefault("fields")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "fields", valid_588848
  var valid_588849 = query.getOrDefault("quotaUser")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "quotaUser", valid_588849
  var valid_588863 = query.getOrDefault("alt")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = newJString("json"))
  if valid_588863 != nil:
    section.add "alt", valid_588863
  var valid_588864 = query.getOrDefault("sort")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "sort", valid_588864
  var valid_588865 = query.getOrDefault("segment")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "segment", valid_588865
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_588866 = query.getOrDefault("metrics")
  valid_588866 = validateParameter(valid_588866, JString, required = true,
                                 default = nil)
  if valid_588866 != nil:
    section.add "metrics", valid_588866
  var valid_588867 = query.getOrDefault("oauth_token")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "oauth_token", valid_588867
  var valid_588868 = query.getOrDefault("userIp")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "userIp", valid_588868
  var valid_588869 = query.getOrDefault("dimensions")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "dimensions", valid_588869
  var valid_588870 = query.getOrDefault("ids")
  valid_588870 = validateParameter(valid_588870, JString, required = true,
                                 default = nil)
  if valid_588870 != nil:
    section.add "ids", valid_588870
  var valid_588871 = query.getOrDefault("key")
  valid_588871 = validateParameter(valid_588871, JString, required = false,
                                 default = nil)
  if valid_588871 != nil:
    section.add "key", valid_588871
  var valid_588872 = query.getOrDefault("max-results")
  valid_588872 = validateParameter(valid_588872, JInt, required = false, default = nil)
  if valid_588872 != nil:
    section.add "max-results", valid_588872
  var valid_588873 = query.getOrDefault("end-date")
  valid_588873 = validateParameter(valid_588873, JString, required = true,
                                 default = nil)
  if valid_588873 != nil:
    section.add "end-date", valid_588873
  var valid_588874 = query.getOrDefault("start-date")
  valid_588874 = validateParameter(valid_588874, JString, required = true,
                                 default = nil)
  if valid_588874 != nil:
    section.add "start-date", valid_588874
  var valid_588875 = query.getOrDefault("filters")
  valid_588875 = validateParameter(valid_588875, JString, required = false,
                                 default = nil)
  if valid_588875 != nil:
    section.add "filters", valid_588875
  var valid_588876 = query.getOrDefault("include-empty-rows")
  valid_588876 = validateParameter(valid_588876, JBool, required = false, default = nil)
  if valid_588876 != nil:
    section.add "include-empty-rows", valid_588876
  var valid_588877 = query.getOrDefault("start-index")
  valid_588877 = validateParameter(valid_588877, JInt, required = false, default = nil)
  if valid_588877 != nil:
    section.add "start-index", valid_588877
  var valid_588878 = query.getOrDefault("samplingLevel")
  valid_588878 = validateParameter(valid_588878, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_588878 != nil:
    section.add "samplingLevel", valid_588878
  var valid_588879 = query.getOrDefault("prettyPrint")
  valid_588879 = validateParameter(valid_588879, JBool, required = false,
                                 default = newJBool(false))
  if valid_588879 != nil:
    section.add "prettyPrint", valid_588879
  var valid_588880 = query.getOrDefault("output")
  valid_588880 = validateParameter(valid_588880, JString, required = false,
                                 default = newJString("dataTable"))
  if valid_588880 != nil:
    section.add "output", valid_588880
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588903: Call_AnalyticsDataGaGet_588734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Analytics data for a view (profile).
  ## 
  let valid = call_588903.validator(path, query, header, formData, body)
  let scheme = call_588903.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588903.url(scheme.get, call_588903.host, call_588903.base,
                         call_588903.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588903, url, valid)

proc call*(call_588974: Call_AnalyticsDataGaGet_588734; metrics: string; ids: string;
          endDate: string; startDate: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; sort: string = "";
          segment: string = ""; oauthToken: string = ""; userIp: string = "";
          dimensions: string = ""; key: string = ""; maxResults: int = 0;
          filters: string = ""; includeEmptyRows: bool = false; startIndex: int = 0;
          samplingLevel: string = "DEFAULT"; prettyPrint: bool = false;
          output: string = "dataTable"): Recallable =
  ## analyticsDataGaGet
  ## Returns Analytics data for a view (profile).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for Analytics data.
  ##   segment: string
  ##          : An Analytics segment to be applied to data.
  ##   metrics: string (required)
  ##          : A comma-separated list of Analytics metrics. E.g., 'ga:sessions,ga:pageviews'. At least one metric must be specified.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: string
  ##             : A comma-separated list of Analytics dimensions. E.g., 'ga:browser,ga:city'.
  ##   ids: string (required)
  ##      : Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of entries to include in this feed.
  ##   endDate: string (required)
  ##          : End date for fetching Analytics data. Request can should specify an end date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is yesterday.
  ##   startDate: string (required)
  ##            : Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   filters: string
  ##          : A comma-separated list of dimension or metric filters to be applied to Analytics data.
  ##   includeEmptyRows: bool
  ##                   : The response will include empty rows if this parameter is set to true, the default is true
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   samplingLevel: string
  ##                : The desired sampling level.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   output: string
  ##         : The selected format for the response. Default format is JSON.
  var query_588975 = newJObject()
  add(query_588975, "fields", newJString(fields))
  add(query_588975, "quotaUser", newJString(quotaUser))
  add(query_588975, "alt", newJString(alt))
  add(query_588975, "sort", newJString(sort))
  add(query_588975, "segment", newJString(segment))
  add(query_588975, "metrics", newJString(metrics))
  add(query_588975, "oauth_token", newJString(oauthToken))
  add(query_588975, "userIp", newJString(userIp))
  add(query_588975, "dimensions", newJString(dimensions))
  add(query_588975, "ids", newJString(ids))
  add(query_588975, "key", newJString(key))
  add(query_588975, "max-results", newJInt(maxResults))
  add(query_588975, "end-date", newJString(endDate))
  add(query_588975, "start-date", newJString(startDate))
  add(query_588975, "filters", newJString(filters))
  add(query_588975, "include-empty-rows", newJBool(includeEmptyRows))
  add(query_588975, "start-index", newJInt(startIndex))
  add(query_588975, "samplingLevel", newJString(samplingLevel))
  add(query_588975, "prettyPrint", newJBool(prettyPrint))
  add(query_588975, "output", newJString(output))
  result = call_588974.call(nil, query_588975, nil, nil, nil)

var analyticsDataGaGet* = Call_AnalyticsDataGaGet_588734(
    name: "analyticsDataGaGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/data/ga",
    validator: validate_AnalyticsDataGaGet_588735, base: "/analytics/v3",
    url: url_AnalyticsDataGaGet_588736, schemes: {Scheme.Https})
type
  Call_AnalyticsDataMcfGet_589015 = ref object of OpenApiRestCall_588466
proc url_AnalyticsDataMcfGet_589017(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsDataMcfGet_589016(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns Analytics Multi-Channel Funnels data for a view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for the Analytics data.
  ##   metrics: JString (required)
  ##          : A comma-separated list of Multi-Channel Funnels metrics. E.g., 'mcf:totalConversions,mcf:totalConversionValue'. At least one metric must be specified.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: JString
  ##             : A comma-separated list of Multi-Channel Funnels dimensions. E.g., 'mcf:source,mcf:medium'.
  ##   ids: JString (required)
  ##      : Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of entries to include in this feed.
  ##   end-date: JString (required)
  ##           : End date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   start-date: JString (required)
  ##             : Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   filters: JString
  ##          : A comma-separated list of dimension or metric filters to be applied to the Analytics data.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   samplingLevel: JString
  ##                : The desired sampling level.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589018 = query.getOrDefault("fields")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "fields", valid_589018
  var valid_589019 = query.getOrDefault("quotaUser")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "quotaUser", valid_589019
  var valid_589020 = query.getOrDefault("alt")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = newJString("json"))
  if valid_589020 != nil:
    section.add "alt", valid_589020
  var valid_589021 = query.getOrDefault("sort")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "sort", valid_589021
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_589022 = query.getOrDefault("metrics")
  valid_589022 = validateParameter(valid_589022, JString, required = true,
                                 default = nil)
  if valid_589022 != nil:
    section.add "metrics", valid_589022
  var valid_589023 = query.getOrDefault("oauth_token")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "oauth_token", valid_589023
  var valid_589024 = query.getOrDefault("userIp")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "userIp", valid_589024
  var valid_589025 = query.getOrDefault("dimensions")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "dimensions", valid_589025
  var valid_589026 = query.getOrDefault("ids")
  valid_589026 = validateParameter(valid_589026, JString, required = true,
                                 default = nil)
  if valid_589026 != nil:
    section.add "ids", valid_589026
  var valid_589027 = query.getOrDefault("key")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "key", valid_589027
  var valid_589028 = query.getOrDefault("max-results")
  valid_589028 = validateParameter(valid_589028, JInt, required = false, default = nil)
  if valid_589028 != nil:
    section.add "max-results", valid_589028
  var valid_589029 = query.getOrDefault("end-date")
  valid_589029 = validateParameter(valid_589029, JString, required = true,
                                 default = nil)
  if valid_589029 != nil:
    section.add "end-date", valid_589029
  var valid_589030 = query.getOrDefault("start-date")
  valid_589030 = validateParameter(valid_589030, JString, required = true,
                                 default = nil)
  if valid_589030 != nil:
    section.add "start-date", valid_589030
  var valid_589031 = query.getOrDefault("filters")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "filters", valid_589031
  var valid_589032 = query.getOrDefault("start-index")
  valid_589032 = validateParameter(valid_589032, JInt, required = false, default = nil)
  if valid_589032 != nil:
    section.add "start-index", valid_589032
  var valid_589033 = query.getOrDefault("samplingLevel")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_589033 != nil:
    section.add "samplingLevel", valid_589033
  var valid_589034 = query.getOrDefault("prettyPrint")
  valid_589034 = validateParameter(valid_589034, JBool, required = false,
                                 default = newJBool(false))
  if valid_589034 != nil:
    section.add "prettyPrint", valid_589034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589035: Call_AnalyticsDataMcfGet_589015; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Analytics Multi-Channel Funnels data for a view (profile).
  ## 
  let valid = call_589035.validator(path, query, header, formData, body)
  let scheme = call_589035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589035.url(scheme.get, call_589035.host, call_589035.base,
                         call_589035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589035, url, valid)

proc call*(call_589036: Call_AnalyticsDataMcfGet_589015; metrics: string;
          ids: string; endDate: string; startDate: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; sort: string = "";
          oauthToken: string = ""; userIp: string = ""; dimensions: string = "";
          key: string = ""; maxResults: int = 0; filters: string = ""; startIndex: int = 0;
          samplingLevel: string = "DEFAULT"; prettyPrint: bool = false): Recallable =
  ## analyticsDataMcfGet
  ## Returns Analytics Multi-Channel Funnels data for a view (profile).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for the Analytics data.
  ##   metrics: string (required)
  ##          : A comma-separated list of Multi-Channel Funnels metrics. E.g., 'mcf:totalConversions,mcf:totalConversionValue'. At least one metric must be specified.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: string
  ##             : A comma-separated list of Multi-Channel Funnels dimensions. E.g., 'mcf:source,mcf:medium'.
  ##   ids: string (required)
  ##      : Unique table ID for retrieving Analytics data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of entries to include in this feed.
  ##   endDate: string (required)
  ##          : End date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   startDate: string (required)
  ##            : Start date for fetching Analytics data. Requests can specify a start date formatted as YYYY-MM-DD, or as a relative date (e.g., today, yesterday, or 7daysAgo). The default value is 7daysAgo.
  ##   filters: string
  ##          : A comma-separated list of dimension or metric filters to be applied to the Analytics data.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   samplingLevel: string
  ##                : The desired sampling level.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589037 = newJObject()
  add(query_589037, "fields", newJString(fields))
  add(query_589037, "quotaUser", newJString(quotaUser))
  add(query_589037, "alt", newJString(alt))
  add(query_589037, "sort", newJString(sort))
  add(query_589037, "metrics", newJString(metrics))
  add(query_589037, "oauth_token", newJString(oauthToken))
  add(query_589037, "userIp", newJString(userIp))
  add(query_589037, "dimensions", newJString(dimensions))
  add(query_589037, "ids", newJString(ids))
  add(query_589037, "key", newJString(key))
  add(query_589037, "max-results", newJInt(maxResults))
  add(query_589037, "end-date", newJString(endDate))
  add(query_589037, "start-date", newJString(startDate))
  add(query_589037, "filters", newJString(filters))
  add(query_589037, "start-index", newJInt(startIndex))
  add(query_589037, "samplingLevel", newJString(samplingLevel))
  add(query_589037, "prettyPrint", newJBool(prettyPrint))
  result = call_589036.call(nil, query_589037, nil, nil, nil)

var analyticsDataMcfGet* = Call_AnalyticsDataMcfGet_589015(
    name: "analyticsDataMcfGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/data/mcf",
    validator: validate_AnalyticsDataMcfGet_589016, base: "/analytics/v3",
    url: url_AnalyticsDataMcfGet_589017, schemes: {Scheme.Https})
type
  Call_AnalyticsDataRealtimeGet_589038 = ref object of OpenApiRestCall_588466
proc url_AnalyticsDataRealtimeGet_589040(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsDataRealtimeGet_589039(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns real time data for a view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for real time data.
  ##   metrics: JString (required)
  ##          : A comma-separated list of real time metrics. E.g., 'rt:activeUsers'. At least one metric must be specified.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: JString
  ##             : A comma-separated list of real time dimensions. E.g., 'rt:medium,rt:city'.
  ##   ids: JString (required)
  ##      : Unique table ID for retrieving real time data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of entries to include in this feed.
  ##   filters: JString
  ##          : A comma-separated list of dimension or metric filters to be applied to real time data.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589041 = query.getOrDefault("fields")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "fields", valid_589041
  var valid_589042 = query.getOrDefault("quotaUser")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "quotaUser", valid_589042
  var valid_589043 = query.getOrDefault("alt")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = newJString("json"))
  if valid_589043 != nil:
    section.add "alt", valid_589043
  var valid_589044 = query.getOrDefault("sort")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "sort", valid_589044
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_589045 = query.getOrDefault("metrics")
  valid_589045 = validateParameter(valid_589045, JString, required = true,
                                 default = nil)
  if valid_589045 != nil:
    section.add "metrics", valid_589045
  var valid_589046 = query.getOrDefault("oauth_token")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "oauth_token", valid_589046
  var valid_589047 = query.getOrDefault("userIp")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "userIp", valid_589047
  var valid_589048 = query.getOrDefault("dimensions")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "dimensions", valid_589048
  var valid_589049 = query.getOrDefault("ids")
  valid_589049 = validateParameter(valid_589049, JString, required = true,
                                 default = nil)
  if valid_589049 != nil:
    section.add "ids", valid_589049
  var valid_589050 = query.getOrDefault("key")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "key", valid_589050
  var valid_589051 = query.getOrDefault("max-results")
  valid_589051 = validateParameter(valid_589051, JInt, required = false, default = nil)
  if valid_589051 != nil:
    section.add "max-results", valid_589051
  var valid_589052 = query.getOrDefault("filters")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "filters", valid_589052
  var valid_589053 = query.getOrDefault("prettyPrint")
  valid_589053 = validateParameter(valid_589053, JBool, required = false,
                                 default = newJBool(false))
  if valid_589053 != nil:
    section.add "prettyPrint", valid_589053
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589054: Call_AnalyticsDataRealtimeGet_589038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns real time data for a view (profile).
  ## 
  let valid = call_589054.validator(path, query, header, formData, body)
  let scheme = call_589054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589054.url(scheme.get, call_589054.host, call_589054.base,
                         call_589054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589054, url, valid)

proc call*(call_589055: Call_AnalyticsDataRealtimeGet_589038; metrics: string;
          ids: string; fields: string = ""; quotaUser: string = ""; alt: string = "json";
          sort: string = ""; oauthToken: string = ""; userIp: string = "";
          dimensions: string = ""; key: string = ""; maxResults: int = 0;
          filters: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsDataRealtimeGet
  ## Returns real time data for a view (profile).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for real time data.
  ##   metrics: string (required)
  ##          : A comma-separated list of real time metrics. E.g., 'rt:activeUsers'. At least one metric must be specified.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: string
  ##             : A comma-separated list of real time dimensions. E.g., 'rt:medium,rt:city'.
  ##   ids: string (required)
  ##      : Unique table ID for retrieving real time data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of entries to include in this feed.
  ##   filters: string
  ##          : A comma-separated list of dimension or metric filters to be applied to real time data.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589056 = newJObject()
  add(query_589056, "fields", newJString(fields))
  add(query_589056, "quotaUser", newJString(quotaUser))
  add(query_589056, "alt", newJString(alt))
  add(query_589056, "sort", newJString(sort))
  add(query_589056, "metrics", newJString(metrics))
  add(query_589056, "oauth_token", newJString(oauthToken))
  add(query_589056, "userIp", newJString(userIp))
  add(query_589056, "dimensions", newJString(dimensions))
  add(query_589056, "ids", newJString(ids))
  add(query_589056, "key", newJString(key))
  add(query_589056, "max-results", newJInt(maxResults))
  add(query_589056, "filters", newJString(filters))
  add(query_589056, "prettyPrint", newJBool(prettyPrint))
  result = call_589055.call(nil, query_589056, nil, nil, nil)

var analyticsDataRealtimeGet* = Call_AnalyticsDataRealtimeGet_589038(
    name: "analyticsDataRealtimeGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/data/realtime",
    validator: validate_AnalyticsDataRealtimeGet_589039, base: "/analytics/v3",
    url: url_AnalyticsDataRealtimeGet_589040, schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountSummariesList_589057 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementAccountSummariesList_589059(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementAccountSummariesList_589058(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists account summaries (lightweight tree comprised of accounts/properties/profiles) to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of account summaries to include in this response, where the largest acceptable value is 1000.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589060 = query.getOrDefault("fields")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "fields", valid_589060
  var valid_589061 = query.getOrDefault("quotaUser")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "quotaUser", valid_589061
  var valid_589062 = query.getOrDefault("alt")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = newJString("json"))
  if valid_589062 != nil:
    section.add "alt", valid_589062
  var valid_589063 = query.getOrDefault("oauth_token")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "oauth_token", valid_589063
  var valid_589064 = query.getOrDefault("userIp")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "userIp", valid_589064
  var valid_589065 = query.getOrDefault("key")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "key", valid_589065
  var valid_589066 = query.getOrDefault("max-results")
  valid_589066 = validateParameter(valid_589066, JInt, required = false, default = nil)
  if valid_589066 != nil:
    section.add "max-results", valid_589066
  var valid_589067 = query.getOrDefault("start-index")
  valid_589067 = validateParameter(valid_589067, JInt, required = false, default = nil)
  if valid_589067 != nil:
    section.add "start-index", valid_589067
  var valid_589068 = query.getOrDefault("prettyPrint")
  valid_589068 = validateParameter(valid_589068, JBool, required = false,
                                 default = newJBool(false))
  if valid_589068 != nil:
    section.add "prettyPrint", valid_589068
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589069: Call_AnalyticsManagementAccountSummariesList_589057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists account summaries (lightweight tree comprised of accounts/properties/profiles) to which the user has access.
  ## 
  let valid = call_589069.validator(path, query, header, formData, body)
  let scheme = call_589069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589069.url(scheme.get, call_589069.host, call_589069.base,
                         call_589069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589069, url, valid)

proc call*(call_589070: Call_AnalyticsManagementAccountSummariesList_589057;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementAccountSummariesList
  ## Lists account summaries (lightweight tree comprised of accounts/properties/profiles) to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of account summaries to include in this response, where the largest acceptable value is 1000.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589071 = newJObject()
  add(query_589071, "fields", newJString(fields))
  add(query_589071, "quotaUser", newJString(quotaUser))
  add(query_589071, "alt", newJString(alt))
  add(query_589071, "oauth_token", newJString(oauthToken))
  add(query_589071, "userIp", newJString(userIp))
  add(query_589071, "key", newJString(key))
  add(query_589071, "max-results", newJInt(maxResults))
  add(query_589071, "start-index", newJInt(startIndex))
  add(query_589071, "prettyPrint", newJBool(prettyPrint))
  result = call_589070.call(nil, query_589071, nil, nil, nil)

var analyticsManagementAccountSummariesList* = Call_AnalyticsManagementAccountSummariesList_589057(
    name: "analyticsManagementAccountSummariesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accountSummaries",
    validator: validate_AnalyticsManagementAccountSummariesList_589058,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountSummariesList_589059,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountsList_589072 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementAccountsList_589074(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementAccountsList_589073(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all accounts to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of accounts to include in this response.
  ##   start-index: JInt
  ##              : An index of the first account to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589075 = query.getOrDefault("fields")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "fields", valid_589075
  var valid_589076 = query.getOrDefault("quotaUser")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "quotaUser", valid_589076
  var valid_589077 = query.getOrDefault("alt")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = newJString("json"))
  if valid_589077 != nil:
    section.add "alt", valid_589077
  var valid_589078 = query.getOrDefault("oauth_token")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "oauth_token", valid_589078
  var valid_589079 = query.getOrDefault("userIp")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "userIp", valid_589079
  var valid_589080 = query.getOrDefault("key")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "key", valid_589080
  var valid_589081 = query.getOrDefault("max-results")
  valid_589081 = validateParameter(valid_589081, JInt, required = false, default = nil)
  if valid_589081 != nil:
    section.add "max-results", valid_589081
  var valid_589082 = query.getOrDefault("start-index")
  valid_589082 = validateParameter(valid_589082, JInt, required = false, default = nil)
  if valid_589082 != nil:
    section.add "start-index", valid_589082
  var valid_589083 = query.getOrDefault("prettyPrint")
  valid_589083 = validateParameter(valid_589083, JBool, required = false,
                                 default = newJBool(false))
  if valid_589083 != nil:
    section.add "prettyPrint", valid_589083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589084: Call_AnalyticsManagementAccountsList_589072;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all accounts to which the user has access.
  ## 
  let valid = call_589084.validator(path, query, header, formData, body)
  let scheme = call_589084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589084.url(scheme.get, call_589084.host, call_589084.base,
                         call_589084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589084, url, valid)

proc call*(call_589085: Call_AnalyticsManagementAccountsList_589072;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementAccountsList
  ## Lists all accounts to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of accounts to include in this response.
  ##   startIndex: int
  ##             : An index of the first account to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589086 = newJObject()
  add(query_589086, "fields", newJString(fields))
  add(query_589086, "quotaUser", newJString(quotaUser))
  add(query_589086, "alt", newJString(alt))
  add(query_589086, "oauth_token", newJString(oauthToken))
  add(query_589086, "userIp", newJString(userIp))
  add(query_589086, "key", newJString(key))
  add(query_589086, "max-results", newJInt(maxResults))
  add(query_589086, "start-index", newJInt(startIndex))
  add(query_589086, "prettyPrint", newJBool(prettyPrint))
  result = call_589085.call(nil, query_589086, nil, nil, nil)

var analyticsManagementAccountsList* = Call_AnalyticsManagementAccountsList_589072(
    name: "analyticsManagementAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts",
    validator: validate_AnalyticsManagementAccountsList_589073,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountsList_589074,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksInsert_589118 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementAccountUserLinksInsert_589120(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementAccountUserLinksInsert_589119(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new user to the given account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to create the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589121 = path.getOrDefault("accountId")
  valid_589121 = validateParameter(valid_589121, JString, required = true,
                                 default = nil)
  if valid_589121 != nil:
    section.add "accountId", valid_589121
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589122 = query.getOrDefault("fields")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "fields", valid_589122
  var valid_589123 = query.getOrDefault("quotaUser")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "quotaUser", valid_589123
  var valid_589124 = query.getOrDefault("alt")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = newJString("json"))
  if valid_589124 != nil:
    section.add "alt", valid_589124
  var valid_589125 = query.getOrDefault("oauth_token")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "oauth_token", valid_589125
  var valid_589126 = query.getOrDefault("userIp")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "userIp", valid_589126
  var valid_589127 = query.getOrDefault("key")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "key", valid_589127
  var valid_589128 = query.getOrDefault("prettyPrint")
  valid_589128 = validateParameter(valid_589128, JBool, required = false,
                                 default = newJBool(false))
  if valid_589128 != nil:
    section.add "prettyPrint", valid_589128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589130: Call_AnalyticsManagementAccountUserLinksInsert_589118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new user to the given account.
  ## 
  let valid = call_589130.validator(path, query, header, formData, body)
  let scheme = call_589130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589130.url(scheme.get, call_589130.host, call_589130.base,
                         call_589130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589130, url, valid)

proc call*(call_589131: Call_AnalyticsManagementAccountUserLinksInsert_589118;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementAccountUserLinksInsert
  ## Adds a new user to the given account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589132 = newJObject()
  var query_589133 = newJObject()
  var body_589134 = newJObject()
  add(query_589133, "fields", newJString(fields))
  add(query_589133, "quotaUser", newJString(quotaUser))
  add(query_589133, "alt", newJString(alt))
  add(query_589133, "oauth_token", newJString(oauthToken))
  add(path_589132, "accountId", newJString(accountId))
  add(query_589133, "userIp", newJString(userIp))
  add(query_589133, "key", newJString(key))
  if body != nil:
    body_589134 = body
  add(query_589133, "prettyPrint", newJBool(prettyPrint))
  result = call_589131.call(path_589132, query_589133, nil, nil, body_589134)

var analyticsManagementAccountUserLinksInsert* = Call_AnalyticsManagementAccountUserLinksInsert_589118(
    name: "analyticsManagementAccountUserLinksInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks",
    validator: validate_AnalyticsManagementAccountUserLinksInsert_589119,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksInsert_589120,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksList_589087 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementAccountUserLinksList_589089(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementAccountUserLinksList_589088(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists account-user links for a given account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the user links for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589104 = path.getOrDefault("accountId")
  valid_589104 = validateParameter(valid_589104, JString, required = true,
                                 default = nil)
  if valid_589104 != nil:
    section.add "accountId", valid_589104
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of account-user links to include in this response.
  ##   start-index: JInt
  ##              : An index of the first account-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589105 = query.getOrDefault("fields")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "fields", valid_589105
  var valid_589106 = query.getOrDefault("quotaUser")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "quotaUser", valid_589106
  var valid_589107 = query.getOrDefault("alt")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = newJString("json"))
  if valid_589107 != nil:
    section.add "alt", valid_589107
  var valid_589108 = query.getOrDefault("oauth_token")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = nil)
  if valid_589108 != nil:
    section.add "oauth_token", valid_589108
  var valid_589109 = query.getOrDefault("userIp")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "userIp", valid_589109
  var valid_589110 = query.getOrDefault("key")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "key", valid_589110
  var valid_589111 = query.getOrDefault("max-results")
  valid_589111 = validateParameter(valid_589111, JInt, required = false, default = nil)
  if valid_589111 != nil:
    section.add "max-results", valid_589111
  var valid_589112 = query.getOrDefault("start-index")
  valid_589112 = validateParameter(valid_589112, JInt, required = false, default = nil)
  if valid_589112 != nil:
    section.add "start-index", valid_589112
  var valid_589113 = query.getOrDefault("prettyPrint")
  valid_589113 = validateParameter(valid_589113, JBool, required = false,
                                 default = newJBool(false))
  if valid_589113 != nil:
    section.add "prettyPrint", valid_589113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589114: Call_AnalyticsManagementAccountUserLinksList_589087;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists account-user links for a given account.
  ## 
  let valid = call_589114.validator(path, query, header, formData, body)
  let scheme = call_589114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589114.url(scheme.get, call_589114.host, call_589114.base,
                         call_589114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589114, url, valid)

proc call*(call_589115: Call_AnalyticsManagementAccountUserLinksList_589087;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementAccountUserLinksList
  ## Lists account-user links for a given account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the user links for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of account-user links to include in this response.
  ##   startIndex: int
  ##             : An index of the first account-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589116 = newJObject()
  var query_589117 = newJObject()
  add(query_589117, "fields", newJString(fields))
  add(query_589117, "quotaUser", newJString(quotaUser))
  add(query_589117, "alt", newJString(alt))
  add(query_589117, "oauth_token", newJString(oauthToken))
  add(path_589116, "accountId", newJString(accountId))
  add(query_589117, "userIp", newJString(userIp))
  add(query_589117, "key", newJString(key))
  add(query_589117, "max-results", newJInt(maxResults))
  add(query_589117, "start-index", newJInt(startIndex))
  add(query_589117, "prettyPrint", newJBool(prettyPrint))
  result = call_589115.call(path_589116, query_589117, nil, nil, nil)

var analyticsManagementAccountUserLinksList* = Call_AnalyticsManagementAccountUserLinksList_589087(
    name: "analyticsManagementAccountUserLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks",
    validator: validate_AnalyticsManagementAccountUserLinksList_589088,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksList_589089,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksUpdate_589135 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementAccountUserLinksUpdate_589137(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/entityUserLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementAccountUserLinksUpdate_589136(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates permissions for an existing user on the given account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to update the account-user link for.
  ##   linkId: JString (required)
  ##         : Link ID to update the account-user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589138 = path.getOrDefault("accountId")
  valid_589138 = validateParameter(valid_589138, JString, required = true,
                                 default = nil)
  if valid_589138 != nil:
    section.add "accountId", valid_589138
  var valid_589139 = path.getOrDefault("linkId")
  valid_589139 = validateParameter(valid_589139, JString, required = true,
                                 default = nil)
  if valid_589139 != nil:
    section.add "linkId", valid_589139
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589140 = query.getOrDefault("fields")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "fields", valid_589140
  var valid_589141 = query.getOrDefault("quotaUser")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "quotaUser", valid_589141
  var valid_589142 = query.getOrDefault("alt")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = newJString("json"))
  if valid_589142 != nil:
    section.add "alt", valid_589142
  var valid_589143 = query.getOrDefault("oauth_token")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "oauth_token", valid_589143
  var valid_589144 = query.getOrDefault("userIp")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "userIp", valid_589144
  var valid_589145 = query.getOrDefault("key")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "key", valid_589145
  var valid_589146 = query.getOrDefault("prettyPrint")
  valid_589146 = validateParameter(valid_589146, JBool, required = false,
                                 default = newJBool(false))
  if valid_589146 != nil:
    section.add "prettyPrint", valid_589146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589148: Call_AnalyticsManagementAccountUserLinksUpdate_589135;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates permissions for an existing user on the given account.
  ## 
  let valid = call_589148.validator(path, query, header, formData, body)
  let scheme = call_589148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589148.url(scheme.get, call_589148.host, call_589148.base,
                         call_589148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589148, url, valid)

proc call*(call_589149: Call_AnalyticsManagementAccountUserLinksUpdate_589135;
          accountId: string; linkId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementAccountUserLinksUpdate
  ## Updates permissions for an existing user on the given account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to update the account-user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : Link ID to update the account-user link for.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589150 = newJObject()
  var query_589151 = newJObject()
  var body_589152 = newJObject()
  add(query_589151, "fields", newJString(fields))
  add(query_589151, "quotaUser", newJString(quotaUser))
  add(query_589151, "alt", newJString(alt))
  add(query_589151, "oauth_token", newJString(oauthToken))
  add(path_589150, "accountId", newJString(accountId))
  add(query_589151, "userIp", newJString(userIp))
  add(query_589151, "key", newJString(key))
  add(path_589150, "linkId", newJString(linkId))
  if body != nil:
    body_589152 = body
  add(query_589151, "prettyPrint", newJBool(prettyPrint))
  result = call_589149.call(path_589150, query_589151, nil, nil, body_589152)

var analyticsManagementAccountUserLinksUpdate* = Call_AnalyticsManagementAccountUserLinksUpdate_589135(
    name: "analyticsManagementAccountUserLinksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementAccountUserLinksUpdate_589136,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksUpdate_589137,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksDelete_589153 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementAccountUserLinksDelete_589155(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/entityUserLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementAccountUserLinksDelete_589154(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a user from the given account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to delete the user link for.
  ##   linkId: JString (required)
  ##         : Link ID to delete the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589156 = path.getOrDefault("accountId")
  valid_589156 = validateParameter(valid_589156, JString, required = true,
                                 default = nil)
  if valid_589156 != nil:
    section.add "accountId", valid_589156
  var valid_589157 = path.getOrDefault("linkId")
  valid_589157 = validateParameter(valid_589157, JString, required = true,
                                 default = nil)
  if valid_589157 != nil:
    section.add "linkId", valid_589157
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589158 = query.getOrDefault("fields")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "fields", valid_589158
  var valid_589159 = query.getOrDefault("quotaUser")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "quotaUser", valid_589159
  var valid_589160 = query.getOrDefault("alt")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = newJString("json"))
  if valid_589160 != nil:
    section.add "alt", valid_589160
  var valid_589161 = query.getOrDefault("oauth_token")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "oauth_token", valid_589161
  var valid_589162 = query.getOrDefault("userIp")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "userIp", valid_589162
  var valid_589163 = query.getOrDefault("key")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "key", valid_589163
  var valid_589164 = query.getOrDefault("prettyPrint")
  valid_589164 = validateParameter(valid_589164, JBool, required = false,
                                 default = newJBool(false))
  if valid_589164 != nil:
    section.add "prettyPrint", valid_589164
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589165: Call_AnalyticsManagementAccountUserLinksDelete_589153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the given account.
  ## 
  let valid = call_589165.validator(path, query, header, formData, body)
  let scheme = call_589165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589165.url(scheme.get, call_589165.host, call_589165.base,
                         call_589165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589165, url, valid)

proc call*(call_589166: Call_AnalyticsManagementAccountUserLinksDelete_589153;
          accountId: string; linkId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementAccountUserLinksDelete
  ## Removes a user from the given account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to delete the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : Link ID to delete the user link for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589167 = newJObject()
  var query_589168 = newJObject()
  add(query_589168, "fields", newJString(fields))
  add(query_589168, "quotaUser", newJString(quotaUser))
  add(query_589168, "alt", newJString(alt))
  add(query_589168, "oauth_token", newJString(oauthToken))
  add(path_589167, "accountId", newJString(accountId))
  add(query_589168, "userIp", newJString(userIp))
  add(query_589168, "key", newJString(key))
  add(path_589167, "linkId", newJString(linkId))
  add(query_589168, "prettyPrint", newJBool(prettyPrint))
  result = call_589166.call(path_589167, query_589168, nil, nil, nil)

var analyticsManagementAccountUserLinksDelete* = Call_AnalyticsManagementAccountUserLinksDelete_589153(
    name: "analyticsManagementAccountUserLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementAccountUserLinksDelete_589154,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksDelete_589155,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersInsert_589186 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementFiltersInsert_589188(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/filters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementFiltersInsert_589187(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to create filter for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589189 = path.getOrDefault("accountId")
  valid_589189 = validateParameter(valid_589189, JString, required = true,
                                 default = nil)
  if valid_589189 != nil:
    section.add "accountId", valid_589189
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589190 = query.getOrDefault("fields")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "fields", valid_589190
  var valid_589191 = query.getOrDefault("quotaUser")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "quotaUser", valid_589191
  var valid_589192 = query.getOrDefault("alt")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = newJString("json"))
  if valid_589192 != nil:
    section.add "alt", valid_589192
  var valid_589193 = query.getOrDefault("oauth_token")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "oauth_token", valid_589193
  var valid_589194 = query.getOrDefault("userIp")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "userIp", valid_589194
  var valid_589195 = query.getOrDefault("key")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "key", valid_589195
  var valid_589196 = query.getOrDefault("prettyPrint")
  valid_589196 = validateParameter(valid_589196, JBool, required = false,
                                 default = newJBool(false))
  if valid_589196 != nil:
    section.add "prettyPrint", valid_589196
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589198: Call_AnalyticsManagementFiltersInsert_589186;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new filter.
  ## 
  let valid = call_589198.validator(path, query, header, formData, body)
  let scheme = call_589198.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589198.url(scheme.get, call_589198.host, call_589198.base,
                         call_589198.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589198, url, valid)

proc call*(call_589199: Call_AnalyticsManagementFiltersInsert_589186;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementFiltersInsert
  ## Create a new filter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create filter for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589200 = newJObject()
  var query_589201 = newJObject()
  var body_589202 = newJObject()
  add(query_589201, "fields", newJString(fields))
  add(query_589201, "quotaUser", newJString(quotaUser))
  add(query_589201, "alt", newJString(alt))
  add(query_589201, "oauth_token", newJString(oauthToken))
  add(path_589200, "accountId", newJString(accountId))
  add(query_589201, "userIp", newJString(userIp))
  add(query_589201, "key", newJString(key))
  if body != nil:
    body_589202 = body
  add(query_589201, "prettyPrint", newJBool(prettyPrint))
  result = call_589199.call(path_589200, query_589201, nil, nil, body_589202)

var analyticsManagementFiltersInsert* = Call_AnalyticsManagementFiltersInsert_589186(
    name: "analyticsManagementFiltersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/filters",
    validator: validate_AnalyticsManagementFiltersInsert_589187,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersInsert_589188,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersList_589169 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementFiltersList_589171(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/filters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementFiltersList_589170(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all filters for an account
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to retrieve filters for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589172 = path.getOrDefault("accountId")
  valid_589172 = validateParameter(valid_589172, JString, required = true,
                                 default = nil)
  if valid_589172 != nil:
    section.add "accountId", valid_589172
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of filters to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589173 = query.getOrDefault("fields")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = nil)
  if valid_589173 != nil:
    section.add "fields", valid_589173
  var valid_589174 = query.getOrDefault("quotaUser")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "quotaUser", valid_589174
  var valid_589175 = query.getOrDefault("alt")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = newJString("json"))
  if valid_589175 != nil:
    section.add "alt", valid_589175
  var valid_589176 = query.getOrDefault("oauth_token")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "oauth_token", valid_589176
  var valid_589177 = query.getOrDefault("userIp")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "userIp", valid_589177
  var valid_589178 = query.getOrDefault("key")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "key", valid_589178
  var valid_589179 = query.getOrDefault("max-results")
  valid_589179 = validateParameter(valid_589179, JInt, required = false, default = nil)
  if valid_589179 != nil:
    section.add "max-results", valid_589179
  var valid_589180 = query.getOrDefault("start-index")
  valid_589180 = validateParameter(valid_589180, JInt, required = false, default = nil)
  if valid_589180 != nil:
    section.add "start-index", valid_589180
  var valid_589181 = query.getOrDefault("prettyPrint")
  valid_589181 = validateParameter(valid_589181, JBool, required = false,
                                 default = newJBool(false))
  if valid_589181 != nil:
    section.add "prettyPrint", valid_589181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589182: Call_AnalyticsManagementFiltersList_589169; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all filters for an account
  ## 
  let valid = call_589182.validator(path, query, header, formData, body)
  let scheme = call_589182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589182.url(scheme.get, call_589182.host, call_589182.base,
                         call_589182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589182, url, valid)

proc call*(call_589183: Call_AnalyticsManagementFiltersList_589169;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementFiltersList
  ## Lists all filters for an account
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve filters for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of filters to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589184 = newJObject()
  var query_589185 = newJObject()
  add(query_589185, "fields", newJString(fields))
  add(query_589185, "quotaUser", newJString(quotaUser))
  add(query_589185, "alt", newJString(alt))
  add(query_589185, "oauth_token", newJString(oauthToken))
  add(path_589184, "accountId", newJString(accountId))
  add(query_589185, "userIp", newJString(userIp))
  add(query_589185, "key", newJString(key))
  add(query_589185, "max-results", newJInt(maxResults))
  add(query_589185, "start-index", newJInt(startIndex))
  add(query_589185, "prettyPrint", newJBool(prettyPrint))
  result = call_589183.call(path_589184, query_589185, nil, nil, nil)

var analyticsManagementFiltersList* = Call_AnalyticsManagementFiltersList_589169(
    name: "analyticsManagementFiltersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/filters",
    validator: validate_AnalyticsManagementFiltersList_589170,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersList_589171,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersUpdate_589219 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementFiltersUpdate_589221(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "filterId" in path, "`filterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/filters/"),
               (kind: VariableSegment, value: "filterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementFiltersUpdate_589220(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to which the filter belongs.
  ##   filterId: JString (required)
  ##           : ID of the filter to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589222 = path.getOrDefault("accountId")
  valid_589222 = validateParameter(valid_589222, JString, required = true,
                                 default = nil)
  if valid_589222 != nil:
    section.add "accountId", valid_589222
  var valid_589223 = path.getOrDefault("filterId")
  valid_589223 = validateParameter(valid_589223, JString, required = true,
                                 default = nil)
  if valid_589223 != nil:
    section.add "filterId", valid_589223
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589224 = query.getOrDefault("fields")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "fields", valid_589224
  var valid_589225 = query.getOrDefault("quotaUser")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "quotaUser", valid_589225
  var valid_589226 = query.getOrDefault("alt")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = newJString("json"))
  if valid_589226 != nil:
    section.add "alt", valid_589226
  var valid_589227 = query.getOrDefault("oauth_token")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "oauth_token", valid_589227
  var valid_589228 = query.getOrDefault("userIp")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "userIp", valid_589228
  var valid_589229 = query.getOrDefault("key")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "key", valid_589229
  var valid_589230 = query.getOrDefault("prettyPrint")
  valid_589230 = validateParameter(valid_589230, JBool, required = false,
                                 default = newJBool(false))
  if valid_589230 != nil:
    section.add "prettyPrint", valid_589230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589232: Call_AnalyticsManagementFiltersUpdate_589219;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing filter.
  ## 
  let valid = call_589232.validator(path, query, header, formData, body)
  let scheme = call_589232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589232.url(scheme.get, call_589232.host, call_589232.base,
                         call_589232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589232, url, valid)

proc call*(call_589233: Call_AnalyticsManagementFiltersUpdate_589219;
          accountId: string; filterId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementFiltersUpdate
  ## Updates an existing filter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the filter belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filterId: string (required)
  ##           : ID of the filter to be updated.
  var path_589234 = newJObject()
  var query_589235 = newJObject()
  var body_589236 = newJObject()
  add(query_589235, "fields", newJString(fields))
  add(query_589235, "quotaUser", newJString(quotaUser))
  add(query_589235, "alt", newJString(alt))
  add(query_589235, "oauth_token", newJString(oauthToken))
  add(path_589234, "accountId", newJString(accountId))
  add(query_589235, "userIp", newJString(userIp))
  add(query_589235, "key", newJString(key))
  if body != nil:
    body_589236 = body
  add(query_589235, "prettyPrint", newJBool(prettyPrint))
  add(path_589234, "filterId", newJString(filterId))
  result = call_589233.call(path_589234, query_589235, nil, nil, body_589236)

var analyticsManagementFiltersUpdate* = Call_AnalyticsManagementFiltersUpdate_589219(
    name: "analyticsManagementFiltersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersUpdate_589220,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersUpdate_589221,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersGet_589203 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementFiltersGet_589205(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "filterId" in path, "`filterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/filters/"),
               (kind: VariableSegment, value: "filterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementFiltersGet_589204(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns filters to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to retrieve filters for.
  ##   filterId: JString (required)
  ##           : Filter ID to retrieve filters for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589206 = path.getOrDefault("accountId")
  valid_589206 = validateParameter(valid_589206, JString, required = true,
                                 default = nil)
  if valid_589206 != nil:
    section.add "accountId", valid_589206
  var valid_589207 = path.getOrDefault("filterId")
  valid_589207 = validateParameter(valid_589207, JString, required = true,
                                 default = nil)
  if valid_589207 != nil:
    section.add "filterId", valid_589207
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589208 = query.getOrDefault("fields")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "fields", valid_589208
  var valid_589209 = query.getOrDefault("quotaUser")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "quotaUser", valid_589209
  var valid_589210 = query.getOrDefault("alt")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = newJString("json"))
  if valid_589210 != nil:
    section.add "alt", valid_589210
  var valid_589211 = query.getOrDefault("oauth_token")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "oauth_token", valid_589211
  var valid_589212 = query.getOrDefault("userIp")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "userIp", valid_589212
  var valid_589213 = query.getOrDefault("key")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "key", valid_589213
  var valid_589214 = query.getOrDefault("prettyPrint")
  valid_589214 = validateParameter(valid_589214, JBool, required = false,
                                 default = newJBool(false))
  if valid_589214 != nil:
    section.add "prettyPrint", valid_589214
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589215: Call_AnalyticsManagementFiltersGet_589203; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns filters to which the user has access.
  ## 
  let valid = call_589215.validator(path, query, header, formData, body)
  let scheme = call_589215.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589215.url(scheme.get, call_589215.host, call_589215.base,
                         call_589215.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589215, url, valid)

proc call*(call_589216: Call_AnalyticsManagementFiltersGet_589203;
          accountId: string; filterId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementFiltersGet
  ## Returns filters to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve filters for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filterId: string (required)
  ##           : Filter ID to retrieve filters for.
  var path_589217 = newJObject()
  var query_589218 = newJObject()
  add(query_589218, "fields", newJString(fields))
  add(query_589218, "quotaUser", newJString(quotaUser))
  add(query_589218, "alt", newJString(alt))
  add(query_589218, "oauth_token", newJString(oauthToken))
  add(path_589217, "accountId", newJString(accountId))
  add(query_589218, "userIp", newJString(userIp))
  add(query_589218, "key", newJString(key))
  add(query_589218, "prettyPrint", newJBool(prettyPrint))
  add(path_589217, "filterId", newJString(filterId))
  result = call_589216.call(path_589217, query_589218, nil, nil, nil)

var analyticsManagementFiltersGet* = Call_AnalyticsManagementFiltersGet_589203(
    name: "analyticsManagementFiltersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersGet_589204,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersGet_589205,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersPatch_589253 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementFiltersPatch_589255(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "filterId" in path, "`filterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/filters/"),
               (kind: VariableSegment, value: "filterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementFiltersPatch_589254(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing filter. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to which the filter belongs.
  ##   filterId: JString (required)
  ##           : ID of the filter to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589256 = path.getOrDefault("accountId")
  valid_589256 = validateParameter(valid_589256, JString, required = true,
                                 default = nil)
  if valid_589256 != nil:
    section.add "accountId", valid_589256
  var valid_589257 = path.getOrDefault("filterId")
  valid_589257 = validateParameter(valid_589257, JString, required = true,
                                 default = nil)
  if valid_589257 != nil:
    section.add "filterId", valid_589257
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589258 = query.getOrDefault("fields")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "fields", valid_589258
  var valid_589259 = query.getOrDefault("quotaUser")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "quotaUser", valid_589259
  var valid_589260 = query.getOrDefault("alt")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = newJString("json"))
  if valid_589260 != nil:
    section.add "alt", valid_589260
  var valid_589261 = query.getOrDefault("oauth_token")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "oauth_token", valid_589261
  var valid_589262 = query.getOrDefault("userIp")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "userIp", valid_589262
  var valid_589263 = query.getOrDefault("key")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "key", valid_589263
  var valid_589264 = query.getOrDefault("prettyPrint")
  valid_589264 = validateParameter(valid_589264, JBool, required = false,
                                 default = newJBool(false))
  if valid_589264 != nil:
    section.add "prettyPrint", valid_589264
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589266: Call_AnalyticsManagementFiltersPatch_589253;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing filter. This method supports patch semantics.
  ## 
  let valid = call_589266.validator(path, query, header, formData, body)
  let scheme = call_589266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589266.url(scheme.get, call_589266.host, call_589266.base,
                         call_589266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589266, url, valid)

proc call*(call_589267: Call_AnalyticsManagementFiltersPatch_589253;
          accountId: string; filterId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementFiltersPatch
  ## Updates an existing filter. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the filter belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filterId: string (required)
  ##           : ID of the filter to be updated.
  var path_589268 = newJObject()
  var query_589269 = newJObject()
  var body_589270 = newJObject()
  add(query_589269, "fields", newJString(fields))
  add(query_589269, "quotaUser", newJString(quotaUser))
  add(query_589269, "alt", newJString(alt))
  add(query_589269, "oauth_token", newJString(oauthToken))
  add(path_589268, "accountId", newJString(accountId))
  add(query_589269, "userIp", newJString(userIp))
  add(query_589269, "key", newJString(key))
  if body != nil:
    body_589270 = body
  add(query_589269, "prettyPrint", newJBool(prettyPrint))
  add(path_589268, "filterId", newJString(filterId))
  result = call_589267.call(path_589268, query_589269, nil, nil, body_589270)

var analyticsManagementFiltersPatch* = Call_AnalyticsManagementFiltersPatch_589253(
    name: "analyticsManagementFiltersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersPatch_589254,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersPatch_589255,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersDelete_589237 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementFiltersDelete_589239(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "filterId" in path, "`filterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/filters/"),
               (kind: VariableSegment, value: "filterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementFiltersDelete_589238(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a filter.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to delete the filter for.
  ##   filterId: JString (required)
  ##           : ID of the filter to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589240 = path.getOrDefault("accountId")
  valid_589240 = validateParameter(valid_589240, JString, required = true,
                                 default = nil)
  if valid_589240 != nil:
    section.add "accountId", valid_589240
  var valid_589241 = path.getOrDefault("filterId")
  valid_589241 = validateParameter(valid_589241, JString, required = true,
                                 default = nil)
  if valid_589241 != nil:
    section.add "filterId", valid_589241
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589242 = query.getOrDefault("fields")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "fields", valid_589242
  var valid_589243 = query.getOrDefault("quotaUser")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "quotaUser", valid_589243
  var valid_589244 = query.getOrDefault("alt")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = newJString("json"))
  if valid_589244 != nil:
    section.add "alt", valid_589244
  var valid_589245 = query.getOrDefault("oauth_token")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "oauth_token", valid_589245
  var valid_589246 = query.getOrDefault("userIp")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "userIp", valid_589246
  var valid_589247 = query.getOrDefault("key")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "key", valid_589247
  var valid_589248 = query.getOrDefault("prettyPrint")
  valid_589248 = validateParameter(valid_589248, JBool, required = false,
                                 default = newJBool(false))
  if valid_589248 != nil:
    section.add "prettyPrint", valid_589248
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589249: Call_AnalyticsManagementFiltersDelete_589237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a filter.
  ## 
  let valid = call_589249.validator(path, query, header, formData, body)
  let scheme = call_589249.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589249.url(scheme.get, call_589249.host, call_589249.base,
                         call_589249.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589249, url, valid)

proc call*(call_589250: Call_AnalyticsManagementFiltersDelete_589237;
          accountId: string; filterId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementFiltersDelete
  ## Delete a filter.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to delete the filter for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filterId: string (required)
  ##           : ID of the filter to be deleted.
  var path_589251 = newJObject()
  var query_589252 = newJObject()
  add(query_589252, "fields", newJString(fields))
  add(query_589252, "quotaUser", newJString(quotaUser))
  add(query_589252, "alt", newJString(alt))
  add(query_589252, "oauth_token", newJString(oauthToken))
  add(path_589251, "accountId", newJString(accountId))
  add(query_589252, "userIp", newJString(userIp))
  add(query_589252, "key", newJString(key))
  add(query_589252, "prettyPrint", newJBool(prettyPrint))
  add(path_589251, "filterId", newJString(filterId))
  result = call_589250.call(path_589251, query_589252, nil, nil, nil)

var analyticsManagementFiltersDelete* = Call_AnalyticsManagementFiltersDelete_589237(
    name: "analyticsManagementFiltersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersDelete_589238,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersDelete_589239,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesInsert_589288 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebpropertiesInsert_589290(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertiesInsert_589289(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new property if the account has fewer than 20 properties. Web properties are visible in the Google Analytics interface only if they have at least one profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to create the web property for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589291 = path.getOrDefault("accountId")
  valid_589291 = validateParameter(valid_589291, JString, required = true,
                                 default = nil)
  if valid_589291 != nil:
    section.add "accountId", valid_589291
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589292 = query.getOrDefault("fields")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "fields", valid_589292
  var valid_589293 = query.getOrDefault("quotaUser")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "quotaUser", valid_589293
  var valid_589294 = query.getOrDefault("alt")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = newJString("json"))
  if valid_589294 != nil:
    section.add "alt", valid_589294
  var valid_589295 = query.getOrDefault("oauth_token")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "oauth_token", valid_589295
  var valid_589296 = query.getOrDefault("userIp")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "userIp", valid_589296
  var valid_589297 = query.getOrDefault("key")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "key", valid_589297
  var valid_589298 = query.getOrDefault("prettyPrint")
  valid_589298 = validateParameter(valid_589298, JBool, required = false,
                                 default = newJBool(false))
  if valid_589298 != nil:
    section.add "prettyPrint", valid_589298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589300: Call_AnalyticsManagementWebpropertiesInsert_589288;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new property if the account has fewer than 20 properties. Web properties are visible in the Google Analytics interface only if they have at least one profile.
  ## 
  let valid = call_589300.validator(path, query, header, formData, body)
  let scheme = call_589300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589300.url(scheme.get, call_589300.host, call_589300.base,
                         call_589300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589300, url, valid)

proc call*(call_589301: Call_AnalyticsManagementWebpropertiesInsert_589288;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertiesInsert
  ## Create a new property if the account has fewer than 20 properties. Web properties are visible in the Google Analytics interface only if they have at least one profile.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the web property for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589302 = newJObject()
  var query_589303 = newJObject()
  var body_589304 = newJObject()
  add(query_589303, "fields", newJString(fields))
  add(query_589303, "quotaUser", newJString(quotaUser))
  add(query_589303, "alt", newJString(alt))
  add(query_589303, "oauth_token", newJString(oauthToken))
  add(path_589302, "accountId", newJString(accountId))
  add(query_589303, "userIp", newJString(userIp))
  add(query_589303, "key", newJString(key))
  if body != nil:
    body_589304 = body
  add(query_589303, "prettyPrint", newJBool(prettyPrint))
  result = call_589301.call(path_589302, query_589303, nil, nil, body_589304)

var analyticsManagementWebpropertiesInsert* = Call_AnalyticsManagementWebpropertiesInsert_589288(
    name: "analyticsManagementWebpropertiesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties",
    validator: validate_AnalyticsManagementWebpropertiesInsert_589289,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesInsert_589290,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesList_589271 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebpropertiesList_589273(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertiesList_589272(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists web properties to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to retrieve web properties for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589274 = path.getOrDefault("accountId")
  valid_589274 = validateParameter(valid_589274, JString, required = true,
                                 default = nil)
  if valid_589274 != nil:
    section.add "accountId", valid_589274
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of web properties to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589275 = query.getOrDefault("fields")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "fields", valid_589275
  var valid_589276 = query.getOrDefault("quotaUser")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = nil)
  if valid_589276 != nil:
    section.add "quotaUser", valid_589276
  var valid_589277 = query.getOrDefault("alt")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = newJString("json"))
  if valid_589277 != nil:
    section.add "alt", valid_589277
  var valid_589278 = query.getOrDefault("oauth_token")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "oauth_token", valid_589278
  var valid_589279 = query.getOrDefault("userIp")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "userIp", valid_589279
  var valid_589280 = query.getOrDefault("key")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "key", valid_589280
  var valid_589281 = query.getOrDefault("max-results")
  valid_589281 = validateParameter(valid_589281, JInt, required = false, default = nil)
  if valid_589281 != nil:
    section.add "max-results", valid_589281
  var valid_589282 = query.getOrDefault("start-index")
  valid_589282 = validateParameter(valid_589282, JInt, required = false, default = nil)
  if valid_589282 != nil:
    section.add "start-index", valid_589282
  var valid_589283 = query.getOrDefault("prettyPrint")
  valid_589283 = validateParameter(valid_589283, JBool, required = false,
                                 default = newJBool(false))
  if valid_589283 != nil:
    section.add "prettyPrint", valid_589283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589284: Call_AnalyticsManagementWebpropertiesList_589271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists web properties to which the user has access.
  ## 
  let valid = call_589284.validator(path, query, header, formData, body)
  let scheme = call_589284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589284.url(scheme.get, call_589284.host, call_589284.base,
                         call_589284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589284, url, valid)

proc call*(call_589285: Call_AnalyticsManagementWebpropertiesList_589271;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertiesList
  ## Lists web properties to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve web properties for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of web properties to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589286 = newJObject()
  var query_589287 = newJObject()
  add(query_589287, "fields", newJString(fields))
  add(query_589287, "quotaUser", newJString(quotaUser))
  add(query_589287, "alt", newJString(alt))
  add(query_589287, "oauth_token", newJString(oauthToken))
  add(path_589286, "accountId", newJString(accountId))
  add(query_589287, "userIp", newJString(userIp))
  add(query_589287, "key", newJString(key))
  add(query_589287, "max-results", newJInt(maxResults))
  add(query_589287, "start-index", newJInt(startIndex))
  add(query_589287, "prettyPrint", newJBool(prettyPrint))
  result = call_589285.call(path_589286, query_589287, nil, nil, nil)

var analyticsManagementWebpropertiesList* = Call_AnalyticsManagementWebpropertiesList_589271(
    name: "analyticsManagementWebpropertiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties",
    validator: validate_AnalyticsManagementWebpropertiesList_589272,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesList_589273,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesUpdate_589321 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebpropertiesUpdate_589323(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertiesUpdate_589322(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to which the web property belongs
  ##   webPropertyId: JString (required)
  ##                : Web property ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589324 = path.getOrDefault("accountId")
  valid_589324 = validateParameter(valid_589324, JString, required = true,
                                 default = nil)
  if valid_589324 != nil:
    section.add "accountId", valid_589324
  var valid_589325 = path.getOrDefault("webPropertyId")
  valid_589325 = validateParameter(valid_589325, JString, required = true,
                                 default = nil)
  if valid_589325 != nil:
    section.add "webPropertyId", valid_589325
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589326 = query.getOrDefault("fields")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "fields", valid_589326
  var valid_589327 = query.getOrDefault("quotaUser")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "quotaUser", valid_589327
  var valid_589328 = query.getOrDefault("alt")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = newJString("json"))
  if valid_589328 != nil:
    section.add "alt", valid_589328
  var valid_589329 = query.getOrDefault("oauth_token")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "oauth_token", valid_589329
  var valid_589330 = query.getOrDefault("userIp")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "userIp", valid_589330
  var valid_589331 = query.getOrDefault("key")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "key", valid_589331
  var valid_589332 = query.getOrDefault("prettyPrint")
  valid_589332 = validateParameter(valid_589332, JBool, required = false,
                                 default = newJBool(false))
  if valid_589332 != nil:
    section.add "prettyPrint", valid_589332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589334: Call_AnalyticsManagementWebpropertiesUpdate_589321;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing web property.
  ## 
  let valid = call_589334.validator(path, query, header, formData, body)
  let scheme = call_589334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589334.url(scheme.get, call_589334.host, call_589334.base,
                         call_589334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589334, url, valid)

proc call*(call_589335: Call_AnalyticsManagementWebpropertiesUpdate_589321;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertiesUpdate
  ## Updates an existing web property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the web property belongs
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589336 = newJObject()
  var query_589337 = newJObject()
  var body_589338 = newJObject()
  add(query_589337, "fields", newJString(fields))
  add(query_589337, "quotaUser", newJString(quotaUser))
  add(query_589337, "alt", newJString(alt))
  add(query_589337, "oauth_token", newJString(oauthToken))
  add(path_589336, "accountId", newJString(accountId))
  add(query_589337, "userIp", newJString(userIp))
  add(path_589336, "webPropertyId", newJString(webPropertyId))
  add(query_589337, "key", newJString(key))
  if body != nil:
    body_589338 = body
  add(query_589337, "prettyPrint", newJBool(prettyPrint))
  result = call_589335.call(path_589336, query_589337, nil, nil, body_589338)

var analyticsManagementWebpropertiesUpdate* = Call_AnalyticsManagementWebpropertiesUpdate_589321(
    name: "analyticsManagementWebpropertiesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties/{webPropertyId}",
    validator: validate_AnalyticsManagementWebpropertiesUpdate_589322,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesUpdate_589323,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesGet_589305 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebpropertiesGet_589307(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertiesGet_589306(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a web property to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the web property for.
  ##   webPropertyId: JString (required)
  ##                : ID to retrieve the web property for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589308 = path.getOrDefault("accountId")
  valid_589308 = validateParameter(valid_589308, JString, required = true,
                                 default = nil)
  if valid_589308 != nil:
    section.add "accountId", valid_589308
  var valid_589309 = path.getOrDefault("webPropertyId")
  valid_589309 = validateParameter(valid_589309, JString, required = true,
                                 default = nil)
  if valid_589309 != nil:
    section.add "webPropertyId", valid_589309
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589310 = query.getOrDefault("fields")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "fields", valid_589310
  var valid_589311 = query.getOrDefault("quotaUser")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "quotaUser", valid_589311
  var valid_589312 = query.getOrDefault("alt")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = newJString("json"))
  if valid_589312 != nil:
    section.add "alt", valid_589312
  var valid_589313 = query.getOrDefault("oauth_token")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "oauth_token", valid_589313
  var valid_589314 = query.getOrDefault("userIp")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "userIp", valid_589314
  var valid_589315 = query.getOrDefault("key")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "key", valid_589315
  var valid_589316 = query.getOrDefault("prettyPrint")
  valid_589316 = validateParameter(valid_589316, JBool, required = false,
                                 default = newJBool(false))
  if valid_589316 != nil:
    section.add "prettyPrint", valid_589316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589317: Call_AnalyticsManagementWebpropertiesGet_589305;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a web property to which the user has access.
  ## 
  let valid = call_589317.validator(path, query, header, formData, body)
  let scheme = call_589317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589317.url(scheme.get, call_589317.host, call_589317.base,
                         call_589317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589317, url, valid)

proc call*(call_589318: Call_AnalyticsManagementWebpropertiesGet_589305;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertiesGet
  ## Gets a web property to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the web property for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : ID to retrieve the web property for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589319 = newJObject()
  var query_589320 = newJObject()
  add(query_589320, "fields", newJString(fields))
  add(query_589320, "quotaUser", newJString(quotaUser))
  add(query_589320, "alt", newJString(alt))
  add(query_589320, "oauth_token", newJString(oauthToken))
  add(path_589319, "accountId", newJString(accountId))
  add(query_589320, "userIp", newJString(userIp))
  add(path_589319, "webPropertyId", newJString(webPropertyId))
  add(query_589320, "key", newJString(key))
  add(query_589320, "prettyPrint", newJBool(prettyPrint))
  result = call_589318.call(path_589319, query_589320, nil, nil, nil)

var analyticsManagementWebpropertiesGet* = Call_AnalyticsManagementWebpropertiesGet_589305(
    name: "analyticsManagementWebpropertiesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties/{webPropertyId}",
    validator: validate_AnalyticsManagementWebpropertiesGet_589306,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesGet_589307,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesPatch_589339 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebpropertiesPatch_589341(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertiesPatch_589340(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing web property. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to which the web property belongs
  ##   webPropertyId: JString (required)
  ##                : Web property ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589342 = path.getOrDefault("accountId")
  valid_589342 = validateParameter(valid_589342, JString, required = true,
                                 default = nil)
  if valid_589342 != nil:
    section.add "accountId", valid_589342
  var valid_589343 = path.getOrDefault("webPropertyId")
  valid_589343 = validateParameter(valid_589343, JString, required = true,
                                 default = nil)
  if valid_589343 != nil:
    section.add "webPropertyId", valid_589343
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589344 = query.getOrDefault("fields")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "fields", valid_589344
  var valid_589345 = query.getOrDefault("quotaUser")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "quotaUser", valid_589345
  var valid_589346 = query.getOrDefault("alt")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = newJString("json"))
  if valid_589346 != nil:
    section.add "alt", valid_589346
  var valid_589347 = query.getOrDefault("oauth_token")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "oauth_token", valid_589347
  var valid_589348 = query.getOrDefault("userIp")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "userIp", valid_589348
  var valid_589349 = query.getOrDefault("key")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "key", valid_589349
  var valid_589350 = query.getOrDefault("prettyPrint")
  valid_589350 = validateParameter(valid_589350, JBool, required = false,
                                 default = newJBool(false))
  if valid_589350 != nil:
    section.add "prettyPrint", valid_589350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589352: Call_AnalyticsManagementWebpropertiesPatch_589339;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing web property. This method supports patch semantics.
  ## 
  let valid = call_589352.validator(path, query, header, formData, body)
  let scheme = call_589352.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589352.url(scheme.get, call_589352.host, call_589352.base,
                         call_589352.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589352, url, valid)

proc call*(call_589353: Call_AnalyticsManagementWebpropertiesPatch_589339;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertiesPatch
  ## Updates an existing web property. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the web property belongs
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589354 = newJObject()
  var query_589355 = newJObject()
  var body_589356 = newJObject()
  add(query_589355, "fields", newJString(fields))
  add(query_589355, "quotaUser", newJString(quotaUser))
  add(query_589355, "alt", newJString(alt))
  add(query_589355, "oauth_token", newJString(oauthToken))
  add(path_589354, "accountId", newJString(accountId))
  add(query_589355, "userIp", newJString(userIp))
  add(path_589354, "webPropertyId", newJString(webPropertyId))
  add(query_589355, "key", newJString(key))
  if body != nil:
    body_589356 = body
  add(query_589355, "prettyPrint", newJBool(prettyPrint))
  result = call_589353.call(path_589354, query_589355, nil, nil, body_589356)

var analyticsManagementWebpropertiesPatch* = Call_AnalyticsManagementWebpropertiesPatch_589339(
    name: "analyticsManagementWebpropertiesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties/{webPropertyId}",
    validator: validate_AnalyticsManagementWebpropertiesPatch_589340,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesPatch_589341,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDataSourcesList_589357 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementCustomDataSourcesList_589359(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDataSources")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDataSourcesList_589358(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List custom data sources to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account Id for the custom data sources to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property Id for the custom data sources to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589360 = path.getOrDefault("accountId")
  valid_589360 = validateParameter(valid_589360, JString, required = true,
                                 default = nil)
  if valid_589360 != nil:
    section.add "accountId", valid_589360
  var valid_589361 = path.getOrDefault("webPropertyId")
  valid_589361 = validateParameter(valid_589361, JString, required = true,
                                 default = nil)
  if valid_589361 != nil:
    section.add "webPropertyId", valid_589361
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of custom data sources to include in this response.
  ##   start-index: JInt
  ##              : A 1-based index of the first custom data source to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589362 = query.getOrDefault("fields")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "fields", valid_589362
  var valid_589363 = query.getOrDefault("quotaUser")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "quotaUser", valid_589363
  var valid_589364 = query.getOrDefault("alt")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = newJString("json"))
  if valid_589364 != nil:
    section.add "alt", valid_589364
  var valid_589365 = query.getOrDefault("oauth_token")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "oauth_token", valid_589365
  var valid_589366 = query.getOrDefault("userIp")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "userIp", valid_589366
  var valid_589367 = query.getOrDefault("key")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "key", valid_589367
  var valid_589368 = query.getOrDefault("max-results")
  valid_589368 = validateParameter(valid_589368, JInt, required = false, default = nil)
  if valid_589368 != nil:
    section.add "max-results", valid_589368
  var valid_589369 = query.getOrDefault("start-index")
  valid_589369 = validateParameter(valid_589369, JInt, required = false, default = nil)
  if valid_589369 != nil:
    section.add "start-index", valid_589369
  var valid_589370 = query.getOrDefault("prettyPrint")
  valid_589370 = validateParameter(valid_589370, JBool, required = false,
                                 default = newJBool(false))
  if valid_589370 != nil:
    section.add "prettyPrint", valid_589370
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589371: Call_AnalyticsManagementCustomDataSourcesList_589357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List custom data sources to which the user has access.
  ## 
  let valid = call_589371.validator(path, query, header, formData, body)
  let scheme = call_589371.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589371.url(scheme.get, call_589371.host, call_589371.base,
                         call_589371.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589371, url, valid)

proc call*(call_589372: Call_AnalyticsManagementCustomDataSourcesList_589357;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomDataSourcesList
  ## List custom data sources to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account Id for the custom data sources to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id for the custom data sources to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of custom data sources to include in this response.
  ##   startIndex: int
  ##             : A 1-based index of the first custom data source to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589373 = newJObject()
  var query_589374 = newJObject()
  add(query_589374, "fields", newJString(fields))
  add(query_589374, "quotaUser", newJString(quotaUser))
  add(query_589374, "alt", newJString(alt))
  add(query_589374, "oauth_token", newJString(oauthToken))
  add(path_589373, "accountId", newJString(accountId))
  add(query_589374, "userIp", newJString(userIp))
  add(path_589373, "webPropertyId", newJString(webPropertyId))
  add(query_589374, "key", newJString(key))
  add(query_589374, "max-results", newJInt(maxResults))
  add(query_589374, "start-index", newJInt(startIndex))
  add(query_589374, "prettyPrint", newJBool(prettyPrint))
  result = call_589372.call(path_589373, query_589374, nil, nil, nil)

var analyticsManagementCustomDataSourcesList* = Call_AnalyticsManagementCustomDataSourcesList_589357(
    name: "analyticsManagementCustomDataSourcesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources",
    validator: validate_AnalyticsManagementCustomDataSourcesList_589358,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDataSourcesList_589359,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsDeleteUploadData_589375 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementUploadsDeleteUploadData_589377(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDataSourceId" in path,
        "`customDataSourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDataSources/"),
               (kind: VariableSegment, value: "customDataSourceId"),
               (kind: ConstantSegment, value: "/deleteUploadData")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUploadsDeleteUploadData_589376(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete data associated with a previous upload.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account Id for the uploads to be deleted.
  ##   webPropertyId: JString (required)
  ##                : Web property Id for the uploads to be deleted.
  ##   customDataSourceId: JString (required)
  ##                     : Custom data source Id for the uploads to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589378 = path.getOrDefault("accountId")
  valid_589378 = validateParameter(valid_589378, JString, required = true,
                                 default = nil)
  if valid_589378 != nil:
    section.add "accountId", valid_589378
  var valid_589379 = path.getOrDefault("webPropertyId")
  valid_589379 = validateParameter(valid_589379, JString, required = true,
                                 default = nil)
  if valid_589379 != nil:
    section.add "webPropertyId", valid_589379
  var valid_589380 = path.getOrDefault("customDataSourceId")
  valid_589380 = validateParameter(valid_589380, JString, required = true,
                                 default = nil)
  if valid_589380 != nil:
    section.add "customDataSourceId", valid_589380
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589381 = query.getOrDefault("fields")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "fields", valid_589381
  var valid_589382 = query.getOrDefault("quotaUser")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "quotaUser", valid_589382
  var valid_589383 = query.getOrDefault("alt")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = newJString("json"))
  if valid_589383 != nil:
    section.add "alt", valid_589383
  var valid_589384 = query.getOrDefault("oauth_token")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "oauth_token", valid_589384
  var valid_589385 = query.getOrDefault("userIp")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "userIp", valid_589385
  var valid_589386 = query.getOrDefault("key")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "key", valid_589386
  var valid_589387 = query.getOrDefault("prettyPrint")
  valid_589387 = validateParameter(valid_589387, JBool, required = false,
                                 default = newJBool(false))
  if valid_589387 != nil:
    section.add "prettyPrint", valid_589387
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589389: Call_AnalyticsManagementUploadsDeleteUploadData_589375;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete data associated with a previous upload.
  ## 
  let valid = call_589389.validator(path, query, header, formData, body)
  let scheme = call_589389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589389.url(scheme.get, call_589389.host, call_589389.base,
                         call_589389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589389, url, valid)

proc call*(call_589390: Call_AnalyticsManagementUploadsDeleteUploadData_589375;
          accountId: string; webPropertyId: string; customDataSourceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUploadsDeleteUploadData
  ## Delete data associated with a previous upload.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account Id for the uploads to be deleted.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id for the uploads to be deleted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   customDataSourceId: string (required)
  ##                     : Custom data source Id for the uploads to be deleted.
  var path_589391 = newJObject()
  var query_589392 = newJObject()
  var body_589393 = newJObject()
  add(query_589392, "fields", newJString(fields))
  add(query_589392, "quotaUser", newJString(quotaUser))
  add(query_589392, "alt", newJString(alt))
  add(query_589392, "oauth_token", newJString(oauthToken))
  add(path_589391, "accountId", newJString(accountId))
  add(query_589392, "userIp", newJString(userIp))
  add(path_589391, "webPropertyId", newJString(webPropertyId))
  add(query_589392, "key", newJString(key))
  if body != nil:
    body_589393 = body
  add(query_589392, "prettyPrint", newJBool(prettyPrint))
  add(path_589391, "customDataSourceId", newJString(customDataSourceId))
  result = call_589390.call(path_589391, query_589392, nil, nil, body_589393)

var analyticsManagementUploadsDeleteUploadData* = Call_AnalyticsManagementUploadsDeleteUploadData_589375(
    name: "analyticsManagementUploadsDeleteUploadData", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/deleteUploadData",
    validator: validate_AnalyticsManagementUploadsDeleteUploadData_589376,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsDeleteUploadData_589377,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsUploadData_589413 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementUploadsUploadData_589415(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDataSourceId" in path,
        "`customDataSourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDataSources/"),
               (kind: VariableSegment, value: "customDataSourceId"),
               (kind: ConstantSegment, value: "/uploads")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUploadsUploadData_589414(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Upload data for a custom data source.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account Id associated with the upload.
  ##   webPropertyId: JString (required)
  ##                : Web property UA-string associated with the upload.
  ##   customDataSourceId: JString (required)
  ##                     : Custom data source Id to which the data being uploaded belongs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589416 = path.getOrDefault("accountId")
  valid_589416 = validateParameter(valid_589416, JString, required = true,
                                 default = nil)
  if valid_589416 != nil:
    section.add "accountId", valid_589416
  var valid_589417 = path.getOrDefault("webPropertyId")
  valid_589417 = validateParameter(valid_589417, JString, required = true,
                                 default = nil)
  if valid_589417 != nil:
    section.add "webPropertyId", valid_589417
  var valid_589418 = path.getOrDefault("customDataSourceId")
  valid_589418 = validateParameter(valid_589418, JString, required = true,
                                 default = nil)
  if valid_589418 != nil:
    section.add "customDataSourceId", valid_589418
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589419 = query.getOrDefault("fields")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "fields", valid_589419
  var valid_589420 = query.getOrDefault("quotaUser")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "quotaUser", valid_589420
  var valid_589421 = query.getOrDefault("alt")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = newJString("json"))
  if valid_589421 != nil:
    section.add "alt", valid_589421
  var valid_589422 = query.getOrDefault("oauth_token")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "oauth_token", valid_589422
  var valid_589423 = query.getOrDefault("userIp")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "userIp", valid_589423
  var valid_589424 = query.getOrDefault("key")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "key", valid_589424
  var valid_589425 = query.getOrDefault("prettyPrint")
  valid_589425 = validateParameter(valid_589425, JBool, required = false,
                                 default = newJBool(false))
  if valid_589425 != nil:
    section.add "prettyPrint", valid_589425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589426: Call_AnalyticsManagementUploadsUploadData_589413;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload data for a custom data source.
  ## 
  let valid = call_589426.validator(path, query, header, formData, body)
  let scheme = call_589426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589426.url(scheme.get, call_589426.host, call_589426.base,
                         call_589426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589426, url, valid)

proc call*(call_589427: Call_AnalyticsManagementUploadsUploadData_589413;
          accountId: string; webPropertyId: string; customDataSourceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementUploadsUploadData
  ## Upload data for a custom data source.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account Id associated with the upload.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property UA-string associated with the upload.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customDataSourceId: string (required)
  ##                     : Custom data source Id to which the data being uploaded belongs.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589428 = newJObject()
  var query_589429 = newJObject()
  add(query_589429, "fields", newJString(fields))
  add(query_589429, "quotaUser", newJString(quotaUser))
  add(query_589429, "alt", newJString(alt))
  add(query_589429, "oauth_token", newJString(oauthToken))
  add(path_589428, "accountId", newJString(accountId))
  add(query_589429, "userIp", newJString(userIp))
  add(path_589428, "webPropertyId", newJString(webPropertyId))
  add(query_589429, "key", newJString(key))
  add(path_589428, "customDataSourceId", newJString(customDataSourceId))
  add(query_589429, "prettyPrint", newJBool(prettyPrint))
  result = call_589427.call(path_589428, query_589429, nil, nil, nil)

var analyticsManagementUploadsUploadData* = Call_AnalyticsManagementUploadsUploadData_589413(
    name: "analyticsManagementUploadsUploadData", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/uploads",
    validator: validate_AnalyticsManagementUploadsUploadData_589414,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsUploadData_589415,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsList_589394 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementUploadsList_589396(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDataSourceId" in path,
        "`customDataSourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDataSources/"),
               (kind: VariableSegment, value: "customDataSourceId"),
               (kind: ConstantSegment, value: "/uploads")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUploadsList_589395(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List uploads to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account Id for the uploads to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property Id for the uploads to retrieve.
  ##   customDataSourceId: JString (required)
  ##                     : Custom data source Id for uploads to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589397 = path.getOrDefault("accountId")
  valid_589397 = validateParameter(valid_589397, JString, required = true,
                                 default = nil)
  if valid_589397 != nil:
    section.add "accountId", valid_589397
  var valid_589398 = path.getOrDefault("webPropertyId")
  valid_589398 = validateParameter(valid_589398, JString, required = true,
                                 default = nil)
  if valid_589398 != nil:
    section.add "webPropertyId", valid_589398
  var valid_589399 = path.getOrDefault("customDataSourceId")
  valid_589399 = validateParameter(valid_589399, JString, required = true,
                                 default = nil)
  if valid_589399 != nil:
    section.add "customDataSourceId", valid_589399
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of uploads to include in this response.
  ##   start-index: JInt
  ##              : A 1-based index of the first upload to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589400 = query.getOrDefault("fields")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "fields", valid_589400
  var valid_589401 = query.getOrDefault("quotaUser")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "quotaUser", valid_589401
  var valid_589402 = query.getOrDefault("alt")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = newJString("json"))
  if valid_589402 != nil:
    section.add "alt", valid_589402
  var valid_589403 = query.getOrDefault("oauth_token")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "oauth_token", valid_589403
  var valid_589404 = query.getOrDefault("userIp")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "userIp", valid_589404
  var valid_589405 = query.getOrDefault("key")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "key", valid_589405
  var valid_589406 = query.getOrDefault("max-results")
  valid_589406 = validateParameter(valid_589406, JInt, required = false, default = nil)
  if valid_589406 != nil:
    section.add "max-results", valid_589406
  var valid_589407 = query.getOrDefault("start-index")
  valid_589407 = validateParameter(valid_589407, JInt, required = false, default = nil)
  if valid_589407 != nil:
    section.add "start-index", valid_589407
  var valid_589408 = query.getOrDefault("prettyPrint")
  valid_589408 = validateParameter(valid_589408, JBool, required = false,
                                 default = newJBool(false))
  if valid_589408 != nil:
    section.add "prettyPrint", valid_589408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589409: Call_AnalyticsManagementUploadsList_589394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List uploads to which the user has access.
  ## 
  let valid = call_589409.validator(path, query, header, formData, body)
  let scheme = call_589409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589409.url(scheme.get, call_589409.host, call_589409.base,
                         call_589409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589409, url, valid)

proc call*(call_589410: Call_AnalyticsManagementUploadsList_589394;
          accountId: string; webPropertyId: string; customDataSourceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUploadsList
  ## List uploads to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account Id for the uploads to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id for the uploads to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of uploads to include in this response.
  ##   startIndex: int
  ##             : A 1-based index of the first upload to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   customDataSourceId: string (required)
  ##                     : Custom data source Id for uploads to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589411 = newJObject()
  var query_589412 = newJObject()
  add(query_589412, "fields", newJString(fields))
  add(query_589412, "quotaUser", newJString(quotaUser))
  add(query_589412, "alt", newJString(alt))
  add(query_589412, "oauth_token", newJString(oauthToken))
  add(path_589411, "accountId", newJString(accountId))
  add(query_589412, "userIp", newJString(userIp))
  add(path_589411, "webPropertyId", newJString(webPropertyId))
  add(query_589412, "key", newJString(key))
  add(query_589412, "max-results", newJInt(maxResults))
  add(query_589412, "start-index", newJInt(startIndex))
  add(path_589411, "customDataSourceId", newJString(customDataSourceId))
  add(query_589412, "prettyPrint", newJBool(prettyPrint))
  result = call_589410.call(path_589411, query_589412, nil, nil, nil)

var analyticsManagementUploadsList* = Call_AnalyticsManagementUploadsList_589394(
    name: "analyticsManagementUploadsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/uploads",
    validator: validate_AnalyticsManagementUploadsList_589395,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsList_589396,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsGet_589430 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementUploadsGet_589432(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDataSourceId" in path,
        "`customDataSourceId` is a required path parameter"
  assert "uploadId" in path, "`uploadId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDataSources/"),
               (kind: VariableSegment, value: "customDataSourceId"),
               (kind: ConstantSegment, value: "/uploads/"),
               (kind: VariableSegment, value: "uploadId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUploadsGet_589431(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List uploads to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   uploadId: JString (required)
  ##           : Upload Id to retrieve.
  ##   accountId: JString (required)
  ##            : Account Id for the upload to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property Id for the upload to retrieve.
  ##   customDataSourceId: JString (required)
  ##                     : Custom data source Id for upload to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `uploadId` field"
  var valid_589433 = path.getOrDefault("uploadId")
  valid_589433 = validateParameter(valid_589433, JString, required = true,
                                 default = nil)
  if valid_589433 != nil:
    section.add "uploadId", valid_589433
  var valid_589434 = path.getOrDefault("accountId")
  valid_589434 = validateParameter(valid_589434, JString, required = true,
                                 default = nil)
  if valid_589434 != nil:
    section.add "accountId", valid_589434
  var valid_589435 = path.getOrDefault("webPropertyId")
  valid_589435 = validateParameter(valid_589435, JString, required = true,
                                 default = nil)
  if valid_589435 != nil:
    section.add "webPropertyId", valid_589435
  var valid_589436 = path.getOrDefault("customDataSourceId")
  valid_589436 = validateParameter(valid_589436, JString, required = true,
                                 default = nil)
  if valid_589436 != nil:
    section.add "customDataSourceId", valid_589436
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589437 = query.getOrDefault("fields")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "fields", valid_589437
  var valid_589438 = query.getOrDefault("quotaUser")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "quotaUser", valid_589438
  var valid_589439 = query.getOrDefault("alt")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = newJString("json"))
  if valid_589439 != nil:
    section.add "alt", valid_589439
  var valid_589440 = query.getOrDefault("oauth_token")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "oauth_token", valid_589440
  var valid_589441 = query.getOrDefault("userIp")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "userIp", valid_589441
  var valid_589442 = query.getOrDefault("key")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "key", valid_589442
  var valid_589443 = query.getOrDefault("prettyPrint")
  valid_589443 = validateParameter(valid_589443, JBool, required = false,
                                 default = newJBool(false))
  if valid_589443 != nil:
    section.add "prettyPrint", valid_589443
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589444: Call_AnalyticsManagementUploadsGet_589430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List uploads to which the user has access.
  ## 
  let valid = call_589444.validator(path, query, header, formData, body)
  let scheme = call_589444.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589444.url(scheme.get, call_589444.host, call_589444.base,
                         call_589444.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589444, url, valid)

proc call*(call_589445: Call_AnalyticsManagementUploadsGet_589430;
          uploadId: string; accountId: string; webPropertyId: string;
          customDataSourceId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUploadsGet
  ## List uploads to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   uploadId: string (required)
  ##           : Upload Id to retrieve.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account Id for the upload to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id for the upload to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customDataSourceId: string (required)
  ##                     : Custom data source Id for upload to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589446 = newJObject()
  var query_589447 = newJObject()
  add(query_589447, "fields", newJString(fields))
  add(path_589446, "uploadId", newJString(uploadId))
  add(query_589447, "quotaUser", newJString(quotaUser))
  add(query_589447, "alt", newJString(alt))
  add(query_589447, "oauth_token", newJString(oauthToken))
  add(path_589446, "accountId", newJString(accountId))
  add(query_589447, "userIp", newJString(userIp))
  add(path_589446, "webPropertyId", newJString(webPropertyId))
  add(query_589447, "key", newJString(key))
  add(path_589446, "customDataSourceId", newJString(customDataSourceId))
  add(query_589447, "prettyPrint", newJBool(prettyPrint))
  result = call_589445.call(path_589446, query_589447, nil, nil, nil)

var analyticsManagementUploadsGet* = Call_AnalyticsManagementUploadsGet_589430(
    name: "analyticsManagementUploadsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/uploads/{uploadId}",
    validator: validate_AnalyticsManagementUploadsGet_589431,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsGet_589432,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsInsert_589466 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementCustomDimensionsInsert_589468(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDimensionsInsert_589467(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new custom dimension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimension to create.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to create.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589469 = path.getOrDefault("accountId")
  valid_589469 = validateParameter(valid_589469, JString, required = true,
                                 default = nil)
  if valid_589469 != nil:
    section.add "accountId", valid_589469
  var valid_589470 = path.getOrDefault("webPropertyId")
  valid_589470 = validateParameter(valid_589470, JString, required = true,
                                 default = nil)
  if valid_589470 != nil:
    section.add "webPropertyId", valid_589470
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589471 = query.getOrDefault("fields")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "fields", valid_589471
  var valid_589472 = query.getOrDefault("quotaUser")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "quotaUser", valid_589472
  var valid_589473 = query.getOrDefault("alt")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = newJString("json"))
  if valid_589473 != nil:
    section.add "alt", valid_589473
  var valid_589474 = query.getOrDefault("oauth_token")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "oauth_token", valid_589474
  var valid_589475 = query.getOrDefault("userIp")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "userIp", valid_589475
  var valid_589476 = query.getOrDefault("key")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "key", valid_589476
  var valid_589477 = query.getOrDefault("prettyPrint")
  valid_589477 = validateParameter(valid_589477, JBool, required = false,
                                 default = newJBool(false))
  if valid_589477 != nil:
    section.add "prettyPrint", valid_589477
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589479: Call_AnalyticsManagementCustomDimensionsInsert_589466;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new custom dimension.
  ## 
  let valid = call_589479.validator(path, query, header, formData, body)
  let scheme = call_589479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589479.url(scheme.get, call_589479.host, call_589479.base,
                         call_589479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589479, url, valid)

proc call*(call_589480: Call_AnalyticsManagementCustomDimensionsInsert_589466;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomDimensionsInsert
  ## Create a new custom dimension.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom dimension to create.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to create.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589481 = newJObject()
  var query_589482 = newJObject()
  var body_589483 = newJObject()
  add(query_589482, "fields", newJString(fields))
  add(query_589482, "quotaUser", newJString(quotaUser))
  add(query_589482, "alt", newJString(alt))
  add(query_589482, "oauth_token", newJString(oauthToken))
  add(path_589481, "accountId", newJString(accountId))
  add(query_589482, "userIp", newJString(userIp))
  add(path_589481, "webPropertyId", newJString(webPropertyId))
  add(query_589482, "key", newJString(key))
  if body != nil:
    body_589483 = body
  add(query_589482, "prettyPrint", newJBool(prettyPrint))
  result = call_589480.call(path_589481, query_589482, nil, nil, body_589483)

var analyticsManagementCustomDimensionsInsert* = Call_AnalyticsManagementCustomDimensionsInsert_589466(
    name: "analyticsManagementCustomDimensionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions",
    validator: validate_AnalyticsManagementCustomDimensionsInsert_589467,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsInsert_589468,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsList_589448 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementCustomDimensionsList_589450(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDimensions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDimensionsList_589449(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists custom dimensions to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimensions to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimensions to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589451 = path.getOrDefault("accountId")
  valid_589451 = validateParameter(valid_589451, JString, required = true,
                                 default = nil)
  if valid_589451 != nil:
    section.add "accountId", valid_589451
  var valid_589452 = path.getOrDefault("webPropertyId")
  valid_589452 = validateParameter(valid_589452, JString, required = true,
                                 default = nil)
  if valid_589452 != nil:
    section.add "webPropertyId", valid_589452
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of custom dimensions to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589453 = query.getOrDefault("fields")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "fields", valid_589453
  var valid_589454 = query.getOrDefault("quotaUser")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "quotaUser", valid_589454
  var valid_589455 = query.getOrDefault("alt")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = newJString("json"))
  if valid_589455 != nil:
    section.add "alt", valid_589455
  var valid_589456 = query.getOrDefault("oauth_token")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "oauth_token", valid_589456
  var valid_589457 = query.getOrDefault("userIp")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = nil)
  if valid_589457 != nil:
    section.add "userIp", valid_589457
  var valid_589458 = query.getOrDefault("key")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "key", valid_589458
  var valid_589459 = query.getOrDefault("max-results")
  valid_589459 = validateParameter(valid_589459, JInt, required = false, default = nil)
  if valid_589459 != nil:
    section.add "max-results", valid_589459
  var valid_589460 = query.getOrDefault("start-index")
  valid_589460 = validateParameter(valid_589460, JInt, required = false, default = nil)
  if valid_589460 != nil:
    section.add "start-index", valid_589460
  var valid_589461 = query.getOrDefault("prettyPrint")
  valid_589461 = validateParameter(valid_589461, JBool, required = false,
                                 default = newJBool(false))
  if valid_589461 != nil:
    section.add "prettyPrint", valid_589461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589462: Call_AnalyticsManagementCustomDimensionsList_589448;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists custom dimensions to which the user has access.
  ## 
  let valid = call_589462.validator(path, query, header, formData, body)
  let scheme = call_589462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589462.url(scheme.get, call_589462.host, call_589462.base,
                         call_589462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589462, url, valid)

proc call*(call_589463: Call_AnalyticsManagementCustomDimensionsList_589448;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomDimensionsList
  ## Lists custom dimensions to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom dimensions to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimensions to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of custom dimensions to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589464 = newJObject()
  var query_589465 = newJObject()
  add(query_589465, "fields", newJString(fields))
  add(query_589465, "quotaUser", newJString(quotaUser))
  add(query_589465, "alt", newJString(alt))
  add(query_589465, "oauth_token", newJString(oauthToken))
  add(path_589464, "accountId", newJString(accountId))
  add(query_589465, "userIp", newJString(userIp))
  add(path_589464, "webPropertyId", newJString(webPropertyId))
  add(query_589465, "key", newJString(key))
  add(query_589465, "max-results", newJInt(maxResults))
  add(query_589465, "start-index", newJInt(startIndex))
  add(query_589465, "prettyPrint", newJBool(prettyPrint))
  result = call_589463.call(path_589464, query_589465, nil, nil, nil)

var analyticsManagementCustomDimensionsList* = Call_AnalyticsManagementCustomDimensionsList_589448(
    name: "analyticsManagementCustomDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions",
    validator: validate_AnalyticsManagementCustomDimensionsList_589449,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsList_589450,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsUpdate_589501 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementCustomDimensionsUpdate_589503(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDimensionId" in path,
        "`customDimensionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDimensions/"),
               (kind: VariableSegment, value: "customDimensionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDimensionsUpdate_589502(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing custom dimension.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDimensionId: JString (required)
  ##                    : Custom dimension ID for the custom dimension to update.
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimension to update.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDimensionId` field"
  var valid_589504 = path.getOrDefault("customDimensionId")
  valid_589504 = validateParameter(valid_589504, JString, required = true,
                                 default = nil)
  if valid_589504 != nil:
    section.add "customDimensionId", valid_589504
  var valid_589505 = path.getOrDefault("accountId")
  valid_589505 = validateParameter(valid_589505, JString, required = true,
                                 default = nil)
  if valid_589505 != nil:
    section.add "accountId", valid_589505
  var valid_589506 = path.getOrDefault("webPropertyId")
  valid_589506 = validateParameter(valid_589506, JString, required = true,
                                 default = nil)
  if valid_589506 != nil:
    section.add "webPropertyId", valid_589506
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: JBool
  ##                              : Force the update and ignore any warnings related to the custom dimension being linked to a custom data source / data set.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589507 = query.getOrDefault("fields")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = nil)
  if valid_589507 != nil:
    section.add "fields", valid_589507
  var valid_589508 = query.getOrDefault("quotaUser")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = nil)
  if valid_589508 != nil:
    section.add "quotaUser", valid_589508
  var valid_589509 = query.getOrDefault("alt")
  valid_589509 = validateParameter(valid_589509, JString, required = false,
                                 default = newJString("json"))
  if valid_589509 != nil:
    section.add "alt", valid_589509
  var valid_589510 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_589510 = validateParameter(valid_589510, JBool, required = false,
                                 default = newJBool(false))
  if valid_589510 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_589510
  var valid_589511 = query.getOrDefault("oauth_token")
  valid_589511 = validateParameter(valid_589511, JString, required = false,
                                 default = nil)
  if valid_589511 != nil:
    section.add "oauth_token", valid_589511
  var valid_589512 = query.getOrDefault("userIp")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = nil)
  if valid_589512 != nil:
    section.add "userIp", valid_589512
  var valid_589513 = query.getOrDefault("key")
  valid_589513 = validateParameter(valid_589513, JString, required = false,
                                 default = nil)
  if valid_589513 != nil:
    section.add "key", valid_589513
  var valid_589514 = query.getOrDefault("prettyPrint")
  valid_589514 = validateParameter(valid_589514, JBool, required = false,
                                 default = newJBool(false))
  if valid_589514 != nil:
    section.add "prettyPrint", valid_589514
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589516: Call_AnalyticsManagementCustomDimensionsUpdate_589501;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom dimension.
  ## 
  let valid = call_589516.validator(path, query, header, formData, body)
  let scheme = call_589516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589516.url(scheme.get, call_589516.host, call_589516.base,
                         call_589516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589516, url, valid)

proc call*(call_589517: Call_AnalyticsManagementCustomDimensionsUpdate_589501;
          customDimensionId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          ignoreCustomDataSourceLinks: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomDimensionsUpdate
  ## Updates an existing custom dimension.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   customDimensionId: string (required)
  ##                    : Custom dimension ID for the custom dimension to update.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: bool
  ##                              : Force the update and ignore any warnings related to the custom dimension being linked to a custom data source / data set.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom dimension to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589518 = newJObject()
  var query_589519 = newJObject()
  var body_589520 = newJObject()
  add(query_589519, "fields", newJString(fields))
  add(path_589518, "customDimensionId", newJString(customDimensionId))
  add(query_589519, "quotaUser", newJString(quotaUser))
  add(query_589519, "alt", newJString(alt))
  add(query_589519, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(query_589519, "oauth_token", newJString(oauthToken))
  add(path_589518, "accountId", newJString(accountId))
  add(query_589519, "userIp", newJString(userIp))
  add(path_589518, "webPropertyId", newJString(webPropertyId))
  add(query_589519, "key", newJString(key))
  if body != nil:
    body_589520 = body
  add(query_589519, "prettyPrint", newJBool(prettyPrint))
  result = call_589517.call(path_589518, query_589519, nil, nil, body_589520)

var analyticsManagementCustomDimensionsUpdate* = Call_AnalyticsManagementCustomDimensionsUpdate_589501(
    name: "analyticsManagementCustomDimensionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions/{customDimensionId}",
    validator: validate_AnalyticsManagementCustomDimensionsUpdate_589502,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsUpdate_589503,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsGet_589484 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementCustomDimensionsGet_589486(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDimensionId" in path,
        "`customDimensionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDimensions/"),
               (kind: VariableSegment, value: "customDimensionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDimensionsGet_589485(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a custom dimension to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDimensionId: JString (required)
  ##                    : The ID of the custom dimension to retrieve.
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimension to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDimensionId` field"
  var valid_589487 = path.getOrDefault("customDimensionId")
  valid_589487 = validateParameter(valid_589487, JString, required = true,
                                 default = nil)
  if valid_589487 != nil:
    section.add "customDimensionId", valid_589487
  var valid_589488 = path.getOrDefault("accountId")
  valid_589488 = validateParameter(valid_589488, JString, required = true,
                                 default = nil)
  if valid_589488 != nil:
    section.add "accountId", valid_589488
  var valid_589489 = path.getOrDefault("webPropertyId")
  valid_589489 = validateParameter(valid_589489, JString, required = true,
                                 default = nil)
  if valid_589489 != nil:
    section.add "webPropertyId", valid_589489
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589490 = query.getOrDefault("fields")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = nil)
  if valid_589490 != nil:
    section.add "fields", valid_589490
  var valid_589491 = query.getOrDefault("quotaUser")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = nil)
  if valid_589491 != nil:
    section.add "quotaUser", valid_589491
  var valid_589492 = query.getOrDefault("alt")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = newJString("json"))
  if valid_589492 != nil:
    section.add "alt", valid_589492
  var valid_589493 = query.getOrDefault("oauth_token")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = nil)
  if valid_589493 != nil:
    section.add "oauth_token", valid_589493
  var valid_589494 = query.getOrDefault("userIp")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "userIp", valid_589494
  var valid_589495 = query.getOrDefault("key")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "key", valid_589495
  var valid_589496 = query.getOrDefault("prettyPrint")
  valid_589496 = validateParameter(valid_589496, JBool, required = false,
                                 default = newJBool(false))
  if valid_589496 != nil:
    section.add "prettyPrint", valid_589496
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589497: Call_AnalyticsManagementCustomDimensionsGet_589484;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a custom dimension to which the user has access.
  ## 
  let valid = call_589497.validator(path, query, header, formData, body)
  let scheme = call_589497.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589497.url(scheme.get, call_589497.host, call_589497.base,
                         call_589497.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589497, url, valid)

proc call*(call_589498: Call_AnalyticsManagementCustomDimensionsGet_589484;
          customDimensionId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomDimensionsGet
  ## Get a custom dimension to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   customDimensionId: string (required)
  ##                    : The ID of the custom dimension to retrieve.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom dimension to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589499 = newJObject()
  var query_589500 = newJObject()
  add(query_589500, "fields", newJString(fields))
  add(path_589499, "customDimensionId", newJString(customDimensionId))
  add(query_589500, "quotaUser", newJString(quotaUser))
  add(query_589500, "alt", newJString(alt))
  add(query_589500, "oauth_token", newJString(oauthToken))
  add(path_589499, "accountId", newJString(accountId))
  add(query_589500, "userIp", newJString(userIp))
  add(path_589499, "webPropertyId", newJString(webPropertyId))
  add(query_589500, "key", newJString(key))
  add(query_589500, "prettyPrint", newJBool(prettyPrint))
  result = call_589498.call(path_589499, query_589500, nil, nil, nil)

var analyticsManagementCustomDimensionsGet* = Call_AnalyticsManagementCustomDimensionsGet_589484(
    name: "analyticsManagementCustomDimensionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions/{customDimensionId}",
    validator: validate_AnalyticsManagementCustomDimensionsGet_589485,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsGet_589486,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsPatch_589521 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementCustomDimensionsPatch_589523(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customDimensionId" in path,
        "`customDimensionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customDimensions/"),
               (kind: VariableSegment, value: "customDimensionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomDimensionsPatch_589522(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing custom dimension. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customDimensionId: JString (required)
  ##                    : Custom dimension ID for the custom dimension to update.
  ##   accountId: JString (required)
  ##            : Account ID for the custom dimension to update.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customDimensionId` field"
  var valid_589524 = path.getOrDefault("customDimensionId")
  valid_589524 = validateParameter(valid_589524, JString, required = true,
                                 default = nil)
  if valid_589524 != nil:
    section.add "customDimensionId", valid_589524
  var valid_589525 = path.getOrDefault("accountId")
  valid_589525 = validateParameter(valid_589525, JString, required = true,
                                 default = nil)
  if valid_589525 != nil:
    section.add "accountId", valid_589525
  var valid_589526 = path.getOrDefault("webPropertyId")
  valid_589526 = validateParameter(valid_589526, JString, required = true,
                                 default = nil)
  if valid_589526 != nil:
    section.add "webPropertyId", valid_589526
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: JBool
  ##                              : Force the update and ignore any warnings related to the custom dimension being linked to a custom data source / data set.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589527 = query.getOrDefault("fields")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "fields", valid_589527
  var valid_589528 = query.getOrDefault("quotaUser")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = nil)
  if valid_589528 != nil:
    section.add "quotaUser", valid_589528
  var valid_589529 = query.getOrDefault("alt")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = newJString("json"))
  if valid_589529 != nil:
    section.add "alt", valid_589529
  var valid_589530 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_589530 = validateParameter(valid_589530, JBool, required = false,
                                 default = newJBool(false))
  if valid_589530 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_589530
  var valid_589531 = query.getOrDefault("oauth_token")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = nil)
  if valid_589531 != nil:
    section.add "oauth_token", valid_589531
  var valid_589532 = query.getOrDefault("userIp")
  valid_589532 = validateParameter(valid_589532, JString, required = false,
                                 default = nil)
  if valid_589532 != nil:
    section.add "userIp", valid_589532
  var valid_589533 = query.getOrDefault("key")
  valid_589533 = validateParameter(valid_589533, JString, required = false,
                                 default = nil)
  if valid_589533 != nil:
    section.add "key", valid_589533
  var valid_589534 = query.getOrDefault("prettyPrint")
  valid_589534 = validateParameter(valid_589534, JBool, required = false,
                                 default = newJBool(false))
  if valid_589534 != nil:
    section.add "prettyPrint", valid_589534
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589536: Call_AnalyticsManagementCustomDimensionsPatch_589521;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom dimension. This method supports patch semantics.
  ## 
  let valid = call_589536.validator(path, query, header, formData, body)
  let scheme = call_589536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589536.url(scheme.get, call_589536.host, call_589536.base,
                         call_589536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589536, url, valid)

proc call*(call_589537: Call_AnalyticsManagementCustomDimensionsPatch_589521;
          customDimensionId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          ignoreCustomDataSourceLinks: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomDimensionsPatch
  ## Updates an existing custom dimension. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   customDimensionId: string (required)
  ##                    : Custom dimension ID for the custom dimension to update.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: bool
  ##                              : Force the update and ignore any warnings related to the custom dimension being linked to a custom data source / data set.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom dimension to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589538 = newJObject()
  var query_589539 = newJObject()
  var body_589540 = newJObject()
  add(query_589539, "fields", newJString(fields))
  add(path_589538, "customDimensionId", newJString(customDimensionId))
  add(query_589539, "quotaUser", newJString(quotaUser))
  add(query_589539, "alt", newJString(alt))
  add(query_589539, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(query_589539, "oauth_token", newJString(oauthToken))
  add(path_589538, "accountId", newJString(accountId))
  add(query_589539, "userIp", newJString(userIp))
  add(path_589538, "webPropertyId", newJString(webPropertyId))
  add(query_589539, "key", newJString(key))
  if body != nil:
    body_589540 = body
  add(query_589539, "prettyPrint", newJBool(prettyPrint))
  result = call_589537.call(path_589538, query_589539, nil, nil, body_589540)

var analyticsManagementCustomDimensionsPatch* = Call_AnalyticsManagementCustomDimensionsPatch_589521(
    name: "analyticsManagementCustomDimensionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions/{customDimensionId}",
    validator: validate_AnalyticsManagementCustomDimensionsPatch_589522,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsPatch_589523,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsInsert_589559 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementCustomMetricsInsert_589561(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customMetrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomMetricsInsert_589560(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new custom metric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID for the custom metric to create.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom dimension to create.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589562 = path.getOrDefault("accountId")
  valid_589562 = validateParameter(valid_589562, JString, required = true,
                                 default = nil)
  if valid_589562 != nil:
    section.add "accountId", valid_589562
  var valid_589563 = path.getOrDefault("webPropertyId")
  valid_589563 = validateParameter(valid_589563, JString, required = true,
                                 default = nil)
  if valid_589563 != nil:
    section.add "webPropertyId", valid_589563
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589564 = query.getOrDefault("fields")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "fields", valid_589564
  var valid_589565 = query.getOrDefault("quotaUser")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "quotaUser", valid_589565
  var valid_589566 = query.getOrDefault("alt")
  valid_589566 = validateParameter(valid_589566, JString, required = false,
                                 default = newJString("json"))
  if valid_589566 != nil:
    section.add "alt", valid_589566
  var valid_589567 = query.getOrDefault("oauth_token")
  valid_589567 = validateParameter(valid_589567, JString, required = false,
                                 default = nil)
  if valid_589567 != nil:
    section.add "oauth_token", valid_589567
  var valid_589568 = query.getOrDefault("userIp")
  valid_589568 = validateParameter(valid_589568, JString, required = false,
                                 default = nil)
  if valid_589568 != nil:
    section.add "userIp", valid_589568
  var valid_589569 = query.getOrDefault("key")
  valid_589569 = validateParameter(valid_589569, JString, required = false,
                                 default = nil)
  if valid_589569 != nil:
    section.add "key", valid_589569
  var valid_589570 = query.getOrDefault("prettyPrint")
  valid_589570 = validateParameter(valid_589570, JBool, required = false,
                                 default = newJBool(false))
  if valid_589570 != nil:
    section.add "prettyPrint", valid_589570
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589572: Call_AnalyticsManagementCustomMetricsInsert_589559;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new custom metric.
  ## 
  let valid = call_589572.validator(path, query, header, formData, body)
  let scheme = call_589572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589572.url(scheme.get, call_589572.host, call_589572.base,
                         call_589572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589572, url, valid)

proc call*(call_589573: Call_AnalyticsManagementCustomMetricsInsert_589559;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomMetricsInsert
  ## Create a new custom metric.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom metric to create.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom dimension to create.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589574 = newJObject()
  var query_589575 = newJObject()
  var body_589576 = newJObject()
  add(query_589575, "fields", newJString(fields))
  add(query_589575, "quotaUser", newJString(quotaUser))
  add(query_589575, "alt", newJString(alt))
  add(query_589575, "oauth_token", newJString(oauthToken))
  add(path_589574, "accountId", newJString(accountId))
  add(query_589575, "userIp", newJString(userIp))
  add(path_589574, "webPropertyId", newJString(webPropertyId))
  add(query_589575, "key", newJString(key))
  if body != nil:
    body_589576 = body
  add(query_589575, "prettyPrint", newJBool(prettyPrint))
  result = call_589573.call(path_589574, query_589575, nil, nil, body_589576)

var analyticsManagementCustomMetricsInsert* = Call_AnalyticsManagementCustomMetricsInsert_589559(
    name: "analyticsManagementCustomMetricsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics",
    validator: validate_AnalyticsManagementCustomMetricsInsert_589560,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsInsert_589561,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsList_589541 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementCustomMetricsList_589543(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customMetrics")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomMetricsList_589542(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists custom metrics to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID for the custom metrics to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom metrics to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589544 = path.getOrDefault("accountId")
  valid_589544 = validateParameter(valid_589544, JString, required = true,
                                 default = nil)
  if valid_589544 != nil:
    section.add "accountId", valid_589544
  var valid_589545 = path.getOrDefault("webPropertyId")
  valid_589545 = validateParameter(valid_589545, JString, required = true,
                                 default = nil)
  if valid_589545 != nil:
    section.add "webPropertyId", valid_589545
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of custom metrics to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589546 = query.getOrDefault("fields")
  valid_589546 = validateParameter(valid_589546, JString, required = false,
                                 default = nil)
  if valid_589546 != nil:
    section.add "fields", valid_589546
  var valid_589547 = query.getOrDefault("quotaUser")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = nil)
  if valid_589547 != nil:
    section.add "quotaUser", valid_589547
  var valid_589548 = query.getOrDefault("alt")
  valid_589548 = validateParameter(valid_589548, JString, required = false,
                                 default = newJString("json"))
  if valid_589548 != nil:
    section.add "alt", valid_589548
  var valid_589549 = query.getOrDefault("oauth_token")
  valid_589549 = validateParameter(valid_589549, JString, required = false,
                                 default = nil)
  if valid_589549 != nil:
    section.add "oauth_token", valid_589549
  var valid_589550 = query.getOrDefault("userIp")
  valid_589550 = validateParameter(valid_589550, JString, required = false,
                                 default = nil)
  if valid_589550 != nil:
    section.add "userIp", valid_589550
  var valid_589551 = query.getOrDefault("key")
  valid_589551 = validateParameter(valid_589551, JString, required = false,
                                 default = nil)
  if valid_589551 != nil:
    section.add "key", valid_589551
  var valid_589552 = query.getOrDefault("max-results")
  valid_589552 = validateParameter(valid_589552, JInt, required = false, default = nil)
  if valid_589552 != nil:
    section.add "max-results", valid_589552
  var valid_589553 = query.getOrDefault("start-index")
  valid_589553 = validateParameter(valid_589553, JInt, required = false, default = nil)
  if valid_589553 != nil:
    section.add "start-index", valid_589553
  var valid_589554 = query.getOrDefault("prettyPrint")
  valid_589554 = validateParameter(valid_589554, JBool, required = false,
                                 default = newJBool(false))
  if valid_589554 != nil:
    section.add "prettyPrint", valid_589554
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589555: Call_AnalyticsManagementCustomMetricsList_589541;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists custom metrics to which the user has access.
  ## 
  let valid = call_589555.validator(path, query, header, formData, body)
  let scheme = call_589555.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589555.url(scheme.get, call_589555.host, call_589555.base,
                         call_589555.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589555, url, valid)

proc call*(call_589556: Call_AnalyticsManagementCustomMetricsList_589541;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomMetricsList
  ## Lists custom metrics to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom metrics to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom metrics to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of custom metrics to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589557 = newJObject()
  var query_589558 = newJObject()
  add(query_589558, "fields", newJString(fields))
  add(query_589558, "quotaUser", newJString(quotaUser))
  add(query_589558, "alt", newJString(alt))
  add(query_589558, "oauth_token", newJString(oauthToken))
  add(path_589557, "accountId", newJString(accountId))
  add(query_589558, "userIp", newJString(userIp))
  add(path_589557, "webPropertyId", newJString(webPropertyId))
  add(query_589558, "key", newJString(key))
  add(query_589558, "max-results", newJInt(maxResults))
  add(query_589558, "start-index", newJInt(startIndex))
  add(query_589558, "prettyPrint", newJBool(prettyPrint))
  result = call_589556.call(path_589557, query_589558, nil, nil, nil)

var analyticsManagementCustomMetricsList* = Call_AnalyticsManagementCustomMetricsList_589541(
    name: "analyticsManagementCustomMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics",
    validator: validate_AnalyticsManagementCustomMetricsList_589542,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsList_589543,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsUpdate_589594 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementCustomMetricsUpdate_589596(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customMetricId" in path, "`customMetricId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customMetrics/"),
               (kind: VariableSegment, value: "customMetricId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomMetricsUpdate_589595(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing custom metric.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customMetricId: JString (required)
  ##                 : Custom metric ID for the custom metric to update.
  ##   accountId: JString (required)
  ##            : Account ID for the custom metric to update.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom metric to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customMetricId` field"
  var valid_589597 = path.getOrDefault("customMetricId")
  valid_589597 = validateParameter(valid_589597, JString, required = true,
                                 default = nil)
  if valid_589597 != nil:
    section.add "customMetricId", valid_589597
  var valid_589598 = path.getOrDefault("accountId")
  valid_589598 = validateParameter(valid_589598, JString, required = true,
                                 default = nil)
  if valid_589598 != nil:
    section.add "accountId", valid_589598
  var valid_589599 = path.getOrDefault("webPropertyId")
  valid_589599 = validateParameter(valid_589599, JString, required = true,
                                 default = nil)
  if valid_589599 != nil:
    section.add "webPropertyId", valid_589599
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: JBool
  ##                              : Force the update and ignore any warnings related to the custom metric being linked to a custom data source / data set.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589600 = query.getOrDefault("fields")
  valid_589600 = validateParameter(valid_589600, JString, required = false,
                                 default = nil)
  if valid_589600 != nil:
    section.add "fields", valid_589600
  var valid_589601 = query.getOrDefault("quotaUser")
  valid_589601 = validateParameter(valid_589601, JString, required = false,
                                 default = nil)
  if valid_589601 != nil:
    section.add "quotaUser", valid_589601
  var valid_589602 = query.getOrDefault("alt")
  valid_589602 = validateParameter(valid_589602, JString, required = false,
                                 default = newJString("json"))
  if valid_589602 != nil:
    section.add "alt", valid_589602
  var valid_589603 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_589603 = validateParameter(valid_589603, JBool, required = false,
                                 default = newJBool(false))
  if valid_589603 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_589603
  var valid_589604 = query.getOrDefault("oauth_token")
  valid_589604 = validateParameter(valid_589604, JString, required = false,
                                 default = nil)
  if valid_589604 != nil:
    section.add "oauth_token", valid_589604
  var valid_589605 = query.getOrDefault("userIp")
  valid_589605 = validateParameter(valid_589605, JString, required = false,
                                 default = nil)
  if valid_589605 != nil:
    section.add "userIp", valid_589605
  var valid_589606 = query.getOrDefault("key")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "key", valid_589606
  var valid_589607 = query.getOrDefault("prettyPrint")
  valid_589607 = validateParameter(valid_589607, JBool, required = false,
                                 default = newJBool(false))
  if valid_589607 != nil:
    section.add "prettyPrint", valid_589607
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589609: Call_AnalyticsManagementCustomMetricsUpdate_589594;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom metric.
  ## 
  let valid = call_589609.validator(path, query, header, formData, body)
  let scheme = call_589609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589609.url(scheme.get, call_589609.host, call_589609.base,
                         call_589609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589609, url, valid)

proc call*(call_589610: Call_AnalyticsManagementCustomMetricsUpdate_589594;
          customMetricId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          ignoreCustomDataSourceLinks: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomMetricsUpdate
  ## Updates an existing custom metric.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: bool
  ##                              : Force the update and ignore any warnings related to the custom metric being linked to a custom data source / data set.
  ##   customMetricId: string (required)
  ##                 : Custom metric ID for the custom metric to update.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom metric to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom metric to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589611 = newJObject()
  var query_589612 = newJObject()
  var body_589613 = newJObject()
  add(query_589612, "fields", newJString(fields))
  add(query_589612, "quotaUser", newJString(quotaUser))
  add(query_589612, "alt", newJString(alt))
  add(query_589612, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(path_589611, "customMetricId", newJString(customMetricId))
  add(query_589612, "oauth_token", newJString(oauthToken))
  add(path_589611, "accountId", newJString(accountId))
  add(query_589612, "userIp", newJString(userIp))
  add(path_589611, "webPropertyId", newJString(webPropertyId))
  add(query_589612, "key", newJString(key))
  if body != nil:
    body_589613 = body
  add(query_589612, "prettyPrint", newJBool(prettyPrint))
  result = call_589610.call(path_589611, query_589612, nil, nil, body_589613)

var analyticsManagementCustomMetricsUpdate* = Call_AnalyticsManagementCustomMetricsUpdate_589594(
    name: "analyticsManagementCustomMetricsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics/{customMetricId}",
    validator: validate_AnalyticsManagementCustomMetricsUpdate_589595,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsUpdate_589596,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsGet_589577 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementCustomMetricsGet_589579(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customMetricId" in path, "`customMetricId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customMetrics/"),
               (kind: VariableSegment, value: "customMetricId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomMetricsGet_589578(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get a custom metric to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customMetricId: JString (required)
  ##                 : The ID of the custom metric to retrieve.
  ##   accountId: JString (required)
  ##            : Account ID for the custom metric to retrieve.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom metric to retrieve.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customMetricId` field"
  var valid_589580 = path.getOrDefault("customMetricId")
  valid_589580 = validateParameter(valid_589580, JString, required = true,
                                 default = nil)
  if valid_589580 != nil:
    section.add "customMetricId", valid_589580
  var valid_589581 = path.getOrDefault("accountId")
  valid_589581 = validateParameter(valid_589581, JString, required = true,
                                 default = nil)
  if valid_589581 != nil:
    section.add "accountId", valid_589581
  var valid_589582 = path.getOrDefault("webPropertyId")
  valid_589582 = validateParameter(valid_589582, JString, required = true,
                                 default = nil)
  if valid_589582 != nil:
    section.add "webPropertyId", valid_589582
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589583 = query.getOrDefault("fields")
  valid_589583 = validateParameter(valid_589583, JString, required = false,
                                 default = nil)
  if valid_589583 != nil:
    section.add "fields", valid_589583
  var valid_589584 = query.getOrDefault("quotaUser")
  valid_589584 = validateParameter(valid_589584, JString, required = false,
                                 default = nil)
  if valid_589584 != nil:
    section.add "quotaUser", valid_589584
  var valid_589585 = query.getOrDefault("alt")
  valid_589585 = validateParameter(valid_589585, JString, required = false,
                                 default = newJString("json"))
  if valid_589585 != nil:
    section.add "alt", valid_589585
  var valid_589586 = query.getOrDefault("oauth_token")
  valid_589586 = validateParameter(valid_589586, JString, required = false,
                                 default = nil)
  if valid_589586 != nil:
    section.add "oauth_token", valid_589586
  var valid_589587 = query.getOrDefault("userIp")
  valid_589587 = validateParameter(valid_589587, JString, required = false,
                                 default = nil)
  if valid_589587 != nil:
    section.add "userIp", valid_589587
  var valid_589588 = query.getOrDefault("key")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = nil)
  if valid_589588 != nil:
    section.add "key", valid_589588
  var valid_589589 = query.getOrDefault("prettyPrint")
  valid_589589 = validateParameter(valid_589589, JBool, required = false,
                                 default = newJBool(false))
  if valid_589589 != nil:
    section.add "prettyPrint", valid_589589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589590: Call_AnalyticsManagementCustomMetricsGet_589577;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a custom metric to which the user has access.
  ## 
  let valid = call_589590.validator(path, query, header, formData, body)
  let scheme = call_589590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589590.url(scheme.get, call_589590.host, call_589590.base,
                         call_589590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589590, url, valid)

proc call*(call_589591: Call_AnalyticsManagementCustomMetricsGet_589577;
          customMetricId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomMetricsGet
  ## Get a custom metric to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   customMetricId: string (required)
  ##                 : The ID of the custom metric to retrieve.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom metric to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom metric to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589592 = newJObject()
  var query_589593 = newJObject()
  add(query_589593, "fields", newJString(fields))
  add(query_589593, "quotaUser", newJString(quotaUser))
  add(query_589593, "alt", newJString(alt))
  add(path_589592, "customMetricId", newJString(customMetricId))
  add(query_589593, "oauth_token", newJString(oauthToken))
  add(path_589592, "accountId", newJString(accountId))
  add(query_589593, "userIp", newJString(userIp))
  add(path_589592, "webPropertyId", newJString(webPropertyId))
  add(query_589593, "key", newJString(key))
  add(query_589593, "prettyPrint", newJBool(prettyPrint))
  result = call_589591.call(path_589592, query_589593, nil, nil, nil)

var analyticsManagementCustomMetricsGet* = Call_AnalyticsManagementCustomMetricsGet_589577(
    name: "analyticsManagementCustomMetricsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics/{customMetricId}",
    validator: validate_AnalyticsManagementCustomMetricsGet_589578,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsGet_589579,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsPatch_589614 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementCustomMetricsPatch_589616(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "customMetricId" in path, "`customMetricId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/customMetrics/"),
               (kind: VariableSegment, value: "customMetricId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementCustomMetricsPatch_589615(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing custom metric. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customMetricId: JString (required)
  ##                 : Custom metric ID for the custom metric to update.
  ##   accountId: JString (required)
  ##            : Account ID for the custom metric to update.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the custom metric to update.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customMetricId` field"
  var valid_589617 = path.getOrDefault("customMetricId")
  valid_589617 = validateParameter(valid_589617, JString, required = true,
                                 default = nil)
  if valid_589617 != nil:
    section.add "customMetricId", valid_589617
  var valid_589618 = path.getOrDefault("accountId")
  valid_589618 = validateParameter(valid_589618, JString, required = true,
                                 default = nil)
  if valid_589618 != nil:
    section.add "accountId", valid_589618
  var valid_589619 = path.getOrDefault("webPropertyId")
  valid_589619 = validateParameter(valid_589619, JString, required = true,
                                 default = nil)
  if valid_589619 != nil:
    section.add "webPropertyId", valid_589619
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: JBool
  ##                              : Force the update and ignore any warnings related to the custom metric being linked to a custom data source / data set.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589620 = query.getOrDefault("fields")
  valid_589620 = validateParameter(valid_589620, JString, required = false,
                                 default = nil)
  if valid_589620 != nil:
    section.add "fields", valid_589620
  var valid_589621 = query.getOrDefault("quotaUser")
  valid_589621 = validateParameter(valid_589621, JString, required = false,
                                 default = nil)
  if valid_589621 != nil:
    section.add "quotaUser", valid_589621
  var valid_589622 = query.getOrDefault("alt")
  valid_589622 = validateParameter(valid_589622, JString, required = false,
                                 default = newJString("json"))
  if valid_589622 != nil:
    section.add "alt", valid_589622
  var valid_589623 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_589623 = validateParameter(valid_589623, JBool, required = false,
                                 default = newJBool(false))
  if valid_589623 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_589623
  var valid_589624 = query.getOrDefault("oauth_token")
  valid_589624 = validateParameter(valid_589624, JString, required = false,
                                 default = nil)
  if valid_589624 != nil:
    section.add "oauth_token", valid_589624
  var valid_589625 = query.getOrDefault("userIp")
  valid_589625 = validateParameter(valid_589625, JString, required = false,
                                 default = nil)
  if valid_589625 != nil:
    section.add "userIp", valid_589625
  var valid_589626 = query.getOrDefault("key")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "key", valid_589626
  var valid_589627 = query.getOrDefault("prettyPrint")
  valid_589627 = validateParameter(valid_589627, JBool, required = false,
                                 default = newJBool(false))
  if valid_589627 != nil:
    section.add "prettyPrint", valid_589627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589629: Call_AnalyticsManagementCustomMetricsPatch_589614;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom metric. This method supports patch semantics.
  ## 
  let valid = call_589629.validator(path, query, header, formData, body)
  let scheme = call_589629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589629.url(scheme.get, call_589629.host, call_589629.base,
                         call_589629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589629, url, valid)

proc call*(call_589630: Call_AnalyticsManagementCustomMetricsPatch_589614;
          customMetricId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          ignoreCustomDataSourceLinks: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementCustomMetricsPatch
  ## Updates an existing custom metric. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ignoreCustomDataSourceLinks: bool
  ##                              : Force the update and ignore any warnings related to the custom metric being linked to a custom data source / data set.
  ##   customMetricId: string (required)
  ##                 : Custom metric ID for the custom metric to update.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the custom metric to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the custom metric to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589631 = newJObject()
  var query_589632 = newJObject()
  var body_589633 = newJObject()
  add(query_589632, "fields", newJString(fields))
  add(query_589632, "quotaUser", newJString(quotaUser))
  add(query_589632, "alt", newJString(alt))
  add(query_589632, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(path_589631, "customMetricId", newJString(customMetricId))
  add(query_589632, "oauth_token", newJString(oauthToken))
  add(path_589631, "accountId", newJString(accountId))
  add(query_589632, "userIp", newJString(userIp))
  add(path_589631, "webPropertyId", newJString(webPropertyId))
  add(query_589632, "key", newJString(key))
  if body != nil:
    body_589633 = body
  add(query_589632, "prettyPrint", newJBool(prettyPrint))
  result = call_589630.call(path_589631, query_589632, nil, nil, body_589633)

var analyticsManagementCustomMetricsPatch* = Call_AnalyticsManagementCustomMetricsPatch_589614(
    name: "analyticsManagementCustomMetricsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics/{customMetricId}",
    validator: validate_AnalyticsManagementCustomMetricsPatch_589615,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsPatch_589616,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_589652 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebPropertyAdWordsLinksInsert_589654(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityAdWordsLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksInsert_589653(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a webProperty-Google Ads link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : ID of the Google Analytics account to create the link for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589655 = path.getOrDefault("accountId")
  valid_589655 = validateParameter(valid_589655, JString, required = true,
                                 default = nil)
  if valid_589655 != nil:
    section.add "accountId", valid_589655
  var valid_589656 = path.getOrDefault("webPropertyId")
  valid_589656 = validateParameter(valid_589656, JString, required = true,
                                 default = nil)
  if valid_589656 != nil:
    section.add "webPropertyId", valid_589656
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589657 = query.getOrDefault("fields")
  valid_589657 = validateParameter(valid_589657, JString, required = false,
                                 default = nil)
  if valid_589657 != nil:
    section.add "fields", valid_589657
  var valid_589658 = query.getOrDefault("quotaUser")
  valid_589658 = validateParameter(valid_589658, JString, required = false,
                                 default = nil)
  if valid_589658 != nil:
    section.add "quotaUser", valid_589658
  var valid_589659 = query.getOrDefault("alt")
  valid_589659 = validateParameter(valid_589659, JString, required = false,
                                 default = newJString("json"))
  if valid_589659 != nil:
    section.add "alt", valid_589659
  var valid_589660 = query.getOrDefault("oauth_token")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = nil)
  if valid_589660 != nil:
    section.add "oauth_token", valid_589660
  var valid_589661 = query.getOrDefault("userIp")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = nil)
  if valid_589661 != nil:
    section.add "userIp", valid_589661
  var valid_589662 = query.getOrDefault("key")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "key", valid_589662
  var valid_589663 = query.getOrDefault("prettyPrint")
  valid_589663 = validateParameter(valid_589663, JBool, required = false,
                                 default = newJBool(false))
  if valid_589663 != nil:
    section.add "prettyPrint", valid_589663
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589665: Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_589652;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a webProperty-Google Ads link.
  ## 
  let valid = call_589665.validator(path, query, header, formData, body)
  let scheme = call_589665.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589665.url(scheme.get, call_589665.host, call_589665.base,
                         call_589665.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589665, url, valid)

proc call*(call_589666: Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_589652;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksInsert
  ## Creates a webProperty-Google Ads link.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : ID of the Google Analytics account to create the link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589667 = newJObject()
  var query_589668 = newJObject()
  var body_589669 = newJObject()
  add(query_589668, "fields", newJString(fields))
  add(query_589668, "quotaUser", newJString(quotaUser))
  add(query_589668, "alt", newJString(alt))
  add(query_589668, "oauth_token", newJString(oauthToken))
  add(path_589667, "accountId", newJString(accountId))
  add(query_589668, "userIp", newJString(userIp))
  add(path_589667, "webPropertyId", newJString(webPropertyId))
  add(query_589668, "key", newJString(key))
  if body != nil:
    body_589669 = body
  add(query_589668, "prettyPrint", newJBool(prettyPrint))
  result = call_589666.call(path_589667, query_589668, nil, nil, body_589669)

var analyticsManagementWebPropertyAdWordsLinksInsert* = Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_589652(
    name: "analyticsManagementWebPropertyAdWordsLinksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksInsert_589653,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksInsert_589654,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksList_589634 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebPropertyAdWordsLinksList_589636(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityAdWordsLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksList_589635(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists webProperty-Google Ads links for a given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the Google Ads links for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589637 = path.getOrDefault("accountId")
  valid_589637 = validateParameter(valid_589637, JString, required = true,
                                 default = nil)
  if valid_589637 != nil:
    section.add "accountId", valid_589637
  var valid_589638 = path.getOrDefault("webPropertyId")
  valid_589638 = validateParameter(valid_589638, JString, required = true,
                                 default = nil)
  if valid_589638 != nil:
    section.add "webPropertyId", valid_589638
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of webProperty-Google Ads links to include in this response.
  ##   start-index: JInt
  ##              : An index of the first webProperty-Google Ads link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589639 = query.getOrDefault("fields")
  valid_589639 = validateParameter(valid_589639, JString, required = false,
                                 default = nil)
  if valid_589639 != nil:
    section.add "fields", valid_589639
  var valid_589640 = query.getOrDefault("quotaUser")
  valid_589640 = validateParameter(valid_589640, JString, required = false,
                                 default = nil)
  if valid_589640 != nil:
    section.add "quotaUser", valid_589640
  var valid_589641 = query.getOrDefault("alt")
  valid_589641 = validateParameter(valid_589641, JString, required = false,
                                 default = newJString("json"))
  if valid_589641 != nil:
    section.add "alt", valid_589641
  var valid_589642 = query.getOrDefault("oauth_token")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = nil)
  if valid_589642 != nil:
    section.add "oauth_token", valid_589642
  var valid_589643 = query.getOrDefault("userIp")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "userIp", valid_589643
  var valid_589644 = query.getOrDefault("key")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "key", valid_589644
  var valid_589645 = query.getOrDefault("max-results")
  valid_589645 = validateParameter(valid_589645, JInt, required = false, default = nil)
  if valid_589645 != nil:
    section.add "max-results", valid_589645
  var valid_589646 = query.getOrDefault("start-index")
  valid_589646 = validateParameter(valid_589646, JInt, required = false, default = nil)
  if valid_589646 != nil:
    section.add "start-index", valid_589646
  var valid_589647 = query.getOrDefault("prettyPrint")
  valid_589647 = validateParameter(valid_589647, JBool, required = false,
                                 default = newJBool(false))
  if valid_589647 != nil:
    section.add "prettyPrint", valid_589647
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589648: Call_AnalyticsManagementWebPropertyAdWordsLinksList_589634;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists webProperty-Google Ads links for a given web property.
  ## 
  let valid = call_589648.validator(path, query, header, formData, body)
  let scheme = call_589648.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589648.url(scheme.get, call_589648.host, call_589648.base,
                         call_589648.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589648, url, valid)

proc call*(call_589649: Call_AnalyticsManagementWebPropertyAdWordsLinksList_589634;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksList
  ## Lists webProperty-Google Ads links for a given web property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the Google Ads links for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of webProperty-Google Ads links to include in this response.
  ##   startIndex: int
  ##             : An index of the first webProperty-Google Ads link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589650 = newJObject()
  var query_589651 = newJObject()
  add(query_589651, "fields", newJString(fields))
  add(query_589651, "quotaUser", newJString(quotaUser))
  add(query_589651, "alt", newJString(alt))
  add(query_589651, "oauth_token", newJString(oauthToken))
  add(path_589650, "accountId", newJString(accountId))
  add(query_589651, "userIp", newJString(userIp))
  add(path_589650, "webPropertyId", newJString(webPropertyId))
  add(query_589651, "key", newJString(key))
  add(query_589651, "max-results", newJInt(maxResults))
  add(query_589651, "start-index", newJInt(startIndex))
  add(query_589651, "prettyPrint", newJBool(prettyPrint))
  result = call_589649.call(path_589650, query_589651, nil, nil, nil)

var analyticsManagementWebPropertyAdWordsLinksList* = Call_AnalyticsManagementWebPropertyAdWordsLinksList_589634(
    name: "analyticsManagementWebPropertyAdWordsLinksList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksList_589635,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksList_589636,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_589687 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebPropertyAdWordsLinksUpdate_589689(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "webPropertyAdWordsLinkId" in path,
        "`webPropertyAdWordsLinkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityAdWordsLinks/"),
               (kind: VariableSegment, value: "webPropertyAdWordsLinkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksUpdate_589688(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing webProperty-Google Ads link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyAdWordsLinkId: JString (required)
  ##                           : Web property-Google Ads link ID.
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `webPropertyAdWordsLinkId` field"
  var valid_589690 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_589690 = validateParameter(valid_589690, JString, required = true,
                                 default = nil)
  if valid_589690 != nil:
    section.add "webPropertyAdWordsLinkId", valid_589690
  var valid_589691 = path.getOrDefault("accountId")
  valid_589691 = validateParameter(valid_589691, JString, required = true,
                                 default = nil)
  if valid_589691 != nil:
    section.add "accountId", valid_589691
  var valid_589692 = path.getOrDefault("webPropertyId")
  valid_589692 = validateParameter(valid_589692, JString, required = true,
                                 default = nil)
  if valid_589692 != nil:
    section.add "webPropertyId", valid_589692
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589693 = query.getOrDefault("fields")
  valid_589693 = validateParameter(valid_589693, JString, required = false,
                                 default = nil)
  if valid_589693 != nil:
    section.add "fields", valid_589693
  var valid_589694 = query.getOrDefault("quotaUser")
  valid_589694 = validateParameter(valid_589694, JString, required = false,
                                 default = nil)
  if valid_589694 != nil:
    section.add "quotaUser", valid_589694
  var valid_589695 = query.getOrDefault("alt")
  valid_589695 = validateParameter(valid_589695, JString, required = false,
                                 default = newJString("json"))
  if valid_589695 != nil:
    section.add "alt", valid_589695
  var valid_589696 = query.getOrDefault("oauth_token")
  valid_589696 = validateParameter(valid_589696, JString, required = false,
                                 default = nil)
  if valid_589696 != nil:
    section.add "oauth_token", valid_589696
  var valid_589697 = query.getOrDefault("userIp")
  valid_589697 = validateParameter(valid_589697, JString, required = false,
                                 default = nil)
  if valid_589697 != nil:
    section.add "userIp", valid_589697
  var valid_589698 = query.getOrDefault("key")
  valid_589698 = validateParameter(valid_589698, JString, required = false,
                                 default = nil)
  if valid_589698 != nil:
    section.add "key", valid_589698
  var valid_589699 = query.getOrDefault("prettyPrint")
  valid_589699 = validateParameter(valid_589699, JBool, required = false,
                                 default = newJBool(false))
  if valid_589699 != nil:
    section.add "prettyPrint", valid_589699
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589701: Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_589687;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing webProperty-Google Ads link.
  ## 
  let valid = call_589701.validator(path, query, header, formData, body)
  let scheme = call_589701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589701.url(scheme.get, call_589701.host, call_589701.base,
                         call_589701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589701, url, valid)

proc call*(call_589702: Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_589687;
          webPropertyAdWordsLinkId: string; accountId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksUpdate
  ## Updates an existing webProperty-Google Ads link.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   webPropertyAdWordsLinkId: string (required)
  ##                           : Web property-Google Ads link ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589703 = newJObject()
  var query_589704 = newJObject()
  var body_589705 = newJObject()
  add(query_589704, "fields", newJString(fields))
  add(query_589704, "quotaUser", newJString(quotaUser))
  add(query_589704, "alt", newJString(alt))
  add(path_589703, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(query_589704, "oauth_token", newJString(oauthToken))
  add(path_589703, "accountId", newJString(accountId))
  add(query_589704, "userIp", newJString(userIp))
  add(path_589703, "webPropertyId", newJString(webPropertyId))
  add(query_589704, "key", newJString(key))
  if body != nil:
    body_589705 = body
  add(query_589704, "prettyPrint", newJBool(prettyPrint))
  result = call_589702.call(path_589703, query_589704, nil, nil, body_589705)

var analyticsManagementWebPropertyAdWordsLinksUpdate* = Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_589687(
    name: "analyticsManagementWebPropertyAdWordsLinksUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksUpdate_589688,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksUpdate_589689,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksGet_589670 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebPropertyAdWordsLinksGet_589672(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "webPropertyAdWordsLinkId" in path,
        "`webPropertyAdWordsLinkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityAdWordsLinks/"),
               (kind: VariableSegment, value: "webPropertyAdWordsLinkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksGet_589671(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a web property-Google Ads link to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyAdWordsLinkId: JString (required)
  ##                           : Web property-Google Ads link ID.
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `webPropertyAdWordsLinkId` field"
  var valid_589673 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_589673 = validateParameter(valid_589673, JString, required = true,
                                 default = nil)
  if valid_589673 != nil:
    section.add "webPropertyAdWordsLinkId", valid_589673
  var valid_589674 = path.getOrDefault("accountId")
  valid_589674 = validateParameter(valid_589674, JString, required = true,
                                 default = nil)
  if valid_589674 != nil:
    section.add "accountId", valid_589674
  var valid_589675 = path.getOrDefault("webPropertyId")
  valid_589675 = validateParameter(valid_589675, JString, required = true,
                                 default = nil)
  if valid_589675 != nil:
    section.add "webPropertyId", valid_589675
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589676 = query.getOrDefault("fields")
  valid_589676 = validateParameter(valid_589676, JString, required = false,
                                 default = nil)
  if valid_589676 != nil:
    section.add "fields", valid_589676
  var valid_589677 = query.getOrDefault("quotaUser")
  valid_589677 = validateParameter(valid_589677, JString, required = false,
                                 default = nil)
  if valid_589677 != nil:
    section.add "quotaUser", valid_589677
  var valid_589678 = query.getOrDefault("alt")
  valid_589678 = validateParameter(valid_589678, JString, required = false,
                                 default = newJString("json"))
  if valid_589678 != nil:
    section.add "alt", valid_589678
  var valid_589679 = query.getOrDefault("oauth_token")
  valid_589679 = validateParameter(valid_589679, JString, required = false,
                                 default = nil)
  if valid_589679 != nil:
    section.add "oauth_token", valid_589679
  var valid_589680 = query.getOrDefault("userIp")
  valid_589680 = validateParameter(valid_589680, JString, required = false,
                                 default = nil)
  if valid_589680 != nil:
    section.add "userIp", valid_589680
  var valid_589681 = query.getOrDefault("key")
  valid_589681 = validateParameter(valid_589681, JString, required = false,
                                 default = nil)
  if valid_589681 != nil:
    section.add "key", valid_589681
  var valid_589682 = query.getOrDefault("prettyPrint")
  valid_589682 = validateParameter(valid_589682, JBool, required = false,
                                 default = newJBool(false))
  if valid_589682 != nil:
    section.add "prettyPrint", valid_589682
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589683: Call_AnalyticsManagementWebPropertyAdWordsLinksGet_589670;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a web property-Google Ads link to which the user has access.
  ## 
  let valid = call_589683.validator(path, query, header, formData, body)
  let scheme = call_589683.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589683.url(scheme.get, call_589683.host, call_589683.base,
                         call_589683.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589683, url, valid)

proc call*(call_589684: Call_AnalyticsManagementWebPropertyAdWordsLinksGet_589670;
          webPropertyAdWordsLinkId: string; accountId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksGet
  ## Returns a web property-Google Ads link to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   webPropertyAdWordsLinkId: string (required)
  ##                           : Web property-Google Ads link ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589685 = newJObject()
  var query_589686 = newJObject()
  add(query_589686, "fields", newJString(fields))
  add(query_589686, "quotaUser", newJString(quotaUser))
  add(query_589686, "alt", newJString(alt))
  add(path_589685, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(query_589686, "oauth_token", newJString(oauthToken))
  add(path_589685, "accountId", newJString(accountId))
  add(query_589686, "userIp", newJString(userIp))
  add(path_589685, "webPropertyId", newJString(webPropertyId))
  add(query_589686, "key", newJString(key))
  add(query_589686, "prettyPrint", newJBool(prettyPrint))
  result = call_589684.call(path_589685, query_589686, nil, nil, nil)

var analyticsManagementWebPropertyAdWordsLinksGet* = Call_AnalyticsManagementWebPropertyAdWordsLinksGet_589670(
    name: "analyticsManagementWebPropertyAdWordsLinksGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksGet_589671,
    base: "/analytics/v3", url: url_AnalyticsManagementWebPropertyAdWordsLinksGet_589672,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_589723 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebPropertyAdWordsLinksPatch_589725(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "webPropertyAdWordsLinkId" in path,
        "`webPropertyAdWordsLinkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityAdWordsLinks/"),
               (kind: VariableSegment, value: "webPropertyAdWordsLinkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksPatch_589724(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an existing webProperty-Google Ads link. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyAdWordsLinkId: JString (required)
  ##                           : Web property-Google Ads link ID.
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `webPropertyAdWordsLinkId` field"
  var valid_589726 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_589726 = validateParameter(valid_589726, JString, required = true,
                                 default = nil)
  if valid_589726 != nil:
    section.add "webPropertyAdWordsLinkId", valid_589726
  var valid_589727 = path.getOrDefault("accountId")
  valid_589727 = validateParameter(valid_589727, JString, required = true,
                                 default = nil)
  if valid_589727 != nil:
    section.add "accountId", valid_589727
  var valid_589728 = path.getOrDefault("webPropertyId")
  valid_589728 = validateParameter(valid_589728, JString, required = true,
                                 default = nil)
  if valid_589728 != nil:
    section.add "webPropertyId", valid_589728
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589729 = query.getOrDefault("fields")
  valid_589729 = validateParameter(valid_589729, JString, required = false,
                                 default = nil)
  if valid_589729 != nil:
    section.add "fields", valid_589729
  var valid_589730 = query.getOrDefault("quotaUser")
  valid_589730 = validateParameter(valid_589730, JString, required = false,
                                 default = nil)
  if valid_589730 != nil:
    section.add "quotaUser", valid_589730
  var valid_589731 = query.getOrDefault("alt")
  valid_589731 = validateParameter(valid_589731, JString, required = false,
                                 default = newJString("json"))
  if valid_589731 != nil:
    section.add "alt", valid_589731
  var valid_589732 = query.getOrDefault("oauth_token")
  valid_589732 = validateParameter(valid_589732, JString, required = false,
                                 default = nil)
  if valid_589732 != nil:
    section.add "oauth_token", valid_589732
  var valid_589733 = query.getOrDefault("userIp")
  valid_589733 = validateParameter(valid_589733, JString, required = false,
                                 default = nil)
  if valid_589733 != nil:
    section.add "userIp", valid_589733
  var valid_589734 = query.getOrDefault("key")
  valid_589734 = validateParameter(valid_589734, JString, required = false,
                                 default = nil)
  if valid_589734 != nil:
    section.add "key", valid_589734
  var valid_589735 = query.getOrDefault("prettyPrint")
  valid_589735 = validateParameter(valid_589735, JBool, required = false,
                                 default = newJBool(false))
  if valid_589735 != nil:
    section.add "prettyPrint", valid_589735
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589737: Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_589723;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing webProperty-Google Ads link. This method supports patch semantics.
  ## 
  let valid = call_589737.validator(path, query, header, formData, body)
  let scheme = call_589737.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589737.url(scheme.get, call_589737.host, call_589737.base,
                         call_589737.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589737, url, valid)

proc call*(call_589738: Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_589723;
          webPropertyAdWordsLinkId: string; accountId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksPatch
  ## Updates an existing webProperty-Google Ads link. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   webPropertyAdWordsLinkId: string (required)
  ##                           : Web property-Google Ads link ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the Google Ads link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589739 = newJObject()
  var query_589740 = newJObject()
  var body_589741 = newJObject()
  add(query_589740, "fields", newJString(fields))
  add(query_589740, "quotaUser", newJString(quotaUser))
  add(query_589740, "alt", newJString(alt))
  add(path_589739, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(query_589740, "oauth_token", newJString(oauthToken))
  add(path_589739, "accountId", newJString(accountId))
  add(query_589740, "userIp", newJString(userIp))
  add(path_589739, "webPropertyId", newJString(webPropertyId))
  add(query_589740, "key", newJString(key))
  if body != nil:
    body_589741 = body
  add(query_589740, "prettyPrint", newJBool(prettyPrint))
  result = call_589738.call(path_589739, query_589740, nil, nil, body_589741)

var analyticsManagementWebPropertyAdWordsLinksPatch* = Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_589723(
    name: "analyticsManagementWebPropertyAdWordsLinksPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksPatch_589724,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksPatch_589725,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_589706 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebPropertyAdWordsLinksDelete_589708(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "webPropertyAdWordsLinkId" in path,
        "`webPropertyAdWordsLinkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityAdWordsLinks/"),
               (kind: VariableSegment, value: "webPropertyAdWordsLinkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebPropertyAdWordsLinksDelete_589707(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Deletes a web property-Google Ads link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webPropertyAdWordsLinkId: JString (required)
  ##                           : Web property Google Ads link ID.
  ##   accountId: JString (required)
  ##            : ID of the account which the given web property belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to delete the Google Ads link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `webPropertyAdWordsLinkId` field"
  var valid_589709 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_589709 = validateParameter(valid_589709, JString, required = true,
                                 default = nil)
  if valid_589709 != nil:
    section.add "webPropertyAdWordsLinkId", valid_589709
  var valid_589710 = path.getOrDefault("accountId")
  valid_589710 = validateParameter(valid_589710, JString, required = true,
                                 default = nil)
  if valid_589710 != nil:
    section.add "accountId", valid_589710
  var valid_589711 = path.getOrDefault("webPropertyId")
  valid_589711 = validateParameter(valid_589711, JString, required = true,
                                 default = nil)
  if valid_589711 != nil:
    section.add "webPropertyId", valid_589711
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589712 = query.getOrDefault("fields")
  valid_589712 = validateParameter(valid_589712, JString, required = false,
                                 default = nil)
  if valid_589712 != nil:
    section.add "fields", valid_589712
  var valid_589713 = query.getOrDefault("quotaUser")
  valid_589713 = validateParameter(valid_589713, JString, required = false,
                                 default = nil)
  if valid_589713 != nil:
    section.add "quotaUser", valid_589713
  var valid_589714 = query.getOrDefault("alt")
  valid_589714 = validateParameter(valid_589714, JString, required = false,
                                 default = newJString("json"))
  if valid_589714 != nil:
    section.add "alt", valid_589714
  var valid_589715 = query.getOrDefault("oauth_token")
  valid_589715 = validateParameter(valid_589715, JString, required = false,
                                 default = nil)
  if valid_589715 != nil:
    section.add "oauth_token", valid_589715
  var valid_589716 = query.getOrDefault("userIp")
  valid_589716 = validateParameter(valid_589716, JString, required = false,
                                 default = nil)
  if valid_589716 != nil:
    section.add "userIp", valid_589716
  var valid_589717 = query.getOrDefault("key")
  valid_589717 = validateParameter(valid_589717, JString, required = false,
                                 default = nil)
  if valid_589717 != nil:
    section.add "key", valid_589717
  var valid_589718 = query.getOrDefault("prettyPrint")
  valid_589718 = validateParameter(valid_589718, JBool, required = false,
                                 default = newJBool(false))
  if valid_589718 != nil:
    section.add "prettyPrint", valid_589718
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589719: Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_589706;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a web property-Google Ads link.
  ## 
  let valid = call_589719.validator(path, query, header, formData, body)
  let scheme = call_589719.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589719.url(scheme.get, call_589719.host, call_589719.base,
                         call_589719.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589719, url, valid)

proc call*(call_589720: Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_589706;
          webPropertyAdWordsLinkId: string; accountId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebPropertyAdWordsLinksDelete
  ## Deletes a web property-Google Ads link.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   webPropertyAdWordsLinkId: string (required)
  ##                           : Web property Google Ads link ID.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : ID of the account which the given web property belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to delete the Google Ads link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589721 = newJObject()
  var query_589722 = newJObject()
  add(query_589722, "fields", newJString(fields))
  add(query_589722, "quotaUser", newJString(quotaUser))
  add(query_589722, "alt", newJString(alt))
  add(path_589721, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(query_589722, "oauth_token", newJString(oauthToken))
  add(path_589721, "accountId", newJString(accountId))
  add(query_589722, "userIp", newJString(userIp))
  add(path_589721, "webPropertyId", newJString(webPropertyId))
  add(query_589722, "key", newJString(key))
  add(query_589722, "prettyPrint", newJBool(prettyPrint))
  result = call_589720.call(path_589721, query_589722, nil, nil, nil)

var analyticsManagementWebPropertyAdWordsLinksDelete* = Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_589706(
    name: "analyticsManagementWebPropertyAdWordsLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksDelete_589707,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksDelete_589708,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksInsert_589760 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebpropertyUserLinksInsert_589762(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertyUserLinksInsert_589761(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Adds a new user to the given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to create the user link for.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to create the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589763 = path.getOrDefault("accountId")
  valid_589763 = validateParameter(valid_589763, JString, required = true,
                                 default = nil)
  if valid_589763 != nil:
    section.add "accountId", valid_589763
  var valid_589764 = path.getOrDefault("webPropertyId")
  valid_589764 = validateParameter(valid_589764, JString, required = true,
                                 default = nil)
  if valid_589764 != nil:
    section.add "webPropertyId", valid_589764
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589765 = query.getOrDefault("fields")
  valid_589765 = validateParameter(valid_589765, JString, required = false,
                                 default = nil)
  if valid_589765 != nil:
    section.add "fields", valid_589765
  var valid_589766 = query.getOrDefault("quotaUser")
  valid_589766 = validateParameter(valid_589766, JString, required = false,
                                 default = nil)
  if valid_589766 != nil:
    section.add "quotaUser", valid_589766
  var valid_589767 = query.getOrDefault("alt")
  valid_589767 = validateParameter(valid_589767, JString, required = false,
                                 default = newJString("json"))
  if valid_589767 != nil:
    section.add "alt", valid_589767
  var valid_589768 = query.getOrDefault("oauth_token")
  valid_589768 = validateParameter(valid_589768, JString, required = false,
                                 default = nil)
  if valid_589768 != nil:
    section.add "oauth_token", valid_589768
  var valid_589769 = query.getOrDefault("userIp")
  valid_589769 = validateParameter(valid_589769, JString, required = false,
                                 default = nil)
  if valid_589769 != nil:
    section.add "userIp", valid_589769
  var valid_589770 = query.getOrDefault("key")
  valid_589770 = validateParameter(valid_589770, JString, required = false,
                                 default = nil)
  if valid_589770 != nil:
    section.add "key", valid_589770
  var valid_589771 = query.getOrDefault("prettyPrint")
  valid_589771 = validateParameter(valid_589771, JBool, required = false,
                                 default = newJBool(false))
  if valid_589771 != nil:
    section.add "prettyPrint", valid_589771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589773: Call_AnalyticsManagementWebpropertyUserLinksInsert_589760;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new user to the given web property.
  ## 
  let valid = call_589773.validator(path, query, header, formData, body)
  let scheme = call_589773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589773.url(scheme.get, call_589773.host, call_589773.base,
                         call_589773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589773, url, valid)

proc call*(call_589774: Call_AnalyticsManagementWebpropertyUserLinksInsert_589760;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertyUserLinksInsert
  ## Adds a new user to the given web property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to create the user link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589775 = newJObject()
  var query_589776 = newJObject()
  var body_589777 = newJObject()
  add(query_589776, "fields", newJString(fields))
  add(query_589776, "quotaUser", newJString(quotaUser))
  add(query_589776, "alt", newJString(alt))
  add(query_589776, "oauth_token", newJString(oauthToken))
  add(path_589775, "accountId", newJString(accountId))
  add(query_589776, "userIp", newJString(userIp))
  add(path_589775, "webPropertyId", newJString(webPropertyId))
  add(query_589776, "key", newJString(key))
  if body != nil:
    body_589777 = body
  add(query_589776, "prettyPrint", newJBool(prettyPrint))
  result = call_589774.call(path_589775, query_589776, nil, nil, body_589777)

var analyticsManagementWebpropertyUserLinksInsert* = Call_AnalyticsManagementWebpropertyUserLinksInsert_589760(
    name: "analyticsManagementWebpropertyUserLinksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks",
    validator: validate_AnalyticsManagementWebpropertyUserLinksInsert_589761,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksInsert_589762,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksList_589742 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebpropertyUserLinksList_589744(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertyUserLinksList_589743(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists webProperty-user links for a given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID which the given web property belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID for the webProperty-user links to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589745 = path.getOrDefault("accountId")
  valid_589745 = validateParameter(valid_589745, JString, required = true,
                                 default = nil)
  if valid_589745 != nil:
    section.add "accountId", valid_589745
  var valid_589746 = path.getOrDefault("webPropertyId")
  valid_589746 = validateParameter(valid_589746, JString, required = true,
                                 default = nil)
  if valid_589746 != nil:
    section.add "webPropertyId", valid_589746
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of webProperty-user Links to include in this response.
  ##   start-index: JInt
  ##              : An index of the first webProperty-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589747 = query.getOrDefault("fields")
  valid_589747 = validateParameter(valid_589747, JString, required = false,
                                 default = nil)
  if valid_589747 != nil:
    section.add "fields", valid_589747
  var valid_589748 = query.getOrDefault("quotaUser")
  valid_589748 = validateParameter(valid_589748, JString, required = false,
                                 default = nil)
  if valid_589748 != nil:
    section.add "quotaUser", valid_589748
  var valid_589749 = query.getOrDefault("alt")
  valid_589749 = validateParameter(valid_589749, JString, required = false,
                                 default = newJString("json"))
  if valid_589749 != nil:
    section.add "alt", valid_589749
  var valid_589750 = query.getOrDefault("oauth_token")
  valid_589750 = validateParameter(valid_589750, JString, required = false,
                                 default = nil)
  if valid_589750 != nil:
    section.add "oauth_token", valid_589750
  var valid_589751 = query.getOrDefault("userIp")
  valid_589751 = validateParameter(valid_589751, JString, required = false,
                                 default = nil)
  if valid_589751 != nil:
    section.add "userIp", valid_589751
  var valid_589752 = query.getOrDefault("key")
  valid_589752 = validateParameter(valid_589752, JString, required = false,
                                 default = nil)
  if valid_589752 != nil:
    section.add "key", valid_589752
  var valid_589753 = query.getOrDefault("max-results")
  valid_589753 = validateParameter(valid_589753, JInt, required = false, default = nil)
  if valid_589753 != nil:
    section.add "max-results", valid_589753
  var valid_589754 = query.getOrDefault("start-index")
  valid_589754 = validateParameter(valid_589754, JInt, required = false, default = nil)
  if valid_589754 != nil:
    section.add "start-index", valid_589754
  var valid_589755 = query.getOrDefault("prettyPrint")
  valid_589755 = validateParameter(valid_589755, JBool, required = false,
                                 default = newJBool(false))
  if valid_589755 != nil:
    section.add "prettyPrint", valid_589755
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589756: Call_AnalyticsManagementWebpropertyUserLinksList_589742;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists webProperty-user links for a given web property.
  ## 
  let valid = call_589756.validator(path, query, header, formData, body)
  let scheme = call_589756.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589756.url(scheme.get, call_589756.host, call_589756.base,
                         call_589756.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589756, url, valid)

proc call*(call_589757: Call_AnalyticsManagementWebpropertyUserLinksList_589742;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertyUserLinksList
  ## Lists webProperty-user links for a given web property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID which the given web property belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID for the webProperty-user links to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of webProperty-user Links to include in this response.
  ##   startIndex: int
  ##             : An index of the first webProperty-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589758 = newJObject()
  var query_589759 = newJObject()
  add(query_589759, "fields", newJString(fields))
  add(query_589759, "quotaUser", newJString(quotaUser))
  add(query_589759, "alt", newJString(alt))
  add(query_589759, "oauth_token", newJString(oauthToken))
  add(path_589758, "accountId", newJString(accountId))
  add(query_589759, "userIp", newJString(userIp))
  add(path_589758, "webPropertyId", newJString(webPropertyId))
  add(query_589759, "key", newJString(key))
  add(query_589759, "max-results", newJInt(maxResults))
  add(query_589759, "start-index", newJInt(startIndex))
  add(query_589759, "prettyPrint", newJBool(prettyPrint))
  result = call_589757.call(path_589758, query_589759, nil, nil, nil)

var analyticsManagementWebpropertyUserLinksList* = Call_AnalyticsManagementWebpropertyUserLinksList_589742(
    name: "analyticsManagementWebpropertyUserLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks",
    validator: validate_AnalyticsManagementWebpropertyUserLinksList_589743,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksList_589744,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksUpdate_589778 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebpropertyUserLinksUpdate_589780(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityUserLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertyUserLinksUpdate_589779(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates permissions for an existing user on the given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to update the account-user link for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to update the account-user link for.
  ##   linkId: JString (required)
  ##         : Link ID to update the account-user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589781 = path.getOrDefault("accountId")
  valid_589781 = validateParameter(valid_589781, JString, required = true,
                                 default = nil)
  if valid_589781 != nil:
    section.add "accountId", valid_589781
  var valid_589782 = path.getOrDefault("webPropertyId")
  valid_589782 = validateParameter(valid_589782, JString, required = true,
                                 default = nil)
  if valid_589782 != nil:
    section.add "webPropertyId", valid_589782
  var valid_589783 = path.getOrDefault("linkId")
  valid_589783 = validateParameter(valid_589783, JString, required = true,
                                 default = nil)
  if valid_589783 != nil:
    section.add "linkId", valid_589783
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589784 = query.getOrDefault("fields")
  valid_589784 = validateParameter(valid_589784, JString, required = false,
                                 default = nil)
  if valid_589784 != nil:
    section.add "fields", valid_589784
  var valid_589785 = query.getOrDefault("quotaUser")
  valid_589785 = validateParameter(valid_589785, JString, required = false,
                                 default = nil)
  if valid_589785 != nil:
    section.add "quotaUser", valid_589785
  var valid_589786 = query.getOrDefault("alt")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = newJString("json"))
  if valid_589786 != nil:
    section.add "alt", valid_589786
  var valid_589787 = query.getOrDefault("oauth_token")
  valid_589787 = validateParameter(valid_589787, JString, required = false,
                                 default = nil)
  if valid_589787 != nil:
    section.add "oauth_token", valid_589787
  var valid_589788 = query.getOrDefault("userIp")
  valid_589788 = validateParameter(valid_589788, JString, required = false,
                                 default = nil)
  if valid_589788 != nil:
    section.add "userIp", valid_589788
  var valid_589789 = query.getOrDefault("key")
  valid_589789 = validateParameter(valid_589789, JString, required = false,
                                 default = nil)
  if valid_589789 != nil:
    section.add "key", valid_589789
  var valid_589790 = query.getOrDefault("prettyPrint")
  valid_589790 = validateParameter(valid_589790, JBool, required = false,
                                 default = newJBool(false))
  if valid_589790 != nil:
    section.add "prettyPrint", valid_589790
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589792: Call_AnalyticsManagementWebpropertyUserLinksUpdate_589778;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates permissions for an existing user on the given web property.
  ## 
  let valid = call_589792.validator(path, query, header, formData, body)
  let scheme = call_589792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589792.url(scheme.get, call_589792.host, call_589792.base,
                         call_589792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589792, url, valid)

proc call*(call_589793: Call_AnalyticsManagementWebpropertyUserLinksUpdate_589778;
          accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertyUserLinksUpdate
  ## Updates permissions for an existing user on the given web property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to update the account-user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to update the account-user link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : Link ID to update the account-user link for.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589794 = newJObject()
  var query_589795 = newJObject()
  var body_589796 = newJObject()
  add(query_589795, "fields", newJString(fields))
  add(query_589795, "quotaUser", newJString(quotaUser))
  add(query_589795, "alt", newJString(alt))
  add(query_589795, "oauth_token", newJString(oauthToken))
  add(path_589794, "accountId", newJString(accountId))
  add(query_589795, "userIp", newJString(userIp))
  add(path_589794, "webPropertyId", newJString(webPropertyId))
  add(query_589795, "key", newJString(key))
  add(path_589794, "linkId", newJString(linkId))
  if body != nil:
    body_589796 = body
  add(query_589795, "prettyPrint", newJBool(prettyPrint))
  result = call_589793.call(path_589794, query_589795, nil, nil, body_589796)

var analyticsManagementWebpropertyUserLinksUpdate* = Call_AnalyticsManagementWebpropertyUserLinksUpdate_589778(
    name: "analyticsManagementWebpropertyUserLinksUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementWebpropertyUserLinksUpdate_589779,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksUpdate_589780,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksDelete_589797 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementWebpropertyUserLinksDelete_589799(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/entityUserLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementWebpropertyUserLinksDelete_589798(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Removes a user from the given web property.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to delete the user link for.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to delete the user link for.
  ##   linkId: JString (required)
  ##         : Link ID to delete the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589800 = path.getOrDefault("accountId")
  valid_589800 = validateParameter(valid_589800, JString, required = true,
                                 default = nil)
  if valid_589800 != nil:
    section.add "accountId", valid_589800
  var valid_589801 = path.getOrDefault("webPropertyId")
  valid_589801 = validateParameter(valid_589801, JString, required = true,
                                 default = nil)
  if valid_589801 != nil:
    section.add "webPropertyId", valid_589801
  var valid_589802 = path.getOrDefault("linkId")
  valid_589802 = validateParameter(valid_589802, JString, required = true,
                                 default = nil)
  if valid_589802 != nil:
    section.add "linkId", valid_589802
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589803 = query.getOrDefault("fields")
  valid_589803 = validateParameter(valid_589803, JString, required = false,
                                 default = nil)
  if valid_589803 != nil:
    section.add "fields", valid_589803
  var valid_589804 = query.getOrDefault("quotaUser")
  valid_589804 = validateParameter(valid_589804, JString, required = false,
                                 default = nil)
  if valid_589804 != nil:
    section.add "quotaUser", valid_589804
  var valid_589805 = query.getOrDefault("alt")
  valid_589805 = validateParameter(valid_589805, JString, required = false,
                                 default = newJString("json"))
  if valid_589805 != nil:
    section.add "alt", valid_589805
  var valid_589806 = query.getOrDefault("oauth_token")
  valid_589806 = validateParameter(valid_589806, JString, required = false,
                                 default = nil)
  if valid_589806 != nil:
    section.add "oauth_token", valid_589806
  var valid_589807 = query.getOrDefault("userIp")
  valid_589807 = validateParameter(valid_589807, JString, required = false,
                                 default = nil)
  if valid_589807 != nil:
    section.add "userIp", valid_589807
  var valid_589808 = query.getOrDefault("key")
  valid_589808 = validateParameter(valid_589808, JString, required = false,
                                 default = nil)
  if valid_589808 != nil:
    section.add "key", valid_589808
  var valid_589809 = query.getOrDefault("prettyPrint")
  valid_589809 = validateParameter(valid_589809, JBool, required = false,
                                 default = newJBool(false))
  if valid_589809 != nil:
    section.add "prettyPrint", valid_589809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589810: Call_AnalyticsManagementWebpropertyUserLinksDelete_589797;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the given web property.
  ## 
  let valid = call_589810.validator(path, query, header, formData, body)
  let scheme = call_589810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589810.url(scheme.get, call_589810.host, call_589810.base,
                         call_589810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589810, url, valid)

proc call*(call_589811: Call_AnalyticsManagementWebpropertyUserLinksDelete_589797;
          accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementWebpropertyUserLinksDelete
  ## Removes a user from the given web property.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to delete the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to delete the user link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : Link ID to delete the user link for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589812 = newJObject()
  var query_589813 = newJObject()
  add(query_589813, "fields", newJString(fields))
  add(query_589813, "quotaUser", newJString(quotaUser))
  add(query_589813, "alt", newJString(alt))
  add(query_589813, "oauth_token", newJString(oauthToken))
  add(path_589812, "accountId", newJString(accountId))
  add(query_589813, "userIp", newJString(userIp))
  add(path_589812, "webPropertyId", newJString(webPropertyId))
  add(query_589813, "key", newJString(key))
  add(path_589812, "linkId", newJString(linkId))
  add(query_589813, "prettyPrint", newJBool(prettyPrint))
  result = call_589811.call(path_589812, query_589813, nil, nil, nil)

var analyticsManagementWebpropertyUserLinksDelete* = Call_AnalyticsManagementWebpropertyUserLinksDelete_589797(
    name: "analyticsManagementWebpropertyUserLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementWebpropertyUserLinksDelete_589798,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksDelete_589799,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesInsert_589832 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfilesInsert_589834(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesInsert_589833(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to create the view (profile) for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the view (profile) for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589835 = path.getOrDefault("accountId")
  valid_589835 = validateParameter(valid_589835, JString, required = true,
                                 default = nil)
  if valid_589835 != nil:
    section.add "accountId", valid_589835
  var valid_589836 = path.getOrDefault("webPropertyId")
  valid_589836 = validateParameter(valid_589836, JString, required = true,
                                 default = nil)
  if valid_589836 != nil:
    section.add "webPropertyId", valid_589836
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589837 = query.getOrDefault("fields")
  valid_589837 = validateParameter(valid_589837, JString, required = false,
                                 default = nil)
  if valid_589837 != nil:
    section.add "fields", valid_589837
  var valid_589838 = query.getOrDefault("quotaUser")
  valid_589838 = validateParameter(valid_589838, JString, required = false,
                                 default = nil)
  if valid_589838 != nil:
    section.add "quotaUser", valid_589838
  var valid_589839 = query.getOrDefault("alt")
  valid_589839 = validateParameter(valid_589839, JString, required = false,
                                 default = newJString("json"))
  if valid_589839 != nil:
    section.add "alt", valid_589839
  var valid_589840 = query.getOrDefault("oauth_token")
  valid_589840 = validateParameter(valid_589840, JString, required = false,
                                 default = nil)
  if valid_589840 != nil:
    section.add "oauth_token", valid_589840
  var valid_589841 = query.getOrDefault("userIp")
  valid_589841 = validateParameter(valid_589841, JString, required = false,
                                 default = nil)
  if valid_589841 != nil:
    section.add "userIp", valid_589841
  var valid_589842 = query.getOrDefault("key")
  valid_589842 = validateParameter(valid_589842, JString, required = false,
                                 default = nil)
  if valid_589842 != nil:
    section.add "key", valid_589842
  var valid_589843 = query.getOrDefault("prettyPrint")
  valid_589843 = validateParameter(valid_589843, JBool, required = false,
                                 default = newJBool(false))
  if valid_589843 != nil:
    section.add "prettyPrint", valid_589843
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589845: Call_AnalyticsManagementProfilesInsert_589832;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new view (profile).
  ## 
  let valid = call_589845.validator(path, query, header, formData, body)
  let scheme = call_589845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589845.url(scheme.get, call_589845.host, call_589845.base,
                         call_589845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589845, url, valid)

proc call*(call_589846: Call_AnalyticsManagementProfilesInsert_589832;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfilesInsert
  ## Create a new view (profile).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the view (profile) for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the view (profile) for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589847 = newJObject()
  var query_589848 = newJObject()
  var body_589849 = newJObject()
  add(query_589848, "fields", newJString(fields))
  add(query_589848, "quotaUser", newJString(quotaUser))
  add(query_589848, "alt", newJString(alt))
  add(query_589848, "oauth_token", newJString(oauthToken))
  add(path_589847, "accountId", newJString(accountId))
  add(query_589848, "userIp", newJString(userIp))
  add(path_589847, "webPropertyId", newJString(webPropertyId))
  add(query_589848, "key", newJString(key))
  if body != nil:
    body_589849 = body
  add(query_589848, "prettyPrint", newJBool(prettyPrint))
  result = call_589846.call(path_589847, query_589848, nil, nil, body_589849)

var analyticsManagementProfilesInsert* = Call_AnalyticsManagementProfilesInsert_589832(
    name: "analyticsManagementProfilesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles",
    validator: validate_AnalyticsManagementProfilesInsert_589833,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesInsert_589834,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesList_589814 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfilesList_589816(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesList_589815(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists views (profiles) to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID for the view (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts to which the user has access.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties to which the user has access.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_589817 = path.getOrDefault("accountId")
  valid_589817 = validateParameter(valid_589817, JString, required = true,
                                 default = nil)
  if valid_589817 != nil:
    section.add "accountId", valid_589817
  var valid_589818 = path.getOrDefault("webPropertyId")
  valid_589818 = validateParameter(valid_589818, JString, required = true,
                                 default = nil)
  if valid_589818 != nil:
    section.add "webPropertyId", valid_589818
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of views (profiles) to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589819 = query.getOrDefault("fields")
  valid_589819 = validateParameter(valid_589819, JString, required = false,
                                 default = nil)
  if valid_589819 != nil:
    section.add "fields", valid_589819
  var valid_589820 = query.getOrDefault("quotaUser")
  valid_589820 = validateParameter(valid_589820, JString, required = false,
                                 default = nil)
  if valid_589820 != nil:
    section.add "quotaUser", valid_589820
  var valid_589821 = query.getOrDefault("alt")
  valid_589821 = validateParameter(valid_589821, JString, required = false,
                                 default = newJString("json"))
  if valid_589821 != nil:
    section.add "alt", valid_589821
  var valid_589822 = query.getOrDefault("oauth_token")
  valid_589822 = validateParameter(valid_589822, JString, required = false,
                                 default = nil)
  if valid_589822 != nil:
    section.add "oauth_token", valid_589822
  var valid_589823 = query.getOrDefault("userIp")
  valid_589823 = validateParameter(valid_589823, JString, required = false,
                                 default = nil)
  if valid_589823 != nil:
    section.add "userIp", valid_589823
  var valid_589824 = query.getOrDefault("key")
  valid_589824 = validateParameter(valid_589824, JString, required = false,
                                 default = nil)
  if valid_589824 != nil:
    section.add "key", valid_589824
  var valid_589825 = query.getOrDefault("max-results")
  valid_589825 = validateParameter(valid_589825, JInt, required = false, default = nil)
  if valid_589825 != nil:
    section.add "max-results", valid_589825
  var valid_589826 = query.getOrDefault("start-index")
  valid_589826 = validateParameter(valid_589826, JInt, required = false, default = nil)
  if valid_589826 != nil:
    section.add "start-index", valid_589826
  var valid_589827 = query.getOrDefault("prettyPrint")
  valid_589827 = validateParameter(valid_589827, JBool, required = false,
                                 default = newJBool(false))
  if valid_589827 != nil:
    section.add "prettyPrint", valid_589827
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589828: Call_AnalyticsManagementProfilesList_589814;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists views (profiles) to which the user has access.
  ## 
  let valid = call_589828.validator(path, query, header, formData, body)
  let scheme = call_589828.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589828.url(scheme.get, call_589828.host, call_589828.base,
                         call_589828.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589828, url, valid)

proc call*(call_589829: Call_AnalyticsManagementProfilesList_589814;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; maxResults: int = 0; startIndex: int = 0;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfilesList
  ## Lists views (profiles) to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID for the view (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts to which the user has access.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties to which the user has access.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of views (profiles) to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589830 = newJObject()
  var query_589831 = newJObject()
  add(query_589831, "fields", newJString(fields))
  add(query_589831, "quotaUser", newJString(quotaUser))
  add(query_589831, "alt", newJString(alt))
  add(query_589831, "oauth_token", newJString(oauthToken))
  add(path_589830, "accountId", newJString(accountId))
  add(query_589831, "userIp", newJString(userIp))
  add(path_589830, "webPropertyId", newJString(webPropertyId))
  add(query_589831, "key", newJString(key))
  add(query_589831, "max-results", newJInt(maxResults))
  add(query_589831, "start-index", newJInt(startIndex))
  add(query_589831, "prettyPrint", newJBool(prettyPrint))
  result = call_589829.call(path_589830, query_589831, nil, nil, nil)

var analyticsManagementProfilesList* = Call_AnalyticsManagementProfilesList_589814(
    name: "analyticsManagementProfilesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles",
    validator: validate_AnalyticsManagementProfilesList_589815,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesList_589816,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesUpdate_589867 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfilesUpdate_589869(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesUpdate_589868(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : ID of the view (profile) to be updated.
  ##   accountId: JString (required)
  ##            : Account ID to which the view (profile) belongs
  ##   webPropertyId: JString (required)
  ##                : Web property ID to which the view (profile) belongs
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_589870 = path.getOrDefault("profileId")
  valid_589870 = validateParameter(valid_589870, JString, required = true,
                                 default = nil)
  if valid_589870 != nil:
    section.add "profileId", valid_589870
  var valid_589871 = path.getOrDefault("accountId")
  valid_589871 = validateParameter(valid_589871, JString, required = true,
                                 default = nil)
  if valid_589871 != nil:
    section.add "accountId", valid_589871
  var valid_589872 = path.getOrDefault("webPropertyId")
  valid_589872 = validateParameter(valid_589872, JString, required = true,
                                 default = nil)
  if valid_589872 != nil:
    section.add "webPropertyId", valid_589872
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589873 = query.getOrDefault("fields")
  valid_589873 = validateParameter(valid_589873, JString, required = false,
                                 default = nil)
  if valid_589873 != nil:
    section.add "fields", valid_589873
  var valid_589874 = query.getOrDefault("quotaUser")
  valid_589874 = validateParameter(valid_589874, JString, required = false,
                                 default = nil)
  if valid_589874 != nil:
    section.add "quotaUser", valid_589874
  var valid_589875 = query.getOrDefault("alt")
  valid_589875 = validateParameter(valid_589875, JString, required = false,
                                 default = newJString("json"))
  if valid_589875 != nil:
    section.add "alt", valid_589875
  var valid_589876 = query.getOrDefault("oauth_token")
  valid_589876 = validateParameter(valid_589876, JString, required = false,
                                 default = nil)
  if valid_589876 != nil:
    section.add "oauth_token", valid_589876
  var valid_589877 = query.getOrDefault("userIp")
  valid_589877 = validateParameter(valid_589877, JString, required = false,
                                 default = nil)
  if valid_589877 != nil:
    section.add "userIp", valid_589877
  var valid_589878 = query.getOrDefault("key")
  valid_589878 = validateParameter(valid_589878, JString, required = false,
                                 default = nil)
  if valid_589878 != nil:
    section.add "key", valid_589878
  var valid_589879 = query.getOrDefault("prettyPrint")
  valid_589879 = validateParameter(valid_589879, JBool, required = false,
                                 default = newJBool(false))
  if valid_589879 != nil:
    section.add "prettyPrint", valid_589879
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589881: Call_AnalyticsManagementProfilesUpdate_589867;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing view (profile).
  ## 
  let valid = call_589881.validator(path, query, header, formData, body)
  let scheme = call_589881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589881.url(scheme.get, call_589881.host, call_589881.base,
                         call_589881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589881, url, valid)

proc call*(call_589882: Call_AnalyticsManagementProfilesUpdate_589867;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfilesUpdate
  ## Updates an existing view (profile).
  ##   profileId: string (required)
  ##            : ID of the view (profile) to be updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the view (profile) belongs
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to which the view (profile) belongs
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589883 = newJObject()
  var query_589884 = newJObject()
  var body_589885 = newJObject()
  add(path_589883, "profileId", newJString(profileId))
  add(query_589884, "fields", newJString(fields))
  add(query_589884, "quotaUser", newJString(quotaUser))
  add(query_589884, "alt", newJString(alt))
  add(query_589884, "oauth_token", newJString(oauthToken))
  add(path_589883, "accountId", newJString(accountId))
  add(query_589884, "userIp", newJString(userIp))
  add(path_589883, "webPropertyId", newJString(webPropertyId))
  add(query_589884, "key", newJString(key))
  if body != nil:
    body_589885 = body
  add(query_589884, "prettyPrint", newJBool(prettyPrint))
  result = call_589882.call(path_589883, query_589884, nil, nil, body_589885)

var analyticsManagementProfilesUpdate* = Call_AnalyticsManagementProfilesUpdate_589867(
    name: "analyticsManagementProfilesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesUpdate_589868,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesUpdate_589869,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesGet_589850 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfilesGet_589852(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesGet_589851(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a view (profile) to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve the view (profile) for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the view (profile) for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the view (profile) for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_589853 = path.getOrDefault("profileId")
  valid_589853 = validateParameter(valid_589853, JString, required = true,
                                 default = nil)
  if valid_589853 != nil:
    section.add "profileId", valid_589853
  var valid_589854 = path.getOrDefault("accountId")
  valid_589854 = validateParameter(valid_589854, JString, required = true,
                                 default = nil)
  if valid_589854 != nil:
    section.add "accountId", valid_589854
  var valid_589855 = path.getOrDefault("webPropertyId")
  valid_589855 = validateParameter(valid_589855, JString, required = true,
                                 default = nil)
  if valid_589855 != nil:
    section.add "webPropertyId", valid_589855
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589856 = query.getOrDefault("fields")
  valid_589856 = validateParameter(valid_589856, JString, required = false,
                                 default = nil)
  if valid_589856 != nil:
    section.add "fields", valid_589856
  var valid_589857 = query.getOrDefault("quotaUser")
  valid_589857 = validateParameter(valid_589857, JString, required = false,
                                 default = nil)
  if valid_589857 != nil:
    section.add "quotaUser", valid_589857
  var valid_589858 = query.getOrDefault("alt")
  valid_589858 = validateParameter(valid_589858, JString, required = false,
                                 default = newJString("json"))
  if valid_589858 != nil:
    section.add "alt", valid_589858
  var valid_589859 = query.getOrDefault("oauth_token")
  valid_589859 = validateParameter(valid_589859, JString, required = false,
                                 default = nil)
  if valid_589859 != nil:
    section.add "oauth_token", valid_589859
  var valid_589860 = query.getOrDefault("userIp")
  valid_589860 = validateParameter(valid_589860, JString, required = false,
                                 default = nil)
  if valid_589860 != nil:
    section.add "userIp", valid_589860
  var valid_589861 = query.getOrDefault("key")
  valid_589861 = validateParameter(valid_589861, JString, required = false,
                                 default = nil)
  if valid_589861 != nil:
    section.add "key", valid_589861
  var valid_589862 = query.getOrDefault("prettyPrint")
  valid_589862 = validateParameter(valid_589862, JBool, required = false,
                                 default = newJBool(false))
  if valid_589862 != nil:
    section.add "prettyPrint", valid_589862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589863: Call_AnalyticsManagementProfilesGet_589850; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a view (profile) to which the user has access.
  ## 
  let valid = call_589863.validator(path, query, header, formData, body)
  let scheme = call_589863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589863.url(scheme.get, call_589863.host, call_589863.base,
                         call_589863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589863, url, valid)

proc call*(call_589864: Call_AnalyticsManagementProfilesGet_589850;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfilesGet
  ## Gets a view (profile) to which the user has access.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve the view (profile) for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the view (profile) for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the view (profile) for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589865 = newJObject()
  var query_589866 = newJObject()
  add(path_589865, "profileId", newJString(profileId))
  add(query_589866, "fields", newJString(fields))
  add(query_589866, "quotaUser", newJString(quotaUser))
  add(query_589866, "alt", newJString(alt))
  add(query_589866, "oauth_token", newJString(oauthToken))
  add(path_589865, "accountId", newJString(accountId))
  add(query_589866, "userIp", newJString(userIp))
  add(path_589865, "webPropertyId", newJString(webPropertyId))
  add(query_589866, "key", newJString(key))
  add(query_589866, "prettyPrint", newJBool(prettyPrint))
  result = call_589864.call(path_589865, query_589866, nil, nil, nil)

var analyticsManagementProfilesGet* = Call_AnalyticsManagementProfilesGet_589850(
    name: "analyticsManagementProfilesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesGet_589851,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesGet_589852,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesPatch_589903 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfilesPatch_589905(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesPatch_589904(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing view (profile). This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : ID of the view (profile) to be updated.
  ##   accountId: JString (required)
  ##            : Account ID to which the view (profile) belongs
  ##   webPropertyId: JString (required)
  ##                : Web property ID to which the view (profile) belongs
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_589906 = path.getOrDefault("profileId")
  valid_589906 = validateParameter(valid_589906, JString, required = true,
                                 default = nil)
  if valid_589906 != nil:
    section.add "profileId", valid_589906
  var valid_589907 = path.getOrDefault("accountId")
  valid_589907 = validateParameter(valid_589907, JString, required = true,
                                 default = nil)
  if valid_589907 != nil:
    section.add "accountId", valid_589907
  var valid_589908 = path.getOrDefault("webPropertyId")
  valid_589908 = validateParameter(valid_589908, JString, required = true,
                                 default = nil)
  if valid_589908 != nil:
    section.add "webPropertyId", valid_589908
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589909 = query.getOrDefault("fields")
  valid_589909 = validateParameter(valid_589909, JString, required = false,
                                 default = nil)
  if valid_589909 != nil:
    section.add "fields", valid_589909
  var valid_589910 = query.getOrDefault("quotaUser")
  valid_589910 = validateParameter(valid_589910, JString, required = false,
                                 default = nil)
  if valid_589910 != nil:
    section.add "quotaUser", valid_589910
  var valid_589911 = query.getOrDefault("alt")
  valid_589911 = validateParameter(valid_589911, JString, required = false,
                                 default = newJString("json"))
  if valid_589911 != nil:
    section.add "alt", valid_589911
  var valid_589912 = query.getOrDefault("oauth_token")
  valid_589912 = validateParameter(valid_589912, JString, required = false,
                                 default = nil)
  if valid_589912 != nil:
    section.add "oauth_token", valid_589912
  var valid_589913 = query.getOrDefault("userIp")
  valid_589913 = validateParameter(valid_589913, JString, required = false,
                                 default = nil)
  if valid_589913 != nil:
    section.add "userIp", valid_589913
  var valid_589914 = query.getOrDefault("key")
  valid_589914 = validateParameter(valid_589914, JString, required = false,
                                 default = nil)
  if valid_589914 != nil:
    section.add "key", valid_589914
  var valid_589915 = query.getOrDefault("prettyPrint")
  valid_589915 = validateParameter(valid_589915, JBool, required = false,
                                 default = newJBool(false))
  if valid_589915 != nil:
    section.add "prettyPrint", valid_589915
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589917: Call_AnalyticsManagementProfilesPatch_589903;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing view (profile). This method supports patch semantics.
  ## 
  let valid = call_589917.validator(path, query, header, formData, body)
  let scheme = call_589917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589917.url(scheme.get, call_589917.host, call_589917.base,
                         call_589917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589917, url, valid)

proc call*(call_589918: Call_AnalyticsManagementProfilesPatch_589903;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfilesPatch
  ## Updates an existing view (profile). This method supports patch semantics.
  ##   profileId: string (required)
  ##            : ID of the view (profile) to be updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the view (profile) belongs
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to which the view (profile) belongs
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589919 = newJObject()
  var query_589920 = newJObject()
  var body_589921 = newJObject()
  add(path_589919, "profileId", newJString(profileId))
  add(query_589920, "fields", newJString(fields))
  add(query_589920, "quotaUser", newJString(quotaUser))
  add(query_589920, "alt", newJString(alt))
  add(query_589920, "oauth_token", newJString(oauthToken))
  add(path_589919, "accountId", newJString(accountId))
  add(query_589920, "userIp", newJString(userIp))
  add(path_589919, "webPropertyId", newJString(webPropertyId))
  add(query_589920, "key", newJString(key))
  if body != nil:
    body_589921 = body
  add(query_589920, "prettyPrint", newJBool(prettyPrint))
  result = call_589918.call(path_589919, query_589920, nil, nil, body_589921)

var analyticsManagementProfilesPatch* = Call_AnalyticsManagementProfilesPatch_589903(
    name: "analyticsManagementProfilesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesPatch_589904,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesPatch_589905,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesDelete_589886 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfilesDelete_589888(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfilesDelete_589887(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : ID of the view (profile) to be deleted.
  ##   accountId: JString (required)
  ##            : Account ID to delete the view (profile) for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to delete the view (profile) for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_589889 = path.getOrDefault("profileId")
  valid_589889 = validateParameter(valid_589889, JString, required = true,
                                 default = nil)
  if valid_589889 != nil:
    section.add "profileId", valid_589889
  var valid_589890 = path.getOrDefault("accountId")
  valid_589890 = validateParameter(valid_589890, JString, required = true,
                                 default = nil)
  if valid_589890 != nil:
    section.add "accountId", valid_589890
  var valid_589891 = path.getOrDefault("webPropertyId")
  valid_589891 = validateParameter(valid_589891, JString, required = true,
                                 default = nil)
  if valid_589891 != nil:
    section.add "webPropertyId", valid_589891
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589892 = query.getOrDefault("fields")
  valid_589892 = validateParameter(valid_589892, JString, required = false,
                                 default = nil)
  if valid_589892 != nil:
    section.add "fields", valid_589892
  var valid_589893 = query.getOrDefault("quotaUser")
  valid_589893 = validateParameter(valid_589893, JString, required = false,
                                 default = nil)
  if valid_589893 != nil:
    section.add "quotaUser", valid_589893
  var valid_589894 = query.getOrDefault("alt")
  valid_589894 = validateParameter(valid_589894, JString, required = false,
                                 default = newJString("json"))
  if valid_589894 != nil:
    section.add "alt", valid_589894
  var valid_589895 = query.getOrDefault("oauth_token")
  valid_589895 = validateParameter(valid_589895, JString, required = false,
                                 default = nil)
  if valid_589895 != nil:
    section.add "oauth_token", valid_589895
  var valid_589896 = query.getOrDefault("userIp")
  valid_589896 = validateParameter(valid_589896, JString, required = false,
                                 default = nil)
  if valid_589896 != nil:
    section.add "userIp", valid_589896
  var valid_589897 = query.getOrDefault("key")
  valid_589897 = validateParameter(valid_589897, JString, required = false,
                                 default = nil)
  if valid_589897 != nil:
    section.add "key", valid_589897
  var valid_589898 = query.getOrDefault("prettyPrint")
  valid_589898 = validateParameter(valid_589898, JBool, required = false,
                                 default = newJBool(false))
  if valid_589898 != nil:
    section.add "prettyPrint", valid_589898
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589899: Call_AnalyticsManagementProfilesDelete_589886;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a view (profile).
  ## 
  let valid = call_589899.validator(path, query, header, formData, body)
  let scheme = call_589899.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589899.url(scheme.get, call_589899.host, call_589899.base,
                         call_589899.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589899, url, valid)

proc call*(call_589900: Call_AnalyticsManagementProfilesDelete_589886;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfilesDelete
  ## Deletes a view (profile).
  ##   profileId: string (required)
  ##            : ID of the view (profile) to be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to delete the view (profile) for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to delete the view (profile) for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589901 = newJObject()
  var query_589902 = newJObject()
  add(path_589901, "profileId", newJString(profileId))
  add(query_589902, "fields", newJString(fields))
  add(query_589902, "quotaUser", newJString(quotaUser))
  add(query_589902, "alt", newJString(alt))
  add(query_589902, "oauth_token", newJString(oauthToken))
  add(path_589901, "accountId", newJString(accountId))
  add(query_589902, "userIp", newJString(userIp))
  add(path_589901, "webPropertyId", newJString(webPropertyId))
  add(query_589902, "key", newJString(key))
  add(query_589902, "prettyPrint", newJBool(prettyPrint))
  result = call_589900.call(path_589901, query_589902, nil, nil, nil)

var analyticsManagementProfilesDelete* = Call_AnalyticsManagementProfilesDelete_589886(
    name: "analyticsManagementProfilesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesDelete_589887,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesDelete_589888,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksInsert_589941 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfileUserLinksInsert_589943(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileUserLinksInsert_589942(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new user to the given view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to create the user link for.
  ##   accountId: JString (required)
  ##            : Account ID to create the user link for.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to create the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_589944 = path.getOrDefault("profileId")
  valid_589944 = validateParameter(valid_589944, JString, required = true,
                                 default = nil)
  if valid_589944 != nil:
    section.add "profileId", valid_589944
  var valid_589945 = path.getOrDefault("accountId")
  valid_589945 = validateParameter(valid_589945, JString, required = true,
                                 default = nil)
  if valid_589945 != nil:
    section.add "accountId", valid_589945
  var valid_589946 = path.getOrDefault("webPropertyId")
  valid_589946 = validateParameter(valid_589946, JString, required = true,
                                 default = nil)
  if valid_589946 != nil:
    section.add "webPropertyId", valid_589946
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589947 = query.getOrDefault("fields")
  valid_589947 = validateParameter(valid_589947, JString, required = false,
                                 default = nil)
  if valid_589947 != nil:
    section.add "fields", valid_589947
  var valid_589948 = query.getOrDefault("quotaUser")
  valid_589948 = validateParameter(valid_589948, JString, required = false,
                                 default = nil)
  if valid_589948 != nil:
    section.add "quotaUser", valid_589948
  var valid_589949 = query.getOrDefault("alt")
  valid_589949 = validateParameter(valid_589949, JString, required = false,
                                 default = newJString("json"))
  if valid_589949 != nil:
    section.add "alt", valid_589949
  var valid_589950 = query.getOrDefault("oauth_token")
  valid_589950 = validateParameter(valid_589950, JString, required = false,
                                 default = nil)
  if valid_589950 != nil:
    section.add "oauth_token", valid_589950
  var valid_589951 = query.getOrDefault("userIp")
  valid_589951 = validateParameter(valid_589951, JString, required = false,
                                 default = nil)
  if valid_589951 != nil:
    section.add "userIp", valid_589951
  var valid_589952 = query.getOrDefault("key")
  valid_589952 = validateParameter(valid_589952, JString, required = false,
                                 default = nil)
  if valid_589952 != nil:
    section.add "key", valid_589952
  var valid_589953 = query.getOrDefault("prettyPrint")
  valid_589953 = validateParameter(valid_589953, JBool, required = false,
                                 default = newJBool(false))
  if valid_589953 != nil:
    section.add "prettyPrint", valid_589953
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589955: Call_AnalyticsManagementProfileUserLinksInsert_589941;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new user to the given view (profile).
  ## 
  let valid = call_589955.validator(path, query, header, formData, body)
  let scheme = call_589955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589955.url(scheme.get, call_589955.host, call_589955.base,
                         call_589955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589955, url, valid)

proc call*(call_589956: Call_AnalyticsManagementProfileUserLinksInsert_589941;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileUserLinksInsert
  ## Adds a new user to the given view (profile).
  ##   profileId: string (required)
  ##            : View (Profile) ID to create the user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to create the user link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589957 = newJObject()
  var query_589958 = newJObject()
  var body_589959 = newJObject()
  add(path_589957, "profileId", newJString(profileId))
  add(query_589958, "fields", newJString(fields))
  add(query_589958, "quotaUser", newJString(quotaUser))
  add(query_589958, "alt", newJString(alt))
  add(query_589958, "oauth_token", newJString(oauthToken))
  add(path_589957, "accountId", newJString(accountId))
  add(query_589958, "userIp", newJString(userIp))
  add(path_589957, "webPropertyId", newJString(webPropertyId))
  add(query_589958, "key", newJString(key))
  if body != nil:
    body_589959 = body
  add(query_589958, "prettyPrint", newJBool(prettyPrint))
  result = call_589956.call(path_589957, query_589958, nil, nil, body_589959)

var analyticsManagementProfileUserLinksInsert* = Call_AnalyticsManagementProfileUserLinksInsert_589941(
    name: "analyticsManagementProfileUserLinksInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks",
    validator: validate_AnalyticsManagementProfileUserLinksInsert_589942,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksInsert_589943,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksList_589922 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfileUserLinksList_589924(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/entityUserLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileUserLinksList_589923(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists profile-user links for a given view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve the profile-user links for. Can either be a specific profile ID or '~all', which refers to all the profiles that user has access to.
  ##   accountId: JString (required)
  ##            : Account ID which the given view (profile) belongs to.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID which the given view (profile) belongs to. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_589925 = path.getOrDefault("profileId")
  valid_589925 = validateParameter(valid_589925, JString, required = true,
                                 default = nil)
  if valid_589925 != nil:
    section.add "profileId", valid_589925
  var valid_589926 = path.getOrDefault("accountId")
  valid_589926 = validateParameter(valid_589926, JString, required = true,
                                 default = nil)
  if valid_589926 != nil:
    section.add "accountId", valid_589926
  var valid_589927 = path.getOrDefault("webPropertyId")
  valid_589927 = validateParameter(valid_589927, JString, required = true,
                                 default = nil)
  if valid_589927 != nil:
    section.add "webPropertyId", valid_589927
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of profile-user links to include in this response.
  ##   start-index: JInt
  ##              : An index of the first profile-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589928 = query.getOrDefault("fields")
  valid_589928 = validateParameter(valid_589928, JString, required = false,
                                 default = nil)
  if valid_589928 != nil:
    section.add "fields", valid_589928
  var valid_589929 = query.getOrDefault("quotaUser")
  valid_589929 = validateParameter(valid_589929, JString, required = false,
                                 default = nil)
  if valid_589929 != nil:
    section.add "quotaUser", valid_589929
  var valid_589930 = query.getOrDefault("alt")
  valid_589930 = validateParameter(valid_589930, JString, required = false,
                                 default = newJString("json"))
  if valid_589930 != nil:
    section.add "alt", valid_589930
  var valid_589931 = query.getOrDefault("oauth_token")
  valid_589931 = validateParameter(valid_589931, JString, required = false,
                                 default = nil)
  if valid_589931 != nil:
    section.add "oauth_token", valid_589931
  var valid_589932 = query.getOrDefault("userIp")
  valid_589932 = validateParameter(valid_589932, JString, required = false,
                                 default = nil)
  if valid_589932 != nil:
    section.add "userIp", valid_589932
  var valid_589933 = query.getOrDefault("key")
  valid_589933 = validateParameter(valid_589933, JString, required = false,
                                 default = nil)
  if valid_589933 != nil:
    section.add "key", valid_589933
  var valid_589934 = query.getOrDefault("max-results")
  valid_589934 = validateParameter(valid_589934, JInt, required = false, default = nil)
  if valid_589934 != nil:
    section.add "max-results", valid_589934
  var valid_589935 = query.getOrDefault("start-index")
  valid_589935 = validateParameter(valid_589935, JInt, required = false, default = nil)
  if valid_589935 != nil:
    section.add "start-index", valid_589935
  var valid_589936 = query.getOrDefault("prettyPrint")
  valid_589936 = validateParameter(valid_589936, JBool, required = false,
                                 default = newJBool(false))
  if valid_589936 != nil:
    section.add "prettyPrint", valid_589936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589937: Call_AnalyticsManagementProfileUserLinksList_589922;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists profile-user links for a given view (profile).
  ## 
  let valid = call_589937.validator(path, query, header, formData, body)
  let scheme = call_589937.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589937.url(scheme.get, call_589937.host, call_589937.base,
                         call_589937.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589937, url, valid)

proc call*(call_589938: Call_AnalyticsManagementProfileUserLinksList_589922;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileUserLinksList
  ## Lists profile-user links for a given view (profile).
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve the profile-user links for. Can either be a specific profile ID or '~all', which refers to all the profiles that user has access to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID which the given view (profile) belongs to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID which the given view (profile) belongs to. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of profile-user links to include in this response.
  ##   startIndex: int
  ##             : An index of the first profile-user link to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589939 = newJObject()
  var query_589940 = newJObject()
  add(path_589939, "profileId", newJString(profileId))
  add(query_589940, "fields", newJString(fields))
  add(query_589940, "quotaUser", newJString(quotaUser))
  add(query_589940, "alt", newJString(alt))
  add(query_589940, "oauth_token", newJString(oauthToken))
  add(path_589939, "accountId", newJString(accountId))
  add(query_589940, "userIp", newJString(userIp))
  add(path_589939, "webPropertyId", newJString(webPropertyId))
  add(query_589940, "key", newJString(key))
  add(query_589940, "max-results", newJInt(maxResults))
  add(query_589940, "start-index", newJInt(startIndex))
  add(query_589940, "prettyPrint", newJBool(prettyPrint))
  result = call_589938.call(path_589939, query_589940, nil, nil, nil)

var analyticsManagementProfileUserLinksList* = Call_AnalyticsManagementProfileUserLinksList_589922(
    name: "analyticsManagementProfileUserLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks",
    validator: validate_AnalyticsManagementProfileUserLinksList_589923,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksList_589924,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksUpdate_589960 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfileUserLinksUpdate_589962(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/entityUserLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileUserLinksUpdate_589961(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates permissions for an existing user on the given view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile ID) to update the user link for.
  ##   accountId: JString (required)
  ##            : Account ID to update the user link for.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to update the user link for.
  ##   linkId: JString (required)
  ##         : Link ID to update the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_589963 = path.getOrDefault("profileId")
  valid_589963 = validateParameter(valid_589963, JString, required = true,
                                 default = nil)
  if valid_589963 != nil:
    section.add "profileId", valid_589963
  var valid_589964 = path.getOrDefault("accountId")
  valid_589964 = validateParameter(valid_589964, JString, required = true,
                                 default = nil)
  if valid_589964 != nil:
    section.add "accountId", valid_589964
  var valid_589965 = path.getOrDefault("webPropertyId")
  valid_589965 = validateParameter(valid_589965, JString, required = true,
                                 default = nil)
  if valid_589965 != nil:
    section.add "webPropertyId", valid_589965
  var valid_589966 = path.getOrDefault("linkId")
  valid_589966 = validateParameter(valid_589966, JString, required = true,
                                 default = nil)
  if valid_589966 != nil:
    section.add "linkId", valid_589966
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589967 = query.getOrDefault("fields")
  valid_589967 = validateParameter(valid_589967, JString, required = false,
                                 default = nil)
  if valid_589967 != nil:
    section.add "fields", valid_589967
  var valid_589968 = query.getOrDefault("quotaUser")
  valid_589968 = validateParameter(valid_589968, JString, required = false,
                                 default = nil)
  if valid_589968 != nil:
    section.add "quotaUser", valid_589968
  var valid_589969 = query.getOrDefault("alt")
  valid_589969 = validateParameter(valid_589969, JString, required = false,
                                 default = newJString("json"))
  if valid_589969 != nil:
    section.add "alt", valid_589969
  var valid_589970 = query.getOrDefault("oauth_token")
  valid_589970 = validateParameter(valid_589970, JString, required = false,
                                 default = nil)
  if valid_589970 != nil:
    section.add "oauth_token", valid_589970
  var valid_589971 = query.getOrDefault("userIp")
  valid_589971 = validateParameter(valid_589971, JString, required = false,
                                 default = nil)
  if valid_589971 != nil:
    section.add "userIp", valid_589971
  var valid_589972 = query.getOrDefault("key")
  valid_589972 = validateParameter(valid_589972, JString, required = false,
                                 default = nil)
  if valid_589972 != nil:
    section.add "key", valid_589972
  var valid_589973 = query.getOrDefault("prettyPrint")
  valid_589973 = validateParameter(valid_589973, JBool, required = false,
                                 default = newJBool(false))
  if valid_589973 != nil:
    section.add "prettyPrint", valid_589973
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_589975: Call_AnalyticsManagementProfileUserLinksUpdate_589960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates permissions for an existing user on the given view (profile).
  ## 
  let valid = call_589975.validator(path, query, header, formData, body)
  let scheme = call_589975.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589975.url(scheme.get, call_589975.host, call_589975.base,
                         call_589975.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589975, url, valid)

proc call*(call_589976: Call_AnalyticsManagementProfileUserLinksUpdate_589960;
          profileId: string; accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileUserLinksUpdate
  ## Updates permissions for an existing user on the given view (profile).
  ##   profileId: string (required)
  ##            : View (Profile ID) to update the user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to update the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to update the user link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : Link ID to update the user link for.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589977 = newJObject()
  var query_589978 = newJObject()
  var body_589979 = newJObject()
  add(path_589977, "profileId", newJString(profileId))
  add(query_589978, "fields", newJString(fields))
  add(query_589978, "quotaUser", newJString(quotaUser))
  add(query_589978, "alt", newJString(alt))
  add(query_589978, "oauth_token", newJString(oauthToken))
  add(path_589977, "accountId", newJString(accountId))
  add(query_589978, "userIp", newJString(userIp))
  add(path_589977, "webPropertyId", newJString(webPropertyId))
  add(query_589978, "key", newJString(key))
  add(path_589977, "linkId", newJString(linkId))
  if body != nil:
    body_589979 = body
  add(query_589978, "prettyPrint", newJBool(prettyPrint))
  result = call_589976.call(path_589977, query_589978, nil, nil, body_589979)

var analyticsManagementProfileUserLinksUpdate* = Call_AnalyticsManagementProfileUserLinksUpdate_589960(
    name: "analyticsManagementProfileUserLinksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileUserLinksUpdate_589961,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksUpdate_589962,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksDelete_589980 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfileUserLinksDelete_589982(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/entityUserLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileUserLinksDelete_589981(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes a user from the given view (profile).
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to delete the user link for.
  ##   accountId: JString (required)
  ##            : Account ID to delete the user link for.
  ##   webPropertyId: JString (required)
  ##                : Web Property ID to delete the user link for.
  ##   linkId: JString (required)
  ##         : Link ID to delete the user link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_589983 = path.getOrDefault("profileId")
  valid_589983 = validateParameter(valid_589983, JString, required = true,
                                 default = nil)
  if valid_589983 != nil:
    section.add "profileId", valid_589983
  var valid_589984 = path.getOrDefault("accountId")
  valid_589984 = validateParameter(valid_589984, JString, required = true,
                                 default = nil)
  if valid_589984 != nil:
    section.add "accountId", valid_589984
  var valid_589985 = path.getOrDefault("webPropertyId")
  valid_589985 = validateParameter(valid_589985, JString, required = true,
                                 default = nil)
  if valid_589985 != nil:
    section.add "webPropertyId", valid_589985
  var valid_589986 = path.getOrDefault("linkId")
  valid_589986 = validateParameter(valid_589986, JString, required = true,
                                 default = nil)
  if valid_589986 != nil:
    section.add "linkId", valid_589986
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589987 = query.getOrDefault("fields")
  valid_589987 = validateParameter(valid_589987, JString, required = false,
                                 default = nil)
  if valid_589987 != nil:
    section.add "fields", valid_589987
  var valid_589988 = query.getOrDefault("quotaUser")
  valid_589988 = validateParameter(valid_589988, JString, required = false,
                                 default = nil)
  if valid_589988 != nil:
    section.add "quotaUser", valid_589988
  var valid_589989 = query.getOrDefault("alt")
  valid_589989 = validateParameter(valid_589989, JString, required = false,
                                 default = newJString("json"))
  if valid_589989 != nil:
    section.add "alt", valid_589989
  var valid_589990 = query.getOrDefault("oauth_token")
  valid_589990 = validateParameter(valid_589990, JString, required = false,
                                 default = nil)
  if valid_589990 != nil:
    section.add "oauth_token", valid_589990
  var valid_589991 = query.getOrDefault("userIp")
  valid_589991 = validateParameter(valid_589991, JString, required = false,
                                 default = nil)
  if valid_589991 != nil:
    section.add "userIp", valid_589991
  var valid_589992 = query.getOrDefault("key")
  valid_589992 = validateParameter(valid_589992, JString, required = false,
                                 default = nil)
  if valid_589992 != nil:
    section.add "key", valid_589992
  var valid_589993 = query.getOrDefault("prettyPrint")
  valid_589993 = validateParameter(valid_589993, JBool, required = false,
                                 default = newJBool(false))
  if valid_589993 != nil:
    section.add "prettyPrint", valid_589993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589994: Call_AnalyticsManagementProfileUserLinksDelete_589980;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the given view (profile).
  ## 
  let valid = call_589994.validator(path, query, header, formData, body)
  let scheme = call_589994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589994.url(scheme.get, call_589994.host, call_589994.base,
                         call_589994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589994, url, valid)

proc call*(call_589995: Call_AnalyticsManagementProfileUserLinksDelete_589980;
          profileId: string; accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileUserLinksDelete
  ## Removes a user from the given view (profile).
  ##   profileId: string (required)
  ##            : View (Profile) ID to delete the user link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to delete the user link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web Property ID to delete the user link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : Link ID to delete the user link for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589996 = newJObject()
  var query_589997 = newJObject()
  add(path_589996, "profileId", newJString(profileId))
  add(query_589997, "fields", newJString(fields))
  add(query_589997, "quotaUser", newJString(quotaUser))
  add(query_589997, "alt", newJString(alt))
  add(query_589997, "oauth_token", newJString(oauthToken))
  add(path_589996, "accountId", newJString(accountId))
  add(query_589997, "userIp", newJString(userIp))
  add(path_589996, "webPropertyId", newJString(webPropertyId))
  add(query_589997, "key", newJString(key))
  add(path_589996, "linkId", newJString(linkId))
  add(query_589997, "prettyPrint", newJBool(prettyPrint))
  result = call_589995.call(path_589996, query_589997, nil, nil, nil)

var analyticsManagementProfileUserLinksDelete* = Call_AnalyticsManagementProfileUserLinksDelete_589980(
    name: "analyticsManagementProfileUserLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileUserLinksDelete_589981,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksDelete_589982,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsInsert_590017 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementExperimentsInsert_590019(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/experiments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsInsert_590018(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to create the experiment for.
  ##   accountId: JString (required)
  ##            : Account ID to create the experiment for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the experiment for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590020 = path.getOrDefault("profileId")
  valid_590020 = validateParameter(valid_590020, JString, required = true,
                                 default = nil)
  if valid_590020 != nil:
    section.add "profileId", valid_590020
  var valid_590021 = path.getOrDefault("accountId")
  valid_590021 = validateParameter(valid_590021, JString, required = true,
                                 default = nil)
  if valid_590021 != nil:
    section.add "accountId", valid_590021
  var valid_590022 = path.getOrDefault("webPropertyId")
  valid_590022 = validateParameter(valid_590022, JString, required = true,
                                 default = nil)
  if valid_590022 != nil:
    section.add "webPropertyId", valid_590022
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590023 = query.getOrDefault("fields")
  valid_590023 = validateParameter(valid_590023, JString, required = false,
                                 default = nil)
  if valid_590023 != nil:
    section.add "fields", valid_590023
  var valid_590024 = query.getOrDefault("quotaUser")
  valid_590024 = validateParameter(valid_590024, JString, required = false,
                                 default = nil)
  if valid_590024 != nil:
    section.add "quotaUser", valid_590024
  var valid_590025 = query.getOrDefault("alt")
  valid_590025 = validateParameter(valid_590025, JString, required = false,
                                 default = newJString("json"))
  if valid_590025 != nil:
    section.add "alt", valid_590025
  var valid_590026 = query.getOrDefault("oauth_token")
  valid_590026 = validateParameter(valid_590026, JString, required = false,
                                 default = nil)
  if valid_590026 != nil:
    section.add "oauth_token", valid_590026
  var valid_590027 = query.getOrDefault("userIp")
  valid_590027 = validateParameter(valid_590027, JString, required = false,
                                 default = nil)
  if valid_590027 != nil:
    section.add "userIp", valid_590027
  var valid_590028 = query.getOrDefault("key")
  valid_590028 = validateParameter(valid_590028, JString, required = false,
                                 default = nil)
  if valid_590028 != nil:
    section.add "key", valid_590028
  var valid_590029 = query.getOrDefault("prettyPrint")
  valid_590029 = validateParameter(valid_590029, JBool, required = false,
                                 default = newJBool(false))
  if valid_590029 != nil:
    section.add "prettyPrint", valid_590029
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590031: Call_AnalyticsManagementExperimentsInsert_590017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new experiment.
  ## 
  let valid = call_590031.validator(path, query, header, formData, body)
  let scheme = call_590031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590031.url(scheme.get, call_590031.host, call_590031.base,
                         call_590031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590031, url, valid)

proc call*(call_590032: Call_AnalyticsManagementExperimentsInsert_590017;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementExperimentsInsert
  ## Create a new experiment.
  ##   profileId: string (required)
  ##            : View (Profile) ID to create the experiment for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the experiment for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the experiment for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590033 = newJObject()
  var query_590034 = newJObject()
  var body_590035 = newJObject()
  add(path_590033, "profileId", newJString(profileId))
  add(query_590034, "fields", newJString(fields))
  add(query_590034, "quotaUser", newJString(quotaUser))
  add(query_590034, "alt", newJString(alt))
  add(query_590034, "oauth_token", newJString(oauthToken))
  add(path_590033, "accountId", newJString(accountId))
  add(query_590034, "userIp", newJString(userIp))
  add(path_590033, "webPropertyId", newJString(webPropertyId))
  add(query_590034, "key", newJString(key))
  if body != nil:
    body_590035 = body
  add(query_590034, "prettyPrint", newJBool(prettyPrint))
  result = call_590032.call(path_590033, query_590034, nil, nil, body_590035)

var analyticsManagementExperimentsInsert* = Call_AnalyticsManagementExperimentsInsert_590017(
    name: "analyticsManagementExperimentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments",
    validator: validate_AnalyticsManagementExperimentsInsert_590018,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsInsert_590019,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsList_589998 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementExperimentsList_590000(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/experiments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsList_589999(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists experiments to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve experiments for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve experiments for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve experiments for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590001 = path.getOrDefault("profileId")
  valid_590001 = validateParameter(valid_590001, JString, required = true,
                                 default = nil)
  if valid_590001 != nil:
    section.add "profileId", valid_590001
  var valid_590002 = path.getOrDefault("accountId")
  valid_590002 = validateParameter(valid_590002, JString, required = true,
                                 default = nil)
  if valid_590002 != nil:
    section.add "accountId", valid_590002
  var valid_590003 = path.getOrDefault("webPropertyId")
  valid_590003 = validateParameter(valid_590003, JString, required = true,
                                 default = nil)
  if valid_590003 != nil:
    section.add "webPropertyId", valid_590003
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of experiments to include in this response.
  ##   start-index: JInt
  ##              : An index of the first experiment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590004 = query.getOrDefault("fields")
  valid_590004 = validateParameter(valid_590004, JString, required = false,
                                 default = nil)
  if valid_590004 != nil:
    section.add "fields", valid_590004
  var valid_590005 = query.getOrDefault("quotaUser")
  valid_590005 = validateParameter(valid_590005, JString, required = false,
                                 default = nil)
  if valid_590005 != nil:
    section.add "quotaUser", valid_590005
  var valid_590006 = query.getOrDefault("alt")
  valid_590006 = validateParameter(valid_590006, JString, required = false,
                                 default = newJString("json"))
  if valid_590006 != nil:
    section.add "alt", valid_590006
  var valid_590007 = query.getOrDefault("oauth_token")
  valid_590007 = validateParameter(valid_590007, JString, required = false,
                                 default = nil)
  if valid_590007 != nil:
    section.add "oauth_token", valid_590007
  var valid_590008 = query.getOrDefault("userIp")
  valid_590008 = validateParameter(valid_590008, JString, required = false,
                                 default = nil)
  if valid_590008 != nil:
    section.add "userIp", valid_590008
  var valid_590009 = query.getOrDefault("key")
  valid_590009 = validateParameter(valid_590009, JString, required = false,
                                 default = nil)
  if valid_590009 != nil:
    section.add "key", valid_590009
  var valid_590010 = query.getOrDefault("max-results")
  valid_590010 = validateParameter(valid_590010, JInt, required = false, default = nil)
  if valid_590010 != nil:
    section.add "max-results", valid_590010
  var valid_590011 = query.getOrDefault("start-index")
  valid_590011 = validateParameter(valid_590011, JInt, required = false, default = nil)
  if valid_590011 != nil:
    section.add "start-index", valid_590011
  var valid_590012 = query.getOrDefault("prettyPrint")
  valid_590012 = validateParameter(valid_590012, JBool, required = false,
                                 default = newJBool(false))
  if valid_590012 != nil:
    section.add "prettyPrint", valid_590012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590013: Call_AnalyticsManagementExperimentsList_589998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists experiments to which the user has access.
  ## 
  let valid = call_590013.validator(path, query, header, formData, body)
  let scheme = call_590013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590013.url(scheme.get, call_590013.host, call_590013.base,
                         call_590013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590013, url, valid)

proc call*(call_590014: Call_AnalyticsManagementExperimentsList_589998;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementExperimentsList
  ## Lists experiments to which the user has access.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve experiments for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve experiments for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve experiments for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of experiments to include in this response.
  ##   startIndex: int
  ##             : An index of the first experiment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590015 = newJObject()
  var query_590016 = newJObject()
  add(path_590015, "profileId", newJString(profileId))
  add(query_590016, "fields", newJString(fields))
  add(query_590016, "quotaUser", newJString(quotaUser))
  add(query_590016, "alt", newJString(alt))
  add(query_590016, "oauth_token", newJString(oauthToken))
  add(path_590015, "accountId", newJString(accountId))
  add(query_590016, "userIp", newJString(userIp))
  add(path_590015, "webPropertyId", newJString(webPropertyId))
  add(query_590016, "key", newJString(key))
  add(query_590016, "max-results", newJInt(maxResults))
  add(query_590016, "start-index", newJInt(startIndex))
  add(query_590016, "prettyPrint", newJBool(prettyPrint))
  result = call_590014.call(path_590015, query_590016, nil, nil, nil)

var analyticsManagementExperimentsList* = Call_AnalyticsManagementExperimentsList_589998(
    name: "analyticsManagementExperimentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments",
    validator: validate_AnalyticsManagementExperimentsList_589999,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsList_590000,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsUpdate_590054 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementExperimentsUpdate_590056(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "experimentId" in path, "`experimentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsUpdate_590055(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID of the experiment to update.
  ##   accountId: JString (required)
  ##            : Account ID of the experiment to update.
  ##   experimentId: JString (required)
  ##               : Experiment ID of the experiment to update.
  ##   webPropertyId: JString (required)
  ##                : Web property ID of the experiment to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590057 = path.getOrDefault("profileId")
  valid_590057 = validateParameter(valid_590057, JString, required = true,
                                 default = nil)
  if valid_590057 != nil:
    section.add "profileId", valid_590057
  var valid_590058 = path.getOrDefault("accountId")
  valid_590058 = validateParameter(valid_590058, JString, required = true,
                                 default = nil)
  if valid_590058 != nil:
    section.add "accountId", valid_590058
  var valid_590059 = path.getOrDefault("experimentId")
  valid_590059 = validateParameter(valid_590059, JString, required = true,
                                 default = nil)
  if valid_590059 != nil:
    section.add "experimentId", valid_590059
  var valid_590060 = path.getOrDefault("webPropertyId")
  valid_590060 = validateParameter(valid_590060, JString, required = true,
                                 default = nil)
  if valid_590060 != nil:
    section.add "webPropertyId", valid_590060
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590061 = query.getOrDefault("fields")
  valid_590061 = validateParameter(valid_590061, JString, required = false,
                                 default = nil)
  if valid_590061 != nil:
    section.add "fields", valid_590061
  var valid_590062 = query.getOrDefault("quotaUser")
  valid_590062 = validateParameter(valid_590062, JString, required = false,
                                 default = nil)
  if valid_590062 != nil:
    section.add "quotaUser", valid_590062
  var valid_590063 = query.getOrDefault("alt")
  valid_590063 = validateParameter(valid_590063, JString, required = false,
                                 default = newJString("json"))
  if valid_590063 != nil:
    section.add "alt", valid_590063
  var valid_590064 = query.getOrDefault("oauth_token")
  valid_590064 = validateParameter(valid_590064, JString, required = false,
                                 default = nil)
  if valid_590064 != nil:
    section.add "oauth_token", valid_590064
  var valid_590065 = query.getOrDefault("userIp")
  valid_590065 = validateParameter(valid_590065, JString, required = false,
                                 default = nil)
  if valid_590065 != nil:
    section.add "userIp", valid_590065
  var valid_590066 = query.getOrDefault("key")
  valid_590066 = validateParameter(valid_590066, JString, required = false,
                                 default = nil)
  if valid_590066 != nil:
    section.add "key", valid_590066
  var valid_590067 = query.getOrDefault("prettyPrint")
  valid_590067 = validateParameter(valid_590067, JBool, required = false,
                                 default = newJBool(false))
  if valid_590067 != nil:
    section.add "prettyPrint", valid_590067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590069: Call_AnalyticsManagementExperimentsUpdate_590054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing experiment.
  ## 
  let valid = call_590069.validator(path, query, header, formData, body)
  let scheme = call_590069.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590069.url(scheme.get, call_590069.host, call_590069.base,
                         call_590069.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590069, url, valid)

proc call*(call_590070: Call_AnalyticsManagementExperimentsUpdate_590054;
          profileId: string; accountId: string; experimentId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementExperimentsUpdate
  ## Update an existing experiment.
  ##   profileId: string (required)
  ##            : View (Profile) ID of the experiment to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID of the experiment to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   experimentId: string (required)
  ##               : Experiment ID of the experiment to update.
  ##   webPropertyId: string (required)
  ##                : Web property ID of the experiment to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590071 = newJObject()
  var query_590072 = newJObject()
  var body_590073 = newJObject()
  add(path_590071, "profileId", newJString(profileId))
  add(query_590072, "fields", newJString(fields))
  add(query_590072, "quotaUser", newJString(quotaUser))
  add(query_590072, "alt", newJString(alt))
  add(query_590072, "oauth_token", newJString(oauthToken))
  add(path_590071, "accountId", newJString(accountId))
  add(query_590072, "userIp", newJString(userIp))
  add(path_590071, "experimentId", newJString(experimentId))
  add(path_590071, "webPropertyId", newJString(webPropertyId))
  add(query_590072, "key", newJString(key))
  if body != nil:
    body_590073 = body
  add(query_590072, "prettyPrint", newJBool(prettyPrint))
  result = call_590070.call(path_590071, query_590072, nil, nil, body_590073)

var analyticsManagementExperimentsUpdate* = Call_AnalyticsManagementExperimentsUpdate_590054(
    name: "analyticsManagementExperimentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsUpdate_590055,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsUpdate_590056,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsGet_590036 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementExperimentsGet_590038(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "experimentId" in path, "`experimentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsGet_590037(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an experiment to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve the experiment for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the experiment for.
  ##   experimentId: JString (required)
  ##               : Experiment ID to retrieve the experiment for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the experiment for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590039 = path.getOrDefault("profileId")
  valid_590039 = validateParameter(valid_590039, JString, required = true,
                                 default = nil)
  if valid_590039 != nil:
    section.add "profileId", valid_590039
  var valid_590040 = path.getOrDefault("accountId")
  valid_590040 = validateParameter(valid_590040, JString, required = true,
                                 default = nil)
  if valid_590040 != nil:
    section.add "accountId", valid_590040
  var valid_590041 = path.getOrDefault("experimentId")
  valid_590041 = validateParameter(valid_590041, JString, required = true,
                                 default = nil)
  if valid_590041 != nil:
    section.add "experimentId", valid_590041
  var valid_590042 = path.getOrDefault("webPropertyId")
  valid_590042 = validateParameter(valid_590042, JString, required = true,
                                 default = nil)
  if valid_590042 != nil:
    section.add "webPropertyId", valid_590042
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590043 = query.getOrDefault("fields")
  valid_590043 = validateParameter(valid_590043, JString, required = false,
                                 default = nil)
  if valid_590043 != nil:
    section.add "fields", valid_590043
  var valid_590044 = query.getOrDefault("quotaUser")
  valid_590044 = validateParameter(valid_590044, JString, required = false,
                                 default = nil)
  if valid_590044 != nil:
    section.add "quotaUser", valid_590044
  var valid_590045 = query.getOrDefault("alt")
  valid_590045 = validateParameter(valid_590045, JString, required = false,
                                 default = newJString("json"))
  if valid_590045 != nil:
    section.add "alt", valid_590045
  var valid_590046 = query.getOrDefault("oauth_token")
  valid_590046 = validateParameter(valid_590046, JString, required = false,
                                 default = nil)
  if valid_590046 != nil:
    section.add "oauth_token", valid_590046
  var valid_590047 = query.getOrDefault("userIp")
  valid_590047 = validateParameter(valid_590047, JString, required = false,
                                 default = nil)
  if valid_590047 != nil:
    section.add "userIp", valid_590047
  var valid_590048 = query.getOrDefault("key")
  valid_590048 = validateParameter(valid_590048, JString, required = false,
                                 default = nil)
  if valid_590048 != nil:
    section.add "key", valid_590048
  var valid_590049 = query.getOrDefault("prettyPrint")
  valid_590049 = validateParameter(valid_590049, JBool, required = false,
                                 default = newJBool(false))
  if valid_590049 != nil:
    section.add "prettyPrint", valid_590049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590050: Call_AnalyticsManagementExperimentsGet_590036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns an experiment to which the user has access.
  ## 
  let valid = call_590050.validator(path, query, header, formData, body)
  let scheme = call_590050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590050.url(scheme.get, call_590050.host, call_590050.base,
                         call_590050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590050, url, valid)

proc call*(call_590051: Call_AnalyticsManagementExperimentsGet_590036;
          profileId: string; accountId: string; experimentId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementExperimentsGet
  ## Returns an experiment to which the user has access.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve the experiment for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the experiment for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   experimentId: string (required)
  ##               : Experiment ID to retrieve the experiment for.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the experiment for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590052 = newJObject()
  var query_590053 = newJObject()
  add(path_590052, "profileId", newJString(profileId))
  add(query_590053, "fields", newJString(fields))
  add(query_590053, "quotaUser", newJString(quotaUser))
  add(query_590053, "alt", newJString(alt))
  add(query_590053, "oauth_token", newJString(oauthToken))
  add(path_590052, "accountId", newJString(accountId))
  add(query_590053, "userIp", newJString(userIp))
  add(path_590052, "experimentId", newJString(experimentId))
  add(path_590052, "webPropertyId", newJString(webPropertyId))
  add(query_590053, "key", newJString(key))
  add(query_590053, "prettyPrint", newJBool(prettyPrint))
  result = call_590051.call(path_590052, query_590053, nil, nil, nil)

var analyticsManagementExperimentsGet* = Call_AnalyticsManagementExperimentsGet_590036(
    name: "analyticsManagementExperimentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsGet_590037,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsGet_590038,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsPatch_590092 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementExperimentsPatch_590094(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "experimentId" in path, "`experimentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsPatch_590093(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing experiment. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID of the experiment to update.
  ##   accountId: JString (required)
  ##            : Account ID of the experiment to update.
  ##   experimentId: JString (required)
  ##               : Experiment ID of the experiment to update.
  ##   webPropertyId: JString (required)
  ##                : Web property ID of the experiment to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590095 = path.getOrDefault("profileId")
  valid_590095 = validateParameter(valid_590095, JString, required = true,
                                 default = nil)
  if valid_590095 != nil:
    section.add "profileId", valid_590095
  var valid_590096 = path.getOrDefault("accountId")
  valid_590096 = validateParameter(valid_590096, JString, required = true,
                                 default = nil)
  if valid_590096 != nil:
    section.add "accountId", valid_590096
  var valid_590097 = path.getOrDefault("experimentId")
  valid_590097 = validateParameter(valid_590097, JString, required = true,
                                 default = nil)
  if valid_590097 != nil:
    section.add "experimentId", valid_590097
  var valid_590098 = path.getOrDefault("webPropertyId")
  valid_590098 = validateParameter(valid_590098, JString, required = true,
                                 default = nil)
  if valid_590098 != nil:
    section.add "webPropertyId", valid_590098
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590099 = query.getOrDefault("fields")
  valid_590099 = validateParameter(valid_590099, JString, required = false,
                                 default = nil)
  if valid_590099 != nil:
    section.add "fields", valid_590099
  var valid_590100 = query.getOrDefault("quotaUser")
  valid_590100 = validateParameter(valid_590100, JString, required = false,
                                 default = nil)
  if valid_590100 != nil:
    section.add "quotaUser", valid_590100
  var valid_590101 = query.getOrDefault("alt")
  valid_590101 = validateParameter(valid_590101, JString, required = false,
                                 default = newJString("json"))
  if valid_590101 != nil:
    section.add "alt", valid_590101
  var valid_590102 = query.getOrDefault("oauth_token")
  valid_590102 = validateParameter(valid_590102, JString, required = false,
                                 default = nil)
  if valid_590102 != nil:
    section.add "oauth_token", valid_590102
  var valid_590103 = query.getOrDefault("userIp")
  valid_590103 = validateParameter(valid_590103, JString, required = false,
                                 default = nil)
  if valid_590103 != nil:
    section.add "userIp", valid_590103
  var valid_590104 = query.getOrDefault("key")
  valid_590104 = validateParameter(valid_590104, JString, required = false,
                                 default = nil)
  if valid_590104 != nil:
    section.add "key", valid_590104
  var valid_590105 = query.getOrDefault("prettyPrint")
  valid_590105 = validateParameter(valid_590105, JBool, required = false,
                                 default = newJBool(false))
  if valid_590105 != nil:
    section.add "prettyPrint", valid_590105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590107: Call_AnalyticsManagementExperimentsPatch_590092;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing experiment. This method supports patch semantics.
  ## 
  let valid = call_590107.validator(path, query, header, formData, body)
  let scheme = call_590107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590107.url(scheme.get, call_590107.host, call_590107.base,
                         call_590107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590107, url, valid)

proc call*(call_590108: Call_AnalyticsManagementExperimentsPatch_590092;
          profileId: string; accountId: string; experimentId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementExperimentsPatch
  ## Update an existing experiment. This method supports patch semantics.
  ##   profileId: string (required)
  ##            : View (Profile) ID of the experiment to update.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID of the experiment to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   experimentId: string (required)
  ##               : Experiment ID of the experiment to update.
  ##   webPropertyId: string (required)
  ##                : Web property ID of the experiment to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590109 = newJObject()
  var query_590110 = newJObject()
  var body_590111 = newJObject()
  add(path_590109, "profileId", newJString(profileId))
  add(query_590110, "fields", newJString(fields))
  add(query_590110, "quotaUser", newJString(quotaUser))
  add(query_590110, "alt", newJString(alt))
  add(query_590110, "oauth_token", newJString(oauthToken))
  add(path_590109, "accountId", newJString(accountId))
  add(query_590110, "userIp", newJString(userIp))
  add(path_590109, "experimentId", newJString(experimentId))
  add(path_590109, "webPropertyId", newJString(webPropertyId))
  add(query_590110, "key", newJString(key))
  if body != nil:
    body_590111 = body
  add(query_590110, "prettyPrint", newJBool(prettyPrint))
  result = call_590108.call(path_590109, query_590110, nil, nil, body_590111)

var analyticsManagementExperimentsPatch* = Call_AnalyticsManagementExperimentsPatch_590092(
    name: "analyticsManagementExperimentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsPatch_590093,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsPatch_590094,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsDelete_590074 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementExperimentsDelete_590076(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "experimentId" in path, "`experimentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/experiments/"),
               (kind: VariableSegment, value: "experimentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementExperimentsDelete_590075(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete an experiment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to which the experiment belongs
  ##   accountId: JString (required)
  ##            : Account ID to which the experiment belongs
  ##   experimentId: JString (required)
  ##               : ID of the experiment to delete
  ##   webPropertyId: JString (required)
  ##                : Web property ID to which the experiment belongs
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590077 = path.getOrDefault("profileId")
  valid_590077 = validateParameter(valid_590077, JString, required = true,
                                 default = nil)
  if valid_590077 != nil:
    section.add "profileId", valid_590077
  var valid_590078 = path.getOrDefault("accountId")
  valid_590078 = validateParameter(valid_590078, JString, required = true,
                                 default = nil)
  if valid_590078 != nil:
    section.add "accountId", valid_590078
  var valid_590079 = path.getOrDefault("experimentId")
  valid_590079 = validateParameter(valid_590079, JString, required = true,
                                 default = nil)
  if valid_590079 != nil:
    section.add "experimentId", valid_590079
  var valid_590080 = path.getOrDefault("webPropertyId")
  valid_590080 = validateParameter(valid_590080, JString, required = true,
                                 default = nil)
  if valid_590080 != nil:
    section.add "webPropertyId", valid_590080
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590081 = query.getOrDefault("fields")
  valid_590081 = validateParameter(valid_590081, JString, required = false,
                                 default = nil)
  if valid_590081 != nil:
    section.add "fields", valid_590081
  var valid_590082 = query.getOrDefault("quotaUser")
  valid_590082 = validateParameter(valid_590082, JString, required = false,
                                 default = nil)
  if valid_590082 != nil:
    section.add "quotaUser", valid_590082
  var valid_590083 = query.getOrDefault("alt")
  valid_590083 = validateParameter(valid_590083, JString, required = false,
                                 default = newJString("json"))
  if valid_590083 != nil:
    section.add "alt", valid_590083
  var valid_590084 = query.getOrDefault("oauth_token")
  valid_590084 = validateParameter(valid_590084, JString, required = false,
                                 default = nil)
  if valid_590084 != nil:
    section.add "oauth_token", valid_590084
  var valid_590085 = query.getOrDefault("userIp")
  valid_590085 = validateParameter(valid_590085, JString, required = false,
                                 default = nil)
  if valid_590085 != nil:
    section.add "userIp", valid_590085
  var valid_590086 = query.getOrDefault("key")
  valid_590086 = validateParameter(valid_590086, JString, required = false,
                                 default = nil)
  if valid_590086 != nil:
    section.add "key", valid_590086
  var valid_590087 = query.getOrDefault("prettyPrint")
  valid_590087 = validateParameter(valid_590087, JBool, required = false,
                                 default = newJBool(false))
  if valid_590087 != nil:
    section.add "prettyPrint", valid_590087
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590088: Call_AnalyticsManagementExperimentsDelete_590074;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an experiment.
  ## 
  let valid = call_590088.validator(path, query, header, formData, body)
  let scheme = call_590088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590088.url(scheme.get, call_590088.host, call_590088.base,
                         call_590088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590088, url, valid)

proc call*(call_590089: Call_AnalyticsManagementExperimentsDelete_590074;
          profileId: string; accountId: string; experimentId: string;
          webPropertyId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementExperimentsDelete
  ## Delete an experiment.
  ##   profileId: string (required)
  ##            : View (Profile) ID to which the experiment belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the experiment belongs
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   experimentId: string (required)
  ##               : ID of the experiment to delete
  ##   webPropertyId: string (required)
  ##                : Web property ID to which the experiment belongs
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590090 = newJObject()
  var query_590091 = newJObject()
  add(path_590090, "profileId", newJString(profileId))
  add(query_590091, "fields", newJString(fields))
  add(query_590091, "quotaUser", newJString(quotaUser))
  add(query_590091, "alt", newJString(alt))
  add(query_590091, "oauth_token", newJString(oauthToken))
  add(path_590090, "accountId", newJString(accountId))
  add(query_590091, "userIp", newJString(userIp))
  add(path_590090, "experimentId", newJString(experimentId))
  add(path_590090, "webPropertyId", newJString(webPropertyId))
  add(query_590091, "key", newJString(key))
  add(query_590091, "prettyPrint", newJBool(prettyPrint))
  result = call_590089.call(path_590090, query_590091, nil, nil, nil)

var analyticsManagementExperimentsDelete* = Call_AnalyticsManagementExperimentsDelete_590074(
    name: "analyticsManagementExperimentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsDelete_590075,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsDelete_590076,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsInsert_590131 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementGoalsInsert_590133(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/goals")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementGoalsInsert_590132(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new goal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to create the goal for.
  ##   accountId: JString (required)
  ##            : Account ID to create the goal for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the goal for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590134 = path.getOrDefault("profileId")
  valid_590134 = validateParameter(valid_590134, JString, required = true,
                                 default = nil)
  if valid_590134 != nil:
    section.add "profileId", valid_590134
  var valid_590135 = path.getOrDefault("accountId")
  valid_590135 = validateParameter(valid_590135, JString, required = true,
                                 default = nil)
  if valid_590135 != nil:
    section.add "accountId", valid_590135
  var valid_590136 = path.getOrDefault("webPropertyId")
  valid_590136 = validateParameter(valid_590136, JString, required = true,
                                 default = nil)
  if valid_590136 != nil:
    section.add "webPropertyId", valid_590136
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590137 = query.getOrDefault("fields")
  valid_590137 = validateParameter(valid_590137, JString, required = false,
                                 default = nil)
  if valid_590137 != nil:
    section.add "fields", valid_590137
  var valid_590138 = query.getOrDefault("quotaUser")
  valid_590138 = validateParameter(valid_590138, JString, required = false,
                                 default = nil)
  if valid_590138 != nil:
    section.add "quotaUser", valid_590138
  var valid_590139 = query.getOrDefault("alt")
  valid_590139 = validateParameter(valid_590139, JString, required = false,
                                 default = newJString("json"))
  if valid_590139 != nil:
    section.add "alt", valid_590139
  var valid_590140 = query.getOrDefault("oauth_token")
  valid_590140 = validateParameter(valid_590140, JString, required = false,
                                 default = nil)
  if valid_590140 != nil:
    section.add "oauth_token", valid_590140
  var valid_590141 = query.getOrDefault("userIp")
  valid_590141 = validateParameter(valid_590141, JString, required = false,
                                 default = nil)
  if valid_590141 != nil:
    section.add "userIp", valid_590141
  var valid_590142 = query.getOrDefault("key")
  valid_590142 = validateParameter(valid_590142, JString, required = false,
                                 default = nil)
  if valid_590142 != nil:
    section.add "key", valid_590142
  var valid_590143 = query.getOrDefault("prettyPrint")
  valid_590143 = validateParameter(valid_590143, JBool, required = false,
                                 default = newJBool(false))
  if valid_590143 != nil:
    section.add "prettyPrint", valid_590143
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590145: Call_AnalyticsManagementGoalsInsert_590131; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new goal.
  ## 
  let valid = call_590145.validator(path, query, header, formData, body)
  let scheme = call_590145.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590145.url(scheme.get, call_590145.host, call_590145.base,
                         call_590145.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590145, url, valid)

proc call*(call_590146: Call_AnalyticsManagementGoalsInsert_590131;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementGoalsInsert
  ## Create a new goal.
  ##   profileId: string (required)
  ##            : View (Profile) ID to create the goal for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the goal for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the goal for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590147 = newJObject()
  var query_590148 = newJObject()
  var body_590149 = newJObject()
  add(path_590147, "profileId", newJString(profileId))
  add(query_590148, "fields", newJString(fields))
  add(query_590148, "quotaUser", newJString(quotaUser))
  add(query_590148, "alt", newJString(alt))
  add(query_590148, "oauth_token", newJString(oauthToken))
  add(path_590147, "accountId", newJString(accountId))
  add(query_590148, "userIp", newJString(userIp))
  add(path_590147, "webPropertyId", newJString(webPropertyId))
  add(query_590148, "key", newJString(key))
  if body != nil:
    body_590149 = body
  add(query_590148, "prettyPrint", newJBool(prettyPrint))
  result = call_590146.call(path_590147, query_590148, nil, nil, body_590149)

var analyticsManagementGoalsInsert* = Call_AnalyticsManagementGoalsInsert_590131(
    name: "analyticsManagementGoalsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals",
    validator: validate_AnalyticsManagementGoalsInsert_590132,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsInsert_590133,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsList_590112 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementGoalsList_590114(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/goals")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementGoalsList_590113(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists goals to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve goals for. Can either be a specific view (profile) ID or '~all', which refers to all the views (profiles) that user has access to.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve goals for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve goals for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590115 = path.getOrDefault("profileId")
  valid_590115 = validateParameter(valid_590115, JString, required = true,
                                 default = nil)
  if valid_590115 != nil:
    section.add "profileId", valid_590115
  var valid_590116 = path.getOrDefault("accountId")
  valid_590116 = validateParameter(valid_590116, JString, required = true,
                                 default = nil)
  if valid_590116 != nil:
    section.add "accountId", valid_590116
  var valid_590117 = path.getOrDefault("webPropertyId")
  valid_590117 = validateParameter(valid_590117, JString, required = true,
                                 default = nil)
  if valid_590117 != nil:
    section.add "webPropertyId", valid_590117
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of goals to include in this response.
  ##   start-index: JInt
  ##              : An index of the first goal to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590118 = query.getOrDefault("fields")
  valid_590118 = validateParameter(valid_590118, JString, required = false,
                                 default = nil)
  if valid_590118 != nil:
    section.add "fields", valid_590118
  var valid_590119 = query.getOrDefault("quotaUser")
  valid_590119 = validateParameter(valid_590119, JString, required = false,
                                 default = nil)
  if valid_590119 != nil:
    section.add "quotaUser", valid_590119
  var valid_590120 = query.getOrDefault("alt")
  valid_590120 = validateParameter(valid_590120, JString, required = false,
                                 default = newJString("json"))
  if valid_590120 != nil:
    section.add "alt", valid_590120
  var valid_590121 = query.getOrDefault("oauth_token")
  valid_590121 = validateParameter(valid_590121, JString, required = false,
                                 default = nil)
  if valid_590121 != nil:
    section.add "oauth_token", valid_590121
  var valid_590122 = query.getOrDefault("userIp")
  valid_590122 = validateParameter(valid_590122, JString, required = false,
                                 default = nil)
  if valid_590122 != nil:
    section.add "userIp", valid_590122
  var valid_590123 = query.getOrDefault("key")
  valid_590123 = validateParameter(valid_590123, JString, required = false,
                                 default = nil)
  if valid_590123 != nil:
    section.add "key", valid_590123
  var valid_590124 = query.getOrDefault("max-results")
  valid_590124 = validateParameter(valid_590124, JInt, required = false, default = nil)
  if valid_590124 != nil:
    section.add "max-results", valid_590124
  var valid_590125 = query.getOrDefault("start-index")
  valid_590125 = validateParameter(valid_590125, JInt, required = false, default = nil)
  if valid_590125 != nil:
    section.add "start-index", valid_590125
  var valid_590126 = query.getOrDefault("prettyPrint")
  valid_590126 = validateParameter(valid_590126, JBool, required = false,
                                 default = newJBool(false))
  if valid_590126 != nil:
    section.add "prettyPrint", valid_590126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590127: Call_AnalyticsManagementGoalsList_590112; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists goals to which the user has access.
  ## 
  let valid = call_590127.validator(path, query, header, formData, body)
  let scheme = call_590127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590127.url(scheme.get, call_590127.host, call_590127.base,
                         call_590127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590127, url, valid)

proc call*(call_590128: Call_AnalyticsManagementGoalsList_590112;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementGoalsList
  ## Lists goals to which the user has access.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve goals for. Can either be a specific view (profile) ID or '~all', which refers to all the views (profiles) that user has access to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve goals for. Can either be a specific account ID or '~all', which refers to all the accounts that user has access to.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve goals for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of goals to include in this response.
  ##   startIndex: int
  ##             : An index of the first goal to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590129 = newJObject()
  var query_590130 = newJObject()
  add(path_590129, "profileId", newJString(profileId))
  add(query_590130, "fields", newJString(fields))
  add(query_590130, "quotaUser", newJString(quotaUser))
  add(query_590130, "alt", newJString(alt))
  add(query_590130, "oauth_token", newJString(oauthToken))
  add(path_590129, "accountId", newJString(accountId))
  add(query_590130, "userIp", newJString(userIp))
  add(path_590129, "webPropertyId", newJString(webPropertyId))
  add(query_590130, "key", newJString(key))
  add(query_590130, "max-results", newJInt(maxResults))
  add(query_590130, "start-index", newJInt(startIndex))
  add(query_590130, "prettyPrint", newJBool(prettyPrint))
  result = call_590128.call(path_590129, query_590130, nil, nil, nil)

var analyticsManagementGoalsList* = Call_AnalyticsManagementGoalsList_590112(
    name: "analyticsManagementGoalsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals",
    validator: validate_AnalyticsManagementGoalsList_590113,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsList_590114,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsUpdate_590168 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementGoalsUpdate_590170(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "goalId" in path, "`goalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/goals/"),
               (kind: VariableSegment, value: "goalId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementGoalsUpdate_590169(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing goal.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to update the goal.
  ##   accountId: JString (required)
  ##            : Account ID to update the goal.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to update the goal.
  ##   goalId: JString (required)
  ##         : Index of the goal to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590171 = path.getOrDefault("profileId")
  valid_590171 = validateParameter(valid_590171, JString, required = true,
                                 default = nil)
  if valid_590171 != nil:
    section.add "profileId", valid_590171
  var valid_590172 = path.getOrDefault("accountId")
  valid_590172 = validateParameter(valid_590172, JString, required = true,
                                 default = nil)
  if valid_590172 != nil:
    section.add "accountId", valid_590172
  var valid_590173 = path.getOrDefault("webPropertyId")
  valid_590173 = validateParameter(valid_590173, JString, required = true,
                                 default = nil)
  if valid_590173 != nil:
    section.add "webPropertyId", valid_590173
  var valid_590174 = path.getOrDefault("goalId")
  valid_590174 = validateParameter(valid_590174, JString, required = true,
                                 default = nil)
  if valid_590174 != nil:
    section.add "goalId", valid_590174
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590175 = query.getOrDefault("fields")
  valid_590175 = validateParameter(valid_590175, JString, required = false,
                                 default = nil)
  if valid_590175 != nil:
    section.add "fields", valid_590175
  var valid_590176 = query.getOrDefault("quotaUser")
  valid_590176 = validateParameter(valid_590176, JString, required = false,
                                 default = nil)
  if valid_590176 != nil:
    section.add "quotaUser", valid_590176
  var valid_590177 = query.getOrDefault("alt")
  valid_590177 = validateParameter(valid_590177, JString, required = false,
                                 default = newJString("json"))
  if valid_590177 != nil:
    section.add "alt", valid_590177
  var valid_590178 = query.getOrDefault("oauth_token")
  valid_590178 = validateParameter(valid_590178, JString, required = false,
                                 default = nil)
  if valid_590178 != nil:
    section.add "oauth_token", valid_590178
  var valid_590179 = query.getOrDefault("userIp")
  valid_590179 = validateParameter(valid_590179, JString, required = false,
                                 default = nil)
  if valid_590179 != nil:
    section.add "userIp", valid_590179
  var valid_590180 = query.getOrDefault("key")
  valid_590180 = validateParameter(valid_590180, JString, required = false,
                                 default = nil)
  if valid_590180 != nil:
    section.add "key", valid_590180
  var valid_590181 = query.getOrDefault("prettyPrint")
  valid_590181 = validateParameter(valid_590181, JBool, required = false,
                                 default = newJBool(false))
  if valid_590181 != nil:
    section.add "prettyPrint", valid_590181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590183: Call_AnalyticsManagementGoalsUpdate_590168; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing goal.
  ## 
  let valid = call_590183.validator(path, query, header, formData, body)
  let scheme = call_590183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590183.url(scheme.get, call_590183.host, call_590183.base,
                         call_590183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590183, url, valid)

proc call*(call_590184: Call_AnalyticsManagementGoalsUpdate_590168;
          profileId: string; accountId: string; webPropertyId: string; goalId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementGoalsUpdate
  ## Updates an existing goal.
  ##   profileId: string (required)
  ##            : View (Profile) ID to update the goal.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to update the goal.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to update the goal.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   goalId: string (required)
  ##         : Index of the goal to be updated.
  var path_590185 = newJObject()
  var query_590186 = newJObject()
  var body_590187 = newJObject()
  add(path_590185, "profileId", newJString(profileId))
  add(query_590186, "fields", newJString(fields))
  add(query_590186, "quotaUser", newJString(quotaUser))
  add(query_590186, "alt", newJString(alt))
  add(query_590186, "oauth_token", newJString(oauthToken))
  add(path_590185, "accountId", newJString(accountId))
  add(query_590186, "userIp", newJString(userIp))
  add(path_590185, "webPropertyId", newJString(webPropertyId))
  add(query_590186, "key", newJString(key))
  if body != nil:
    body_590187 = body
  add(query_590186, "prettyPrint", newJBool(prettyPrint))
  add(path_590185, "goalId", newJString(goalId))
  result = call_590184.call(path_590185, query_590186, nil, nil, body_590187)

var analyticsManagementGoalsUpdate* = Call_AnalyticsManagementGoalsUpdate_590168(
    name: "analyticsManagementGoalsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals/{goalId}",
    validator: validate_AnalyticsManagementGoalsUpdate_590169,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsUpdate_590170,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsGet_590150 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementGoalsGet_590152(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "goalId" in path, "`goalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/goals/"),
               (kind: VariableSegment, value: "goalId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementGoalsGet_590151(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a goal to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve the goal for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve the goal for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve the goal for.
  ##   goalId: JString (required)
  ##         : Goal ID to retrieve the goal for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590153 = path.getOrDefault("profileId")
  valid_590153 = validateParameter(valid_590153, JString, required = true,
                                 default = nil)
  if valid_590153 != nil:
    section.add "profileId", valid_590153
  var valid_590154 = path.getOrDefault("accountId")
  valid_590154 = validateParameter(valid_590154, JString, required = true,
                                 default = nil)
  if valid_590154 != nil:
    section.add "accountId", valid_590154
  var valid_590155 = path.getOrDefault("webPropertyId")
  valid_590155 = validateParameter(valid_590155, JString, required = true,
                                 default = nil)
  if valid_590155 != nil:
    section.add "webPropertyId", valid_590155
  var valid_590156 = path.getOrDefault("goalId")
  valid_590156 = validateParameter(valid_590156, JString, required = true,
                                 default = nil)
  if valid_590156 != nil:
    section.add "goalId", valid_590156
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590157 = query.getOrDefault("fields")
  valid_590157 = validateParameter(valid_590157, JString, required = false,
                                 default = nil)
  if valid_590157 != nil:
    section.add "fields", valid_590157
  var valid_590158 = query.getOrDefault("quotaUser")
  valid_590158 = validateParameter(valid_590158, JString, required = false,
                                 default = nil)
  if valid_590158 != nil:
    section.add "quotaUser", valid_590158
  var valid_590159 = query.getOrDefault("alt")
  valid_590159 = validateParameter(valid_590159, JString, required = false,
                                 default = newJString("json"))
  if valid_590159 != nil:
    section.add "alt", valid_590159
  var valid_590160 = query.getOrDefault("oauth_token")
  valid_590160 = validateParameter(valid_590160, JString, required = false,
                                 default = nil)
  if valid_590160 != nil:
    section.add "oauth_token", valid_590160
  var valid_590161 = query.getOrDefault("userIp")
  valid_590161 = validateParameter(valid_590161, JString, required = false,
                                 default = nil)
  if valid_590161 != nil:
    section.add "userIp", valid_590161
  var valid_590162 = query.getOrDefault("key")
  valid_590162 = validateParameter(valid_590162, JString, required = false,
                                 default = nil)
  if valid_590162 != nil:
    section.add "key", valid_590162
  var valid_590163 = query.getOrDefault("prettyPrint")
  valid_590163 = validateParameter(valid_590163, JBool, required = false,
                                 default = newJBool(false))
  if valid_590163 != nil:
    section.add "prettyPrint", valid_590163
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590164: Call_AnalyticsManagementGoalsGet_590150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a goal to which the user has access.
  ## 
  let valid = call_590164.validator(path, query, header, formData, body)
  let scheme = call_590164.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590164.url(scheme.get, call_590164.host, call_590164.base,
                         call_590164.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590164, url, valid)

proc call*(call_590165: Call_AnalyticsManagementGoalsGet_590150; profileId: string;
          accountId: string; webPropertyId: string; goalId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementGoalsGet
  ## Gets a goal to which the user has access.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve the goal for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve the goal for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve the goal for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   goalId: string (required)
  ##         : Goal ID to retrieve the goal for.
  var path_590166 = newJObject()
  var query_590167 = newJObject()
  add(path_590166, "profileId", newJString(profileId))
  add(query_590167, "fields", newJString(fields))
  add(query_590167, "quotaUser", newJString(quotaUser))
  add(query_590167, "alt", newJString(alt))
  add(query_590167, "oauth_token", newJString(oauthToken))
  add(path_590166, "accountId", newJString(accountId))
  add(query_590167, "userIp", newJString(userIp))
  add(path_590166, "webPropertyId", newJString(webPropertyId))
  add(query_590167, "key", newJString(key))
  add(query_590167, "prettyPrint", newJBool(prettyPrint))
  add(path_590166, "goalId", newJString(goalId))
  result = call_590165.call(path_590166, query_590167, nil, nil, nil)

var analyticsManagementGoalsGet* = Call_AnalyticsManagementGoalsGet_590150(
    name: "analyticsManagementGoalsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals/{goalId}",
    validator: validate_AnalyticsManagementGoalsGet_590151, base: "/analytics/v3",
    url: url_AnalyticsManagementGoalsGet_590152, schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsPatch_590188 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementGoalsPatch_590190(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "goalId" in path, "`goalId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/goals/"),
               (kind: VariableSegment, value: "goalId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementGoalsPatch_590189(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing goal. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to update the goal.
  ##   accountId: JString (required)
  ##            : Account ID to update the goal.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to update the goal.
  ##   goalId: JString (required)
  ##         : Index of the goal to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590191 = path.getOrDefault("profileId")
  valid_590191 = validateParameter(valid_590191, JString, required = true,
                                 default = nil)
  if valid_590191 != nil:
    section.add "profileId", valid_590191
  var valid_590192 = path.getOrDefault("accountId")
  valid_590192 = validateParameter(valid_590192, JString, required = true,
                                 default = nil)
  if valid_590192 != nil:
    section.add "accountId", valid_590192
  var valid_590193 = path.getOrDefault("webPropertyId")
  valid_590193 = validateParameter(valid_590193, JString, required = true,
                                 default = nil)
  if valid_590193 != nil:
    section.add "webPropertyId", valid_590193
  var valid_590194 = path.getOrDefault("goalId")
  valid_590194 = validateParameter(valid_590194, JString, required = true,
                                 default = nil)
  if valid_590194 != nil:
    section.add "goalId", valid_590194
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590195 = query.getOrDefault("fields")
  valid_590195 = validateParameter(valid_590195, JString, required = false,
                                 default = nil)
  if valid_590195 != nil:
    section.add "fields", valid_590195
  var valid_590196 = query.getOrDefault("quotaUser")
  valid_590196 = validateParameter(valid_590196, JString, required = false,
                                 default = nil)
  if valid_590196 != nil:
    section.add "quotaUser", valid_590196
  var valid_590197 = query.getOrDefault("alt")
  valid_590197 = validateParameter(valid_590197, JString, required = false,
                                 default = newJString("json"))
  if valid_590197 != nil:
    section.add "alt", valid_590197
  var valid_590198 = query.getOrDefault("oauth_token")
  valid_590198 = validateParameter(valid_590198, JString, required = false,
                                 default = nil)
  if valid_590198 != nil:
    section.add "oauth_token", valid_590198
  var valid_590199 = query.getOrDefault("userIp")
  valid_590199 = validateParameter(valid_590199, JString, required = false,
                                 default = nil)
  if valid_590199 != nil:
    section.add "userIp", valid_590199
  var valid_590200 = query.getOrDefault("key")
  valid_590200 = validateParameter(valid_590200, JString, required = false,
                                 default = nil)
  if valid_590200 != nil:
    section.add "key", valid_590200
  var valid_590201 = query.getOrDefault("prettyPrint")
  valid_590201 = validateParameter(valid_590201, JBool, required = false,
                                 default = newJBool(false))
  if valid_590201 != nil:
    section.add "prettyPrint", valid_590201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590203: Call_AnalyticsManagementGoalsPatch_590188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing goal. This method supports patch semantics.
  ## 
  let valid = call_590203.validator(path, query, header, formData, body)
  let scheme = call_590203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590203.url(scheme.get, call_590203.host, call_590203.base,
                         call_590203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590203, url, valid)

proc call*(call_590204: Call_AnalyticsManagementGoalsPatch_590188;
          profileId: string; accountId: string; webPropertyId: string; goalId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementGoalsPatch
  ## Updates an existing goal. This method supports patch semantics.
  ##   profileId: string (required)
  ##            : View (Profile) ID to update the goal.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to update the goal.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to update the goal.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   goalId: string (required)
  ##         : Index of the goal to be updated.
  var path_590205 = newJObject()
  var query_590206 = newJObject()
  var body_590207 = newJObject()
  add(path_590205, "profileId", newJString(profileId))
  add(query_590206, "fields", newJString(fields))
  add(query_590206, "quotaUser", newJString(quotaUser))
  add(query_590206, "alt", newJString(alt))
  add(query_590206, "oauth_token", newJString(oauthToken))
  add(path_590205, "accountId", newJString(accountId))
  add(query_590206, "userIp", newJString(userIp))
  add(path_590205, "webPropertyId", newJString(webPropertyId))
  add(query_590206, "key", newJString(key))
  if body != nil:
    body_590207 = body
  add(query_590206, "prettyPrint", newJBool(prettyPrint))
  add(path_590205, "goalId", newJString(goalId))
  result = call_590204.call(path_590205, query_590206, nil, nil, body_590207)

var analyticsManagementGoalsPatch* = Call_AnalyticsManagementGoalsPatch_590188(
    name: "analyticsManagementGoalsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals/{goalId}",
    validator: validate_AnalyticsManagementGoalsPatch_590189,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsPatch_590190,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksInsert_590227 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfileFilterLinksInsert_590229(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/profileFilterLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksInsert_590228(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new profile filter link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : Profile ID to create filter link for.
  ##   accountId: JString (required)
  ##            : Account ID to create profile filter link for.
  ##   webPropertyId: JString (required)
  ##                : Web property Id to create profile filter link for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590230 = path.getOrDefault("profileId")
  valid_590230 = validateParameter(valid_590230, JString, required = true,
                                 default = nil)
  if valid_590230 != nil:
    section.add "profileId", valid_590230
  var valid_590231 = path.getOrDefault("accountId")
  valid_590231 = validateParameter(valid_590231, JString, required = true,
                                 default = nil)
  if valid_590231 != nil:
    section.add "accountId", valid_590231
  var valid_590232 = path.getOrDefault("webPropertyId")
  valid_590232 = validateParameter(valid_590232, JString, required = true,
                                 default = nil)
  if valid_590232 != nil:
    section.add "webPropertyId", valid_590232
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590233 = query.getOrDefault("fields")
  valid_590233 = validateParameter(valid_590233, JString, required = false,
                                 default = nil)
  if valid_590233 != nil:
    section.add "fields", valid_590233
  var valid_590234 = query.getOrDefault("quotaUser")
  valid_590234 = validateParameter(valid_590234, JString, required = false,
                                 default = nil)
  if valid_590234 != nil:
    section.add "quotaUser", valid_590234
  var valid_590235 = query.getOrDefault("alt")
  valid_590235 = validateParameter(valid_590235, JString, required = false,
                                 default = newJString("json"))
  if valid_590235 != nil:
    section.add "alt", valid_590235
  var valid_590236 = query.getOrDefault("oauth_token")
  valid_590236 = validateParameter(valid_590236, JString, required = false,
                                 default = nil)
  if valid_590236 != nil:
    section.add "oauth_token", valid_590236
  var valid_590237 = query.getOrDefault("userIp")
  valid_590237 = validateParameter(valid_590237, JString, required = false,
                                 default = nil)
  if valid_590237 != nil:
    section.add "userIp", valid_590237
  var valid_590238 = query.getOrDefault("key")
  valid_590238 = validateParameter(valid_590238, JString, required = false,
                                 default = nil)
  if valid_590238 != nil:
    section.add "key", valid_590238
  var valid_590239 = query.getOrDefault("prettyPrint")
  valid_590239 = validateParameter(valid_590239, JBool, required = false,
                                 default = newJBool(false))
  if valid_590239 != nil:
    section.add "prettyPrint", valid_590239
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590241: Call_AnalyticsManagementProfileFilterLinksInsert_590227;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new profile filter link.
  ## 
  let valid = call_590241.validator(path, query, header, formData, body)
  let scheme = call_590241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590241.url(scheme.get, call_590241.host, call_590241.base,
                         call_590241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590241, url, valid)

proc call*(call_590242: Call_AnalyticsManagementProfileFilterLinksInsert_590227;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileFilterLinksInsert
  ## Create a new profile filter link.
  ##   profileId: string (required)
  ##            : Profile ID to create filter link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create profile filter link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id to create profile filter link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590243 = newJObject()
  var query_590244 = newJObject()
  var body_590245 = newJObject()
  add(path_590243, "profileId", newJString(profileId))
  add(query_590244, "fields", newJString(fields))
  add(query_590244, "quotaUser", newJString(quotaUser))
  add(query_590244, "alt", newJString(alt))
  add(query_590244, "oauth_token", newJString(oauthToken))
  add(path_590243, "accountId", newJString(accountId))
  add(query_590244, "userIp", newJString(userIp))
  add(path_590243, "webPropertyId", newJString(webPropertyId))
  add(query_590244, "key", newJString(key))
  if body != nil:
    body_590245 = body
  add(query_590244, "prettyPrint", newJBool(prettyPrint))
  result = call_590242.call(path_590243, query_590244, nil, nil, body_590245)

var analyticsManagementProfileFilterLinksInsert* = Call_AnalyticsManagementProfileFilterLinksInsert_590227(
    name: "analyticsManagementProfileFilterLinksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks",
    validator: validate_AnalyticsManagementProfileFilterLinksInsert_590228,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksInsert_590229,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksList_590208 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfileFilterLinksList_590210(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/profileFilterLinks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksList_590209(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all profile filter links for a profile.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : Profile ID to retrieve filter links for. Can either be a specific profile ID or '~all', which refers to all the profiles that user has access to.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve profile filter links for.
  ##   webPropertyId: JString (required)
  ##                : Web property Id for profile filter links for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590211 = path.getOrDefault("profileId")
  valid_590211 = validateParameter(valid_590211, JString, required = true,
                                 default = nil)
  if valid_590211 != nil:
    section.add "profileId", valid_590211
  var valid_590212 = path.getOrDefault("accountId")
  valid_590212 = validateParameter(valid_590212, JString, required = true,
                                 default = nil)
  if valid_590212 != nil:
    section.add "accountId", valid_590212
  var valid_590213 = path.getOrDefault("webPropertyId")
  valid_590213 = validateParameter(valid_590213, JString, required = true,
                                 default = nil)
  if valid_590213 != nil:
    section.add "webPropertyId", valid_590213
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of profile filter links to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590214 = query.getOrDefault("fields")
  valid_590214 = validateParameter(valid_590214, JString, required = false,
                                 default = nil)
  if valid_590214 != nil:
    section.add "fields", valid_590214
  var valid_590215 = query.getOrDefault("quotaUser")
  valid_590215 = validateParameter(valid_590215, JString, required = false,
                                 default = nil)
  if valid_590215 != nil:
    section.add "quotaUser", valid_590215
  var valid_590216 = query.getOrDefault("alt")
  valid_590216 = validateParameter(valid_590216, JString, required = false,
                                 default = newJString("json"))
  if valid_590216 != nil:
    section.add "alt", valid_590216
  var valid_590217 = query.getOrDefault("oauth_token")
  valid_590217 = validateParameter(valid_590217, JString, required = false,
                                 default = nil)
  if valid_590217 != nil:
    section.add "oauth_token", valid_590217
  var valid_590218 = query.getOrDefault("userIp")
  valid_590218 = validateParameter(valid_590218, JString, required = false,
                                 default = nil)
  if valid_590218 != nil:
    section.add "userIp", valid_590218
  var valid_590219 = query.getOrDefault("key")
  valid_590219 = validateParameter(valid_590219, JString, required = false,
                                 default = nil)
  if valid_590219 != nil:
    section.add "key", valid_590219
  var valid_590220 = query.getOrDefault("max-results")
  valid_590220 = validateParameter(valid_590220, JInt, required = false, default = nil)
  if valid_590220 != nil:
    section.add "max-results", valid_590220
  var valid_590221 = query.getOrDefault("start-index")
  valid_590221 = validateParameter(valid_590221, JInt, required = false, default = nil)
  if valid_590221 != nil:
    section.add "start-index", valid_590221
  var valid_590222 = query.getOrDefault("prettyPrint")
  valid_590222 = validateParameter(valid_590222, JBool, required = false,
                                 default = newJBool(false))
  if valid_590222 != nil:
    section.add "prettyPrint", valid_590222
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590223: Call_AnalyticsManagementProfileFilterLinksList_590208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all profile filter links for a profile.
  ## 
  let valid = call_590223.validator(path, query, header, formData, body)
  let scheme = call_590223.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590223.url(scheme.get, call_590223.host, call_590223.base,
                         call_590223.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590223, url, valid)

proc call*(call_590224: Call_AnalyticsManagementProfileFilterLinksList_590208;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileFilterLinksList
  ## Lists all profile filter links for a profile.
  ##   profileId: string (required)
  ##            : Profile ID to retrieve filter links for. Can either be a specific profile ID or '~all', which refers to all the profiles that user has access to.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve profile filter links for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id for profile filter links for. Can either be a specific web property ID or '~all', which refers to all the web properties that user has access to.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of profile filter links to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590225 = newJObject()
  var query_590226 = newJObject()
  add(path_590225, "profileId", newJString(profileId))
  add(query_590226, "fields", newJString(fields))
  add(query_590226, "quotaUser", newJString(quotaUser))
  add(query_590226, "alt", newJString(alt))
  add(query_590226, "oauth_token", newJString(oauthToken))
  add(path_590225, "accountId", newJString(accountId))
  add(query_590226, "userIp", newJString(userIp))
  add(path_590225, "webPropertyId", newJString(webPropertyId))
  add(query_590226, "key", newJString(key))
  add(query_590226, "max-results", newJInt(maxResults))
  add(query_590226, "start-index", newJInt(startIndex))
  add(query_590226, "prettyPrint", newJBool(prettyPrint))
  result = call_590224.call(path_590225, query_590226, nil, nil, nil)

var analyticsManagementProfileFilterLinksList* = Call_AnalyticsManagementProfileFilterLinksList_590208(
    name: "analyticsManagementProfileFilterLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks",
    validator: validate_AnalyticsManagementProfileFilterLinksList_590209,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksList_590210,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksUpdate_590264 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfileFilterLinksUpdate_590266(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/profileFilterLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksUpdate_590265(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing profile filter link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : Profile ID to which filter link belongs
  ##   accountId: JString (required)
  ##            : Account ID to which profile filter link belongs.
  ##   webPropertyId: JString (required)
  ##                : Web property Id to which profile filter link belongs
  ##   linkId: JString (required)
  ##         : ID of the profile filter link to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590267 = path.getOrDefault("profileId")
  valid_590267 = validateParameter(valid_590267, JString, required = true,
                                 default = nil)
  if valid_590267 != nil:
    section.add "profileId", valid_590267
  var valid_590268 = path.getOrDefault("accountId")
  valid_590268 = validateParameter(valid_590268, JString, required = true,
                                 default = nil)
  if valid_590268 != nil:
    section.add "accountId", valid_590268
  var valid_590269 = path.getOrDefault("webPropertyId")
  valid_590269 = validateParameter(valid_590269, JString, required = true,
                                 default = nil)
  if valid_590269 != nil:
    section.add "webPropertyId", valid_590269
  var valid_590270 = path.getOrDefault("linkId")
  valid_590270 = validateParameter(valid_590270, JString, required = true,
                                 default = nil)
  if valid_590270 != nil:
    section.add "linkId", valid_590270
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590271 = query.getOrDefault("fields")
  valid_590271 = validateParameter(valid_590271, JString, required = false,
                                 default = nil)
  if valid_590271 != nil:
    section.add "fields", valid_590271
  var valid_590272 = query.getOrDefault("quotaUser")
  valid_590272 = validateParameter(valid_590272, JString, required = false,
                                 default = nil)
  if valid_590272 != nil:
    section.add "quotaUser", valid_590272
  var valid_590273 = query.getOrDefault("alt")
  valid_590273 = validateParameter(valid_590273, JString, required = false,
                                 default = newJString("json"))
  if valid_590273 != nil:
    section.add "alt", valid_590273
  var valid_590274 = query.getOrDefault("oauth_token")
  valid_590274 = validateParameter(valid_590274, JString, required = false,
                                 default = nil)
  if valid_590274 != nil:
    section.add "oauth_token", valid_590274
  var valid_590275 = query.getOrDefault("userIp")
  valid_590275 = validateParameter(valid_590275, JString, required = false,
                                 default = nil)
  if valid_590275 != nil:
    section.add "userIp", valid_590275
  var valid_590276 = query.getOrDefault("key")
  valid_590276 = validateParameter(valid_590276, JString, required = false,
                                 default = nil)
  if valid_590276 != nil:
    section.add "key", valid_590276
  var valid_590277 = query.getOrDefault("prettyPrint")
  valid_590277 = validateParameter(valid_590277, JBool, required = false,
                                 default = newJBool(false))
  if valid_590277 != nil:
    section.add "prettyPrint", valid_590277
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590279: Call_AnalyticsManagementProfileFilterLinksUpdate_590264;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing profile filter link.
  ## 
  let valid = call_590279.validator(path, query, header, formData, body)
  let scheme = call_590279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590279.url(scheme.get, call_590279.host, call_590279.base,
                         call_590279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590279, url, valid)

proc call*(call_590280: Call_AnalyticsManagementProfileFilterLinksUpdate_590264;
          profileId: string; accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileFilterLinksUpdate
  ## Update an existing profile filter link.
  ##   profileId: string (required)
  ##            : Profile ID to which filter link belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which profile filter link belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id to which profile filter link belongs
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : ID of the profile filter link to be updated.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590281 = newJObject()
  var query_590282 = newJObject()
  var body_590283 = newJObject()
  add(path_590281, "profileId", newJString(profileId))
  add(query_590282, "fields", newJString(fields))
  add(query_590282, "quotaUser", newJString(quotaUser))
  add(query_590282, "alt", newJString(alt))
  add(query_590282, "oauth_token", newJString(oauthToken))
  add(path_590281, "accountId", newJString(accountId))
  add(query_590282, "userIp", newJString(userIp))
  add(path_590281, "webPropertyId", newJString(webPropertyId))
  add(query_590282, "key", newJString(key))
  add(path_590281, "linkId", newJString(linkId))
  if body != nil:
    body_590283 = body
  add(query_590282, "prettyPrint", newJBool(prettyPrint))
  result = call_590280.call(path_590281, query_590282, nil, nil, body_590283)

var analyticsManagementProfileFilterLinksUpdate* = Call_AnalyticsManagementProfileFilterLinksUpdate_590264(
    name: "analyticsManagementProfileFilterLinksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksUpdate_590265,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksUpdate_590266,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksGet_590246 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfileFilterLinksGet_590248(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/profileFilterLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksGet_590247(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a single profile filter link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : Profile ID to retrieve filter link for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve profile filter link for.
  ##   webPropertyId: JString (required)
  ##                : Web property Id to retrieve profile filter link for.
  ##   linkId: JString (required)
  ##         : ID of the profile filter link.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590249 = path.getOrDefault("profileId")
  valid_590249 = validateParameter(valid_590249, JString, required = true,
                                 default = nil)
  if valid_590249 != nil:
    section.add "profileId", valid_590249
  var valid_590250 = path.getOrDefault("accountId")
  valid_590250 = validateParameter(valid_590250, JString, required = true,
                                 default = nil)
  if valid_590250 != nil:
    section.add "accountId", valid_590250
  var valid_590251 = path.getOrDefault("webPropertyId")
  valid_590251 = validateParameter(valid_590251, JString, required = true,
                                 default = nil)
  if valid_590251 != nil:
    section.add "webPropertyId", valid_590251
  var valid_590252 = path.getOrDefault("linkId")
  valid_590252 = validateParameter(valid_590252, JString, required = true,
                                 default = nil)
  if valid_590252 != nil:
    section.add "linkId", valid_590252
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590253 = query.getOrDefault("fields")
  valid_590253 = validateParameter(valid_590253, JString, required = false,
                                 default = nil)
  if valid_590253 != nil:
    section.add "fields", valid_590253
  var valid_590254 = query.getOrDefault("quotaUser")
  valid_590254 = validateParameter(valid_590254, JString, required = false,
                                 default = nil)
  if valid_590254 != nil:
    section.add "quotaUser", valid_590254
  var valid_590255 = query.getOrDefault("alt")
  valid_590255 = validateParameter(valid_590255, JString, required = false,
                                 default = newJString("json"))
  if valid_590255 != nil:
    section.add "alt", valid_590255
  var valid_590256 = query.getOrDefault("oauth_token")
  valid_590256 = validateParameter(valid_590256, JString, required = false,
                                 default = nil)
  if valid_590256 != nil:
    section.add "oauth_token", valid_590256
  var valid_590257 = query.getOrDefault("userIp")
  valid_590257 = validateParameter(valid_590257, JString, required = false,
                                 default = nil)
  if valid_590257 != nil:
    section.add "userIp", valid_590257
  var valid_590258 = query.getOrDefault("key")
  valid_590258 = validateParameter(valid_590258, JString, required = false,
                                 default = nil)
  if valid_590258 != nil:
    section.add "key", valid_590258
  var valid_590259 = query.getOrDefault("prettyPrint")
  valid_590259 = validateParameter(valid_590259, JBool, required = false,
                                 default = newJBool(false))
  if valid_590259 != nil:
    section.add "prettyPrint", valid_590259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590260: Call_AnalyticsManagementProfileFilterLinksGet_590246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a single profile filter link.
  ## 
  let valid = call_590260.validator(path, query, header, formData, body)
  let scheme = call_590260.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590260.url(scheme.get, call_590260.host, call_590260.base,
                         call_590260.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590260, url, valid)

proc call*(call_590261: Call_AnalyticsManagementProfileFilterLinksGet_590246;
          profileId: string; accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileFilterLinksGet
  ## Returns a single profile filter link.
  ##   profileId: string (required)
  ##            : Profile ID to retrieve filter link for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve profile filter link for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id to retrieve profile filter link for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : ID of the profile filter link.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590262 = newJObject()
  var query_590263 = newJObject()
  add(path_590262, "profileId", newJString(profileId))
  add(query_590263, "fields", newJString(fields))
  add(query_590263, "quotaUser", newJString(quotaUser))
  add(query_590263, "alt", newJString(alt))
  add(query_590263, "oauth_token", newJString(oauthToken))
  add(path_590262, "accountId", newJString(accountId))
  add(query_590263, "userIp", newJString(userIp))
  add(path_590262, "webPropertyId", newJString(webPropertyId))
  add(query_590263, "key", newJString(key))
  add(path_590262, "linkId", newJString(linkId))
  add(query_590263, "prettyPrint", newJBool(prettyPrint))
  result = call_590261.call(path_590262, query_590263, nil, nil, nil)

var analyticsManagementProfileFilterLinksGet* = Call_AnalyticsManagementProfileFilterLinksGet_590246(
    name: "analyticsManagementProfileFilterLinksGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksGet_590247,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksGet_590248,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksPatch_590302 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfileFilterLinksPatch_590304(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/profileFilterLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksPatch_590303(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update an existing profile filter link. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : Profile ID to which filter link belongs
  ##   accountId: JString (required)
  ##            : Account ID to which profile filter link belongs.
  ##   webPropertyId: JString (required)
  ##                : Web property Id to which profile filter link belongs
  ##   linkId: JString (required)
  ##         : ID of the profile filter link to be updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590305 = path.getOrDefault("profileId")
  valid_590305 = validateParameter(valid_590305, JString, required = true,
                                 default = nil)
  if valid_590305 != nil:
    section.add "profileId", valid_590305
  var valid_590306 = path.getOrDefault("accountId")
  valid_590306 = validateParameter(valid_590306, JString, required = true,
                                 default = nil)
  if valid_590306 != nil:
    section.add "accountId", valid_590306
  var valid_590307 = path.getOrDefault("webPropertyId")
  valid_590307 = validateParameter(valid_590307, JString, required = true,
                                 default = nil)
  if valid_590307 != nil:
    section.add "webPropertyId", valid_590307
  var valid_590308 = path.getOrDefault("linkId")
  valid_590308 = validateParameter(valid_590308, JString, required = true,
                                 default = nil)
  if valid_590308 != nil:
    section.add "linkId", valid_590308
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590309 = query.getOrDefault("fields")
  valid_590309 = validateParameter(valid_590309, JString, required = false,
                                 default = nil)
  if valid_590309 != nil:
    section.add "fields", valid_590309
  var valid_590310 = query.getOrDefault("quotaUser")
  valid_590310 = validateParameter(valid_590310, JString, required = false,
                                 default = nil)
  if valid_590310 != nil:
    section.add "quotaUser", valid_590310
  var valid_590311 = query.getOrDefault("alt")
  valid_590311 = validateParameter(valid_590311, JString, required = false,
                                 default = newJString("json"))
  if valid_590311 != nil:
    section.add "alt", valid_590311
  var valid_590312 = query.getOrDefault("oauth_token")
  valid_590312 = validateParameter(valid_590312, JString, required = false,
                                 default = nil)
  if valid_590312 != nil:
    section.add "oauth_token", valid_590312
  var valid_590313 = query.getOrDefault("userIp")
  valid_590313 = validateParameter(valid_590313, JString, required = false,
                                 default = nil)
  if valid_590313 != nil:
    section.add "userIp", valid_590313
  var valid_590314 = query.getOrDefault("key")
  valid_590314 = validateParameter(valid_590314, JString, required = false,
                                 default = nil)
  if valid_590314 != nil:
    section.add "key", valid_590314
  var valid_590315 = query.getOrDefault("prettyPrint")
  valid_590315 = validateParameter(valid_590315, JBool, required = false,
                                 default = newJBool(false))
  if valid_590315 != nil:
    section.add "prettyPrint", valid_590315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590317: Call_AnalyticsManagementProfileFilterLinksPatch_590302;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing profile filter link. This method supports patch semantics.
  ## 
  let valid = call_590317.validator(path, query, header, formData, body)
  let scheme = call_590317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590317.url(scheme.get, call_590317.host, call_590317.base,
                         call_590317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590317, url, valid)

proc call*(call_590318: Call_AnalyticsManagementProfileFilterLinksPatch_590302;
          profileId: string; accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileFilterLinksPatch
  ## Update an existing profile filter link. This method supports patch semantics.
  ##   profileId: string (required)
  ##            : Profile ID to which filter link belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which profile filter link belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id to which profile filter link belongs
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : ID of the profile filter link to be updated.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590319 = newJObject()
  var query_590320 = newJObject()
  var body_590321 = newJObject()
  add(path_590319, "profileId", newJString(profileId))
  add(query_590320, "fields", newJString(fields))
  add(query_590320, "quotaUser", newJString(quotaUser))
  add(query_590320, "alt", newJString(alt))
  add(query_590320, "oauth_token", newJString(oauthToken))
  add(path_590319, "accountId", newJString(accountId))
  add(query_590320, "userIp", newJString(userIp))
  add(path_590319, "webPropertyId", newJString(webPropertyId))
  add(query_590320, "key", newJString(key))
  add(path_590319, "linkId", newJString(linkId))
  if body != nil:
    body_590321 = body
  add(query_590320, "prettyPrint", newJBool(prettyPrint))
  result = call_590318.call(path_590319, query_590320, nil, nil, body_590321)

var analyticsManagementProfileFilterLinksPatch* = Call_AnalyticsManagementProfileFilterLinksPatch_590302(
    name: "analyticsManagementProfileFilterLinksPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksPatch_590303,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksPatch_590304,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksDelete_590284 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementProfileFilterLinksDelete_590286(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "linkId" in path, "`linkId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/profileFilterLinks/"),
               (kind: VariableSegment, value: "linkId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementProfileFilterLinksDelete_590285(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a profile filter link.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : Profile ID to which the filter link belongs.
  ##   accountId: JString (required)
  ##            : Account ID to which the profile filter link belongs.
  ##   webPropertyId: JString (required)
  ##                : Web property Id to which the profile filter link belongs.
  ##   linkId: JString (required)
  ##         : ID of the profile filter link to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590287 = path.getOrDefault("profileId")
  valid_590287 = validateParameter(valid_590287, JString, required = true,
                                 default = nil)
  if valid_590287 != nil:
    section.add "profileId", valid_590287
  var valid_590288 = path.getOrDefault("accountId")
  valid_590288 = validateParameter(valid_590288, JString, required = true,
                                 default = nil)
  if valid_590288 != nil:
    section.add "accountId", valid_590288
  var valid_590289 = path.getOrDefault("webPropertyId")
  valid_590289 = validateParameter(valid_590289, JString, required = true,
                                 default = nil)
  if valid_590289 != nil:
    section.add "webPropertyId", valid_590289
  var valid_590290 = path.getOrDefault("linkId")
  valid_590290 = validateParameter(valid_590290, JString, required = true,
                                 default = nil)
  if valid_590290 != nil:
    section.add "linkId", valid_590290
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590291 = query.getOrDefault("fields")
  valid_590291 = validateParameter(valid_590291, JString, required = false,
                                 default = nil)
  if valid_590291 != nil:
    section.add "fields", valid_590291
  var valid_590292 = query.getOrDefault("quotaUser")
  valid_590292 = validateParameter(valid_590292, JString, required = false,
                                 default = nil)
  if valid_590292 != nil:
    section.add "quotaUser", valid_590292
  var valid_590293 = query.getOrDefault("alt")
  valid_590293 = validateParameter(valid_590293, JString, required = false,
                                 default = newJString("json"))
  if valid_590293 != nil:
    section.add "alt", valid_590293
  var valid_590294 = query.getOrDefault("oauth_token")
  valid_590294 = validateParameter(valid_590294, JString, required = false,
                                 default = nil)
  if valid_590294 != nil:
    section.add "oauth_token", valid_590294
  var valid_590295 = query.getOrDefault("userIp")
  valid_590295 = validateParameter(valid_590295, JString, required = false,
                                 default = nil)
  if valid_590295 != nil:
    section.add "userIp", valid_590295
  var valid_590296 = query.getOrDefault("key")
  valid_590296 = validateParameter(valid_590296, JString, required = false,
                                 default = nil)
  if valid_590296 != nil:
    section.add "key", valid_590296
  var valid_590297 = query.getOrDefault("prettyPrint")
  valid_590297 = validateParameter(valid_590297, JBool, required = false,
                                 default = newJBool(false))
  if valid_590297 != nil:
    section.add "prettyPrint", valid_590297
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590298: Call_AnalyticsManagementProfileFilterLinksDelete_590284;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a profile filter link.
  ## 
  let valid = call_590298.validator(path, query, header, formData, body)
  let scheme = call_590298.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590298.url(scheme.get, call_590298.host, call_590298.base,
                         call_590298.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590298, url, valid)

proc call*(call_590299: Call_AnalyticsManagementProfileFilterLinksDelete_590284;
          profileId: string; accountId: string; webPropertyId: string; linkId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementProfileFilterLinksDelete
  ## Delete a profile filter link.
  ##   profileId: string (required)
  ##            : Profile ID to which the filter link belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the profile filter link belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property Id to which the profile filter link belongs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   linkId: string (required)
  ##         : ID of the profile filter link to delete.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590300 = newJObject()
  var query_590301 = newJObject()
  add(path_590300, "profileId", newJString(profileId))
  add(query_590301, "fields", newJString(fields))
  add(query_590301, "quotaUser", newJString(quotaUser))
  add(query_590301, "alt", newJString(alt))
  add(query_590301, "oauth_token", newJString(oauthToken))
  add(path_590300, "accountId", newJString(accountId))
  add(query_590301, "userIp", newJString(userIp))
  add(path_590300, "webPropertyId", newJString(webPropertyId))
  add(query_590301, "key", newJString(key))
  add(path_590300, "linkId", newJString(linkId))
  add(query_590301, "prettyPrint", newJBool(prettyPrint))
  result = call_590299.call(path_590300, query_590301, nil, nil, nil)

var analyticsManagementProfileFilterLinksDelete* = Call_AnalyticsManagementProfileFilterLinksDelete_590284(
    name: "analyticsManagementProfileFilterLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksDelete_590285,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksDelete_590286,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsInsert_590341 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementUnsampledReportsInsert_590343(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/unsampledReports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUnsampledReportsInsert_590342(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create a new unsampled report.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to create the unsampled report for.
  ##   accountId: JString (required)
  ##            : Account ID to create the unsampled report for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to create the unsampled report for.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590344 = path.getOrDefault("profileId")
  valid_590344 = validateParameter(valid_590344, JString, required = true,
                                 default = nil)
  if valid_590344 != nil:
    section.add "profileId", valid_590344
  var valid_590345 = path.getOrDefault("accountId")
  valid_590345 = validateParameter(valid_590345, JString, required = true,
                                 default = nil)
  if valid_590345 != nil:
    section.add "accountId", valid_590345
  var valid_590346 = path.getOrDefault("webPropertyId")
  valid_590346 = validateParameter(valid_590346, JString, required = true,
                                 default = nil)
  if valid_590346 != nil:
    section.add "webPropertyId", valid_590346
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590347 = query.getOrDefault("fields")
  valid_590347 = validateParameter(valid_590347, JString, required = false,
                                 default = nil)
  if valid_590347 != nil:
    section.add "fields", valid_590347
  var valid_590348 = query.getOrDefault("quotaUser")
  valid_590348 = validateParameter(valid_590348, JString, required = false,
                                 default = nil)
  if valid_590348 != nil:
    section.add "quotaUser", valid_590348
  var valid_590349 = query.getOrDefault("alt")
  valid_590349 = validateParameter(valid_590349, JString, required = false,
                                 default = newJString("json"))
  if valid_590349 != nil:
    section.add "alt", valid_590349
  var valid_590350 = query.getOrDefault("oauth_token")
  valid_590350 = validateParameter(valid_590350, JString, required = false,
                                 default = nil)
  if valid_590350 != nil:
    section.add "oauth_token", valid_590350
  var valid_590351 = query.getOrDefault("userIp")
  valid_590351 = validateParameter(valid_590351, JString, required = false,
                                 default = nil)
  if valid_590351 != nil:
    section.add "userIp", valid_590351
  var valid_590352 = query.getOrDefault("key")
  valid_590352 = validateParameter(valid_590352, JString, required = false,
                                 default = nil)
  if valid_590352 != nil:
    section.add "key", valid_590352
  var valid_590353 = query.getOrDefault("prettyPrint")
  valid_590353 = validateParameter(valid_590353, JBool, required = false,
                                 default = newJBool(false))
  if valid_590353 != nil:
    section.add "prettyPrint", valid_590353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590355: Call_AnalyticsManagementUnsampledReportsInsert_590341;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new unsampled report.
  ## 
  let valid = call_590355.validator(path, query, header, formData, body)
  let scheme = call_590355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590355.url(scheme.get, call_590355.host, call_590355.base,
                         call_590355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590355, url, valid)

proc call*(call_590356: Call_AnalyticsManagementUnsampledReportsInsert_590341;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUnsampledReportsInsert
  ## Create a new unsampled report.
  ##   profileId: string (required)
  ##            : View (Profile) ID to create the unsampled report for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to create the unsampled report for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to create the unsampled report for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590357 = newJObject()
  var query_590358 = newJObject()
  var body_590359 = newJObject()
  add(path_590357, "profileId", newJString(profileId))
  add(query_590358, "fields", newJString(fields))
  add(query_590358, "quotaUser", newJString(quotaUser))
  add(query_590358, "alt", newJString(alt))
  add(query_590358, "oauth_token", newJString(oauthToken))
  add(path_590357, "accountId", newJString(accountId))
  add(query_590358, "userIp", newJString(userIp))
  add(path_590357, "webPropertyId", newJString(webPropertyId))
  add(query_590358, "key", newJString(key))
  if body != nil:
    body_590359 = body
  add(query_590358, "prettyPrint", newJBool(prettyPrint))
  result = call_590356.call(path_590357, query_590358, nil, nil, body_590359)

var analyticsManagementUnsampledReportsInsert* = Call_AnalyticsManagementUnsampledReportsInsert_590341(
    name: "analyticsManagementUnsampledReportsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports",
    validator: validate_AnalyticsManagementUnsampledReportsInsert_590342,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsInsert_590343,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsList_590322 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementUnsampledReportsList_590324(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/unsampledReports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUnsampledReportsList_590323(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists unsampled reports to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve unsampled reports for. Must be a specific view (profile) ID, ~all is not supported.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve unsampled reports for. Must be a specific account ID, ~all is not supported.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve unsampled reports for. Must be a specific web property ID, ~all is not supported.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590325 = path.getOrDefault("profileId")
  valid_590325 = validateParameter(valid_590325, JString, required = true,
                                 default = nil)
  if valid_590325 != nil:
    section.add "profileId", valid_590325
  var valid_590326 = path.getOrDefault("accountId")
  valid_590326 = validateParameter(valid_590326, JString, required = true,
                                 default = nil)
  if valid_590326 != nil:
    section.add "accountId", valid_590326
  var valid_590327 = path.getOrDefault("webPropertyId")
  valid_590327 = validateParameter(valid_590327, JString, required = true,
                                 default = nil)
  if valid_590327 != nil:
    section.add "webPropertyId", valid_590327
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of unsampled reports to include in this response.
  ##   start-index: JInt
  ##              : An index of the first unsampled report to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590328 = query.getOrDefault("fields")
  valid_590328 = validateParameter(valid_590328, JString, required = false,
                                 default = nil)
  if valid_590328 != nil:
    section.add "fields", valid_590328
  var valid_590329 = query.getOrDefault("quotaUser")
  valid_590329 = validateParameter(valid_590329, JString, required = false,
                                 default = nil)
  if valid_590329 != nil:
    section.add "quotaUser", valid_590329
  var valid_590330 = query.getOrDefault("alt")
  valid_590330 = validateParameter(valid_590330, JString, required = false,
                                 default = newJString("json"))
  if valid_590330 != nil:
    section.add "alt", valid_590330
  var valid_590331 = query.getOrDefault("oauth_token")
  valid_590331 = validateParameter(valid_590331, JString, required = false,
                                 default = nil)
  if valid_590331 != nil:
    section.add "oauth_token", valid_590331
  var valid_590332 = query.getOrDefault("userIp")
  valid_590332 = validateParameter(valid_590332, JString, required = false,
                                 default = nil)
  if valid_590332 != nil:
    section.add "userIp", valid_590332
  var valid_590333 = query.getOrDefault("key")
  valid_590333 = validateParameter(valid_590333, JString, required = false,
                                 default = nil)
  if valid_590333 != nil:
    section.add "key", valid_590333
  var valid_590334 = query.getOrDefault("max-results")
  valid_590334 = validateParameter(valid_590334, JInt, required = false, default = nil)
  if valid_590334 != nil:
    section.add "max-results", valid_590334
  var valid_590335 = query.getOrDefault("start-index")
  valid_590335 = validateParameter(valid_590335, JInt, required = false, default = nil)
  if valid_590335 != nil:
    section.add "start-index", valid_590335
  var valid_590336 = query.getOrDefault("prettyPrint")
  valid_590336 = validateParameter(valid_590336, JBool, required = false,
                                 default = newJBool(false))
  if valid_590336 != nil:
    section.add "prettyPrint", valid_590336
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590337: Call_AnalyticsManagementUnsampledReportsList_590322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists unsampled reports to which the user has access.
  ## 
  let valid = call_590337.validator(path, query, header, formData, body)
  let scheme = call_590337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590337.url(scheme.get, call_590337.host, call_590337.base,
                         call_590337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590337, url, valid)

proc call*(call_590338: Call_AnalyticsManagementUnsampledReportsList_590322;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUnsampledReportsList
  ## Lists unsampled reports to which the user has access.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve unsampled reports for. Must be a specific view (profile) ID, ~all is not supported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve unsampled reports for. Must be a specific account ID, ~all is not supported.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve unsampled reports for. Must be a specific web property ID, ~all is not supported.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of unsampled reports to include in this response.
  ##   startIndex: int
  ##             : An index of the first unsampled report to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590339 = newJObject()
  var query_590340 = newJObject()
  add(path_590339, "profileId", newJString(profileId))
  add(query_590340, "fields", newJString(fields))
  add(query_590340, "quotaUser", newJString(quotaUser))
  add(query_590340, "alt", newJString(alt))
  add(query_590340, "oauth_token", newJString(oauthToken))
  add(path_590339, "accountId", newJString(accountId))
  add(query_590340, "userIp", newJString(userIp))
  add(path_590339, "webPropertyId", newJString(webPropertyId))
  add(query_590340, "key", newJString(key))
  add(query_590340, "max-results", newJInt(maxResults))
  add(query_590340, "start-index", newJInt(startIndex))
  add(query_590340, "prettyPrint", newJBool(prettyPrint))
  result = call_590338.call(path_590339, query_590340, nil, nil, nil)

var analyticsManagementUnsampledReportsList* = Call_AnalyticsManagementUnsampledReportsList_590322(
    name: "analyticsManagementUnsampledReportsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports",
    validator: validate_AnalyticsManagementUnsampledReportsList_590323,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsList_590324,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsGet_590360 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementUnsampledReportsGet_590362(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "unsampledReportId" in path,
        "`unsampledReportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/unsampledReports/"),
               (kind: VariableSegment, value: "unsampledReportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUnsampledReportsGet_590361(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a single unsampled report.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to retrieve unsampled report for.
  ##   accountId: JString (required)
  ##            : Account ID to retrieve unsampled report for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to retrieve unsampled reports for.
  ##   unsampledReportId: JString (required)
  ##                    : ID of the unsampled report to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590363 = path.getOrDefault("profileId")
  valid_590363 = validateParameter(valid_590363, JString, required = true,
                                 default = nil)
  if valid_590363 != nil:
    section.add "profileId", valid_590363
  var valid_590364 = path.getOrDefault("accountId")
  valid_590364 = validateParameter(valid_590364, JString, required = true,
                                 default = nil)
  if valid_590364 != nil:
    section.add "accountId", valid_590364
  var valid_590365 = path.getOrDefault("webPropertyId")
  valid_590365 = validateParameter(valid_590365, JString, required = true,
                                 default = nil)
  if valid_590365 != nil:
    section.add "webPropertyId", valid_590365
  var valid_590366 = path.getOrDefault("unsampledReportId")
  valid_590366 = validateParameter(valid_590366, JString, required = true,
                                 default = nil)
  if valid_590366 != nil:
    section.add "unsampledReportId", valid_590366
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590367 = query.getOrDefault("fields")
  valid_590367 = validateParameter(valid_590367, JString, required = false,
                                 default = nil)
  if valid_590367 != nil:
    section.add "fields", valid_590367
  var valid_590368 = query.getOrDefault("quotaUser")
  valid_590368 = validateParameter(valid_590368, JString, required = false,
                                 default = nil)
  if valid_590368 != nil:
    section.add "quotaUser", valid_590368
  var valid_590369 = query.getOrDefault("alt")
  valid_590369 = validateParameter(valid_590369, JString, required = false,
                                 default = newJString("json"))
  if valid_590369 != nil:
    section.add "alt", valid_590369
  var valid_590370 = query.getOrDefault("oauth_token")
  valid_590370 = validateParameter(valid_590370, JString, required = false,
                                 default = nil)
  if valid_590370 != nil:
    section.add "oauth_token", valid_590370
  var valid_590371 = query.getOrDefault("userIp")
  valid_590371 = validateParameter(valid_590371, JString, required = false,
                                 default = nil)
  if valid_590371 != nil:
    section.add "userIp", valid_590371
  var valid_590372 = query.getOrDefault("key")
  valid_590372 = validateParameter(valid_590372, JString, required = false,
                                 default = nil)
  if valid_590372 != nil:
    section.add "key", valid_590372
  var valid_590373 = query.getOrDefault("prettyPrint")
  valid_590373 = validateParameter(valid_590373, JBool, required = false,
                                 default = newJBool(false))
  if valid_590373 != nil:
    section.add "prettyPrint", valid_590373
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590374: Call_AnalyticsManagementUnsampledReportsGet_590360;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a single unsampled report.
  ## 
  let valid = call_590374.validator(path, query, header, formData, body)
  let scheme = call_590374.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590374.url(scheme.get, call_590374.host, call_590374.base,
                         call_590374.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590374, url, valid)

proc call*(call_590375: Call_AnalyticsManagementUnsampledReportsGet_590360;
          profileId: string; accountId: string; webPropertyId: string;
          unsampledReportId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUnsampledReportsGet
  ## Returns a single unsampled report.
  ##   profileId: string (required)
  ##            : View (Profile) ID to retrieve unsampled report for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to retrieve unsampled report for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to retrieve unsampled reports for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   unsampledReportId: string (required)
  ##                    : ID of the unsampled report to retrieve.
  var path_590376 = newJObject()
  var query_590377 = newJObject()
  add(path_590376, "profileId", newJString(profileId))
  add(query_590377, "fields", newJString(fields))
  add(query_590377, "quotaUser", newJString(quotaUser))
  add(query_590377, "alt", newJString(alt))
  add(query_590377, "oauth_token", newJString(oauthToken))
  add(path_590376, "accountId", newJString(accountId))
  add(query_590377, "userIp", newJString(userIp))
  add(path_590376, "webPropertyId", newJString(webPropertyId))
  add(query_590377, "key", newJString(key))
  add(query_590377, "prettyPrint", newJBool(prettyPrint))
  add(path_590376, "unsampledReportId", newJString(unsampledReportId))
  result = call_590375.call(path_590376, query_590377, nil, nil, nil)

var analyticsManagementUnsampledReportsGet* = Call_AnalyticsManagementUnsampledReportsGet_590360(
    name: "analyticsManagementUnsampledReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports/{unsampledReportId}",
    validator: validate_AnalyticsManagementUnsampledReportsGet_590361,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsGet_590362,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsDelete_590378 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementUnsampledReportsDelete_590380(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "profileId" in path, "`profileId` is a required path parameter"
  assert "unsampledReportId" in path,
        "`unsampledReportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/profiles/"),
               (kind: VariableSegment, value: "profileId"),
               (kind: ConstantSegment, value: "/unsampledReports/"),
               (kind: VariableSegment, value: "unsampledReportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementUnsampledReportsDelete_590379(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an unsampled report.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   profileId: JString (required)
  ##            : View (Profile) ID to delete the unsampled report for.
  ##   accountId: JString (required)
  ##            : Account ID to delete the unsampled report for.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to delete the unsampled reports for.
  ##   unsampledReportId: JString (required)
  ##                    : ID of the unsampled report to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `profileId` field"
  var valid_590381 = path.getOrDefault("profileId")
  valid_590381 = validateParameter(valid_590381, JString, required = true,
                                 default = nil)
  if valid_590381 != nil:
    section.add "profileId", valid_590381
  var valid_590382 = path.getOrDefault("accountId")
  valid_590382 = validateParameter(valid_590382, JString, required = true,
                                 default = nil)
  if valid_590382 != nil:
    section.add "accountId", valid_590382
  var valid_590383 = path.getOrDefault("webPropertyId")
  valid_590383 = validateParameter(valid_590383, JString, required = true,
                                 default = nil)
  if valid_590383 != nil:
    section.add "webPropertyId", valid_590383
  var valid_590384 = path.getOrDefault("unsampledReportId")
  valid_590384 = validateParameter(valid_590384, JString, required = true,
                                 default = nil)
  if valid_590384 != nil:
    section.add "unsampledReportId", valid_590384
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590385 = query.getOrDefault("fields")
  valid_590385 = validateParameter(valid_590385, JString, required = false,
                                 default = nil)
  if valid_590385 != nil:
    section.add "fields", valid_590385
  var valid_590386 = query.getOrDefault("quotaUser")
  valid_590386 = validateParameter(valid_590386, JString, required = false,
                                 default = nil)
  if valid_590386 != nil:
    section.add "quotaUser", valid_590386
  var valid_590387 = query.getOrDefault("alt")
  valid_590387 = validateParameter(valid_590387, JString, required = false,
                                 default = newJString("json"))
  if valid_590387 != nil:
    section.add "alt", valid_590387
  var valid_590388 = query.getOrDefault("oauth_token")
  valid_590388 = validateParameter(valid_590388, JString, required = false,
                                 default = nil)
  if valid_590388 != nil:
    section.add "oauth_token", valid_590388
  var valid_590389 = query.getOrDefault("userIp")
  valid_590389 = validateParameter(valid_590389, JString, required = false,
                                 default = nil)
  if valid_590389 != nil:
    section.add "userIp", valid_590389
  var valid_590390 = query.getOrDefault("key")
  valid_590390 = validateParameter(valid_590390, JString, required = false,
                                 default = nil)
  if valid_590390 != nil:
    section.add "key", valid_590390
  var valid_590391 = query.getOrDefault("prettyPrint")
  valid_590391 = validateParameter(valid_590391, JBool, required = false,
                                 default = newJBool(false))
  if valid_590391 != nil:
    section.add "prettyPrint", valid_590391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590392: Call_AnalyticsManagementUnsampledReportsDelete_590378;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an unsampled report.
  ## 
  let valid = call_590392.validator(path, query, header, formData, body)
  let scheme = call_590392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590392.url(scheme.get, call_590392.host, call_590392.base,
                         call_590392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590392, url, valid)

proc call*(call_590393: Call_AnalyticsManagementUnsampledReportsDelete_590378;
          profileId: string; accountId: string; webPropertyId: string;
          unsampledReportId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsManagementUnsampledReportsDelete
  ## Deletes an unsampled report.
  ##   profileId: string (required)
  ##            : View (Profile) ID to delete the unsampled report for.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to delete the unsampled report for.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to delete the unsampled reports for.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   unsampledReportId: string (required)
  ##                    : ID of the unsampled report to be deleted.
  var path_590394 = newJObject()
  var query_590395 = newJObject()
  add(path_590394, "profileId", newJString(profileId))
  add(query_590395, "fields", newJString(fields))
  add(query_590395, "quotaUser", newJString(quotaUser))
  add(query_590395, "alt", newJString(alt))
  add(query_590395, "oauth_token", newJString(oauthToken))
  add(path_590394, "accountId", newJString(accountId))
  add(query_590395, "userIp", newJString(userIp))
  add(path_590394, "webPropertyId", newJString(webPropertyId))
  add(query_590395, "key", newJString(key))
  add(query_590395, "prettyPrint", newJBool(prettyPrint))
  add(path_590394, "unsampledReportId", newJString(unsampledReportId))
  result = call_590393.call(path_590394, query_590395, nil, nil, nil)

var analyticsManagementUnsampledReportsDelete* = Call_AnalyticsManagementUnsampledReportsDelete_590378(
    name: "analyticsManagementUnsampledReportsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports/{unsampledReportId}",
    validator: validate_AnalyticsManagementUnsampledReportsDelete_590379,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsDelete_590380,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceInsert_590415 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementRemarketingAudienceInsert_590417(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/remarketingAudiences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudienceInsert_590416(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new remarketing audience.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account ID for which to create the remarketing audience.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for which to create the remarketing audience.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_590418 = path.getOrDefault("accountId")
  valid_590418 = validateParameter(valid_590418, JString, required = true,
                                 default = nil)
  if valid_590418 != nil:
    section.add "accountId", valid_590418
  var valid_590419 = path.getOrDefault("webPropertyId")
  valid_590419 = validateParameter(valid_590419, JString, required = true,
                                 default = nil)
  if valid_590419 != nil:
    section.add "webPropertyId", valid_590419
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590420 = query.getOrDefault("fields")
  valid_590420 = validateParameter(valid_590420, JString, required = false,
                                 default = nil)
  if valid_590420 != nil:
    section.add "fields", valid_590420
  var valid_590421 = query.getOrDefault("quotaUser")
  valid_590421 = validateParameter(valid_590421, JString, required = false,
                                 default = nil)
  if valid_590421 != nil:
    section.add "quotaUser", valid_590421
  var valid_590422 = query.getOrDefault("alt")
  valid_590422 = validateParameter(valid_590422, JString, required = false,
                                 default = newJString("json"))
  if valid_590422 != nil:
    section.add "alt", valid_590422
  var valid_590423 = query.getOrDefault("oauth_token")
  valid_590423 = validateParameter(valid_590423, JString, required = false,
                                 default = nil)
  if valid_590423 != nil:
    section.add "oauth_token", valid_590423
  var valid_590424 = query.getOrDefault("userIp")
  valid_590424 = validateParameter(valid_590424, JString, required = false,
                                 default = nil)
  if valid_590424 != nil:
    section.add "userIp", valid_590424
  var valid_590425 = query.getOrDefault("key")
  valid_590425 = validateParameter(valid_590425, JString, required = false,
                                 default = nil)
  if valid_590425 != nil:
    section.add "key", valid_590425
  var valid_590426 = query.getOrDefault("prettyPrint")
  valid_590426 = validateParameter(valid_590426, JBool, required = false,
                                 default = newJBool(false))
  if valid_590426 != nil:
    section.add "prettyPrint", valid_590426
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590428: Call_AnalyticsManagementRemarketingAudienceInsert_590415;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new remarketing audience.
  ## 
  let valid = call_590428.validator(path, query, header, formData, body)
  let scheme = call_590428.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590428.url(scheme.get, call_590428.host, call_590428.base,
                         call_590428.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590428, url, valid)

proc call*(call_590429: Call_AnalyticsManagementRemarketingAudienceInsert_590415;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementRemarketingAudienceInsert
  ## Creates a new remarketing audience.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account ID for which to create the remarketing audience.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID for which to create the remarketing audience.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590430 = newJObject()
  var query_590431 = newJObject()
  var body_590432 = newJObject()
  add(query_590431, "fields", newJString(fields))
  add(query_590431, "quotaUser", newJString(quotaUser))
  add(query_590431, "alt", newJString(alt))
  add(query_590431, "oauth_token", newJString(oauthToken))
  add(path_590430, "accountId", newJString(accountId))
  add(query_590431, "userIp", newJString(userIp))
  add(path_590430, "webPropertyId", newJString(webPropertyId))
  add(query_590431, "key", newJString(key))
  if body != nil:
    body_590432 = body
  add(query_590431, "prettyPrint", newJBool(prettyPrint))
  result = call_590429.call(path_590430, query_590431, nil, nil, body_590432)

var analyticsManagementRemarketingAudienceInsert* = Call_AnalyticsManagementRemarketingAudienceInsert_590415(
    name: "analyticsManagementRemarketingAudienceInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences",
    validator: validate_AnalyticsManagementRemarketingAudienceInsert_590416,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceInsert_590417,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceList_590396 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementRemarketingAudienceList_590398(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/remarketingAudiences")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudienceList_590397(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists remarketing audiences to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account ID of the remarketing audiences to retrieve.
  ##   webPropertyId: JString (required)
  ##                : The web property ID of the remarketing audiences to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_590399 = path.getOrDefault("accountId")
  valid_590399 = validateParameter(valid_590399, JString, required = true,
                                 default = nil)
  if valid_590399 != nil:
    section.add "accountId", valid_590399
  var valid_590400 = path.getOrDefault("webPropertyId")
  valid_590400 = validateParameter(valid_590400, JString, required = true,
                                 default = nil)
  if valid_590400 != nil:
    section.add "webPropertyId", valid_590400
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   type: JString
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of remarketing audiences to include in this response.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590401 = query.getOrDefault("fields")
  valid_590401 = validateParameter(valid_590401, JString, required = false,
                                 default = nil)
  if valid_590401 != nil:
    section.add "fields", valid_590401
  var valid_590402 = query.getOrDefault("quotaUser")
  valid_590402 = validateParameter(valid_590402, JString, required = false,
                                 default = nil)
  if valid_590402 != nil:
    section.add "quotaUser", valid_590402
  var valid_590403 = query.getOrDefault("alt")
  valid_590403 = validateParameter(valid_590403, JString, required = false,
                                 default = newJString("json"))
  if valid_590403 != nil:
    section.add "alt", valid_590403
  var valid_590404 = query.getOrDefault("type")
  valid_590404 = validateParameter(valid_590404, JString, required = false,
                                 default = newJString("all"))
  if valid_590404 != nil:
    section.add "type", valid_590404
  var valid_590405 = query.getOrDefault("oauth_token")
  valid_590405 = validateParameter(valid_590405, JString, required = false,
                                 default = nil)
  if valid_590405 != nil:
    section.add "oauth_token", valid_590405
  var valid_590406 = query.getOrDefault("userIp")
  valid_590406 = validateParameter(valid_590406, JString, required = false,
                                 default = nil)
  if valid_590406 != nil:
    section.add "userIp", valid_590406
  var valid_590407 = query.getOrDefault("key")
  valid_590407 = validateParameter(valid_590407, JString, required = false,
                                 default = nil)
  if valid_590407 != nil:
    section.add "key", valid_590407
  var valid_590408 = query.getOrDefault("max-results")
  valid_590408 = validateParameter(valid_590408, JInt, required = false, default = nil)
  if valid_590408 != nil:
    section.add "max-results", valid_590408
  var valid_590409 = query.getOrDefault("start-index")
  valid_590409 = validateParameter(valid_590409, JInt, required = false, default = nil)
  if valid_590409 != nil:
    section.add "start-index", valid_590409
  var valid_590410 = query.getOrDefault("prettyPrint")
  valid_590410 = validateParameter(valid_590410, JBool, required = false,
                                 default = newJBool(false))
  if valid_590410 != nil:
    section.add "prettyPrint", valid_590410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590411: Call_AnalyticsManagementRemarketingAudienceList_590396;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists remarketing audiences to which the user has access.
  ## 
  let valid = call_590411.validator(path, query, header, formData, body)
  let scheme = call_590411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590411.url(scheme.get, call_590411.host, call_590411.base,
                         call_590411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590411, url, valid)

proc call*(call_590412: Call_AnalyticsManagementRemarketingAudienceList_590396;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; `type`: string = "all";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementRemarketingAudienceList
  ## Lists remarketing audiences to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   type: string
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account ID of the remarketing audiences to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : The web property ID of the remarketing audiences to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of remarketing audiences to include in this response.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590413 = newJObject()
  var query_590414 = newJObject()
  add(query_590414, "fields", newJString(fields))
  add(query_590414, "quotaUser", newJString(quotaUser))
  add(query_590414, "alt", newJString(alt))
  add(query_590414, "type", newJString(`type`))
  add(query_590414, "oauth_token", newJString(oauthToken))
  add(path_590413, "accountId", newJString(accountId))
  add(query_590414, "userIp", newJString(userIp))
  add(path_590413, "webPropertyId", newJString(webPropertyId))
  add(query_590414, "key", newJString(key))
  add(query_590414, "max-results", newJInt(maxResults))
  add(query_590414, "start-index", newJInt(startIndex))
  add(query_590414, "prettyPrint", newJBool(prettyPrint))
  result = call_590412.call(path_590413, query_590414, nil, nil, nil)

var analyticsManagementRemarketingAudienceList* = Call_AnalyticsManagementRemarketingAudienceList_590396(
    name: "analyticsManagementRemarketingAudienceList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences",
    validator: validate_AnalyticsManagementRemarketingAudienceList_590397,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceList_590398,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceUpdate_590450 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementRemarketingAudienceUpdate_590452(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "remarketingAudienceId" in path,
        "`remarketingAudienceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/remarketingAudiences/"),
               (kind: VariableSegment, value: "remarketingAudienceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudienceUpdate_590451(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing remarketing audience.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account ID of the remarketing audience to update.
  ##   webPropertyId: JString (required)
  ##                : The web property ID of the remarketing audience to update.
  ##   remarketingAudienceId: JString (required)
  ##                        : The ID of the remarketing audience to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_590453 = path.getOrDefault("accountId")
  valid_590453 = validateParameter(valid_590453, JString, required = true,
                                 default = nil)
  if valid_590453 != nil:
    section.add "accountId", valid_590453
  var valid_590454 = path.getOrDefault("webPropertyId")
  valid_590454 = validateParameter(valid_590454, JString, required = true,
                                 default = nil)
  if valid_590454 != nil:
    section.add "webPropertyId", valid_590454
  var valid_590455 = path.getOrDefault("remarketingAudienceId")
  valid_590455 = validateParameter(valid_590455, JString, required = true,
                                 default = nil)
  if valid_590455 != nil:
    section.add "remarketingAudienceId", valid_590455
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590456 = query.getOrDefault("fields")
  valid_590456 = validateParameter(valid_590456, JString, required = false,
                                 default = nil)
  if valid_590456 != nil:
    section.add "fields", valid_590456
  var valid_590457 = query.getOrDefault("quotaUser")
  valid_590457 = validateParameter(valid_590457, JString, required = false,
                                 default = nil)
  if valid_590457 != nil:
    section.add "quotaUser", valid_590457
  var valid_590458 = query.getOrDefault("alt")
  valid_590458 = validateParameter(valid_590458, JString, required = false,
                                 default = newJString("json"))
  if valid_590458 != nil:
    section.add "alt", valid_590458
  var valid_590459 = query.getOrDefault("oauth_token")
  valid_590459 = validateParameter(valid_590459, JString, required = false,
                                 default = nil)
  if valid_590459 != nil:
    section.add "oauth_token", valid_590459
  var valid_590460 = query.getOrDefault("userIp")
  valid_590460 = validateParameter(valid_590460, JString, required = false,
                                 default = nil)
  if valid_590460 != nil:
    section.add "userIp", valid_590460
  var valid_590461 = query.getOrDefault("key")
  valid_590461 = validateParameter(valid_590461, JString, required = false,
                                 default = nil)
  if valid_590461 != nil:
    section.add "key", valid_590461
  var valid_590462 = query.getOrDefault("prettyPrint")
  valid_590462 = validateParameter(valid_590462, JBool, required = false,
                                 default = newJBool(false))
  if valid_590462 != nil:
    section.add "prettyPrint", valid_590462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590464: Call_AnalyticsManagementRemarketingAudienceUpdate_590450;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing remarketing audience.
  ## 
  let valid = call_590464.validator(path, query, header, formData, body)
  let scheme = call_590464.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590464.url(scheme.get, call_590464.host, call_590464.base,
                         call_590464.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590464, url, valid)

proc call*(call_590465: Call_AnalyticsManagementRemarketingAudienceUpdate_590450;
          accountId: string; webPropertyId: string; remarketingAudienceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementRemarketingAudienceUpdate
  ## Updates an existing remarketing audience.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account ID of the remarketing audience to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : The web property ID of the remarketing audience to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   remarketingAudienceId: string (required)
  ##                        : The ID of the remarketing audience to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590466 = newJObject()
  var query_590467 = newJObject()
  var body_590468 = newJObject()
  add(query_590467, "fields", newJString(fields))
  add(query_590467, "quotaUser", newJString(quotaUser))
  add(query_590467, "alt", newJString(alt))
  add(query_590467, "oauth_token", newJString(oauthToken))
  add(path_590466, "accountId", newJString(accountId))
  add(query_590467, "userIp", newJString(userIp))
  add(path_590466, "webPropertyId", newJString(webPropertyId))
  add(query_590467, "key", newJString(key))
  add(path_590466, "remarketingAudienceId", newJString(remarketingAudienceId))
  if body != nil:
    body_590468 = body
  add(query_590467, "prettyPrint", newJBool(prettyPrint))
  result = call_590465.call(path_590466, query_590467, nil, nil, body_590468)

var analyticsManagementRemarketingAudienceUpdate* = Call_AnalyticsManagementRemarketingAudienceUpdate_590450(
    name: "analyticsManagementRemarketingAudienceUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudienceUpdate_590451,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceUpdate_590452,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceGet_590433 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementRemarketingAudienceGet_590435(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "remarketingAudienceId" in path,
        "`remarketingAudienceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/remarketingAudiences/"),
               (kind: VariableSegment, value: "remarketingAudienceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudienceGet_590434(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a remarketing audience to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account ID of the remarketing audience to retrieve.
  ##   webPropertyId: JString (required)
  ##                : The web property ID of the remarketing audience to retrieve.
  ##   remarketingAudienceId: JString (required)
  ##                        : The ID of the remarketing audience to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_590436 = path.getOrDefault("accountId")
  valid_590436 = validateParameter(valid_590436, JString, required = true,
                                 default = nil)
  if valid_590436 != nil:
    section.add "accountId", valid_590436
  var valid_590437 = path.getOrDefault("webPropertyId")
  valid_590437 = validateParameter(valid_590437, JString, required = true,
                                 default = nil)
  if valid_590437 != nil:
    section.add "webPropertyId", valid_590437
  var valid_590438 = path.getOrDefault("remarketingAudienceId")
  valid_590438 = validateParameter(valid_590438, JString, required = true,
                                 default = nil)
  if valid_590438 != nil:
    section.add "remarketingAudienceId", valid_590438
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590439 = query.getOrDefault("fields")
  valid_590439 = validateParameter(valid_590439, JString, required = false,
                                 default = nil)
  if valid_590439 != nil:
    section.add "fields", valid_590439
  var valid_590440 = query.getOrDefault("quotaUser")
  valid_590440 = validateParameter(valid_590440, JString, required = false,
                                 default = nil)
  if valid_590440 != nil:
    section.add "quotaUser", valid_590440
  var valid_590441 = query.getOrDefault("alt")
  valid_590441 = validateParameter(valid_590441, JString, required = false,
                                 default = newJString("json"))
  if valid_590441 != nil:
    section.add "alt", valid_590441
  var valid_590442 = query.getOrDefault("oauth_token")
  valid_590442 = validateParameter(valid_590442, JString, required = false,
                                 default = nil)
  if valid_590442 != nil:
    section.add "oauth_token", valid_590442
  var valid_590443 = query.getOrDefault("userIp")
  valid_590443 = validateParameter(valid_590443, JString, required = false,
                                 default = nil)
  if valid_590443 != nil:
    section.add "userIp", valid_590443
  var valid_590444 = query.getOrDefault("key")
  valid_590444 = validateParameter(valid_590444, JString, required = false,
                                 default = nil)
  if valid_590444 != nil:
    section.add "key", valid_590444
  var valid_590445 = query.getOrDefault("prettyPrint")
  valid_590445 = validateParameter(valid_590445, JBool, required = false,
                                 default = newJBool(false))
  if valid_590445 != nil:
    section.add "prettyPrint", valid_590445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590446: Call_AnalyticsManagementRemarketingAudienceGet_590433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a remarketing audience to which the user has access.
  ## 
  let valid = call_590446.validator(path, query, header, formData, body)
  let scheme = call_590446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590446.url(scheme.get, call_590446.host, call_590446.base,
                         call_590446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590446, url, valid)

proc call*(call_590447: Call_AnalyticsManagementRemarketingAudienceGet_590433;
          accountId: string; webPropertyId: string; remarketingAudienceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementRemarketingAudienceGet
  ## Gets a remarketing audience to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account ID of the remarketing audience to retrieve.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : The web property ID of the remarketing audience to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   remarketingAudienceId: string (required)
  ##                        : The ID of the remarketing audience to retrieve.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590448 = newJObject()
  var query_590449 = newJObject()
  add(query_590449, "fields", newJString(fields))
  add(query_590449, "quotaUser", newJString(quotaUser))
  add(query_590449, "alt", newJString(alt))
  add(query_590449, "oauth_token", newJString(oauthToken))
  add(path_590448, "accountId", newJString(accountId))
  add(query_590449, "userIp", newJString(userIp))
  add(path_590448, "webPropertyId", newJString(webPropertyId))
  add(query_590449, "key", newJString(key))
  add(path_590448, "remarketingAudienceId", newJString(remarketingAudienceId))
  add(query_590449, "prettyPrint", newJBool(prettyPrint))
  result = call_590447.call(path_590448, query_590449, nil, nil, nil)

var analyticsManagementRemarketingAudienceGet* = Call_AnalyticsManagementRemarketingAudienceGet_590433(
    name: "analyticsManagementRemarketingAudienceGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudienceGet_590434,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceGet_590435,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudiencePatch_590486 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementRemarketingAudiencePatch_590488(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "remarketingAudienceId" in path,
        "`remarketingAudienceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/remarketingAudiences/"),
               (kind: VariableSegment, value: "remarketingAudienceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudiencePatch_590487(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing remarketing audience. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : The account ID of the remarketing audience to update.
  ##   webPropertyId: JString (required)
  ##                : The web property ID of the remarketing audience to update.
  ##   remarketingAudienceId: JString (required)
  ##                        : The ID of the remarketing audience to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_590489 = path.getOrDefault("accountId")
  valid_590489 = validateParameter(valid_590489, JString, required = true,
                                 default = nil)
  if valid_590489 != nil:
    section.add "accountId", valid_590489
  var valid_590490 = path.getOrDefault("webPropertyId")
  valid_590490 = validateParameter(valid_590490, JString, required = true,
                                 default = nil)
  if valid_590490 != nil:
    section.add "webPropertyId", valid_590490
  var valid_590491 = path.getOrDefault("remarketingAudienceId")
  valid_590491 = validateParameter(valid_590491, JString, required = true,
                                 default = nil)
  if valid_590491 != nil:
    section.add "remarketingAudienceId", valid_590491
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590492 = query.getOrDefault("fields")
  valid_590492 = validateParameter(valid_590492, JString, required = false,
                                 default = nil)
  if valid_590492 != nil:
    section.add "fields", valid_590492
  var valid_590493 = query.getOrDefault("quotaUser")
  valid_590493 = validateParameter(valid_590493, JString, required = false,
                                 default = nil)
  if valid_590493 != nil:
    section.add "quotaUser", valid_590493
  var valid_590494 = query.getOrDefault("alt")
  valid_590494 = validateParameter(valid_590494, JString, required = false,
                                 default = newJString("json"))
  if valid_590494 != nil:
    section.add "alt", valid_590494
  var valid_590495 = query.getOrDefault("oauth_token")
  valid_590495 = validateParameter(valid_590495, JString, required = false,
                                 default = nil)
  if valid_590495 != nil:
    section.add "oauth_token", valid_590495
  var valid_590496 = query.getOrDefault("userIp")
  valid_590496 = validateParameter(valid_590496, JString, required = false,
                                 default = nil)
  if valid_590496 != nil:
    section.add "userIp", valid_590496
  var valid_590497 = query.getOrDefault("key")
  valid_590497 = validateParameter(valid_590497, JString, required = false,
                                 default = nil)
  if valid_590497 != nil:
    section.add "key", valid_590497
  var valid_590498 = query.getOrDefault("prettyPrint")
  valid_590498 = validateParameter(valid_590498, JBool, required = false,
                                 default = newJBool(false))
  if valid_590498 != nil:
    section.add "prettyPrint", valid_590498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590500: Call_AnalyticsManagementRemarketingAudiencePatch_590486;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing remarketing audience. This method supports patch semantics.
  ## 
  let valid = call_590500.validator(path, query, header, formData, body)
  let scheme = call_590500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590500.url(scheme.get, call_590500.host, call_590500.base,
                         call_590500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590500, url, valid)

proc call*(call_590501: Call_AnalyticsManagementRemarketingAudiencePatch_590486;
          accountId: string; webPropertyId: string; remarketingAudienceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementRemarketingAudiencePatch
  ## Updates an existing remarketing audience. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : The account ID of the remarketing audience to update.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : The web property ID of the remarketing audience to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   remarketingAudienceId: string (required)
  ##                        : The ID of the remarketing audience to update.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590502 = newJObject()
  var query_590503 = newJObject()
  var body_590504 = newJObject()
  add(query_590503, "fields", newJString(fields))
  add(query_590503, "quotaUser", newJString(quotaUser))
  add(query_590503, "alt", newJString(alt))
  add(query_590503, "oauth_token", newJString(oauthToken))
  add(path_590502, "accountId", newJString(accountId))
  add(query_590503, "userIp", newJString(userIp))
  add(path_590502, "webPropertyId", newJString(webPropertyId))
  add(query_590503, "key", newJString(key))
  add(path_590502, "remarketingAudienceId", newJString(remarketingAudienceId))
  if body != nil:
    body_590504 = body
  add(query_590503, "prettyPrint", newJBool(prettyPrint))
  result = call_590501.call(path_590502, query_590503, nil, nil, body_590504)

var analyticsManagementRemarketingAudiencePatch* = Call_AnalyticsManagementRemarketingAudiencePatch_590486(
    name: "analyticsManagementRemarketingAudiencePatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudiencePatch_590487,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudiencePatch_590488,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceDelete_590469 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementRemarketingAudienceDelete_590471(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "accountId" in path, "`accountId` is a required path parameter"
  assert "webPropertyId" in path, "`webPropertyId` is a required path parameter"
  assert "remarketingAudienceId" in path,
        "`remarketingAudienceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/management/accounts/"),
               (kind: VariableSegment, value: "accountId"),
               (kind: ConstantSegment, value: "/webproperties/"),
               (kind: VariableSegment, value: "webPropertyId"),
               (kind: ConstantSegment, value: "/remarketingAudiences/"),
               (kind: VariableSegment, value: "remarketingAudienceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsManagementRemarketingAudienceDelete_590470(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete a remarketing audience.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID to which the remarketing audience belongs.
  ##   webPropertyId: JString (required)
  ##                : Web property ID to which the remarketing audience belongs.
  ##   remarketingAudienceId: JString (required)
  ##                        : The ID of the remarketing audience to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_590472 = path.getOrDefault("accountId")
  valid_590472 = validateParameter(valid_590472, JString, required = true,
                                 default = nil)
  if valid_590472 != nil:
    section.add "accountId", valid_590472
  var valid_590473 = path.getOrDefault("webPropertyId")
  valid_590473 = validateParameter(valid_590473, JString, required = true,
                                 default = nil)
  if valid_590473 != nil:
    section.add "webPropertyId", valid_590473
  var valid_590474 = path.getOrDefault("remarketingAudienceId")
  valid_590474 = validateParameter(valid_590474, JString, required = true,
                                 default = nil)
  if valid_590474 != nil:
    section.add "remarketingAudienceId", valid_590474
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590475 = query.getOrDefault("fields")
  valid_590475 = validateParameter(valid_590475, JString, required = false,
                                 default = nil)
  if valid_590475 != nil:
    section.add "fields", valid_590475
  var valid_590476 = query.getOrDefault("quotaUser")
  valid_590476 = validateParameter(valid_590476, JString, required = false,
                                 default = nil)
  if valid_590476 != nil:
    section.add "quotaUser", valid_590476
  var valid_590477 = query.getOrDefault("alt")
  valid_590477 = validateParameter(valid_590477, JString, required = false,
                                 default = newJString("json"))
  if valid_590477 != nil:
    section.add "alt", valid_590477
  var valid_590478 = query.getOrDefault("oauth_token")
  valid_590478 = validateParameter(valid_590478, JString, required = false,
                                 default = nil)
  if valid_590478 != nil:
    section.add "oauth_token", valid_590478
  var valid_590479 = query.getOrDefault("userIp")
  valid_590479 = validateParameter(valid_590479, JString, required = false,
                                 default = nil)
  if valid_590479 != nil:
    section.add "userIp", valid_590479
  var valid_590480 = query.getOrDefault("key")
  valid_590480 = validateParameter(valid_590480, JString, required = false,
                                 default = nil)
  if valid_590480 != nil:
    section.add "key", valid_590480
  var valid_590481 = query.getOrDefault("prettyPrint")
  valid_590481 = validateParameter(valid_590481, JBool, required = false,
                                 default = newJBool(false))
  if valid_590481 != nil:
    section.add "prettyPrint", valid_590481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590482: Call_AnalyticsManagementRemarketingAudienceDelete_590469;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a remarketing audience.
  ## 
  let valid = call_590482.validator(path, query, header, formData, body)
  let scheme = call_590482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590482.url(scheme.get, call_590482.host, call_590482.base,
                         call_590482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590482, url, valid)

proc call*(call_590483: Call_AnalyticsManagementRemarketingAudienceDelete_590469;
          accountId: string; webPropertyId: string; remarketingAudienceId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = false): Recallable =
  ## analyticsManagementRemarketingAudienceDelete
  ## Delete a remarketing audience.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   accountId: string (required)
  ##            : Account ID to which the remarketing audience belongs.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   webPropertyId: string (required)
  ##                : Web property ID to which the remarketing audience belongs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   remarketingAudienceId: string (required)
  ##                        : The ID of the remarketing audience to delete.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590484 = newJObject()
  var query_590485 = newJObject()
  add(query_590485, "fields", newJString(fields))
  add(query_590485, "quotaUser", newJString(quotaUser))
  add(query_590485, "alt", newJString(alt))
  add(query_590485, "oauth_token", newJString(oauthToken))
  add(path_590484, "accountId", newJString(accountId))
  add(query_590485, "userIp", newJString(userIp))
  add(path_590484, "webPropertyId", newJString(webPropertyId))
  add(query_590485, "key", newJString(key))
  add(path_590484, "remarketingAudienceId", newJString(remarketingAudienceId))
  add(query_590485, "prettyPrint", newJBool(prettyPrint))
  result = call_590483.call(path_590484, query_590485, nil, nil, nil)

var analyticsManagementRemarketingAudienceDelete* = Call_AnalyticsManagementRemarketingAudienceDelete_590469(
    name: "analyticsManagementRemarketingAudienceDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudienceDelete_590470,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceDelete_590471,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementClientIdHashClientId_590505 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementClientIdHashClientId_590507(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementClientIdHashClientId_590506(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Hashes the given Client ID.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590508 = query.getOrDefault("fields")
  valid_590508 = validateParameter(valid_590508, JString, required = false,
                                 default = nil)
  if valid_590508 != nil:
    section.add "fields", valid_590508
  var valid_590509 = query.getOrDefault("quotaUser")
  valid_590509 = validateParameter(valid_590509, JString, required = false,
                                 default = nil)
  if valid_590509 != nil:
    section.add "quotaUser", valid_590509
  var valid_590510 = query.getOrDefault("alt")
  valid_590510 = validateParameter(valid_590510, JString, required = false,
                                 default = newJString("json"))
  if valid_590510 != nil:
    section.add "alt", valid_590510
  var valid_590511 = query.getOrDefault("oauth_token")
  valid_590511 = validateParameter(valid_590511, JString, required = false,
                                 default = nil)
  if valid_590511 != nil:
    section.add "oauth_token", valid_590511
  var valid_590512 = query.getOrDefault("userIp")
  valid_590512 = validateParameter(valid_590512, JString, required = false,
                                 default = nil)
  if valid_590512 != nil:
    section.add "userIp", valid_590512
  var valid_590513 = query.getOrDefault("key")
  valid_590513 = validateParameter(valid_590513, JString, required = false,
                                 default = nil)
  if valid_590513 != nil:
    section.add "key", valid_590513
  var valid_590514 = query.getOrDefault("prettyPrint")
  valid_590514 = validateParameter(valid_590514, JBool, required = false,
                                 default = newJBool(false))
  if valid_590514 != nil:
    section.add "prettyPrint", valid_590514
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590516: Call_AnalyticsManagementClientIdHashClientId_590505;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Hashes the given Client ID.
  ## 
  let valid = call_590516.validator(path, query, header, formData, body)
  let scheme = call_590516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590516.url(scheme.get, call_590516.host, call_590516.base,
                         call_590516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590516, url, valid)

proc call*(call_590517: Call_AnalyticsManagementClientIdHashClientId_590505;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsManagementClientIdHashClientId
  ## Hashes the given Client ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590518 = newJObject()
  var body_590519 = newJObject()
  add(query_590518, "fields", newJString(fields))
  add(query_590518, "quotaUser", newJString(quotaUser))
  add(query_590518, "alt", newJString(alt))
  add(query_590518, "oauth_token", newJString(oauthToken))
  add(query_590518, "userIp", newJString(userIp))
  add(query_590518, "key", newJString(key))
  if body != nil:
    body_590519 = body
  add(query_590518, "prettyPrint", newJBool(prettyPrint))
  result = call_590517.call(nil, query_590518, nil, nil, body_590519)

var analyticsManagementClientIdHashClientId* = Call_AnalyticsManagementClientIdHashClientId_590505(
    name: "analyticsManagementClientIdHashClientId", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/clientId:hashClientId",
    validator: validate_AnalyticsManagementClientIdHashClientId_590506,
    base: "/analytics/v3", url: url_AnalyticsManagementClientIdHashClientId_590507,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementSegmentsList_590520 = ref object of OpenApiRestCall_588466
proc url_AnalyticsManagementSegmentsList_590522(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementSegmentsList_590521(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists segments to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of segments to include in this response.
  ##   start-index: JInt
  ##              : An index of the first segment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590523 = query.getOrDefault("fields")
  valid_590523 = validateParameter(valid_590523, JString, required = false,
                                 default = nil)
  if valid_590523 != nil:
    section.add "fields", valid_590523
  var valid_590524 = query.getOrDefault("quotaUser")
  valid_590524 = validateParameter(valid_590524, JString, required = false,
                                 default = nil)
  if valid_590524 != nil:
    section.add "quotaUser", valid_590524
  var valid_590525 = query.getOrDefault("alt")
  valid_590525 = validateParameter(valid_590525, JString, required = false,
                                 default = newJString("json"))
  if valid_590525 != nil:
    section.add "alt", valid_590525
  var valid_590526 = query.getOrDefault("oauth_token")
  valid_590526 = validateParameter(valid_590526, JString, required = false,
                                 default = nil)
  if valid_590526 != nil:
    section.add "oauth_token", valid_590526
  var valid_590527 = query.getOrDefault("userIp")
  valid_590527 = validateParameter(valid_590527, JString, required = false,
                                 default = nil)
  if valid_590527 != nil:
    section.add "userIp", valid_590527
  var valid_590528 = query.getOrDefault("key")
  valid_590528 = validateParameter(valid_590528, JString, required = false,
                                 default = nil)
  if valid_590528 != nil:
    section.add "key", valid_590528
  var valid_590529 = query.getOrDefault("max-results")
  valid_590529 = validateParameter(valid_590529, JInt, required = false, default = nil)
  if valid_590529 != nil:
    section.add "max-results", valid_590529
  var valid_590530 = query.getOrDefault("start-index")
  valid_590530 = validateParameter(valid_590530, JInt, required = false, default = nil)
  if valid_590530 != nil:
    section.add "start-index", valid_590530
  var valid_590531 = query.getOrDefault("prettyPrint")
  valid_590531 = validateParameter(valid_590531, JBool, required = false,
                                 default = newJBool(false))
  if valid_590531 != nil:
    section.add "prettyPrint", valid_590531
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590532: Call_AnalyticsManagementSegmentsList_590520;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists segments to which the user has access.
  ## 
  let valid = call_590532.validator(path, query, header, formData, body)
  let scheme = call_590532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590532.url(scheme.get, call_590532.host, call_590532.base,
                         call_590532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590532, url, valid)

proc call*(call_590533: Call_AnalyticsManagementSegmentsList_590520;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementSegmentsList
  ## Lists segments to which the user has access.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of segments to include in this response.
  ##   startIndex: int
  ##             : An index of the first segment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590534 = newJObject()
  add(query_590534, "fields", newJString(fields))
  add(query_590534, "quotaUser", newJString(quotaUser))
  add(query_590534, "alt", newJString(alt))
  add(query_590534, "oauth_token", newJString(oauthToken))
  add(query_590534, "userIp", newJString(userIp))
  add(query_590534, "key", newJString(key))
  add(query_590534, "max-results", newJInt(maxResults))
  add(query_590534, "start-index", newJInt(startIndex))
  add(query_590534, "prettyPrint", newJBool(prettyPrint))
  result = call_590533.call(nil, query_590534, nil, nil, nil)

var analyticsManagementSegmentsList* = Call_AnalyticsManagementSegmentsList_590520(
    name: "analyticsManagementSegmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/segments",
    validator: validate_AnalyticsManagementSegmentsList_590521,
    base: "/analytics/v3", url: url_AnalyticsManagementSegmentsList_590522,
    schemes: {Scheme.Https})
type
  Call_AnalyticsMetadataColumnsList_590535 = ref object of OpenApiRestCall_588466
proc url_AnalyticsMetadataColumnsList_590537(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "reportType" in path, "`reportType` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/metadata/"),
               (kind: VariableSegment, value: "reportType"),
               (kind: ConstantSegment, value: "/columns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AnalyticsMetadataColumnsList_590536(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all columns for a report type
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportType: JString (required)
  ##             : Report type. Allowed Values: 'ga'. Where 'ga' corresponds to the Core Reporting API
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportType` field"
  var valid_590538 = path.getOrDefault("reportType")
  valid_590538 = validateParameter(valid_590538, JString, required = true,
                                 default = nil)
  if valid_590538 != nil:
    section.add "reportType", valid_590538
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590539 = query.getOrDefault("fields")
  valid_590539 = validateParameter(valid_590539, JString, required = false,
                                 default = nil)
  if valid_590539 != nil:
    section.add "fields", valid_590539
  var valid_590540 = query.getOrDefault("quotaUser")
  valid_590540 = validateParameter(valid_590540, JString, required = false,
                                 default = nil)
  if valid_590540 != nil:
    section.add "quotaUser", valid_590540
  var valid_590541 = query.getOrDefault("alt")
  valid_590541 = validateParameter(valid_590541, JString, required = false,
                                 default = newJString("json"))
  if valid_590541 != nil:
    section.add "alt", valid_590541
  var valid_590542 = query.getOrDefault("oauth_token")
  valid_590542 = validateParameter(valid_590542, JString, required = false,
                                 default = nil)
  if valid_590542 != nil:
    section.add "oauth_token", valid_590542
  var valid_590543 = query.getOrDefault("userIp")
  valid_590543 = validateParameter(valid_590543, JString, required = false,
                                 default = nil)
  if valid_590543 != nil:
    section.add "userIp", valid_590543
  var valid_590544 = query.getOrDefault("key")
  valid_590544 = validateParameter(valid_590544, JString, required = false,
                                 default = nil)
  if valid_590544 != nil:
    section.add "key", valid_590544
  var valid_590545 = query.getOrDefault("prettyPrint")
  valid_590545 = validateParameter(valid_590545, JBool, required = false,
                                 default = newJBool(false))
  if valid_590545 != nil:
    section.add "prettyPrint", valid_590545
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590546: Call_AnalyticsMetadataColumnsList_590535; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all columns for a report type
  ## 
  let valid = call_590546.validator(path, query, header, formData, body)
  let scheme = call_590546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590546.url(scheme.get, call_590546.host, call_590546.base,
                         call_590546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590546, url, valid)

proc call*(call_590547: Call_AnalyticsMetadataColumnsList_590535;
          reportType: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = false): Recallable =
  ## analyticsMetadataColumnsList
  ## Lists all columns for a report type
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   reportType: string (required)
  ##             : Report type. Allowed Values: 'ga'. Where 'ga' corresponds to the Core Reporting API
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590548 = newJObject()
  var query_590549 = newJObject()
  add(query_590549, "fields", newJString(fields))
  add(query_590549, "quotaUser", newJString(quotaUser))
  add(query_590549, "alt", newJString(alt))
  add(query_590549, "oauth_token", newJString(oauthToken))
  add(query_590549, "userIp", newJString(userIp))
  add(query_590549, "key", newJString(key))
  add(path_590548, "reportType", newJString(reportType))
  add(query_590549, "prettyPrint", newJBool(prettyPrint))
  result = call_590547.call(path_590548, query_590549, nil, nil, nil)

var analyticsMetadataColumnsList* = Call_AnalyticsMetadataColumnsList_590535(
    name: "analyticsMetadataColumnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/{reportType}/columns",
    validator: validate_AnalyticsMetadataColumnsList_590536,
    base: "/analytics/v3", url: url_AnalyticsMetadataColumnsList_590537,
    schemes: {Scheme.Https})
type
  Call_AnalyticsProvisioningCreateAccountTicket_590550 = ref object of OpenApiRestCall_588466
proc url_AnalyticsProvisioningCreateAccountTicket_590552(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsProvisioningCreateAccountTicket_590551(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an account ticket.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590553 = query.getOrDefault("fields")
  valid_590553 = validateParameter(valid_590553, JString, required = false,
                                 default = nil)
  if valid_590553 != nil:
    section.add "fields", valid_590553
  var valid_590554 = query.getOrDefault("quotaUser")
  valid_590554 = validateParameter(valid_590554, JString, required = false,
                                 default = nil)
  if valid_590554 != nil:
    section.add "quotaUser", valid_590554
  var valid_590555 = query.getOrDefault("alt")
  valid_590555 = validateParameter(valid_590555, JString, required = false,
                                 default = newJString("json"))
  if valid_590555 != nil:
    section.add "alt", valid_590555
  var valid_590556 = query.getOrDefault("oauth_token")
  valid_590556 = validateParameter(valid_590556, JString, required = false,
                                 default = nil)
  if valid_590556 != nil:
    section.add "oauth_token", valid_590556
  var valid_590557 = query.getOrDefault("userIp")
  valid_590557 = validateParameter(valid_590557, JString, required = false,
                                 default = nil)
  if valid_590557 != nil:
    section.add "userIp", valid_590557
  var valid_590558 = query.getOrDefault("key")
  valid_590558 = validateParameter(valid_590558, JString, required = false,
                                 default = nil)
  if valid_590558 != nil:
    section.add "key", valid_590558
  var valid_590559 = query.getOrDefault("prettyPrint")
  valid_590559 = validateParameter(valid_590559, JBool, required = false,
                                 default = newJBool(false))
  if valid_590559 != nil:
    section.add "prettyPrint", valid_590559
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590561: Call_AnalyticsProvisioningCreateAccountTicket_590550;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an account ticket.
  ## 
  let valid = call_590561.validator(path, query, header, formData, body)
  let scheme = call_590561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590561.url(scheme.get, call_590561.host, call_590561.base,
                         call_590561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590561, url, valid)

proc call*(call_590562: Call_AnalyticsProvisioningCreateAccountTicket_590550;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsProvisioningCreateAccountTicket
  ## Creates an account ticket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590563 = newJObject()
  var body_590564 = newJObject()
  add(query_590563, "fields", newJString(fields))
  add(query_590563, "quotaUser", newJString(quotaUser))
  add(query_590563, "alt", newJString(alt))
  add(query_590563, "oauth_token", newJString(oauthToken))
  add(query_590563, "userIp", newJString(userIp))
  add(query_590563, "key", newJString(key))
  if body != nil:
    body_590564 = body
  add(query_590563, "prettyPrint", newJBool(prettyPrint))
  result = call_590562.call(nil, query_590563, nil, nil, body_590564)

var analyticsProvisioningCreateAccountTicket* = Call_AnalyticsProvisioningCreateAccountTicket_590550(
    name: "analyticsProvisioningCreateAccountTicket", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/provisioning/createAccountTicket",
    validator: validate_AnalyticsProvisioningCreateAccountTicket_590551,
    base: "/analytics/v3", url: url_AnalyticsProvisioningCreateAccountTicket_590552,
    schemes: {Scheme.Https})
type
  Call_AnalyticsProvisioningCreateAccountTree_590565 = ref object of OpenApiRestCall_588466
proc url_AnalyticsProvisioningCreateAccountTree_590567(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsProvisioningCreateAccountTree_590566(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Provision account.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590568 = query.getOrDefault("fields")
  valid_590568 = validateParameter(valid_590568, JString, required = false,
                                 default = nil)
  if valid_590568 != nil:
    section.add "fields", valid_590568
  var valid_590569 = query.getOrDefault("quotaUser")
  valid_590569 = validateParameter(valid_590569, JString, required = false,
                                 default = nil)
  if valid_590569 != nil:
    section.add "quotaUser", valid_590569
  var valid_590570 = query.getOrDefault("alt")
  valid_590570 = validateParameter(valid_590570, JString, required = false,
                                 default = newJString("json"))
  if valid_590570 != nil:
    section.add "alt", valid_590570
  var valid_590571 = query.getOrDefault("oauth_token")
  valid_590571 = validateParameter(valid_590571, JString, required = false,
                                 default = nil)
  if valid_590571 != nil:
    section.add "oauth_token", valid_590571
  var valid_590572 = query.getOrDefault("userIp")
  valid_590572 = validateParameter(valid_590572, JString, required = false,
                                 default = nil)
  if valid_590572 != nil:
    section.add "userIp", valid_590572
  var valid_590573 = query.getOrDefault("key")
  valid_590573 = validateParameter(valid_590573, JString, required = false,
                                 default = nil)
  if valid_590573 != nil:
    section.add "key", valid_590573
  var valid_590574 = query.getOrDefault("prettyPrint")
  valid_590574 = validateParameter(valid_590574, JBool, required = false,
                                 default = newJBool(false))
  if valid_590574 != nil:
    section.add "prettyPrint", valid_590574
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590576: Call_AnalyticsProvisioningCreateAccountTree_590565;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provision account.
  ## 
  let valid = call_590576.validator(path, query, header, formData, body)
  let scheme = call_590576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590576.url(scheme.get, call_590576.host, call_590576.base,
                         call_590576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590576, url, valid)

proc call*(call_590577: Call_AnalyticsProvisioningCreateAccountTree_590565;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsProvisioningCreateAccountTree
  ## Provision account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590578 = newJObject()
  var body_590579 = newJObject()
  add(query_590578, "fields", newJString(fields))
  add(query_590578, "quotaUser", newJString(quotaUser))
  add(query_590578, "alt", newJString(alt))
  add(query_590578, "oauth_token", newJString(oauthToken))
  add(query_590578, "userIp", newJString(userIp))
  add(query_590578, "key", newJString(key))
  if body != nil:
    body_590579 = body
  add(query_590578, "prettyPrint", newJBool(prettyPrint))
  result = call_590577.call(nil, query_590578, nil, nil, body_590579)

var analyticsProvisioningCreateAccountTree* = Call_AnalyticsProvisioningCreateAccountTree_590565(
    name: "analyticsProvisioningCreateAccountTree", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/provisioning/createAccountTree",
    validator: validate_AnalyticsProvisioningCreateAccountTree_590566,
    base: "/analytics/v3", url: url_AnalyticsProvisioningCreateAccountTree_590567,
    schemes: {Scheme.Https})
type
  Call_AnalyticsUserDeletionUserDeletionRequestUpsert_590580 = ref object of OpenApiRestCall_588466
proc url_AnalyticsUserDeletionUserDeletionRequestUpsert_590582(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsUserDeletionUserDeletionRequestUpsert_590581(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Insert or update a user deletion requests.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590583 = query.getOrDefault("fields")
  valid_590583 = validateParameter(valid_590583, JString, required = false,
                                 default = nil)
  if valid_590583 != nil:
    section.add "fields", valid_590583
  var valid_590584 = query.getOrDefault("quotaUser")
  valid_590584 = validateParameter(valid_590584, JString, required = false,
                                 default = nil)
  if valid_590584 != nil:
    section.add "quotaUser", valid_590584
  var valid_590585 = query.getOrDefault("alt")
  valid_590585 = validateParameter(valid_590585, JString, required = false,
                                 default = newJString("json"))
  if valid_590585 != nil:
    section.add "alt", valid_590585
  var valid_590586 = query.getOrDefault("oauth_token")
  valid_590586 = validateParameter(valid_590586, JString, required = false,
                                 default = nil)
  if valid_590586 != nil:
    section.add "oauth_token", valid_590586
  var valid_590587 = query.getOrDefault("userIp")
  valid_590587 = validateParameter(valid_590587, JString, required = false,
                                 default = nil)
  if valid_590587 != nil:
    section.add "userIp", valid_590587
  var valid_590588 = query.getOrDefault("key")
  valid_590588 = validateParameter(valid_590588, JString, required = false,
                                 default = nil)
  if valid_590588 != nil:
    section.add "key", valid_590588
  var valid_590589 = query.getOrDefault("prettyPrint")
  valid_590589 = validateParameter(valid_590589, JBool, required = false,
                                 default = newJBool(false))
  if valid_590589 != nil:
    section.add "prettyPrint", valid_590589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_590591: Call_AnalyticsUserDeletionUserDeletionRequestUpsert_590580;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert or update a user deletion requests.
  ## 
  let valid = call_590591.validator(path, query, header, formData, body)
  let scheme = call_590591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590591.url(scheme.get, call_590591.host, call_590591.base,
                         call_590591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590591, url, valid)

proc call*(call_590592: Call_AnalyticsUserDeletionUserDeletionRequestUpsert_590580;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = false): Recallable =
  ## analyticsUserDeletionUserDeletionRequestUpsert
  ## Insert or update a user deletion requests.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_590593 = newJObject()
  var body_590594 = newJObject()
  add(query_590593, "fields", newJString(fields))
  add(query_590593, "quotaUser", newJString(quotaUser))
  add(query_590593, "alt", newJString(alt))
  add(query_590593, "oauth_token", newJString(oauthToken))
  add(query_590593, "userIp", newJString(userIp))
  add(query_590593, "key", newJString(key))
  if body != nil:
    body_590594 = body
  add(query_590593, "prettyPrint", newJBool(prettyPrint))
  result = call_590592.call(nil, query_590593, nil, nil, body_590594)

var analyticsUserDeletionUserDeletionRequestUpsert* = Call_AnalyticsUserDeletionUserDeletionRequestUpsert_590580(
    name: "analyticsUserDeletionUserDeletionRequestUpsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/userDeletion/userDeletionRequests:upsert",
    validator: validate_AnalyticsUserDeletionUserDeletionRequestUpsert_590581,
    base: "/analytics/v3",
    url: url_AnalyticsUserDeletionUserDeletionRequestUpsert_590582,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
