
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

  OpenApiRestCall_579437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579437): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
  Call_AnalyticsDataGaGet_579705 = ref object of OpenApiRestCall_579437
proc url_AnalyticsDataGaGet_579707(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsDataGaGet_579706(path: JsonNode; query: JsonNode;
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
  var valid_579819 = query.getOrDefault("fields")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "fields", valid_579819
  var valid_579820 = query.getOrDefault("quotaUser")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "quotaUser", valid_579820
  var valid_579834 = query.getOrDefault("alt")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = newJString("json"))
  if valid_579834 != nil:
    section.add "alt", valid_579834
  var valid_579835 = query.getOrDefault("sort")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "sort", valid_579835
  var valid_579836 = query.getOrDefault("segment")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "segment", valid_579836
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_579837 = query.getOrDefault("metrics")
  valid_579837 = validateParameter(valid_579837, JString, required = true,
                                 default = nil)
  if valid_579837 != nil:
    section.add "metrics", valid_579837
  var valid_579838 = query.getOrDefault("oauth_token")
  valid_579838 = validateParameter(valid_579838, JString, required = false,
                                 default = nil)
  if valid_579838 != nil:
    section.add "oauth_token", valid_579838
  var valid_579839 = query.getOrDefault("userIp")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "userIp", valid_579839
  var valid_579840 = query.getOrDefault("dimensions")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = nil)
  if valid_579840 != nil:
    section.add "dimensions", valid_579840
  var valid_579841 = query.getOrDefault("ids")
  valid_579841 = validateParameter(valid_579841, JString, required = true,
                                 default = nil)
  if valid_579841 != nil:
    section.add "ids", valid_579841
  var valid_579842 = query.getOrDefault("key")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "key", valid_579842
  var valid_579843 = query.getOrDefault("max-results")
  valid_579843 = validateParameter(valid_579843, JInt, required = false, default = nil)
  if valid_579843 != nil:
    section.add "max-results", valid_579843
  var valid_579844 = query.getOrDefault("end-date")
  valid_579844 = validateParameter(valid_579844, JString, required = true,
                                 default = nil)
  if valid_579844 != nil:
    section.add "end-date", valid_579844
  var valid_579845 = query.getOrDefault("start-date")
  valid_579845 = validateParameter(valid_579845, JString, required = true,
                                 default = nil)
  if valid_579845 != nil:
    section.add "start-date", valid_579845
  var valid_579846 = query.getOrDefault("filters")
  valid_579846 = validateParameter(valid_579846, JString, required = false,
                                 default = nil)
  if valid_579846 != nil:
    section.add "filters", valid_579846
  var valid_579847 = query.getOrDefault("include-empty-rows")
  valid_579847 = validateParameter(valid_579847, JBool, required = false, default = nil)
  if valid_579847 != nil:
    section.add "include-empty-rows", valid_579847
  var valid_579848 = query.getOrDefault("start-index")
  valid_579848 = validateParameter(valid_579848, JInt, required = false, default = nil)
  if valid_579848 != nil:
    section.add "start-index", valid_579848
  var valid_579849 = query.getOrDefault("samplingLevel")
  valid_579849 = validateParameter(valid_579849, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_579849 != nil:
    section.add "samplingLevel", valid_579849
  var valid_579850 = query.getOrDefault("prettyPrint")
  valid_579850 = validateParameter(valid_579850, JBool, required = false,
                                 default = newJBool(false))
  if valid_579850 != nil:
    section.add "prettyPrint", valid_579850
  var valid_579851 = query.getOrDefault("output")
  valid_579851 = validateParameter(valid_579851, JString, required = false,
                                 default = newJString("dataTable"))
  if valid_579851 != nil:
    section.add "output", valid_579851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579874: Call_AnalyticsDataGaGet_579705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Analytics data for a view (profile).
  ## 
  let valid = call_579874.validator(path, query, header, formData, body)
  let scheme = call_579874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579874.url(scheme.get, call_579874.host, call_579874.base,
                         call_579874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579874, url, valid)

proc call*(call_579945: Call_AnalyticsDataGaGet_579705; metrics: string; ids: string;
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
  var query_579946 = newJObject()
  add(query_579946, "fields", newJString(fields))
  add(query_579946, "quotaUser", newJString(quotaUser))
  add(query_579946, "alt", newJString(alt))
  add(query_579946, "sort", newJString(sort))
  add(query_579946, "segment", newJString(segment))
  add(query_579946, "metrics", newJString(metrics))
  add(query_579946, "oauth_token", newJString(oauthToken))
  add(query_579946, "userIp", newJString(userIp))
  add(query_579946, "dimensions", newJString(dimensions))
  add(query_579946, "ids", newJString(ids))
  add(query_579946, "key", newJString(key))
  add(query_579946, "max-results", newJInt(maxResults))
  add(query_579946, "end-date", newJString(endDate))
  add(query_579946, "start-date", newJString(startDate))
  add(query_579946, "filters", newJString(filters))
  add(query_579946, "include-empty-rows", newJBool(includeEmptyRows))
  add(query_579946, "start-index", newJInt(startIndex))
  add(query_579946, "samplingLevel", newJString(samplingLevel))
  add(query_579946, "prettyPrint", newJBool(prettyPrint))
  add(query_579946, "output", newJString(output))
  result = call_579945.call(nil, query_579946, nil, nil, nil)

var analyticsDataGaGet* = Call_AnalyticsDataGaGet_579705(
    name: "analyticsDataGaGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/data/ga",
    validator: validate_AnalyticsDataGaGet_579706, base: "/analytics/v3",
    url: url_AnalyticsDataGaGet_579707, schemes: {Scheme.Https})
type
  Call_AnalyticsDataMcfGet_579986 = ref object of OpenApiRestCall_579437
proc url_AnalyticsDataMcfGet_579988(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsDataMcfGet_579987(path: JsonNode; query: JsonNode;
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
  var valid_579989 = query.getOrDefault("fields")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "fields", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("sort")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "sort", valid_579992
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_579993 = query.getOrDefault("metrics")
  valid_579993 = validateParameter(valid_579993, JString, required = true,
                                 default = nil)
  if valid_579993 != nil:
    section.add "metrics", valid_579993
  var valid_579994 = query.getOrDefault("oauth_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "oauth_token", valid_579994
  var valid_579995 = query.getOrDefault("userIp")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "userIp", valid_579995
  var valid_579996 = query.getOrDefault("dimensions")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "dimensions", valid_579996
  var valid_579997 = query.getOrDefault("ids")
  valid_579997 = validateParameter(valid_579997, JString, required = true,
                                 default = nil)
  if valid_579997 != nil:
    section.add "ids", valid_579997
  var valid_579998 = query.getOrDefault("key")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "key", valid_579998
  var valid_579999 = query.getOrDefault("max-results")
  valid_579999 = validateParameter(valid_579999, JInt, required = false, default = nil)
  if valid_579999 != nil:
    section.add "max-results", valid_579999
  var valid_580000 = query.getOrDefault("end-date")
  valid_580000 = validateParameter(valid_580000, JString, required = true,
                                 default = nil)
  if valid_580000 != nil:
    section.add "end-date", valid_580000
  var valid_580001 = query.getOrDefault("start-date")
  valid_580001 = validateParameter(valid_580001, JString, required = true,
                                 default = nil)
  if valid_580001 != nil:
    section.add "start-date", valid_580001
  var valid_580002 = query.getOrDefault("filters")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "filters", valid_580002
  var valid_580003 = query.getOrDefault("start-index")
  valid_580003 = validateParameter(valid_580003, JInt, required = false, default = nil)
  if valid_580003 != nil:
    section.add "start-index", valid_580003
  var valid_580004 = query.getOrDefault("samplingLevel")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("DEFAULT"))
  if valid_580004 != nil:
    section.add "samplingLevel", valid_580004
  var valid_580005 = query.getOrDefault("prettyPrint")
  valid_580005 = validateParameter(valid_580005, JBool, required = false,
                                 default = newJBool(false))
  if valid_580005 != nil:
    section.add "prettyPrint", valid_580005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580006: Call_AnalyticsDataMcfGet_579986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Analytics Multi-Channel Funnels data for a view (profile).
  ## 
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_AnalyticsDataMcfGet_579986; metrics: string;
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
  var query_580008 = newJObject()
  add(query_580008, "fields", newJString(fields))
  add(query_580008, "quotaUser", newJString(quotaUser))
  add(query_580008, "alt", newJString(alt))
  add(query_580008, "sort", newJString(sort))
  add(query_580008, "metrics", newJString(metrics))
  add(query_580008, "oauth_token", newJString(oauthToken))
  add(query_580008, "userIp", newJString(userIp))
  add(query_580008, "dimensions", newJString(dimensions))
  add(query_580008, "ids", newJString(ids))
  add(query_580008, "key", newJString(key))
  add(query_580008, "max-results", newJInt(maxResults))
  add(query_580008, "end-date", newJString(endDate))
  add(query_580008, "start-date", newJString(startDate))
  add(query_580008, "filters", newJString(filters))
  add(query_580008, "start-index", newJInt(startIndex))
  add(query_580008, "samplingLevel", newJString(samplingLevel))
  add(query_580008, "prettyPrint", newJBool(prettyPrint))
  result = call_580007.call(nil, query_580008, nil, nil, nil)

var analyticsDataMcfGet* = Call_AnalyticsDataMcfGet_579986(
    name: "analyticsDataMcfGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/data/mcf",
    validator: validate_AnalyticsDataMcfGet_579987, base: "/analytics/v3",
    url: url_AnalyticsDataMcfGet_579988, schemes: {Scheme.Https})
type
  Call_AnalyticsDataRealtimeGet_580009 = ref object of OpenApiRestCall_579437
proc url_AnalyticsDataRealtimeGet_580011(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsDataRealtimeGet_580010(path: JsonNode; query: JsonNode;
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
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("sort")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "sort", valid_580015
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_580016 = query.getOrDefault("metrics")
  valid_580016 = validateParameter(valid_580016, JString, required = true,
                                 default = nil)
  if valid_580016 != nil:
    section.add "metrics", valid_580016
  var valid_580017 = query.getOrDefault("oauth_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "oauth_token", valid_580017
  var valid_580018 = query.getOrDefault("userIp")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "userIp", valid_580018
  var valid_580019 = query.getOrDefault("dimensions")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "dimensions", valid_580019
  var valid_580020 = query.getOrDefault("ids")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "ids", valid_580020
  var valid_580021 = query.getOrDefault("key")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "key", valid_580021
  var valid_580022 = query.getOrDefault("max-results")
  valid_580022 = validateParameter(valid_580022, JInt, required = false, default = nil)
  if valid_580022 != nil:
    section.add "max-results", valid_580022
  var valid_580023 = query.getOrDefault("filters")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "filters", valid_580023
  var valid_580024 = query.getOrDefault("prettyPrint")
  valid_580024 = validateParameter(valid_580024, JBool, required = false,
                                 default = newJBool(false))
  if valid_580024 != nil:
    section.add "prettyPrint", valid_580024
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580025: Call_AnalyticsDataRealtimeGet_580009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns real time data for a view (profile).
  ## 
  let valid = call_580025.validator(path, query, header, formData, body)
  let scheme = call_580025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580025.url(scheme.get, call_580025.host, call_580025.base,
                         call_580025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580025, url, valid)

proc call*(call_580026: Call_AnalyticsDataRealtimeGet_580009; metrics: string;
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
  var query_580027 = newJObject()
  add(query_580027, "fields", newJString(fields))
  add(query_580027, "quotaUser", newJString(quotaUser))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "sort", newJString(sort))
  add(query_580027, "metrics", newJString(metrics))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "userIp", newJString(userIp))
  add(query_580027, "dimensions", newJString(dimensions))
  add(query_580027, "ids", newJString(ids))
  add(query_580027, "key", newJString(key))
  add(query_580027, "max-results", newJInt(maxResults))
  add(query_580027, "filters", newJString(filters))
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  result = call_580026.call(nil, query_580027, nil, nil, nil)

var analyticsDataRealtimeGet* = Call_AnalyticsDataRealtimeGet_580009(
    name: "analyticsDataRealtimeGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/data/realtime",
    validator: validate_AnalyticsDataRealtimeGet_580010, base: "/analytics/v3",
    url: url_AnalyticsDataRealtimeGet_580011, schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountSummariesList_580028 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementAccountSummariesList_580030(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementAccountSummariesList_580029(path: JsonNode;
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
  var valid_580031 = query.getOrDefault("fields")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "fields", valid_580031
  var valid_580032 = query.getOrDefault("quotaUser")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "quotaUser", valid_580032
  var valid_580033 = query.getOrDefault("alt")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = newJString("json"))
  if valid_580033 != nil:
    section.add "alt", valid_580033
  var valid_580034 = query.getOrDefault("oauth_token")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "oauth_token", valid_580034
  var valid_580035 = query.getOrDefault("userIp")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "userIp", valid_580035
  var valid_580036 = query.getOrDefault("key")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "key", valid_580036
  var valid_580037 = query.getOrDefault("max-results")
  valid_580037 = validateParameter(valid_580037, JInt, required = false, default = nil)
  if valid_580037 != nil:
    section.add "max-results", valid_580037
  var valid_580038 = query.getOrDefault("start-index")
  valid_580038 = validateParameter(valid_580038, JInt, required = false, default = nil)
  if valid_580038 != nil:
    section.add "start-index", valid_580038
  var valid_580039 = query.getOrDefault("prettyPrint")
  valid_580039 = validateParameter(valid_580039, JBool, required = false,
                                 default = newJBool(false))
  if valid_580039 != nil:
    section.add "prettyPrint", valid_580039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580040: Call_AnalyticsManagementAccountSummariesList_580028;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists account summaries (lightweight tree comprised of accounts/properties/profiles) to which the user has access.
  ## 
  let valid = call_580040.validator(path, query, header, formData, body)
  let scheme = call_580040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580040.url(scheme.get, call_580040.host, call_580040.base,
                         call_580040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580040, url, valid)

proc call*(call_580041: Call_AnalyticsManagementAccountSummariesList_580028;
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
  var query_580042 = newJObject()
  add(query_580042, "fields", newJString(fields))
  add(query_580042, "quotaUser", newJString(quotaUser))
  add(query_580042, "alt", newJString(alt))
  add(query_580042, "oauth_token", newJString(oauthToken))
  add(query_580042, "userIp", newJString(userIp))
  add(query_580042, "key", newJString(key))
  add(query_580042, "max-results", newJInt(maxResults))
  add(query_580042, "start-index", newJInt(startIndex))
  add(query_580042, "prettyPrint", newJBool(prettyPrint))
  result = call_580041.call(nil, query_580042, nil, nil, nil)

var analyticsManagementAccountSummariesList* = Call_AnalyticsManagementAccountSummariesList_580028(
    name: "analyticsManagementAccountSummariesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accountSummaries",
    validator: validate_AnalyticsManagementAccountSummariesList_580029,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountSummariesList_580030,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountsList_580043 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementAccountsList_580045(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementAccountsList_580044(path: JsonNode;
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
  var valid_580046 = query.getOrDefault("fields")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "fields", valid_580046
  var valid_580047 = query.getOrDefault("quotaUser")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "quotaUser", valid_580047
  var valid_580048 = query.getOrDefault("alt")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = newJString("json"))
  if valid_580048 != nil:
    section.add "alt", valid_580048
  var valid_580049 = query.getOrDefault("oauth_token")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "oauth_token", valid_580049
  var valid_580050 = query.getOrDefault("userIp")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "userIp", valid_580050
  var valid_580051 = query.getOrDefault("key")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "key", valid_580051
  var valid_580052 = query.getOrDefault("max-results")
  valid_580052 = validateParameter(valid_580052, JInt, required = false, default = nil)
  if valid_580052 != nil:
    section.add "max-results", valid_580052
  var valid_580053 = query.getOrDefault("start-index")
  valid_580053 = validateParameter(valid_580053, JInt, required = false, default = nil)
  if valid_580053 != nil:
    section.add "start-index", valid_580053
  var valid_580054 = query.getOrDefault("prettyPrint")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(false))
  if valid_580054 != nil:
    section.add "prettyPrint", valid_580054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580055: Call_AnalyticsManagementAccountsList_580043;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all accounts to which the user has access.
  ## 
  let valid = call_580055.validator(path, query, header, formData, body)
  let scheme = call_580055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580055.url(scheme.get, call_580055.host, call_580055.base,
                         call_580055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580055, url, valid)

proc call*(call_580056: Call_AnalyticsManagementAccountsList_580043;
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
  var query_580057 = newJObject()
  add(query_580057, "fields", newJString(fields))
  add(query_580057, "quotaUser", newJString(quotaUser))
  add(query_580057, "alt", newJString(alt))
  add(query_580057, "oauth_token", newJString(oauthToken))
  add(query_580057, "userIp", newJString(userIp))
  add(query_580057, "key", newJString(key))
  add(query_580057, "max-results", newJInt(maxResults))
  add(query_580057, "start-index", newJInt(startIndex))
  add(query_580057, "prettyPrint", newJBool(prettyPrint))
  result = call_580056.call(nil, query_580057, nil, nil, nil)

var analyticsManagementAccountsList* = Call_AnalyticsManagementAccountsList_580043(
    name: "analyticsManagementAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts",
    validator: validate_AnalyticsManagementAccountsList_580044,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountsList_580045,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksInsert_580089 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementAccountUserLinksInsert_580091(protocol: Scheme;
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

proc validate_AnalyticsManagementAccountUserLinksInsert_580090(path: JsonNode;
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
  var valid_580092 = path.getOrDefault("accountId")
  valid_580092 = validateParameter(valid_580092, JString, required = true,
                                 default = nil)
  if valid_580092 != nil:
    section.add "accountId", valid_580092
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
  var valid_580093 = query.getOrDefault("fields")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "fields", valid_580093
  var valid_580094 = query.getOrDefault("quotaUser")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "quotaUser", valid_580094
  var valid_580095 = query.getOrDefault("alt")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("json"))
  if valid_580095 != nil:
    section.add "alt", valid_580095
  var valid_580096 = query.getOrDefault("oauth_token")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "oauth_token", valid_580096
  var valid_580097 = query.getOrDefault("userIp")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "userIp", valid_580097
  var valid_580098 = query.getOrDefault("key")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "key", valid_580098
  var valid_580099 = query.getOrDefault("prettyPrint")
  valid_580099 = validateParameter(valid_580099, JBool, required = false,
                                 default = newJBool(false))
  if valid_580099 != nil:
    section.add "prettyPrint", valid_580099
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

proc call*(call_580101: Call_AnalyticsManagementAccountUserLinksInsert_580089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new user to the given account.
  ## 
  let valid = call_580101.validator(path, query, header, formData, body)
  let scheme = call_580101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580101.url(scheme.get, call_580101.host, call_580101.base,
                         call_580101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580101, url, valid)

proc call*(call_580102: Call_AnalyticsManagementAccountUserLinksInsert_580089;
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
  var path_580103 = newJObject()
  var query_580104 = newJObject()
  var body_580105 = newJObject()
  add(query_580104, "fields", newJString(fields))
  add(query_580104, "quotaUser", newJString(quotaUser))
  add(query_580104, "alt", newJString(alt))
  add(query_580104, "oauth_token", newJString(oauthToken))
  add(path_580103, "accountId", newJString(accountId))
  add(query_580104, "userIp", newJString(userIp))
  add(query_580104, "key", newJString(key))
  if body != nil:
    body_580105 = body
  add(query_580104, "prettyPrint", newJBool(prettyPrint))
  result = call_580102.call(path_580103, query_580104, nil, nil, body_580105)

var analyticsManagementAccountUserLinksInsert* = Call_AnalyticsManagementAccountUserLinksInsert_580089(
    name: "analyticsManagementAccountUserLinksInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks",
    validator: validate_AnalyticsManagementAccountUserLinksInsert_580090,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksInsert_580091,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksList_580058 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementAccountUserLinksList_580060(protocol: Scheme;
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

proc validate_AnalyticsManagementAccountUserLinksList_580059(path: JsonNode;
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
  var valid_580075 = path.getOrDefault("accountId")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "accountId", valid_580075
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
  var valid_580076 = query.getOrDefault("fields")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "fields", valid_580076
  var valid_580077 = query.getOrDefault("quotaUser")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "quotaUser", valid_580077
  var valid_580078 = query.getOrDefault("alt")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("json"))
  if valid_580078 != nil:
    section.add "alt", valid_580078
  var valid_580079 = query.getOrDefault("oauth_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "oauth_token", valid_580079
  var valid_580080 = query.getOrDefault("userIp")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "userIp", valid_580080
  var valid_580081 = query.getOrDefault("key")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "key", valid_580081
  var valid_580082 = query.getOrDefault("max-results")
  valid_580082 = validateParameter(valid_580082, JInt, required = false, default = nil)
  if valid_580082 != nil:
    section.add "max-results", valid_580082
  var valid_580083 = query.getOrDefault("start-index")
  valid_580083 = validateParameter(valid_580083, JInt, required = false, default = nil)
  if valid_580083 != nil:
    section.add "start-index", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(false))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580085: Call_AnalyticsManagementAccountUserLinksList_580058;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists account-user links for a given account.
  ## 
  let valid = call_580085.validator(path, query, header, formData, body)
  let scheme = call_580085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580085.url(scheme.get, call_580085.host, call_580085.base,
                         call_580085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580085, url, valid)

proc call*(call_580086: Call_AnalyticsManagementAccountUserLinksList_580058;
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
  var path_580087 = newJObject()
  var query_580088 = newJObject()
  add(query_580088, "fields", newJString(fields))
  add(query_580088, "quotaUser", newJString(quotaUser))
  add(query_580088, "alt", newJString(alt))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(path_580087, "accountId", newJString(accountId))
  add(query_580088, "userIp", newJString(userIp))
  add(query_580088, "key", newJString(key))
  add(query_580088, "max-results", newJInt(maxResults))
  add(query_580088, "start-index", newJInt(startIndex))
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  result = call_580086.call(path_580087, query_580088, nil, nil, nil)

var analyticsManagementAccountUserLinksList* = Call_AnalyticsManagementAccountUserLinksList_580058(
    name: "analyticsManagementAccountUserLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks",
    validator: validate_AnalyticsManagementAccountUserLinksList_580059,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksList_580060,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksUpdate_580106 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementAccountUserLinksUpdate_580108(protocol: Scheme;
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

proc validate_AnalyticsManagementAccountUserLinksUpdate_580107(path: JsonNode;
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
  var valid_580109 = path.getOrDefault("accountId")
  valid_580109 = validateParameter(valid_580109, JString, required = true,
                                 default = nil)
  if valid_580109 != nil:
    section.add "accountId", valid_580109
  var valid_580110 = path.getOrDefault("linkId")
  valid_580110 = validateParameter(valid_580110, JString, required = true,
                                 default = nil)
  if valid_580110 != nil:
    section.add "linkId", valid_580110
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
  var valid_580111 = query.getOrDefault("fields")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "fields", valid_580111
  var valid_580112 = query.getOrDefault("quotaUser")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "quotaUser", valid_580112
  var valid_580113 = query.getOrDefault("alt")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("json"))
  if valid_580113 != nil:
    section.add "alt", valid_580113
  var valid_580114 = query.getOrDefault("oauth_token")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "oauth_token", valid_580114
  var valid_580115 = query.getOrDefault("userIp")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "userIp", valid_580115
  var valid_580116 = query.getOrDefault("key")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "key", valid_580116
  var valid_580117 = query.getOrDefault("prettyPrint")
  valid_580117 = validateParameter(valid_580117, JBool, required = false,
                                 default = newJBool(false))
  if valid_580117 != nil:
    section.add "prettyPrint", valid_580117
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

proc call*(call_580119: Call_AnalyticsManagementAccountUserLinksUpdate_580106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates permissions for an existing user on the given account.
  ## 
  let valid = call_580119.validator(path, query, header, formData, body)
  let scheme = call_580119.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580119.url(scheme.get, call_580119.host, call_580119.base,
                         call_580119.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580119, url, valid)

proc call*(call_580120: Call_AnalyticsManagementAccountUserLinksUpdate_580106;
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
  var path_580121 = newJObject()
  var query_580122 = newJObject()
  var body_580123 = newJObject()
  add(query_580122, "fields", newJString(fields))
  add(query_580122, "quotaUser", newJString(quotaUser))
  add(query_580122, "alt", newJString(alt))
  add(query_580122, "oauth_token", newJString(oauthToken))
  add(path_580121, "accountId", newJString(accountId))
  add(query_580122, "userIp", newJString(userIp))
  add(query_580122, "key", newJString(key))
  add(path_580121, "linkId", newJString(linkId))
  if body != nil:
    body_580123 = body
  add(query_580122, "prettyPrint", newJBool(prettyPrint))
  result = call_580120.call(path_580121, query_580122, nil, nil, body_580123)

var analyticsManagementAccountUserLinksUpdate* = Call_AnalyticsManagementAccountUserLinksUpdate_580106(
    name: "analyticsManagementAccountUserLinksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementAccountUserLinksUpdate_580107,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksUpdate_580108,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountUserLinksDelete_580124 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementAccountUserLinksDelete_580126(protocol: Scheme;
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

proc validate_AnalyticsManagementAccountUserLinksDelete_580125(path: JsonNode;
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
  var valid_580127 = path.getOrDefault("accountId")
  valid_580127 = validateParameter(valid_580127, JString, required = true,
                                 default = nil)
  if valid_580127 != nil:
    section.add "accountId", valid_580127
  var valid_580128 = path.getOrDefault("linkId")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "linkId", valid_580128
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
  var valid_580129 = query.getOrDefault("fields")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "fields", valid_580129
  var valid_580130 = query.getOrDefault("quotaUser")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "quotaUser", valid_580130
  var valid_580131 = query.getOrDefault("alt")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = newJString("json"))
  if valid_580131 != nil:
    section.add "alt", valid_580131
  var valid_580132 = query.getOrDefault("oauth_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "oauth_token", valid_580132
  var valid_580133 = query.getOrDefault("userIp")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "userIp", valid_580133
  var valid_580134 = query.getOrDefault("key")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "key", valid_580134
  var valid_580135 = query.getOrDefault("prettyPrint")
  valid_580135 = validateParameter(valid_580135, JBool, required = false,
                                 default = newJBool(false))
  if valid_580135 != nil:
    section.add "prettyPrint", valid_580135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580136: Call_AnalyticsManagementAccountUserLinksDelete_580124;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the given account.
  ## 
  let valid = call_580136.validator(path, query, header, formData, body)
  let scheme = call_580136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580136.url(scheme.get, call_580136.host, call_580136.base,
                         call_580136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580136, url, valid)

proc call*(call_580137: Call_AnalyticsManagementAccountUserLinksDelete_580124;
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
  var path_580138 = newJObject()
  var query_580139 = newJObject()
  add(query_580139, "fields", newJString(fields))
  add(query_580139, "quotaUser", newJString(quotaUser))
  add(query_580139, "alt", newJString(alt))
  add(query_580139, "oauth_token", newJString(oauthToken))
  add(path_580138, "accountId", newJString(accountId))
  add(query_580139, "userIp", newJString(userIp))
  add(query_580139, "key", newJString(key))
  add(path_580138, "linkId", newJString(linkId))
  add(query_580139, "prettyPrint", newJBool(prettyPrint))
  result = call_580137.call(path_580138, query_580139, nil, nil, nil)

var analyticsManagementAccountUserLinksDelete* = Call_AnalyticsManagementAccountUserLinksDelete_580124(
    name: "analyticsManagementAccountUserLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementAccountUserLinksDelete_580125,
    base: "/analytics/v3", url: url_AnalyticsManagementAccountUserLinksDelete_580126,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersInsert_580157 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementFiltersInsert_580159(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementFiltersInsert_580158(path: JsonNode;
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
  var valid_580160 = path.getOrDefault("accountId")
  valid_580160 = validateParameter(valid_580160, JString, required = true,
                                 default = nil)
  if valid_580160 != nil:
    section.add "accountId", valid_580160
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
  var valid_580161 = query.getOrDefault("fields")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "fields", valid_580161
  var valid_580162 = query.getOrDefault("quotaUser")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "quotaUser", valid_580162
  var valid_580163 = query.getOrDefault("alt")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = newJString("json"))
  if valid_580163 != nil:
    section.add "alt", valid_580163
  var valid_580164 = query.getOrDefault("oauth_token")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "oauth_token", valid_580164
  var valid_580165 = query.getOrDefault("userIp")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "userIp", valid_580165
  var valid_580166 = query.getOrDefault("key")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "key", valid_580166
  var valid_580167 = query.getOrDefault("prettyPrint")
  valid_580167 = validateParameter(valid_580167, JBool, required = false,
                                 default = newJBool(false))
  if valid_580167 != nil:
    section.add "prettyPrint", valid_580167
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

proc call*(call_580169: Call_AnalyticsManagementFiltersInsert_580157;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new filter.
  ## 
  let valid = call_580169.validator(path, query, header, formData, body)
  let scheme = call_580169.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580169.url(scheme.get, call_580169.host, call_580169.base,
                         call_580169.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580169, url, valid)

proc call*(call_580170: Call_AnalyticsManagementFiltersInsert_580157;
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
  var path_580171 = newJObject()
  var query_580172 = newJObject()
  var body_580173 = newJObject()
  add(query_580172, "fields", newJString(fields))
  add(query_580172, "quotaUser", newJString(quotaUser))
  add(query_580172, "alt", newJString(alt))
  add(query_580172, "oauth_token", newJString(oauthToken))
  add(path_580171, "accountId", newJString(accountId))
  add(query_580172, "userIp", newJString(userIp))
  add(query_580172, "key", newJString(key))
  if body != nil:
    body_580173 = body
  add(query_580172, "prettyPrint", newJBool(prettyPrint))
  result = call_580170.call(path_580171, query_580172, nil, nil, body_580173)

var analyticsManagementFiltersInsert* = Call_AnalyticsManagementFiltersInsert_580157(
    name: "analyticsManagementFiltersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/filters",
    validator: validate_AnalyticsManagementFiltersInsert_580158,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersInsert_580159,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersList_580140 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementFiltersList_580142(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementFiltersList_580141(path: JsonNode;
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
  var valid_580143 = path.getOrDefault("accountId")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "accountId", valid_580143
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
  var valid_580144 = query.getOrDefault("fields")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "fields", valid_580144
  var valid_580145 = query.getOrDefault("quotaUser")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "quotaUser", valid_580145
  var valid_580146 = query.getOrDefault("alt")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("json"))
  if valid_580146 != nil:
    section.add "alt", valid_580146
  var valid_580147 = query.getOrDefault("oauth_token")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "oauth_token", valid_580147
  var valid_580148 = query.getOrDefault("userIp")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "userIp", valid_580148
  var valid_580149 = query.getOrDefault("key")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "key", valid_580149
  var valid_580150 = query.getOrDefault("max-results")
  valid_580150 = validateParameter(valid_580150, JInt, required = false, default = nil)
  if valid_580150 != nil:
    section.add "max-results", valid_580150
  var valid_580151 = query.getOrDefault("start-index")
  valid_580151 = validateParameter(valid_580151, JInt, required = false, default = nil)
  if valid_580151 != nil:
    section.add "start-index", valid_580151
  var valid_580152 = query.getOrDefault("prettyPrint")
  valid_580152 = validateParameter(valid_580152, JBool, required = false,
                                 default = newJBool(false))
  if valid_580152 != nil:
    section.add "prettyPrint", valid_580152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580153: Call_AnalyticsManagementFiltersList_580140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all filters for an account
  ## 
  let valid = call_580153.validator(path, query, header, formData, body)
  let scheme = call_580153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580153.url(scheme.get, call_580153.host, call_580153.base,
                         call_580153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580153, url, valid)

proc call*(call_580154: Call_AnalyticsManagementFiltersList_580140;
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
  var path_580155 = newJObject()
  var query_580156 = newJObject()
  add(query_580156, "fields", newJString(fields))
  add(query_580156, "quotaUser", newJString(quotaUser))
  add(query_580156, "alt", newJString(alt))
  add(query_580156, "oauth_token", newJString(oauthToken))
  add(path_580155, "accountId", newJString(accountId))
  add(query_580156, "userIp", newJString(userIp))
  add(query_580156, "key", newJString(key))
  add(query_580156, "max-results", newJInt(maxResults))
  add(query_580156, "start-index", newJInt(startIndex))
  add(query_580156, "prettyPrint", newJBool(prettyPrint))
  result = call_580154.call(path_580155, query_580156, nil, nil, nil)

var analyticsManagementFiltersList* = Call_AnalyticsManagementFiltersList_580140(
    name: "analyticsManagementFiltersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/filters",
    validator: validate_AnalyticsManagementFiltersList_580141,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersList_580142,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersUpdate_580190 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementFiltersUpdate_580192(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementFiltersUpdate_580191(path: JsonNode;
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
  var valid_580193 = path.getOrDefault("accountId")
  valid_580193 = validateParameter(valid_580193, JString, required = true,
                                 default = nil)
  if valid_580193 != nil:
    section.add "accountId", valid_580193
  var valid_580194 = path.getOrDefault("filterId")
  valid_580194 = validateParameter(valid_580194, JString, required = true,
                                 default = nil)
  if valid_580194 != nil:
    section.add "filterId", valid_580194
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
  var valid_580195 = query.getOrDefault("fields")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "fields", valid_580195
  var valid_580196 = query.getOrDefault("quotaUser")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "quotaUser", valid_580196
  var valid_580197 = query.getOrDefault("alt")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = newJString("json"))
  if valid_580197 != nil:
    section.add "alt", valid_580197
  var valid_580198 = query.getOrDefault("oauth_token")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "oauth_token", valid_580198
  var valid_580199 = query.getOrDefault("userIp")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "userIp", valid_580199
  var valid_580200 = query.getOrDefault("key")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "key", valid_580200
  var valid_580201 = query.getOrDefault("prettyPrint")
  valid_580201 = validateParameter(valid_580201, JBool, required = false,
                                 default = newJBool(false))
  if valid_580201 != nil:
    section.add "prettyPrint", valid_580201
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

proc call*(call_580203: Call_AnalyticsManagementFiltersUpdate_580190;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing filter.
  ## 
  let valid = call_580203.validator(path, query, header, formData, body)
  let scheme = call_580203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580203.url(scheme.get, call_580203.host, call_580203.base,
                         call_580203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580203, url, valid)

proc call*(call_580204: Call_AnalyticsManagementFiltersUpdate_580190;
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
  var path_580205 = newJObject()
  var query_580206 = newJObject()
  var body_580207 = newJObject()
  add(query_580206, "fields", newJString(fields))
  add(query_580206, "quotaUser", newJString(quotaUser))
  add(query_580206, "alt", newJString(alt))
  add(query_580206, "oauth_token", newJString(oauthToken))
  add(path_580205, "accountId", newJString(accountId))
  add(query_580206, "userIp", newJString(userIp))
  add(query_580206, "key", newJString(key))
  if body != nil:
    body_580207 = body
  add(query_580206, "prettyPrint", newJBool(prettyPrint))
  add(path_580205, "filterId", newJString(filterId))
  result = call_580204.call(path_580205, query_580206, nil, nil, body_580207)

var analyticsManagementFiltersUpdate* = Call_AnalyticsManagementFiltersUpdate_580190(
    name: "analyticsManagementFiltersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersUpdate_580191,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersUpdate_580192,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersGet_580174 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementFiltersGet_580176(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementFiltersGet_580175(path: JsonNode; query: JsonNode;
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
  var valid_580177 = path.getOrDefault("accountId")
  valid_580177 = validateParameter(valid_580177, JString, required = true,
                                 default = nil)
  if valid_580177 != nil:
    section.add "accountId", valid_580177
  var valid_580178 = path.getOrDefault("filterId")
  valid_580178 = validateParameter(valid_580178, JString, required = true,
                                 default = nil)
  if valid_580178 != nil:
    section.add "filterId", valid_580178
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
  var valid_580179 = query.getOrDefault("fields")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "fields", valid_580179
  var valid_580180 = query.getOrDefault("quotaUser")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "quotaUser", valid_580180
  var valid_580181 = query.getOrDefault("alt")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = newJString("json"))
  if valid_580181 != nil:
    section.add "alt", valid_580181
  var valid_580182 = query.getOrDefault("oauth_token")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "oauth_token", valid_580182
  var valid_580183 = query.getOrDefault("userIp")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "userIp", valid_580183
  var valid_580184 = query.getOrDefault("key")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "key", valid_580184
  var valid_580185 = query.getOrDefault("prettyPrint")
  valid_580185 = validateParameter(valid_580185, JBool, required = false,
                                 default = newJBool(false))
  if valid_580185 != nil:
    section.add "prettyPrint", valid_580185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580186: Call_AnalyticsManagementFiltersGet_580174; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns filters to which the user has access.
  ## 
  let valid = call_580186.validator(path, query, header, formData, body)
  let scheme = call_580186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580186.url(scheme.get, call_580186.host, call_580186.base,
                         call_580186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580186, url, valid)

proc call*(call_580187: Call_AnalyticsManagementFiltersGet_580174;
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
  var path_580188 = newJObject()
  var query_580189 = newJObject()
  add(query_580189, "fields", newJString(fields))
  add(query_580189, "quotaUser", newJString(quotaUser))
  add(query_580189, "alt", newJString(alt))
  add(query_580189, "oauth_token", newJString(oauthToken))
  add(path_580188, "accountId", newJString(accountId))
  add(query_580189, "userIp", newJString(userIp))
  add(query_580189, "key", newJString(key))
  add(query_580189, "prettyPrint", newJBool(prettyPrint))
  add(path_580188, "filterId", newJString(filterId))
  result = call_580187.call(path_580188, query_580189, nil, nil, nil)

var analyticsManagementFiltersGet* = Call_AnalyticsManagementFiltersGet_580174(
    name: "analyticsManagementFiltersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersGet_580175,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersGet_580176,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersPatch_580224 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementFiltersPatch_580226(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementFiltersPatch_580225(path: JsonNode;
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
  var valid_580227 = path.getOrDefault("accountId")
  valid_580227 = validateParameter(valid_580227, JString, required = true,
                                 default = nil)
  if valid_580227 != nil:
    section.add "accountId", valid_580227
  var valid_580228 = path.getOrDefault("filterId")
  valid_580228 = validateParameter(valid_580228, JString, required = true,
                                 default = nil)
  if valid_580228 != nil:
    section.add "filterId", valid_580228
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
  var valid_580229 = query.getOrDefault("fields")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "fields", valid_580229
  var valid_580230 = query.getOrDefault("quotaUser")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "quotaUser", valid_580230
  var valid_580231 = query.getOrDefault("alt")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = newJString("json"))
  if valid_580231 != nil:
    section.add "alt", valid_580231
  var valid_580232 = query.getOrDefault("oauth_token")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "oauth_token", valid_580232
  var valid_580233 = query.getOrDefault("userIp")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "userIp", valid_580233
  var valid_580234 = query.getOrDefault("key")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "key", valid_580234
  var valid_580235 = query.getOrDefault("prettyPrint")
  valid_580235 = validateParameter(valid_580235, JBool, required = false,
                                 default = newJBool(false))
  if valid_580235 != nil:
    section.add "prettyPrint", valid_580235
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

proc call*(call_580237: Call_AnalyticsManagementFiltersPatch_580224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing filter. This method supports patch semantics.
  ## 
  let valid = call_580237.validator(path, query, header, formData, body)
  let scheme = call_580237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580237.url(scheme.get, call_580237.host, call_580237.base,
                         call_580237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580237, url, valid)

proc call*(call_580238: Call_AnalyticsManagementFiltersPatch_580224;
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
  var path_580239 = newJObject()
  var query_580240 = newJObject()
  var body_580241 = newJObject()
  add(query_580240, "fields", newJString(fields))
  add(query_580240, "quotaUser", newJString(quotaUser))
  add(query_580240, "alt", newJString(alt))
  add(query_580240, "oauth_token", newJString(oauthToken))
  add(path_580239, "accountId", newJString(accountId))
  add(query_580240, "userIp", newJString(userIp))
  add(query_580240, "key", newJString(key))
  if body != nil:
    body_580241 = body
  add(query_580240, "prettyPrint", newJBool(prettyPrint))
  add(path_580239, "filterId", newJString(filterId))
  result = call_580238.call(path_580239, query_580240, nil, nil, body_580241)

var analyticsManagementFiltersPatch* = Call_AnalyticsManagementFiltersPatch_580224(
    name: "analyticsManagementFiltersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersPatch_580225,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersPatch_580226,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementFiltersDelete_580208 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementFiltersDelete_580210(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementFiltersDelete_580209(path: JsonNode;
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
  var valid_580211 = path.getOrDefault("accountId")
  valid_580211 = validateParameter(valid_580211, JString, required = true,
                                 default = nil)
  if valid_580211 != nil:
    section.add "accountId", valid_580211
  var valid_580212 = path.getOrDefault("filterId")
  valid_580212 = validateParameter(valid_580212, JString, required = true,
                                 default = nil)
  if valid_580212 != nil:
    section.add "filterId", valid_580212
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
  var valid_580213 = query.getOrDefault("fields")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "fields", valid_580213
  var valid_580214 = query.getOrDefault("quotaUser")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "quotaUser", valid_580214
  var valid_580215 = query.getOrDefault("alt")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = newJString("json"))
  if valid_580215 != nil:
    section.add "alt", valid_580215
  var valid_580216 = query.getOrDefault("oauth_token")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "oauth_token", valid_580216
  var valid_580217 = query.getOrDefault("userIp")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "userIp", valid_580217
  var valid_580218 = query.getOrDefault("key")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "key", valid_580218
  var valid_580219 = query.getOrDefault("prettyPrint")
  valid_580219 = validateParameter(valid_580219, JBool, required = false,
                                 default = newJBool(false))
  if valid_580219 != nil:
    section.add "prettyPrint", valid_580219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580220: Call_AnalyticsManagementFiltersDelete_580208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a filter.
  ## 
  let valid = call_580220.validator(path, query, header, formData, body)
  let scheme = call_580220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580220.url(scheme.get, call_580220.host, call_580220.base,
                         call_580220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580220, url, valid)

proc call*(call_580221: Call_AnalyticsManagementFiltersDelete_580208;
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
  var path_580222 = newJObject()
  var query_580223 = newJObject()
  add(query_580223, "fields", newJString(fields))
  add(query_580223, "quotaUser", newJString(quotaUser))
  add(query_580223, "alt", newJString(alt))
  add(query_580223, "oauth_token", newJString(oauthToken))
  add(path_580222, "accountId", newJString(accountId))
  add(query_580223, "userIp", newJString(userIp))
  add(query_580223, "key", newJString(key))
  add(query_580223, "prettyPrint", newJBool(prettyPrint))
  add(path_580222, "filterId", newJString(filterId))
  result = call_580221.call(path_580222, query_580223, nil, nil, nil)

var analyticsManagementFiltersDelete* = Call_AnalyticsManagementFiltersDelete_580208(
    name: "analyticsManagementFiltersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/filters/{filterId}",
    validator: validate_AnalyticsManagementFiltersDelete_580209,
    base: "/analytics/v3", url: url_AnalyticsManagementFiltersDelete_580210,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesInsert_580259 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebpropertiesInsert_580261(protocol: Scheme;
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

proc validate_AnalyticsManagementWebpropertiesInsert_580260(path: JsonNode;
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
  var valid_580262 = path.getOrDefault("accountId")
  valid_580262 = validateParameter(valid_580262, JString, required = true,
                                 default = nil)
  if valid_580262 != nil:
    section.add "accountId", valid_580262
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
  var valid_580263 = query.getOrDefault("fields")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "fields", valid_580263
  var valid_580264 = query.getOrDefault("quotaUser")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "quotaUser", valid_580264
  var valid_580265 = query.getOrDefault("alt")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = newJString("json"))
  if valid_580265 != nil:
    section.add "alt", valid_580265
  var valid_580266 = query.getOrDefault("oauth_token")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = nil)
  if valid_580266 != nil:
    section.add "oauth_token", valid_580266
  var valid_580267 = query.getOrDefault("userIp")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "userIp", valid_580267
  var valid_580268 = query.getOrDefault("key")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "key", valid_580268
  var valid_580269 = query.getOrDefault("prettyPrint")
  valid_580269 = validateParameter(valid_580269, JBool, required = false,
                                 default = newJBool(false))
  if valid_580269 != nil:
    section.add "prettyPrint", valid_580269
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

proc call*(call_580271: Call_AnalyticsManagementWebpropertiesInsert_580259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new property if the account has fewer than 20 properties. Web properties are visible in the Google Analytics interface only if they have at least one profile.
  ## 
  let valid = call_580271.validator(path, query, header, formData, body)
  let scheme = call_580271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580271.url(scheme.get, call_580271.host, call_580271.base,
                         call_580271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580271, url, valid)

proc call*(call_580272: Call_AnalyticsManagementWebpropertiesInsert_580259;
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
  var path_580273 = newJObject()
  var query_580274 = newJObject()
  var body_580275 = newJObject()
  add(query_580274, "fields", newJString(fields))
  add(query_580274, "quotaUser", newJString(quotaUser))
  add(query_580274, "alt", newJString(alt))
  add(query_580274, "oauth_token", newJString(oauthToken))
  add(path_580273, "accountId", newJString(accountId))
  add(query_580274, "userIp", newJString(userIp))
  add(query_580274, "key", newJString(key))
  if body != nil:
    body_580275 = body
  add(query_580274, "prettyPrint", newJBool(prettyPrint))
  result = call_580272.call(path_580273, query_580274, nil, nil, body_580275)

var analyticsManagementWebpropertiesInsert* = Call_AnalyticsManagementWebpropertiesInsert_580259(
    name: "analyticsManagementWebpropertiesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties",
    validator: validate_AnalyticsManagementWebpropertiesInsert_580260,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesInsert_580261,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesList_580242 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebpropertiesList_580244(protocol: Scheme;
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

proc validate_AnalyticsManagementWebpropertiesList_580243(path: JsonNode;
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
  var valid_580245 = path.getOrDefault("accountId")
  valid_580245 = validateParameter(valid_580245, JString, required = true,
                                 default = nil)
  if valid_580245 != nil:
    section.add "accountId", valid_580245
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
  var valid_580246 = query.getOrDefault("fields")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "fields", valid_580246
  var valid_580247 = query.getOrDefault("quotaUser")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "quotaUser", valid_580247
  var valid_580248 = query.getOrDefault("alt")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = newJString("json"))
  if valid_580248 != nil:
    section.add "alt", valid_580248
  var valid_580249 = query.getOrDefault("oauth_token")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "oauth_token", valid_580249
  var valid_580250 = query.getOrDefault("userIp")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "userIp", valid_580250
  var valid_580251 = query.getOrDefault("key")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "key", valid_580251
  var valid_580252 = query.getOrDefault("max-results")
  valid_580252 = validateParameter(valid_580252, JInt, required = false, default = nil)
  if valid_580252 != nil:
    section.add "max-results", valid_580252
  var valid_580253 = query.getOrDefault("start-index")
  valid_580253 = validateParameter(valid_580253, JInt, required = false, default = nil)
  if valid_580253 != nil:
    section.add "start-index", valid_580253
  var valid_580254 = query.getOrDefault("prettyPrint")
  valid_580254 = validateParameter(valid_580254, JBool, required = false,
                                 default = newJBool(false))
  if valid_580254 != nil:
    section.add "prettyPrint", valid_580254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580255: Call_AnalyticsManagementWebpropertiesList_580242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists web properties to which the user has access.
  ## 
  let valid = call_580255.validator(path, query, header, formData, body)
  let scheme = call_580255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580255.url(scheme.get, call_580255.host, call_580255.base,
                         call_580255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580255, url, valid)

proc call*(call_580256: Call_AnalyticsManagementWebpropertiesList_580242;
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
  var path_580257 = newJObject()
  var query_580258 = newJObject()
  add(query_580258, "fields", newJString(fields))
  add(query_580258, "quotaUser", newJString(quotaUser))
  add(query_580258, "alt", newJString(alt))
  add(query_580258, "oauth_token", newJString(oauthToken))
  add(path_580257, "accountId", newJString(accountId))
  add(query_580258, "userIp", newJString(userIp))
  add(query_580258, "key", newJString(key))
  add(query_580258, "max-results", newJInt(maxResults))
  add(query_580258, "start-index", newJInt(startIndex))
  add(query_580258, "prettyPrint", newJBool(prettyPrint))
  result = call_580256.call(path_580257, query_580258, nil, nil, nil)

var analyticsManagementWebpropertiesList* = Call_AnalyticsManagementWebpropertiesList_580242(
    name: "analyticsManagementWebpropertiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties",
    validator: validate_AnalyticsManagementWebpropertiesList_580243,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesList_580244,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesUpdate_580292 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebpropertiesUpdate_580294(protocol: Scheme;
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

proc validate_AnalyticsManagementWebpropertiesUpdate_580293(path: JsonNode;
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
  var valid_580295 = path.getOrDefault("accountId")
  valid_580295 = validateParameter(valid_580295, JString, required = true,
                                 default = nil)
  if valid_580295 != nil:
    section.add "accountId", valid_580295
  var valid_580296 = path.getOrDefault("webPropertyId")
  valid_580296 = validateParameter(valid_580296, JString, required = true,
                                 default = nil)
  if valid_580296 != nil:
    section.add "webPropertyId", valid_580296
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
  var valid_580297 = query.getOrDefault("fields")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "fields", valid_580297
  var valid_580298 = query.getOrDefault("quotaUser")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "quotaUser", valid_580298
  var valid_580299 = query.getOrDefault("alt")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = newJString("json"))
  if valid_580299 != nil:
    section.add "alt", valid_580299
  var valid_580300 = query.getOrDefault("oauth_token")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "oauth_token", valid_580300
  var valid_580301 = query.getOrDefault("userIp")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "userIp", valid_580301
  var valid_580302 = query.getOrDefault("key")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "key", valid_580302
  var valid_580303 = query.getOrDefault("prettyPrint")
  valid_580303 = validateParameter(valid_580303, JBool, required = false,
                                 default = newJBool(false))
  if valid_580303 != nil:
    section.add "prettyPrint", valid_580303
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

proc call*(call_580305: Call_AnalyticsManagementWebpropertiesUpdate_580292;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing web property.
  ## 
  let valid = call_580305.validator(path, query, header, formData, body)
  let scheme = call_580305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580305.url(scheme.get, call_580305.host, call_580305.base,
                         call_580305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580305, url, valid)

proc call*(call_580306: Call_AnalyticsManagementWebpropertiesUpdate_580292;
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
  var path_580307 = newJObject()
  var query_580308 = newJObject()
  var body_580309 = newJObject()
  add(query_580308, "fields", newJString(fields))
  add(query_580308, "quotaUser", newJString(quotaUser))
  add(query_580308, "alt", newJString(alt))
  add(query_580308, "oauth_token", newJString(oauthToken))
  add(path_580307, "accountId", newJString(accountId))
  add(query_580308, "userIp", newJString(userIp))
  add(path_580307, "webPropertyId", newJString(webPropertyId))
  add(query_580308, "key", newJString(key))
  if body != nil:
    body_580309 = body
  add(query_580308, "prettyPrint", newJBool(prettyPrint))
  result = call_580306.call(path_580307, query_580308, nil, nil, body_580309)

var analyticsManagementWebpropertiesUpdate* = Call_AnalyticsManagementWebpropertiesUpdate_580292(
    name: "analyticsManagementWebpropertiesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties/{webPropertyId}",
    validator: validate_AnalyticsManagementWebpropertiesUpdate_580293,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesUpdate_580294,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesGet_580276 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebpropertiesGet_580278(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementWebpropertiesGet_580277(path: JsonNode;
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
  var valid_580279 = path.getOrDefault("accountId")
  valid_580279 = validateParameter(valid_580279, JString, required = true,
                                 default = nil)
  if valid_580279 != nil:
    section.add "accountId", valid_580279
  var valid_580280 = path.getOrDefault("webPropertyId")
  valid_580280 = validateParameter(valid_580280, JString, required = true,
                                 default = nil)
  if valid_580280 != nil:
    section.add "webPropertyId", valid_580280
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
  var valid_580281 = query.getOrDefault("fields")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "fields", valid_580281
  var valid_580282 = query.getOrDefault("quotaUser")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "quotaUser", valid_580282
  var valid_580283 = query.getOrDefault("alt")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = newJString("json"))
  if valid_580283 != nil:
    section.add "alt", valid_580283
  var valid_580284 = query.getOrDefault("oauth_token")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "oauth_token", valid_580284
  var valid_580285 = query.getOrDefault("userIp")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "userIp", valid_580285
  var valid_580286 = query.getOrDefault("key")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "key", valid_580286
  var valid_580287 = query.getOrDefault("prettyPrint")
  valid_580287 = validateParameter(valid_580287, JBool, required = false,
                                 default = newJBool(false))
  if valid_580287 != nil:
    section.add "prettyPrint", valid_580287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580288: Call_AnalyticsManagementWebpropertiesGet_580276;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a web property to which the user has access.
  ## 
  let valid = call_580288.validator(path, query, header, formData, body)
  let scheme = call_580288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580288.url(scheme.get, call_580288.host, call_580288.base,
                         call_580288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580288, url, valid)

proc call*(call_580289: Call_AnalyticsManagementWebpropertiesGet_580276;
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
  var path_580290 = newJObject()
  var query_580291 = newJObject()
  add(query_580291, "fields", newJString(fields))
  add(query_580291, "quotaUser", newJString(quotaUser))
  add(query_580291, "alt", newJString(alt))
  add(query_580291, "oauth_token", newJString(oauthToken))
  add(path_580290, "accountId", newJString(accountId))
  add(query_580291, "userIp", newJString(userIp))
  add(path_580290, "webPropertyId", newJString(webPropertyId))
  add(query_580291, "key", newJString(key))
  add(query_580291, "prettyPrint", newJBool(prettyPrint))
  result = call_580289.call(path_580290, query_580291, nil, nil, nil)

var analyticsManagementWebpropertiesGet* = Call_AnalyticsManagementWebpropertiesGet_580276(
    name: "analyticsManagementWebpropertiesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties/{webPropertyId}",
    validator: validate_AnalyticsManagementWebpropertiesGet_580277,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesGet_580278,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesPatch_580310 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebpropertiesPatch_580312(protocol: Scheme;
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

proc validate_AnalyticsManagementWebpropertiesPatch_580311(path: JsonNode;
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
  var valid_580313 = path.getOrDefault("accountId")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "accountId", valid_580313
  var valid_580314 = path.getOrDefault("webPropertyId")
  valid_580314 = validateParameter(valid_580314, JString, required = true,
                                 default = nil)
  if valid_580314 != nil:
    section.add "webPropertyId", valid_580314
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
  var valid_580315 = query.getOrDefault("fields")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "fields", valid_580315
  var valid_580316 = query.getOrDefault("quotaUser")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "quotaUser", valid_580316
  var valid_580317 = query.getOrDefault("alt")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = newJString("json"))
  if valid_580317 != nil:
    section.add "alt", valid_580317
  var valid_580318 = query.getOrDefault("oauth_token")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "oauth_token", valid_580318
  var valid_580319 = query.getOrDefault("userIp")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "userIp", valid_580319
  var valid_580320 = query.getOrDefault("key")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "key", valid_580320
  var valid_580321 = query.getOrDefault("prettyPrint")
  valid_580321 = validateParameter(valid_580321, JBool, required = false,
                                 default = newJBool(false))
  if valid_580321 != nil:
    section.add "prettyPrint", valid_580321
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

proc call*(call_580323: Call_AnalyticsManagementWebpropertiesPatch_580310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing web property. This method supports patch semantics.
  ## 
  let valid = call_580323.validator(path, query, header, formData, body)
  let scheme = call_580323.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580323.url(scheme.get, call_580323.host, call_580323.base,
                         call_580323.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580323, url, valid)

proc call*(call_580324: Call_AnalyticsManagementWebpropertiesPatch_580310;
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
  var path_580325 = newJObject()
  var query_580326 = newJObject()
  var body_580327 = newJObject()
  add(query_580326, "fields", newJString(fields))
  add(query_580326, "quotaUser", newJString(quotaUser))
  add(query_580326, "alt", newJString(alt))
  add(query_580326, "oauth_token", newJString(oauthToken))
  add(path_580325, "accountId", newJString(accountId))
  add(query_580326, "userIp", newJString(userIp))
  add(path_580325, "webPropertyId", newJString(webPropertyId))
  add(query_580326, "key", newJString(key))
  if body != nil:
    body_580327 = body
  add(query_580326, "prettyPrint", newJBool(prettyPrint))
  result = call_580324.call(path_580325, query_580326, nil, nil, body_580327)

var analyticsManagementWebpropertiesPatch* = Call_AnalyticsManagementWebpropertiesPatch_580310(
    name: "analyticsManagementWebpropertiesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties/{webPropertyId}",
    validator: validate_AnalyticsManagementWebpropertiesPatch_580311,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertiesPatch_580312,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDataSourcesList_580328 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementCustomDataSourcesList_580330(protocol: Scheme;
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

proc validate_AnalyticsManagementCustomDataSourcesList_580329(path: JsonNode;
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
  var valid_580331 = path.getOrDefault("accountId")
  valid_580331 = validateParameter(valid_580331, JString, required = true,
                                 default = nil)
  if valid_580331 != nil:
    section.add "accountId", valid_580331
  var valid_580332 = path.getOrDefault("webPropertyId")
  valid_580332 = validateParameter(valid_580332, JString, required = true,
                                 default = nil)
  if valid_580332 != nil:
    section.add "webPropertyId", valid_580332
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
  var valid_580333 = query.getOrDefault("fields")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "fields", valid_580333
  var valid_580334 = query.getOrDefault("quotaUser")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "quotaUser", valid_580334
  var valid_580335 = query.getOrDefault("alt")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = newJString("json"))
  if valid_580335 != nil:
    section.add "alt", valid_580335
  var valid_580336 = query.getOrDefault("oauth_token")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "oauth_token", valid_580336
  var valid_580337 = query.getOrDefault("userIp")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "userIp", valid_580337
  var valid_580338 = query.getOrDefault("key")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "key", valid_580338
  var valid_580339 = query.getOrDefault("max-results")
  valid_580339 = validateParameter(valid_580339, JInt, required = false, default = nil)
  if valid_580339 != nil:
    section.add "max-results", valid_580339
  var valid_580340 = query.getOrDefault("start-index")
  valid_580340 = validateParameter(valid_580340, JInt, required = false, default = nil)
  if valid_580340 != nil:
    section.add "start-index", valid_580340
  var valid_580341 = query.getOrDefault("prettyPrint")
  valid_580341 = validateParameter(valid_580341, JBool, required = false,
                                 default = newJBool(false))
  if valid_580341 != nil:
    section.add "prettyPrint", valid_580341
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580342: Call_AnalyticsManagementCustomDataSourcesList_580328;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## List custom data sources to which the user has access.
  ## 
  let valid = call_580342.validator(path, query, header, formData, body)
  let scheme = call_580342.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580342.url(scheme.get, call_580342.host, call_580342.base,
                         call_580342.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580342, url, valid)

proc call*(call_580343: Call_AnalyticsManagementCustomDataSourcesList_580328;
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
  var path_580344 = newJObject()
  var query_580345 = newJObject()
  add(query_580345, "fields", newJString(fields))
  add(query_580345, "quotaUser", newJString(quotaUser))
  add(query_580345, "alt", newJString(alt))
  add(query_580345, "oauth_token", newJString(oauthToken))
  add(path_580344, "accountId", newJString(accountId))
  add(query_580345, "userIp", newJString(userIp))
  add(path_580344, "webPropertyId", newJString(webPropertyId))
  add(query_580345, "key", newJString(key))
  add(query_580345, "max-results", newJInt(maxResults))
  add(query_580345, "start-index", newJInt(startIndex))
  add(query_580345, "prettyPrint", newJBool(prettyPrint))
  result = call_580343.call(path_580344, query_580345, nil, nil, nil)

var analyticsManagementCustomDataSourcesList* = Call_AnalyticsManagementCustomDataSourcesList_580328(
    name: "analyticsManagementCustomDataSourcesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources",
    validator: validate_AnalyticsManagementCustomDataSourcesList_580329,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDataSourcesList_580330,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsDeleteUploadData_580346 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementUploadsDeleteUploadData_580348(protocol: Scheme;
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

proc validate_AnalyticsManagementUploadsDeleteUploadData_580347(path: JsonNode;
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
  var valid_580349 = path.getOrDefault("accountId")
  valid_580349 = validateParameter(valid_580349, JString, required = true,
                                 default = nil)
  if valid_580349 != nil:
    section.add "accountId", valid_580349
  var valid_580350 = path.getOrDefault("webPropertyId")
  valid_580350 = validateParameter(valid_580350, JString, required = true,
                                 default = nil)
  if valid_580350 != nil:
    section.add "webPropertyId", valid_580350
  var valid_580351 = path.getOrDefault("customDataSourceId")
  valid_580351 = validateParameter(valid_580351, JString, required = true,
                                 default = nil)
  if valid_580351 != nil:
    section.add "customDataSourceId", valid_580351
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
  var valid_580352 = query.getOrDefault("fields")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "fields", valid_580352
  var valid_580353 = query.getOrDefault("quotaUser")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "quotaUser", valid_580353
  var valid_580354 = query.getOrDefault("alt")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = newJString("json"))
  if valid_580354 != nil:
    section.add "alt", valid_580354
  var valid_580355 = query.getOrDefault("oauth_token")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "oauth_token", valid_580355
  var valid_580356 = query.getOrDefault("userIp")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "userIp", valid_580356
  var valid_580357 = query.getOrDefault("key")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "key", valid_580357
  var valid_580358 = query.getOrDefault("prettyPrint")
  valid_580358 = validateParameter(valid_580358, JBool, required = false,
                                 default = newJBool(false))
  if valid_580358 != nil:
    section.add "prettyPrint", valid_580358
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

proc call*(call_580360: Call_AnalyticsManagementUploadsDeleteUploadData_580346;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete data associated with a previous upload.
  ## 
  let valid = call_580360.validator(path, query, header, formData, body)
  let scheme = call_580360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580360.url(scheme.get, call_580360.host, call_580360.base,
                         call_580360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580360, url, valid)

proc call*(call_580361: Call_AnalyticsManagementUploadsDeleteUploadData_580346;
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
  var path_580362 = newJObject()
  var query_580363 = newJObject()
  var body_580364 = newJObject()
  add(query_580363, "fields", newJString(fields))
  add(query_580363, "quotaUser", newJString(quotaUser))
  add(query_580363, "alt", newJString(alt))
  add(query_580363, "oauth_token", newJString(oauthToken))
  add(path_580362, "accountId", newJString(accountId))
  add(query_580363, "userIp", newJString(userIp))
  add(path_580362, "webPropertyId", newJString(webPropertyId))
  add(query_580363, "key", newJString(key))
  if body != nil:
    body_580364 = body
  add(query_580363, "prettyPrint", newJBool(prettyPrint))
  add(path_580362, "customDataSourceId", newJString(customDataSourceId))
  result = call_580361.call(path_580362, query_580363, nil, nil, body_580364)

var analyticsManagementUploadsDeleteUploadData* = Call_AnalyticsManagementUploadsDeleteUploadData_580346(
    name: "analyticsManagementUploadsDeleteUploadData", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/deleteUploadData",
    validator: validate_AnalyticsManagementUploadsDeleteUploadData_580347,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsDeleteUploadData_580348,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsUploadData_580384 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementUploadsUploadData_580386(protocol: Scheme;
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

proc validate_AnalyticsManagementUploadsUploadData_580385(path: JsonNode;
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
  var valid_580387 = path.getOrDefault("accountId")
  valid_580387 = validateParameter(valid_580387, JString, required = true,
                                 default = nil)
  if valid_580387 != nil:
    section.add "accountId", valid_580387
  var valid_580388 = path.getOrDefault("webPropertyId")
  valid_580388 = validateParameter(valid_580388, JString, required = true,
                                 default = nil)
  if valid_580388 != nil:
    section.add "webPropertyId", valid_580388
  var valid_580389 = path.getOrDefault("customDataSourceId")
  valid_580389 = validateParameter(valid_580389, JString, required = true,
                                 default = nil)
  if valid_580389 != nil:
    section.add "customDataSourceId", valid_580389
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
  var valid_580390 = query.getOrDefault("fields")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "fields", valid_580390
  var valid_580391 = query.getOrDefault("quotaUser")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "quotaUser", valid_580391
  var valid_580392 = query.getOrDefault("alt")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = newJString("json"))
  if valid_580392 != nil:
    section.add "alt", valid_580392
  var valid_580393 = query.getOrDefault("oauth_token")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "oauth_token", valid_580393
  var valid_580394 = query.getOrDefault("userIp")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "userIp", valid_580394
  var valid_580395 = query.getOrDefault("key")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "key", valid_580395
  var valid_580396 = query.getOrDefault("prettyPrint")
  valid_580396 = validateParameter(valid_580396, JBool, required = false,
                                 default = newJBool(false))
  if valid_580396 != nil:
    section.add "prettyPrint", valid_580396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580397: Call_AnalyticsManagementUploadsUploadData_580384;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Upload data for a custom data source.
  ## 
  let valid = call_580397.validator(path, query, header, formData, body)
  let scheme = call_580397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580397.url(scheme.get, call_580397.host, call_580397.base,
                         call_580397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580397, url, valid)

proc call*(call_580398: Call_AnalyticsManagementUploadsUploadData_580384;
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
  var path_580399 = newJObject()
  var query_580400 = newJObject()
  add(query_580400, "fields", newJString(fields))
  add(query_580400, "quotaUser", newJString(quotaUser))
  add(query_580400, "alt", newJString(alt))
  add(query_580400, "oauth_token", newJString(oauthToken))
  add(path_580399, "accountId", newJString(accountId))
  add(query_580400, "userIp", newJString(userIp))
  add(path_580399, "webPropertyId", newJString(webPropertyId))
  add(query_580400, "key", newJString(key))
  add(path_580399, "customDataSourceId", newJString(customDataSourceId))
  add(query_580400, "prettyPrint", newJBool(prettyPrint))
  result = call_580398.call(path_580399, query_580400, nil, nil, nil)

var analyticsManagementUploadsUploadData* = Call_AnalyticsManagementUploadsUploadData_580384(
    name: "analyticsManagementUploadsUploadData", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/uploads",
    validator: validate_AnalyticsManagementUploadsUploadData_580385,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsUploadData_580386,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsList_580365 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementUploadsList_580367(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementUploadsList_580366(path: JsonNode;
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
  var valid_580368 = path.getOrDefault("accountId")
  valid_580368 = validateParameter(valid_580368, JString, required = true,
                                 default = nil)
  if valid_580368 != nil:
    section.add "accountId", valid_580368
  var valid_580369 = path.getOrDefault("webPropertyId")
  valid_580369 = validateParameter(valid_580369, JString, required = true,
                                 default = nil)
  if valid_580369 != nil:
    section.add "webPropertyId", valid_580369
  var valid_580370 = path.getOrDefault("customDataSourceId")
  valid_580370 = validateParameter(valid_580370, JString, required = true,
                                 default = nil)
  if valid_580370 != nil:
    section.add "customDataSourceId", valid_580370
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
  var valid_580371 = query.getOrDefault("fields")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "fields", valid_580371
  var valid_580372 = query.getOrDefault("quotaUser")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "quotaUser", valid_580372
  var valid_580373 = query.getOrDefault("alt")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = newJString("json"))
  if valid_580373 != nil:
    section.add "alt", valid_580373
  var valid_580374 = query.getOrDefault("oauth_token")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "oauth_token", valid_580374
  var valid_580375 = query.getOrDefault("userIp")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "userIp", valid_580375
  var valid_580376 = query.getOrDefault("key")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "key", valid_580376
  var valid_580377 = query.getOrDefault("max-results")
  valid_580377 = validateParameter(valid_580377, JInt, required = false, default = nil)
  if valid_580377 != nil:
    section.add "max-results", valid_580377
  var valid_580378 = query.getOrDefault("start-index")
  valid_580378 = validateParameter(valid_580378, JInt, required = false, default = nil)
  if valid_580378 != nil:
    section.add "start-index", valid_580378
  var valid_580379 = query.getOrDefault("prettyPrint")
  valid_580379 = validateParameter(valid_580379, JBool, required = false,
                                 default = newJBool(false))
  if valid_580379 != nil:
    section.add "prettyPrint", valid_580379
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580380: Call_AnalyticsManagementUploadsList_580365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List uploads to which the user has access.
  ## 
  let valid = call_580380.validator(path, query, header, formData, body)
  let scheme = call_580380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580380.url(scheme.get, call_580380.host, call_580380.base,
                         call_580380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580380, url, valid)

proc call*(call_580381: Call_AnalyticsManagementUploadsList_580365;
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
  var path_580382 = newJObject()
  var query_580383 = newJObject()
  add(query_580383, "fields", newJString(fields))
  add(query_580383, "quotaUser", newJString(quotaUser))
  add(query_580383, "alt", newJString(alt))
  add(query_580383, "oauth_token", newJString(oauthToken))
  add(path_580382, "accountId", newJString(accountId))
  add(query_580383, "userIp", newJString(userIp))
  add(path_580382, "webPropertyId", newJString(webPropertyId))
  add(query_580383, "key", newJString(key))
  add(query_580383, "max-results", newJInt(maxResults))
  add(query_580383, "start-index", newJInt(startIndex))
  add(path_580382, "customDataSourceId", newJString(customDataSourceId))
  add(query_580383, "prettyPrint", newJBool(prettyPrint))
  result = call_580381.call(path_580382, query_580383, nil, nil, nil)

var analyticsManagementUploadsList* = Call_AnalyticsManagementUploadsList_580365(
    name: "analyticsManagementUploadsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/uploads",
    validator: validate_AnalyticsManagementUploadsList_580366,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsList_580367,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUploadsGet_580401 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementUploadsGet_580403(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementUploadsGet_580402(path: JsonNode; query: JsonNode;
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
  var valid_580404 = path.getOrDefault("uploadId")
  valid_580404 = validateParameter(valid_580404, JString, required = true,
                                 default = nil)
  if valid_580404 != nil:
    section.add "uploadId", valid_580404
  var valid_580405 = path.getOrDefault("accountId")
  valid_580405 = validateParameter(valid_580405, JString, required = true,
                                 default = nil)
  if valid_580405 != nil:
    section.add "accountId", valid_580405
  var valid_580406 = path.getOrDefault("webPropertyId")
  valid_580406 = validateParameter(valid_580406, JString, required = true,
                                 default = nil)
  if valid_580406 != nil:
    section.add "webPropertyId", valid_580406
  var valid_580407 = path.getOrDefault("customDataSourceId")
  valid_580407 = validateParameter(valid_580407, JString, required = true,
                                 default = nil)
  if valid_580407 != nil:
    section.add "customDataSourceId", valid_580407
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
  var valid_580408 = query.getOrDefault("fields")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "fields", valid_580408
  var valid_580409 = query.getOrDefault("quotaUser")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "quotaUser", valid_580409
  var valid_580410 = query.getOrDefault("alt")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = newJString("json"))
  if valid_580410 != nil:
    section.add "alt", valid_580410
  var valid_580411 = query.getOrDefault("oauth_token")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "oauth_token", valid_580411
  var valid_580412 = query.getOrDefault("userIp")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "userIp", valid_580412
  var valid_580413 = query.getOrDefault("key")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "key", valid_580413
  var valid_580414 = query.getOrDefault("prettyPrint")
  valid_580414 = validateParameter(valid_580414, JBool, required = false,
                                 default = newJBool(false))
  if valid_580414 != nil:
    section.add "prettyPrint", valid_580414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580415: Call_AnalyticsManagementUploadsGet_580401; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List uploads to which the user has access.
  ## 
  let valid = call_580415.validator(path, query, header, formData, body)
  let scheme = call_580415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580415.url(scheme.get, call_580415.host, call_580415.base,
                         call_580415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580415, url, valid)

proc call*(call_580416: Call_AnalyticsManagementUploadsGet_580401;
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
  var path_580417 = newJObject()
  var query_580418 = newJObject()
  add(query_580418, "fields", newJString(fields))
  add(path_580417, "uploadId", newJString(uploadId))
  add(query_580418, "quotaUser", newJString(quotaUser))
  add(query_580418, "alt", newJString(alt))
  add(query_580418, "oauth_token", newJString(oauthToken))
  add(path_580417, "accountId", newJString(accountId))
  add(query_580418, "userIp", newJString(userIp))
  add(path_580417, "webPropertyId", newJString(webPropertyId))
  add(query_580418, "key", newJString(key))
  add(path_580417, "customDataSourceId", newJString(customDataSourceId))
  add(query_580418, "prettyPrint", newJBool(prettyPrint))
  result = call_580416.call(path_580417, query_580418, nil, nil, nil)

var analyticsManagementUploadsGet* = Call_AnalyticsManagementUploadsGet_580401(
    name: "analyticsManagementUploadsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDataSources/{customDataSourceId}/uploads/{uploadId}",
    validator: validate_AnalyticsManagementUploadsGet_580402,
    base: "/analytics/v3", url: url_AnalyticsManagementUploadsGet_580403,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsInsert_580437 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementCustomDimensionsInsert_580439(protocol: Scheme;
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

proc validate_AnalyticsManagementCustomDimensionsInsert_580438(path: JsonNode;
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
  var valid_580440 = path.getOrDefault("accountId")
  valid_580440 = validateParameter(valid_580440, JString, required = true,
                                 default = nil)
  if valid_580440 != nil:
    section.add "accountId", valid_580440
  var valid_580441 = path.getOrDefault("webPropertyId")
  valid_580441 = validateParameter(valid_580441, JString, required = true,
                                 default = nil)
  if valid_580441 != nil:
    section.add "webPropertyId", valid_580441
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
  var valid_580442 = query.getOrDefault("fields")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "fields", valid_580442
  var valid_580443 = query.getOrDefault("quotaUser")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "quotaUser", valid_580443
  var valid_580444 = query.getOrDefault("alt")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = newJString("json"))
  if valid_580444 != nil:
    section.add "alt", valid_580444
  var valid_580445 = query.getOrDefault("oauth_token")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "oauth_token", valid_580445
  var valid_580446 = query.getOrDefault("userIp")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "userIp", valid_580446
  var valid_580447 = query.getOrDefault("key")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "key", valid_580447
  var valid_580448 = query.getOrDefault("prettyPrint")
  valid_580448 = validateParameter(valid_580448, JBool, required = false,
                                 default = newJBool(false))
  if valid_580448 != nil:
    section.add "prettyPrint", valid_580448
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

proc call*(call_580450: Call_AnalyticsManagementCustomDimensionsInsert_580437;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new custom dimension.
  ## 
  let valid = call_580450.validator(path, query, header, formData, body)
  let scheme = call_580450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580450.url(scheme.get, call_580450.host, call_580450.base,
                         call_580450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580450, url, valid)

proc call*(call_580451: Call_AnalyticsManagementCustomDimensionsInsert_580437;
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
  var path_580452 = newJObject()
  var query_580453 = newJObject()
  var body_580454 = newJObject()
  add(query_580453, "fields", newJString(fields))
  add(query_580453, "quotaUser", newJString(quotaUser))
  add(query_580453, "alt", newJString(alt))
  add(query_580453, "oauth_token", newJString(oauthToken))
  add(path_580452, "accountId", newJString(accountId))
  add(query_580453, "userIp", newJString(userIp))
  add(path_580452, "webPropertyId", newJString(webPropertyId))
  add(query_580453, "key", newJString(key))
  if body != nil:
    body_580454 = body
  add(query_580453, "prettyPrint", newJBool(prettyPrint))
  result = call_580451.call(path_580452, query_580453, nil, nil, body_580454)

var analyticsManagementCustomDimensionsInsert* = Call_AnalyticsManagementCustomDimensionsInsert_580437(
    name: "analyticsManagementCustomDimensionsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions",
    validator: validate_AnalyticsManagementCustomDimensionsInsert_580438,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsInsert_580439,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsList_580419 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementCustomDimensionsList_580421(protocol: Scheme;
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

proc validate_AnalyticsManagementCustomDimensionsList_580420(path: JsonNode;
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
  var valid_580422 = path.getOrDefault("accountId")
  valid_580422 = validateParameter(valid_580422, JString, required = true,
                                 default = nil)
  if valid_580422 != nil:
    section.add "accountId", valid_580422
  var valid_580423 = path.getOrDefault("webPropertyId")
  valid_580423 = validateParameter(valid_580423, JString, required = true,
                                 default = nil)
  if valid_580423 != nil:
    section.add "webPropertyId", valid_580423
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
  var valid_580424 = query.getOrDefault("fields")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "fields", valid_580424
  var valid_580425 = query.getOrDefault("quotaUser")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = nil)
  if valid_580425 != nil:
    section.add "quotaUser", valid_580425
  var valid_580426 = query.getOrDefault("alt")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = newJString("json"))
  if valid_580426 != nil:
    section.add "alt", valid_580426
  var valid_580427 = query.getOrDefault("oauth_token")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "oauth_token", valid_580427
  var valid_580428 = query.getOrDefault("userIp")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "userIp", valid_580428
  var valid_580429 = query.getOrDefault("key")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "key", valid_580429
  var valid_580430 = query.getOrDefault("max-results")
  valid_580430 = validateParameter(valid_580430, JInt, required = false, default = nil)
  if valid_580430 != nil:
    section.add "max-results", valid_580430
  var valid_580431 = query.getOrDefault("start-index")
  valid_580431 = validateParameter(valid_580431, JInt, required = false, default = nil)
  if valid_580431 != nil:
    section.add "start-index", valid_580431
  var valid_580432 = query.getOrDefault("prettyPrint")
  valid_580432 = validateParameter(valid_580432, JBool, required = false,
                                 default = newJBool(false))
  if valid_580432 != nil:
    section.add "prettyPrint", valid_580432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580433: Call_AnalyticsManagementCustomDimensionsList_580419;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists custom dimensions to which the user has access.
  ## 
  let valid = call_580433.validator(path, query, header, formData, body)
  let scheme = call_580433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580433.url(scheme.get, call_580433.host, call_580433.base,
                         call_580433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580433, url, valid)

proc call*(call_580434: Call_AnalyticsManagementCustomDimensionsList_580419;
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
  var path_580435 = newJObject()
  var query_580436 = newJObject()
  add(query_580436, "fields", newJString(fields))
  add(query_580436, "quotaUser", newJString(quotaUser))
  add(query_580436, "alt", newJString(alt))
  add(query_580436, "oauth_token", newJString(oauthToken))
  add(path_580435, "accountId", newJString(accountId))
  add(query_580436, "userIp", newJString(userIp))
  add(path_580435, "webPropertyId", newJString(webPropertyId))
  add(query_580436, "key", newJString(key))
  add(query_580436, "max-results", newJInt(maxResults))
  add(query_580436, "start-index", newJInt(startIndex))
  add(query_580436, "prettyPrint", newJBool(prettyPrint))
  result = call_580434.call(path_580435, query_580436, nil, nil, nil)

var analyticsManagementCustomDimensionsList* = Call_AnalyticsManagementCustomDimensionsList_580419(
    name: "analyticsManagementCustomDimensionsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions",
    validator: validate_AnalyticsManagementCustomDimensionsList_580420,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsList_580421,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsUpdate_580472 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementCustomDimensionsUpdate_580474(protocol: Scheme;
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

proc validate_AnalyticsManagementCustomDimensionsUpdate_580473(path: JsonNode;
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
  var valid_580475 = path.getOrDefault("customDimensionId")
  valid_580475 = validateParameter(valid_580475, JString, required = true,
                                 default = nil)
  if valid_580475 != nil:
    section.add "customDimensionId", valid_580475
  var valid_580476 = path.getOrDefault("accountId")
  valid_580476 = validateParameter(valid_580476, JString, required = true,
                                 default = nil)
  if valid_580476 != nil:
    section.add "accountId", valid_580476
  var valid_580477 = path.getOrDefault("webPropertyId")
  valid_580477 = validateParameter(valid_580477, JString, required = true,
                                 default = nil)
  if valid_580477 != nil:
    section.add "webPropertyId", valid_580477
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
  var valid_580478 = query.getOrDefault("fields")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "fields", valid_580478
  var valid_580479 = query.getOrDefault("quotaUser")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "quotaUser", valid_580479
  var valid_580480 = query.getOrDefault("alt")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = newJString("json"))
  if valid_580480 != nil:
    section.add "alt", valid_580480
  var valid_580481 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_580481 = validateParameter(valid_580481, JBool, required = false,
                                 default = newJBool(false))
  if valid_580481 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_580481
  var valid_580482 = query.getOrDefault("oauth_token")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "oauth_token", valid_580482
  var valid_580483 = query.getOrDefault("userIp")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "userIp", valid_580483
  var valid_580484 = query.getOrDefault("key")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "key", valid_580484
  var valid_580485 = query.getOrDefault("prettyPrint")
  valid_580485 = validateParameter(valid_580485, JBool, required = false,
                                 default = newJBool(false))
  if valid_580485 != nil:
    section.add "prettyPrint", valid_580485
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

proc call*(call_580487: Call_AnalyticsManagementCustomDimensionsUpdate_580472;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom dimension.
  ## 
  let valid = call_580487.validator(path, query, header, formData, body)
  let scheme = call_580487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580487.url(scheme.get, call_580487.host, call_580487.base,
                         call_580487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580487, url, valid)

proc call*(call_580488: Call_AnalyticsManagementCustomDimensionsUpdate_580472;
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
  var path_580489 = newJObject()
  var query_580490 = newJObject()
  var body_580491 = newJObject()
  add(query_580490, "fields", newJString(fields))
  add(path_580489, "customDimensionId", newJString(customDimensionId))
  add(query_580490, "quotaUser", newJString(quotaUser))
  add(query_580490, "alt", newJString(alt))
  add(query_580490, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(query_580490, "oauth_token", newJString(oauthToken))
  add(path_580489, "accountId", newJString(accountId))
  add(query_580490, "userIp", newJString(userIp))
  add(path_580489, "webPropertyId", newJString(webPropertyId))
  add(query_580490, "key", newJString(key))
  if body != nil:
    body_580491 = body
  add(query_580490, "prettyPrint", newJBool(prettyPrint))
  result = call_580488.call(path_580489, query_580490, nil, nil, body_580491)

var analyticsManagementCustomDimensionsUpdate* = Call_AnalyticsManagementCustomDimensionsUpdate_580472(
    name: "analyticsManagementCustomDimensionsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions/{customDimensionId}",
    validator: validate_AnalyticsManagementCustomDimensionsUpdate_580473,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsUpdate_580474,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsGet_580455 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementCustomDimensionsGet_580457(protocol: Scheme;
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

proc validate_AnalyticsManagementCustomDimensionsGet_580456(path: JsonNode;
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
  var valid_580458 = path.getOrDefault("customDimensionId")
  valid_580458 = validateParameter(valid_580458, JString, required = true,
                                 default = nil)
  if valid_580458 != nil:
    section.add "customDimensionId", valid_580458
  var valid_580459 = path.getOrDefault("accountId")
  valid_580459 = validateParameter(valid_580459, JString, required = true,
                                 default = nil)
  if valid_580459 != nil:
    section.add "accountId", valid_580459
  var valid_580460 = path.getOrDefault("webPropertyId")
  valid_580460 = validateParameter(valid_580460, JString, required = true,
                                 default = nil)
  if valid_580460 != nil:
    section.add "webPropertyId", valid_580460
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
  var valid_580461 = query.getOrDefault("fields")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "fields", valid_580461
  var valid_580462 = query.getOrDefault("quotaUser")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "quotaUser", valid_580462
  var valid_580463 = query.getOrDefault("alt")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = newJString("json"))
  if valid_580463 != nil:
    section.add "alt", valid_580463
  var valid_580464 = query.getOrDefault("oauth_token")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "oauth_token", valid_580464
  var valid_580465 = query.getOrDefault("userIp")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "userIp", valid_580465
  var valid_580466 = query.getOrDefault("key")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "key", valid_580466
  var valid_580467 = query.getOrDefault("prettyPrint")
  valid_580467 = validateParameter(valid_580467, JBool, required = false,
                                 default = newJBool(false))
  if valid_580467 != nil:
    section.add "prettyPrint", valid_580467
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580468: Call_AnalyticsManagementCustomDimensionsGet_580455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a custom dimension to which the user has access.
  ## 
  let valid = call_580468.validator(path, query, header, formData, body)
  let scheme = call_580468.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580468.url(scheme.get, call_580468.host, call_580468.base,
                         call_580468.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580468, url, valid)

proc call*(call_580469: Call_AnalyticsManagementCustomDimensionsGet_580455;
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
  var path_580470 = newJObject()
  var query_580471 = newJObject()
  add(query_580471, "fields", newJString(fields))
  add(path_580470, "customDimensionId", newJString(customDimensionId))
  add(query_580471, "quotaUser", newJString(quotaUser))
  add(query_580471, "alt", newJString(alt))
  add(query_580471, "oauth_token", newJString(oauthToken))
  add(path_580470, "accountId", newJString(accountId))
  add(query_580471, "userIp", newJString(userIp))
  add(path_580470, "webPropertyId", newJString(webPropertyId))
  add(query_580471, "key", newJString(key))
  add(query_580471, "prettyPrint", newJBool(prettyPrint))
  result = call_580469.call(path_580470, query_580471, nil, nil, nil)

var analyticsManagementCustomDimensionsGet* = Call_AnalyticsManagementCustomDimensionsGet_580455(
    name: "analyticsManagementCustomDimensionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions/{customDimensionId}",
    validator: validate_AnalyticsManagementCustomDimensionsGet_580456,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsGet_580457,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomDimensionsPatch_580492 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementCustomDimensionsPatch_580494(protocol: Scheme;
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

proc validate_AnalyticsManagementCustomDimensionsPatch_580493(path: JsonNode;
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
  var valid_580495 = path.getOrDefault("customDimensionId")
  valid_580495 = validateParameter(valid_580495, JString, required = true,
                                 default = nil)
  if valid_580495 != nil:
    section.add "customDimensionId", valid_580495
  var valid_580496 = path.getOrDefault("accountId")
  valid_580496 = validateParameter(valid_580496, JString, required = true,
                                 default = nil)
  if valid_580496 != nil:
    section.add "accountId", valid_580496
  var valid_580497 = path.getOrDefault("webPropertyId")
  valid_580497 = validateParameter(valid_580497, JString, required = true,
                                 default = nil)
  if valid_580497 != nil:
    section.add "webPropertyId", valid_580497
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
  var valid_580498 = query.getOrDefault("fields")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "fields", valid_580498
  var valid_580499 = query.getOrDefault("quotaUser")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "quotaUser", valid_580499
  var valid_580500 = query.getOrDefault("alt")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = newJString("json"))
  if valid_580500 != nil:
    section.add "alt", valid_580500
  var valid_580501 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_580501 = validateParameter(valid_580501, JBool, required = false,
                                 default = newJBool(false))
  if valid_580501 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_580501
  var valid_580502 = query.getOrDefault("oauth_token")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = nil)
  if valid_580502 != nil:
    section.add "oauth_token", valid_580502
  var valid_580503 = query.getOrDefault("userIp")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "userIp", valid_580503
  var valid_580504 = query.getOrDefault("key")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "key", valid_580504
  var valid_580505 = query.getOrDefault("prettyPrint")
  valid_580505 = validateParameter(valid_580505, JBool, required = false,
                                 default = newJBool(false))
  if valid_580505 != nil:
    section.add "prettyPrint", valid_580505
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

proc call*(call_580507: Call_AnalyticsManagementCustomDimensionsPatch_580492;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom dimension. This method supports patch semantics.
  ## 
  let valid = call_580507.validator(path, query, header, formData, body)
  let scheme = call_580507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580507.url(scheme.get, call_580507.host, call_580507.base,
                         call_580507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580507, url, valid)

proc call*(call_580508: Call_AnalyticsManagementCustomDimensionsPatch_580492;
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
  var path_580509 = newJObject()
  var query_580510 = newJObject()
  var body_580511 = newJObject()
  add(query_580510, "fields", newJString(fields))
  add(path_580509, "customDimensionId", newJString(customDimensionId))
  add(query_580510, "quotaUser", newJString(quotaUser))
  add(query_580510, "alt", newJString(alt))
  add(query_580510, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(query_580510, "oauth_token", newJString(oauthToken))
  add(path_580509, "accountId", newJString(accountId))
  add(query_580510, "userIp", newJString(userIp))
  add(path_580509, "webPropertyId", newJString(webPropertyId))
  add(query_580510, "key", newJString(key))
  if body != nil:
    body_580511 = body
  add(query_580510, "prettyPrint", newJBool(prettyPrint))
  result = call_580508.call(path_580509, query_580510, nil, nil, body_580511)

var analyticsManagementCustomDimensionsPatch* = Call_AnalyticsManagementCustomDimensionsPatch_580492(
    name: "analyticsManagementCustomDimensionsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customDimensions/{customDimensionId}",
    validator: validate_AnalyticsManagementCustomDimensionsPatch_580493,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomDimensionsPatch_580494,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsInsert_580530 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementCustomMetricsInsert_580532(protocol: Scheme;
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

proc validate_AnalyticsManagementCustomMetricsInsert_580531(path: JsonNode;
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
  var valid_580533 = path.getOrDefault("accountId")
  valid_580533 = validateParameter(valid_580533, JString, required = true,
                                 default = nil)
  if valid_580533 != nil:
    section.add "accountId", valid_580533
  var valid_580534 = path.getOrDefault("webPropertyId")
  valid_580534 = validateParameter(valid_580534, JString, required = true,
                                 default = nil)
  if valid_580534 != nil:
    section.add "webPropertyId", valid_580534
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
  var valid_580535 = query.getOrDefault("fields")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "fields", valid_580535
  var valid_580536 = query.getOrDefault("quotaUser")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "quotaUser", valid_580536
  var valid_580537 = query.getOrDefault("alt")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = newJString("json"))
  if valid_580537 != nil:
    section.add "alt", valid_580537
  var valid_580538 = query.getOrDefault("oauth_token")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "oauth_token", valid_580538
  var valid_580539 = query.getOrDefault("userIp")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "userIp", valid_580539
  var valid_580540 = query.getOrDefault("key")
  valid_580540 = validateParameter(valid_580540, JString, required = false,
                                 default = nil)
  if valid_580540 != nil:
    section.add "key", valid_580540
  var valid_580541 = query.getOrDefault("prettyPrint")
  valid_580541 = validateParameter(valid_580541, JBool, required = false,
                                 default = newJBool(false))
  if valid_580541 != nil:
    section.add "prettyPrint", valid_580541
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

proc call*(call_580543: Call_AnalyticsManagementCustomMetricsInsert_580530;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new custom metric.
  ## 
  let valid = call_580543.validator(path, query, header, formData, body)
  let scheme = call_580543.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580543.url(scheme.get, call_580543.host, call_580543.base,
                         call_580543.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580543, url, valid)

proc call*(call_580544: Call_AnalyticsManagementCustomMetricsInsert_580530;
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
  var path_580545 = newJObject()
  var query_580546 = newJObject()
  var body_580547 = newJObject()
  add(query_580546, "fields", newJString(fields))
  add(query_580546, "quotaUser", newJString(quotaUser))
  add(query_580546, "alt", newJString(alt))
  add(query_580546, "oauth_token", newJString(oauthToken))
  add(path_580545, "accountId", newJString(accountId))
  add(query_580546, "userIp", newJString(userIp))
  add(path_580545, "webPropertyId", newJString(webPropertyId))
  add(query_580546, "key", newJString(key))
  if body != nil:
    body_580547 = body
  add(query_580546, "prettyPrint", newJBool(prettyPrint))
  result = call_580544.call(path_580545, query_580546, nil, nil, body_580547)

var analyticsManagementCustomMetricsInsert* = Call_AnalyticsManagementCustomMetricsInsert_580530(
    name: "analyticsManagementCustomMetricsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics",
    validator: validate_AnalyticsManagementCustomMetricsInsert_580531,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsInsert_580532,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsList_580512 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementCustomMetricsList_580514(protocol: Scheme;
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

proc validate_AnalyticsManagementCustomMetricsList_580513(path: JsonNode;
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
  var valid_580515 = path.getOrDefault("accountId")
  valid_580515 = validateParameter(valid_580515, JString, required = true,
                                 default = nil)
  if valid_580515 != nil:
    section.add "accountId", valid_580515
  var valid_580516 = path.getOrDefault("webPropertyId")
  valid_580516 = validateParameter(valid_580516, JString, required = true,
                                 default = nil)
  if valid_580516 != nil:
    section.add "webPropertyId", valid_580516
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
  var valid_580517 = query.getOrDefault("fields")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "fields", valid_580517
  var valid_580518 = query.getOrDefault("quotaUser")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "quotaUser", valid_580518
  var valid_580519 = query.getOrDefault("alt")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = newJString("json"))
  if valid_580519 != nil:
    section.add "alt", valid_580519
  var valid_580520 = query.getOrDefault("oauth_token")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "oauth_token", valid_580520
  var valid_580521 = query.getOrDefault("userIp")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "userIp", valid_580521
  var valid_580522 = query.getOrDefault("key")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "key", valid_580522
  var valid_580523 = query.getOrDefault("max-results")
  valid_580523 = validateParameter(valid_580523, JInt, required = false, default = nil)
  if valid_580523 != nil:
    section.add "max-results", valid_580523
  var valid_580524 = query.getOrDefault("start-index")
  valid_580524 = validateParameter(valid_580524, JInt, required = false, default = nil)
  if valid_580524 != nil:
    section.add "start-index", valid_580524
  var valid_580525 = query.getOrDefault("prettyPrint")
  valid_580525 = validateParameter(valid_580525, JBool, required = false,
                                 default = newJBool(false))
  if valid_580525 != nil:
    section.add "prettyPrint", valid_580525
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580526: Call_AnalyticsManagementCustomMetricsList_580512;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists custom metrics to which the user has access.
  ## 
  let valid = call_580526.validator(path, query, header, formData, body)
  let scheme = call_580526.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580526.url(scheme.get, call_580526.host, call_580526.base,
                         call_580526.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580526, url, valid)

proc call*(call_580527: Call_AnalyticsManagementCustomMetricsList_580512;
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
  var path_580528 = newJObject()
  var query_580529 = newJObject()
  add(query_580529, "fields", newJString(fields))
  add(query_580529, "quotaUser", newJString(quotaUser))
  add(query_580529, "alt", newJString(alt))
  add(query_580529, "oauth_token", newJString(oauthToken))
  add(path_580528, "accountId", newJString(accountId))
  add(query_580529, "userIp", newJString(userIp))
  add(path_580528, "webPropertyId", newJString(webPropertyId))
  add(query_580529, "key", newJString(key))
  add(query_580529, "max-results", newJInt(maxResults))
  add(query_580529, "start-index", newJInt(startIndex))
  add(query_580529, "prettyPrint", newJBool(prettyPrint))
  result = call_580527.call(path_580528, query_580529, nil, nil, nil)

var analyticsManagementCustomMetricsList* = Call_AnalyticsManagementCustomMetricsList_580512(
    name: "analyticsManagementCustomMetricsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics",
    validator: validate_AnalyticsManagementCustomMetricsList_580513,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsList_580514,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsUpdate_580565 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementCustomMetricsUpdate_580567(protocol: Scheme;
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

proc validate_AnalyticsManagementCustomMetricsUpdate_580566(path: JsonNode;
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
  var valid_580568 = path.getOrDefault("customMetricId")
  valid_580568 = validateParameter(valid_580568, JString, required = true,
                                 default = nil)
  if valid_580568 != nil:
    section.add "customMetricId", valid_580568
  var valid_580569 = path.getOrDefault("accountId")
  valid_580569 = validateParameter(valid_580569, JString, required = true,
                                 default = nil)
  if valid_580569 != nil:
    section.add "accountId", valid_580569
  var valid_580570 = path.getOrDefault("webPropertyId")
  valid_580570 = validateParameter(valid_580570, JString, required = true,
                                 default = nil)
  if valid_580570 != nil:
    section.add "webPropertyId", valid_580570
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
  var valid_580571 = query.getOrDefault("fields")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "fields", valid_580571
  var valid_580572 = query.getOrDefault("quotaUser")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "quotaUser", valid_580572
  var valid_580573 = query.getOrDefault("alt")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = newJString("json"))
  if valid_580573 != nil:
    section.add "alt", valid_580573
  var valid_580574 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_580574 = validateParameter(valid_580574, JBool, required = false,
                                 default = newJBool(false))
  if valid_580574 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_580574
  var valid_580575 = query.getOrDefault("oauth_token")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = nil)
  if valid_580575 != nil:
    section.add "oauth_token", valid_580575
  var valid_580576 = query.getOrDefault("userIp")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "userIp", valid_580576
  var valid_580577 = query.getOrDefault("key")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "key", valid_580577
  var valid_580578 = query.getOrDefault("prettyPrint")
  valid_580578 = validateParameter(valid_580578, JBool, required = false,
                                 default = newJBool(false))
  if valid_580578 != nil:
    section.add "prettyPrint", valid_580578
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

proc call*(call_580580: Call_AnalyticsManagementCustomMetricsUpdate_580565;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom metric.
  ## 
  let valid = call_580580.validator(path, query, header, formData, body)
  let scheme = call_580580.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580580.url(scheme.get, call_580580.host, call_580580.base,
                         call_580580.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580580, url, valid)

proc call*(call_580581: Call_AnalyticsManagementCustomMetricsUpdate_580565;
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
  var path_580582 = newJObject()
  var query_580583 = newJObject()
  var body_580584 = newJObject()
  add(query_580583, "fields", newJString(fields))
  add(query_580583, "quotaUser", newJString(quotaUser))
  add(query_580583, "alt", newJString(alt))
  add(query_580583, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(path_580582, "customMetricId", newJString(customMetricId))
  add(query_580583, "oauth_token", newJString(oauthToken))
  add(path_580582, "accountId", newJString(accountId))
  add(query_580583, "userIp", newJString(userIp))
  add(path_580582, "webPropertyId", newJString(webPropertyId))
  add(query_580583, "key", newJString(key))
  if body != nil:
    body_580584 = body
  add(query_580583, "prettyPrint", newJBool(prettyPrint))
  result = call_580581.call(path_580582, query_580583, nil, nil, body_580584)

var analyticsManagementCustomMetricsUpdate* = Call_AnalyticsManagementCustomMetricsUpdate_580565(
    name: "analyticsManagementCustomMetricsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics/{customMetricId}",
    validator: validate_AnalyticsManagementCustomMetricsUpdate_580566,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsUpdate_580567,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsGet_580548 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementCustomMetricsGet_580550(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementCustomMetricsGet_580549(path: JsonNode;
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
  var valid_580551 = path.getOrDefault("customMetricId")
  valid_580551 = validateParameter(valid_580551, JString, required = true,
                                 default = nil)
  if valid_580551 != nil:
    section.add "customMetricId", valid_580551
  var valid_580552 = path.getOrDefault("accountId")
  valid_580552 = validateParameter(valid_580552, JString, required = true,
                                 default = nil)
  if valid_580552 != nil:
    section.add "accountId", valid_580552
  var valid_580553 = path.getOrDefault("webPropertyId")
  valid_580553 = validateParameter(valid_580553, JString, required = true,
                                 default = nil)
  if valid_580553 != nil:
    section.add "webPropertyId", valid_580553
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
  var valid_580554 = query.getOrDefault("fields")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "fields", valid_580554
  var valid_580555 = query.getOrDefault("quotaUser")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "quotaUser", valid_580555
  var valid_580556 = query.getOrDefault("alt")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = newJString("json"))
  if valid_580556 != nil:
    section.add "alt", valid_580556
  var valid_580557 = query.getOrDefault("oauth_token")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "oauth_token", valid_580557
  var valid_580558 = query.getOrDefault("userIp")
  valid_580558 = validateParameter(valid_580558, JString, required = false,
                                 default = nil)
  if valid_580558 != nil:
    section.add "userIp", valid_580558
  var valid_580559 = query.getOrDefault("key")
  valid_580559 = validateParameter(valid_580559, JString, required = false,
                                 default = nil)
  if valid_580559 != nil:
    section.add "key", valid_580559
  var valid_580560 = query.getOrDefault("prettyPrint")
  valid_580560 = validateParameter(valid_580560, JBool, required = false,
                                 default = newJBool(false))
  if valid_580560 != nil:
    section.add "prettyPrint", valid_580560
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580561: Call_AnalyticsManagementCustomMetricsGet_580548;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get a custom metric to which the user has access.
  ## 
  let valid = call_580561.validator(path, query, header, formData, body)
  let scheme = call_580561.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580561.url(scheme.get, call_580561.host, call_580561.base,
                         call_580561.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580561, url, valid)

proc call*(call_580562: Call_AnalyticsManagementCustomMetricsGet_580548;
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
  var path_580563 = newJObject()
  var query_580564 = newJObject()
  add(query_580564, "fields", newJString(fields))
  add(query_580564, "quotaUser", newJString(quotaUser))
  add(query_580564, "alt", newJString(alt))
  add(path_580563, "customMetricId", newJString(customMetricId))
  add(query_580564, "oauth_token", newJString(oauthToken))
  add(path_580563, "accountId", newJString(accountId))
  add(query_580564, "userIp", newJString(userIp))
  add(path_580563, "webPropertyId", newJString(webPropertyId))
  add(query_580564, "key", newJString(key))
  add(query_580564, "prettyPrint", newJBool(prettyPrint))
  result = call_580562.call(path_580563, query_580564, nil, nil, nil)

var analyticsManagementCustomMetricsGet* = Call_AnalyticsManagementCustomMetricsGet_580548(
    name: "analyticsManagementCustomMetricsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics/{customMetricId}",
    validator: validate_AnalyticsManagementCustomMetricsGet_580549,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsGet_580550,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementCustomMetricsPatch_580585 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementCustomMetricsPatch_580587(protocol: Scheme;
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

proc validate_AnalyticsManagementCustomMetricsPatch_580586(path: JsonNode;
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
  var valid_580588 = path.getOrDefault("customMetricId")
  valid_580588 = validateParameter(valid_580588, JString, required = true,
                                 default = nil)
  if valid_580588 != nil:
    section.add "customMetricId", valid_580588
  var valid_580589 = path.getOrDefault("accountId")
  valid_580589 = validateParameter(valid_580589, JString, required = true,
                                 default = nil)
  if valid_580589 != nil:
    section.add "accountId", valid_580589
  var valid_580590 = path.getOrDefault("webPropertyId")
  valid_580590 = validateParameter(valid_580590, JString, required = true,
                                 default = nil)
  if valid_580590 != nil:
    section.add "webPropertyId", valid_580590
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
  var valid_580591 = query.getOrDefault("fields")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "fields", valid_580591
  var valid_580592 = query.getOrDefault("quotaUser")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "quotaUser", valid_580592
  var valid_580593 = query.getOrDefault("alt")
  valid_580593 = validateParameter(valid_580593, JString, required = false,
                                 default = newJString("json"))
  if valid_580593 != nil:
    section.add "alt", valid_580593
  var valid_580594 = query.getOrDefault("ignoreCustomDataSourceLinks")
  valid_580594 = validateParameter(valid_580594, JBool, required = false,
                                 default = newJBool(false))
  if valid_580594 != nil:
    section.add "ignoreCustomDataSourceLinks", valid_580594
  var valid_580595 = query.getOrDefault("oauth_token")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "oauth_token", valid_580595
  var valid_580596 = query.getOrDefault("userIp")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "userIp", valid_580596
  var valid_580597 = query.getOrDefault("key")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "key", valid_580597
  var valid_580598 = query.getOrDefault("prettyPrint")
  valid_580598 = validateParameter(valid_580598, JBool, required = false,
                                 default = newJBool(false))
  if valid_580598 != nil:
    section.add "prettyPrint", valid_580598
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

proc call*(call_580600: Call_AnalyticsManagementCustomMetricsPatch_580585;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing custom metric. This method supports patch semantics.
  ## 
  let valid = call_580600.validator(path, query, header, formData, body)
  let scheme = call_580600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580600.url(scheme.get, call_580600.host, call_580600.base,
                         call_580600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580600, url, valid)

proc call*(call_580601: Call_AnalyticsManagementCustomMetricsPatch_580585;
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
  var path_580602 = newJObject()
  var query_580603 = newJObject()
  var body_580604 = newJObject()
  add(query_580603, "fields", newJString(fields))
  add(query_580603, "quotaUser", newJString(quotaUser))
  add(query_580603, "alt", newJString(alt))
  add(query_580603, "ignoreCustomDataSourceLinks",
      newJBool(ignoreCustomDataSourceLinks))
  add(path_580602, "customMetricId", newJString(customMetricId))
  add(query_580603, "oauth_token", newJString(oauthToken))
  add(path_580602, "accountId", newJString(accountId))
  add(query_580603, "userIp", newJString(userIp))
  add(path_580602, "webPropertyId", newJString(webPropertyId))
  add(query_580603, "key", newJString(key))
  if body != nil:
    body_580604 = body
  add(query_580603, "prettyPrint", newJBool(prettyPrint))
  result = call_580601.call(path_580602, query_580603, nil, nil, body_580604)

var analyticsManagementCustomMetricsPatch* = Call_AnalyticsManagementCustomMetricsPatch_580585(
    name: "analyticsManagementCustomMetricsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/customMetrics/{customMetricId}",
    validator: validate_AnalyticsManagementCustomMetricsPatch_580586,
    base: "/analytics/v3", url: url_AnalyticsManagementCustomMetricsPatch_580587,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_580623 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebPropertyAdWordsLinksInsert_580625(
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

proc validate_AnalyticsManagementWebPropertyAdWordsLinksInsert_580624(
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
  var valid_580626 = path.getOrDefault("accountId")
  valid_580626 = validateParameter(valid_580626, JString, required = true,
                                 default = nil)
  if valid_580626 != nil:
    section.add "accountId", valid_580626
  var valid_580627 = path.getOrDefault("webPropertyId")
  valid_580627 = validateParameter(valid_580627, JString, required = true,
                                 default = nil)
  if valid_580627 != nil:
    section.add "webPropertyId", valid_580627
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
  var valid_580628 = query.getOrDefault("fields")
  valid_580628 = validateParameter(valid_580628, JString, required = false,
                                 default = nil)
  if valid_580628 != nil:
    section.add "fields", valid_580628
  var valid_580629 = query.getOrDefault("quotaUser")
  valid_580629 = validateParameter(valid_580629, JString, required = false,
                                 default = nil)
  if valid_580629 != nil:
    section.add "quotaUser", valid_580629
  var valid_580630 = query.getOrDefault("alt")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = newJString("json"))
  if valid_580630 != nil:
    section.add "alt", valid_580630
  var valid_580631 = query.getOrDefault("oauth_token")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "oauth_token", valid_580631
  var valid_580632 = query.getOrDefault("userIp")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "userIp", valid_580632
  var valid_580633 = query.getOrDefault("key")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "key", valid_580633
  var valid_580634 = query.getOrDefault("prettyPrint")
  valid_580634 = validateParameter(valid_580634, JBool, required = false,
                                 default = newJBool(false))
  if valid_580634 != nil:
    section.add "prettyPrint", valid_580634
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

proc call*(call_580636: Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_580623;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a webProperty-Google Ads link.
  ## 
  let valid = call_580636.validator(path, query, header, formData, body)
  let scheme = call_580636.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580636.url(scheme.get, call_580636.host, call_580636.base,
                         call_580636.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580636, url, valid)

proc call*(call_580637: Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_580623;
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
  var path_580638 = newJObject()
  var query_580639 = newJObject()
  var body_580640 = newJObject()
  add(query_580639, "fields", newJString(fields))
  add(query_580639, "quotaUser", newJString(quotaUser))
  add(query_580639, "alt", newJString(alt))
  add(query_580639, "oauth_token", newJString(oauthToken))
  add(path_580638, "accountId", newJString(accountId))
  add(query_580639, "userIp", newJString(userIp))
  add(path_580638, "webPropertyId", newJString(webPropertyId))
  add(query_580639, "key", newJString(key))
  if body != nil:
    body_580640 = body
  add(query_580639, "prettyPrint", newJBool(prettyPrint))
  result = call_580637.call(path_580638, query_580639, nil, nil, body_580640)

var analyticsManagementWebPropertyAdWordsLinksInsert* = Call_AnalyticsManagementWebPropertyAdWordsLinksInsert_580623(
    name: "analyticsManagementWebPropertyAdWordsLinksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksInsert_580624,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksInsert_580625,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksList_580605 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebPropertyAdWordsLinksList_580607(protocol: Scheme;
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

proc validate_AnalyticsManagementWebPropertyAdWordsLinksList_580606(
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
  var valid_580608 = path.getOrDefault("accountId")
  valid_580608 = validateParameter(valid_580608, JString, required = true,
                                 default = nil)
  if valid_580608 != nil:
    section.add "accountId", valid_580608
  var valid_580609 = path.getOrDefault("webPropertyId")
  valid_580609 = validateParameter(valid_580609, JString, required = true,
                                 default = nil)
  if valid_580609 != nil:
    section.add "webPropertyId", valid_580609
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
  var valid_580610 = query.getOrDefault("fields")
  valid_580610 = validateParameter(valid_580610, JString, required = false,
                                 default = nil)
  if valid_580610 != nil:
    section.add "fields", valid_580610
  var valid_580611 = query.getOrDefault("quotaUser")
  valid_580611 = validateParameter(valid_580611, JString, required = false,
                                 default = nil)
  if valid_580611 != nil:
    section.add "quotaUser", valid_580611
  var valid_580612 = query.getOrDefault("alt")
  valid_580612 = validateParameter(valid_580612, JString, required = false,
                                 default = newJString("json"))
  if valid_580612 != nil:
    section.add "alt", valid_580612
  var valid_580613 = query.getOrDefault("oauth_token")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "oauth_token", valid_580613
  var valid_580614 = query.getOrDefault("userIp")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "userIp", valid_580614
  var valid_580615 = query.getOrDefault("key")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "key", valid_580615
  var valid_580616 = query.getOrDefault("max-results")
  valid_580616 = validateParameter(valid_580616, JInt, required = false, default = nil)
  if valid_580616 != nil:
    section.add "max-results", valid_580616
  var valid_580617 = query.getOrDefault("start-index")
  valid_580617 = validateParameter(valid_580617, JInt, required = false, default = nil)
  if valid_580617 != nil:
    section.add "start-index", valid_580617
  var valid_580618 = query.getOrDefault("prettyPrint")
  valid_580618 = validateParameter(valid_580618, JBool, required = false,
                                 default = newJBool(false))
  if valid_580618 != nil:
    section.add "prettyPrint", valid_580618
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580619: Call_AnalyticsManagementWebPropertyAdWordsLinksList_580605;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists webProperty-Google Ads links for a given web property.
  ## 
  let valid = call_580619.validator(path, query, header, formData, body)
  let scheme = call_580619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580619.url(scheme.get, call_580619.host, call_580619.base,
                         call_580619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580619, url, valid)

proc call*(call_580620: Call_AnalyticsManagementWebPropertyAdWordsLinksList_580605;
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
  var path_580621 = newJObject()
  var query_580622 = newJObject()
  add(query_580622, "fields", newJString(fields))
  add(query_580622, "quotaUser", newJString(quotaUser))
  add(query_580622, "alt", newJString(alt))
  add(query_580622, "oauth_token", newJString(oauthToken))
  add(path_580621, "accountId", newJString(accountId))
  add(query_580622, "userIp", newJString(userIp))
  add(path_580621, "webPropertyId", newJString(webPropertyId))
  add(query_580622, "key", newJString(key))
  add(query_580622, "max-results", newJInt(maxResults))
  add(query_580622, "start-index", newJInt(startIndex))
  add(query_580622, "prettyPrint", newJBool(prettyPrint))
  result = call_580620.call(path_580621, query_580622, nil, nil, nil)

var analyticsManagementWebPropertyAdWordsLinksList* = Call_AnalyticsManagementWebPropertyAdWordsLinksList_580605(
    name: "analyticsManagementWebPropertyAdWordsLinksList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksList_580606,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksList_580607,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_580658 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebPropertyAdWordsLinksUpdate_580660(
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

proc validate_AnalyticsManagementWebPropertyAdWordsLinksUpdate_580659(
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
  var valid_580661 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_580661 = validateParameter(valid_580661, JString, required = true,
                                 default = nil)
  if valid_580661 != nil:
    section.add "webPropertyAdWordsLinkId", valid_580661
  var valid_580662 = path.getOrDefault("accountId")
  valid_580662 = validateParameter(valid_580662, JString, required = true,
                                 default = nil)
  if valid_580662 != nil:
    section.add "accountId", valid_580662
  var valid_580663 = path.getOrDefault("webPropertyId")
  valid_580663 = validateParameter(valid_580663, JString, required = true,
                                 default = nil)
  if valid_580663 != nil:
    section.add "webPropertyId", valid_580663
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
  var valid_580664 = query.getOrDefault("fields")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "fields", valid_580664
  var valid_580665 = query.getOrDefault("quotaUser")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = nil)
  if valid_580665 != nil:
    section.add "quotaUser", valid_580665
  var valid_580666 = query.getOrDefault("alt")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = newJString("json"))
  if valid_580666 != nil:
    section.add "alt", valid_580666
  var valid_580667 = query.getOrDefault("oauth_token")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "oauth_token", valid_580667
  var valid_580668 = query.getOrDefault("userIp")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "userIp", valid_580668
  var valid_580669 = query.getOrDefault("key")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "key", valid_580669
  var valid_580670 = query.getOrDefault("prettyPrint")
  valid_580670 = validateParameter(valid_580670, JBool, required = false,
                                 default = newJBool(false))
  if valid_580670 != nil:
    section.add "prettyPrint", valid_580670
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

proc call*(call_580672: Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_580658;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing webProperty-Google Ads link.
  ## 
  let valid = call_580672.validator(path, query, header, formData, body)
  let scheme = call_580672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580672.url(scheme.get, call_580672.host, call_580672.base,
                         call_580672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580672, url, valid)

proc call*(call_580673: Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_580658;
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
  var path_580674 = newJObject()
  var query_580675 = newJObject()
  var body_580676 = newJObject()
  add(query_580675, "fields", newJString(fields))
  add(query_580675, "quotaUser", newJString(quotaUser))
  add(query_580675, "alt", newJString(alt))
  add(path_580674, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(query_580675, "oauth_token", newJString(oauthToken))
  add(path_580674, "accountId", newJString(accountId))
  add(query_580675, "userIp", newJString(userIp))
  add(path_580674, "webPropertyId", newJString(webPropertyId))
  add(query_580675, "key", newJString(key))
  if body != nil:
    body_580676 = body
  add(query_580675, "prettyPrint", newJBool(prettyPrint))
  result = call_580673.call(path_580674, query_580675, nil, nil, body_580676)

var analyticsManagementWebPropertyAdWordsLinksUpdate* = Call_AnalyticsManagementWebPropertyAdWordsLinksUpdate_580658(
    name: "analyticsManagementWebPropertyAdWordsLinksUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksUpdate_580659,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksUpdate_580660,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksGet_580641 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebPropertyAdWordsLinksGet_580643(protocol: Scheme;
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

proc validate_AnalyticsManagementWebPropertyAdWordsLinksGet_580642(
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
  var valid_580644 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_580644 = validateParameter(valid_580644, JString, required = true,
                                 default = nil)
  if valid_580644 != nil:
    section.add "webPropertyAdWordsLinkId", valid_580644
  var valid_580645 = path.getOrDefault("accountId")
  valid_580645 = validateParameter(valid_580645, JString, required = true,
                                 default = nil)
  if valid_580645 != nil:
    section.add "accountId", valid_580645
  var valid_580646 = path.getOrDefault("webPropertyId")
  valid_580646 = validateParameter(valid_580646, JString, required = true,
                                 default = nil)
  if valid_580646 != nil:
    section.add "webPropertyId", valid_580646
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
  var valid_580647 = query.getOrDefault("fields")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "fields", valid_580647
  var valid_580648 = query.getOrDefault("quotaUser")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "quotaUser", valid_580648
  var valid_580649 = query.getOrDefault("alt")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = newJString("json"))
  if valid_580649 != nil:
    section.add "alt", valid_580649
  var valid_580650 = query.getOrDefault("oauth_token")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = nil)
  if valid_580650 != nil:
    section.add "oauth_token", valid_580650
  var valid_580651 = query.getOrDefault("userIp")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "userIp", valid_580651
  var valid_580652 = query.getOrDefault("key")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "key", valid_580652
  var valid_580653 = query.getOrDefault("prettyPrint")
  valid_580653 = validateParameter(valid_580653, JBool, required = false,
                                 default = newJBool(false))
  if valid_580653 != nil:
    section.add "prettyPrint", valid_580653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580654: Call_AnalyticsManagementWebPropertyAdWordsLinksGet_580641;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a web property-Google Ads link to which the user has access.
  ## 
  let valid = call_580654.validator(path, query, header, formData, body)
  let scheme = call_580654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580654.url(scheme.get, call_580654.host, call_580654.base,
                         call_580654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580654, url, valid)

proc call*(call_580655: Call_AnalyticsManagementWebPropertyAdWordsLinksGet_580641;
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
  var path_580656 = newJObject()
  var query_580657 = newJObject()
  add(query_580657, "fields", newJString(fields))
  add(query_580657, "quotaUser", newJString(quotaUser))
  add(query_580657, "alt", newJString(alt))
  add(path_580656, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(query_580657, "oauth_token", newJString(oauthToken))
  add(path_580656, "accountId", newJString(accountId))
  add(query_580657, "userIp", newJString(userIp))
  add(path_580656, "webPropertyId", newJString(webPropertyId))
  add(query_580657, "key", newJString(key))
  add(query_580657, "prettyPrint", newJBool(prettyPrint))
  result = call_580655.call(path_580656, query_580657, nil, nil, nil)

var analyticsManagementWebPropertyAdWordsLinksGet* = Call_AnalyticsManagementWebPropertyAdWordsLinksGet_580641(
    name: "analyticsManagementWebPropertyAdWordsLinksGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksGet_580642,
    base: "/analytics/v3", url: url_AnalyticsManagementWebPropertyAdWordsLinksGet_580643,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_580694 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebPropertyAdWordsLinksPatch_580696(protocol: Scheme;
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

proc validate_AnalyticsManagementWebPropertyAdWordsLinksPatch_580695(
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
  var valid_580697 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_580697 = validateParameter(valid_580697, JString, required = true,
                                 default = nil)
  if valid_580697 != nil:
    section.add "webPropertyAdWordsLinkId", valid_580697
  var valid_580698 = path.getOrDefault("accountId")
  valid_580698 = validateParameter(valid_580698, JString, required = true,
                                 default = nil)
  if valid_580698 != nil:
    section.add "accountId", valid_580698
  var valid_580699 = path.getOrDefault("webPropertyId")
  valid_580699 = validateParameter(valid_580699, JString, required = true,
                                 default = nil)
  if valid_580699 != nil:
    section.add "webPropertyId", valid_580699
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
  var valid_580700 = query.getOrDefault("fields")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = nil)
  if valid_580700 != nil:
    section.add "fields", valid_580700
  var valid_580701 = query.getOrDefault("quotaUser")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = nil)
  if valid_580701 != nil:
    section.add "quotaUser", valid_580701
  var valid_580702 = query.getOrDefault("alt")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = newJString("json"))
  if valid_580702 != nil:
    section.add "alt", valid_580702
  var valid_580703 = query.getOrDefault("oauth_token")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "oauth_token", valid_580703
  var valid_580704 = query.getOrDefault("userIp")
  valid_580704 = validateParameter(valid_580704, JString, required = false,
                                 default = nil)
  if valid_580704 != nil:
    section.add "userIp", valid_580704
  var valid_580705 = query.getOrDefault("key")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = nil)
  if valid_580705 != nil:
    section.add "key", valid_580705
  var valid_580706 = query.getOrDefault("prettyPrint")
  valid_580706 = validateParameter(valid_580706, JBool, required = false,
                                 default = newJBool(false))
  if valid_580706 != nil:
    section.add "prettyPrint", valid_580706
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

proc call*(call_580708: Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_580694;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing webProperty-Google Ads link. This method supports patch semantics.
  ## 
  let valid = call_580708.validator(path, query, header, formData, body)
  let scheme = call_580708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580708.url(scheme.get, call_580708.host, call_580708.base,
                         call_580708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580708, url, valid)

proc call*(call_580709: Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_580694;
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
  var path_580710 = newJObject()
  var query_580711 = newJObject()
  var body_580712 = newJObject()
  add(query_580711, "fields", newJString(fields))
  add(query_580711, "quotaUser", newJString(quotaUser))
  add(query_580711, "alt", newJString(alt))
  add(path_580710, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(query_580711, "oauth_token", newJString(oauthToken))
  add(path_580710, "accountId", newJString(accountId))
  add(query_580711, "userIp", newJString(userIp))
  add(path_580710, "webPropertyId", newJString(webPropertyId))
  add(query_580711, "key", newJString(key))
  if body != nil:
    body_580712 = body
  add(query_580711, "prettyPrint", newJBool(prettyPrint))
  result = call_580709.call(path_580710, query_580711, nil, nil, body_580712)

var analyticsManagementWebPropertyAdWordsLinksPatch* = Call_AnalyticsManagementWebPropertyAdWordsLinksPatch_580694(
    name: "analyticsManagementWebPropertyAdWordsLinksPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksPatch_580695,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksPatch_580696,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_580677 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebPropertyAdWordsLinksDelete_580679(
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

proc validate_AnalyticsManagementWebPropertyAdWordsLinksDelete_580678(
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
  var valid_580680 = path.getOrDefault("webPropertyAdWordsLinkId")
  valid_580680 = validateParameter(valid_580680, JString, required = true,
                                 default = nil)
  if valid_580680 != nil:
    section.add "webPropertyAdWordsLinkId", valid_580680
  var valid_580681 = path.getOrDefault("accountId")
  valid_580681 = validateParameter(valid_580681, JString, required = true,
                                 default = nil)
  if valid_580681 != nil:
    section.add "accountId", valid_580681
  var valid_580682 = path.getOrDefault("webPropertyId")
  valid_580682 = validateParameter(valid_580682, JString, required = true,
                                 default = nil)
  if valid_580682 != nil:
    section.add "webPropertyId", valid_580682
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
  var valid_580683 = query.getOrDefault("fields")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = nil)
  if valid_580683 != nil:
    section.add "fields", valid_580683
  var valid_580684 = query.getOrDefault("quotaUser")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "quotaUser", valid_580684
  var valid_580685 = query.getOrDefault("alt")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = newJString("json"))
  if valid_580685 != nil:
    section.add "alt", valid_580685
  var valid_580686 = query.getOrDefault("oauth_token")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = nil)
  if valid_580686 != nil:
    section.add "oauth_token", valid_580686
  var valid_580687 = query.getOrDefault("userIp")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = nil)
  if valid_580687 != nil:
    section.add "userIp", valid_580687
  var valid_580688 = query.getOrDefault("key")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = nil)
  if valid_580688 != nil:
    section.add "key", valid_580688
  var valid_580689 = query.getOrDefault("prettyPrint")
  valid_580689 = validateParameter(valid_580689, JBool, required = false,
                                 default = newJBool(false))
  if valid_580689 != nil:
    section.add "prettyPrint", valid_580689
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580690: Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_580677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a web property-Google Ads link.
  ## 
  let valid = call_580690.validator(path, query, header, formData, body)
  let scheme = call_580690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580690.url(scheme.get, call_580690.host, call_580690.base,
                         call_580690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580690, url, valid)

proc call*(call_580691: Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_580677;
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
  var path_580692 = newJObject()
  var query_580693 = newJObject()
  add(query_580693, "fields", newJString(fields))
  add(query_580693, "quotaUser", newJString(quotaUser))
  add(query_580693, "alt", newJString(alt))
  add(path_580692, "webPropertyAdWordsLinkId",
      newJString(webPropertyAdWordsLinkId))
  add(query_580693, "oauth_token", newJString(oauthToken))
  add(path_580692, "accountId", newJString(accountId))
  add(query_580693, "userIp", newJString(userIp))
  add(path_580692, "webPropertyId", newJString(webPropertyId))
  add(query_580693, "key", newJString(key))
  add(query_580693, "prettyPrint", newJBool(prettyPrint))
  result = call_580691.call(path_580692, query_580693, nil, nil, nil)

var analyticsManagementWebPropertyAdWordsLinksDelete* = Call_AnalyticsManagementWebPropertyAdWordsLinksDelete_580677(
    name: "analyticsManagementWebPropertyAdWordsLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityAdWordsLinks/{webPropertyAdWordsLinkId}",
    validator: validate_AnalyticsManagementWebPropertyAdWordsLinksDelete_580678,
    base: "/analytics/v3",
    url: url_AnalyticsManagementWebPropertyAdWordsLinksDelete_580679,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksInsert_580731 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebpropertyUserLinksInsert_580733(protocol: Scheme;
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

proc validate_AnalyticsManagementWebpropertyUserLinksInsert_580732(
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
  var valid_580734 = path.getOrDefault("accountId")
  valid_580734 = validateParameter(valid_580734, JString, required = true,
                                 default = nil)
  if valid_580734 != nil:
    section.add "accountId", valid_580734
  var valid_580735 = path.getOrDefault("webPropertyId")
  valid_580735 = validateParameter(valid_580735, JString, required = true,
                                 default = nil)
  if valid_580735 != nil:
    section.add "webPropertyId", valid_580735
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
  var valid_580736 = query.getOrDefault("fields")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "fields", valid_580736
  var valid_580737 = query.getOrDefault("quotaUser")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "quotaUser", valid_580737
  var valid_580738 = query.getOrDefault("alt")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = newJString("json"))
  if valid_580738 != nil:
    section.add "alt", valid_580738
  var valid_580739 = query.getOrDefault("oauth_token")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = nil)
  if valid_580739 != nil:
    section.add "oauth_token", valid_580739
  var valid_580740 = query.getOrDefault("userIp")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = nil)
  if valid_580740 != nil:
    section.add "userIp", valid_580740
  var valid_580741 = query.getOrDefault("key")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "key", valid_580741
  var valid_580742 = query.getOrDefault("prettyPrint")
  valid_580742 = validateParameter(valid_580742, JBool, required = false,
                                 default = newJBool(false))
  if valid_580742 != nil:
    section.add "prettyPrint", valid_580742
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

proc call*(call_580744: Call_AnalyticsManagementWebpropertyUserLinksInsert_580731;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new user to the given web property.
  ## 
  let valid = call_580744.validator(path, query, header, formData, body)
  let scheme = call_580744.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580744.url(scheme.get, call_580744.host, call_580744.base,
                         call_580744.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580744, url, valid)

proc call*(call_580745: Call_AnalyticsManagementWebpropertyUserLinksInsert_580731;
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
  var path_580746 = newJObject()
  var query_580747 = newJObject()
  var body_580748 = newJObject()
  add(query_580747, "fields", newJString(fields))
  add(query_580747, "quotaUser", newJString(quotaUser))
  add(query_580747, "alt", newJString(alt))
  add(query_580747, "oauth_token", newJString(oauthToken))
  add(path_580746, "accountId", newJString(accountId))
  add(query_580747, "userIp", newJString(userIp))
  add(path_580746, "webPropertyId", newJString(webPropertyId))
  add(query_580747, "key", newJString(key))
  if body != nil:
    body_580748 = body
  add(query_580747, "prettyPrint", newJBool(prettyPrint))
  result = call_580745.call(path_580746, query_580747, nil, nil, body_580748)

var analyticsManagementWebpropertyUserLinksInsert* = Call_AnalyticsManagementWebpropertyUserLinksInsert_580731(
    name: "analyticsManagementWebpropertyUserLinksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks",
    validator: validate_AnalyticsManagementWebpropertyUserLinksInsert_580732,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksInsert_580733,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksList_580713 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebpropertyUserLinksList_580715(protocol: Scheme;
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

proc validate_AnalyticsManagementWebpropertyUserLinksList_580714(path: JsonNode;
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
  var valid_580716 = path.getOrDefault("accountId")
  valid_580716 = validateParameter(valid_580716, JString, required = true,
                                 default = nil)
  if valid_580716 != nil:
    section.add "accountId", valid_580716
  var valid_580717 = path.getOrDefault("webPropertyId")
  valid_580717 = validateParameter(valid_580717, JString, required = true,
                                 default = nil)
  if valid_580717 != nil:
    section.add "webPropertyId", valid_580717
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
  var valid_580718 = query.getOrDefault("fields")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = nil)
  if valid_580718 != nil:
    section.add "fields", valid_580718
  var valid_580719 = query.getOrDefault("quotaUser")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "quotaUser", valid_580719
  var valid_580720 = query.getOrDefault("alt")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = newJString("json"))
  if valid_580720 != nil:
    section.add "alt", valid_580720
  var valid_580721 = query.getOrDefault("oauth_token")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "oauth_token", valid_580721
  var valid_580722 = query.getOrDefault("userIp")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = nil)
  if valid_580722 != nil:
    section.add "userIp", valid_580722
  var valid_580723 = query.getOrDefault("key")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = nil)
  if valid_580723 != nil:
    section.add "key", valid_580723
  var valid_580724 = query.getOrDefault("max-results")
  valid_580724 = validateParameter(valid_580724, JInt, required = false, default = nil)
  if valid_580724 != nil:
    section.add "max-results", valid_580724
  var valid_580725 = query.getOrDefault("start-index")
  valid_580725 = validateParameter(valid_580725, JInt, required = false, default = nil)
  if valid_580725 != nil:
    section.add "start-index", valid_580725
  var valid_580726 = query.getOrDefault("prettyPrint")
  valid_580726 = validateParameter(valid_580726, JBool, required = false,
                                 default = newJBool(false))
  if valid_580726 != nil:
    section.add "prettyPrint", valid_580726
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580727: Call_AnalyticsManagementWebpropertyUserLinksList_580713;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists webProperty-user links for a given web property.
  ## 
  let valid = call_580727.validator(path, query, header, formData, body)
  let scheme = call_580727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580727.url(scheme.get, call_580727.host, call_580727.base,
                         call_580727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580727, url, valid)

proc call*(call_580728: Call_AnalyticsManagementWebpropertyUserLinksList_580713;
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
  var path_580729 = newJObject()
  var query_580730 = newJObject()
  add(query_580730, "fields", newJString(fields))
  add(query_580730, "quotaUser", newJString(quotaUser))
  add(query_580730, "alt", newJString(alt))
  add(query_580730, "oauth_token", newJString(oauthToken))
  add(path_580729, "accountId", newJString(accountId))
  add(query_580730, "userIp", newJString(userIp))
  add(path_580729, "webPropertyId", newJString(webPropertyId))
  add(query_580730, "key", newJString(key))
  add(query_580730, "max-results", newJInt(maxResults))
  add(query_580730, "start-index", newJInt(startIndex))
  add(query_580730, "prettyPrint", newJBool(prettyPrint))
  result = call_580728.call(path_580729, query_580730, nil, nil, nil)

var analyticsManagementWebpropertyUserLinksList* = Call_AnalyticsManagementWebpropertyUserLinksList_580713(
    name: "analyticsManagementWebpropertyUserLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks",
    validator: validate_AnalyticsManagementWebpropertyUserLinksList_580714,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksList_580715,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksUpdate_580749 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebpropertyUserLinksUpdate_580751(protocol: Scheme;
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

proc validate_AnalyticsManagementWebpropertyUserLinksUpdate_580750(
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
  var valid_580752 = path.getOrDefault("accountId")
  valid_580752 = validateParameter(valid_580752, JString, required = true,
                                 default = nil)
  if valid_580752 != nil:
    section.add "accountId", valid_580752
  var valid_580753 = path.getOrDefault("webPropertyId")
  valid_580753 = validateParameter(valid_580753, JString, required = true,
                                 default = nil)
  if valid_580753 != nil:
    section.add "webPropertyId", valid_580753
  var valid_580754 = path.getOrDefault("linkId")
  valid_580754 = validateParameter(valid_580754, JString, required = true,
                                 default = nil)
  if valid_580754 != nil:
    section.add "linkId", valid_580754
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
  var valid_580755 = query.getOrDefault("fields")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "fields", valid_580755
  var valid_580756 = query.getOrDefault("quotaUser")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = nil)
  if valid_580756 != nil:
    section.add "quotaUser", valid_580756
  var valid_580757 = query.getOrDefault("alt")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = newJString("json"))
  if valid_580757 != nil:
    section.add "alt", valid_580757
  var valid_580758 = query.getOrDefault("oauth_token")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = nil)
  if valid_580758 != nil:
    section.add "oauth_token", valid_580758
  var valid_580759 = query.getOrDefault("userIp")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = nil)
  if valid_580759 != nil:
    section.add "userIp", valid_580759
  var valid_580760 = query.getOrDefault("key")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = nil)
  if valid_580760 != nil:
    section.add "key", valid_580760
  var valid_580761 = query.getOrDefault("prettyPrint")
  valid_580761 = validateParameter(valid_580761, JBool, required = false,
                                 default = newJBool(false))
  if valid_580761 != nil:
    section.add "prettyPrint", valid_580761
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

proc call*(call_580763: Call_AnalyticsManagementWebpropertyUserLinksUpdate_580749;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates permissions for an existing user on the given web property.
  ## 
  let valid = call_580763.validator(path, query, header, formData, body)
  let scheme = call_580763.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580763.url(scheme.get, call_580763.host, call_580763.base,
                         call_580763.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580763, url, valid)

proc call*(call_580764: Call_AnalyticsManagementWebpropertyUserLinksUpdate_580749;
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
  var path_580765 = newJObject()
  var query_580766 = newJObject()
  var body_580767 = newJObject()
  add(query_580766, "fields", newJString(fields))
  add(query_580766, "quotaUser", newJString(quotaUser))
  add(query_580766, "alt", newJString(alt))
  add(query_580766, "oauth_token", newJString(oauthToken))
  add(path_580765, "accountId", newJString(accountId))
  add(query_580766, "userIp", newJString(userIp))
  add(path_580765, "webPropertyId", newJString(webPropertyId))
  add(query_580766, "key", newJString(key))
  add(path_580765, "linkId", newJString(linkId))
  if body != nil:
    body_580767 = body
  add(query_580766, "prettyPrint", newJBool(prettyPrint))
  result = call_580764.call(path_580765, query_580766, nil, nil, body_580767)

var analyticsManagementWebpropertyUserLinksUpdate* = Call_AnalyticsManagementWebpropertyUserLinksUpdate_580749(
    name: "analyticsManagementWebpropertyUserLinksUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementWebpropertyUserLinksUpdate_580750,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksUpdate_580751,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertyUserLinksDelete_580768 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementWebpropertyUserLinksDelete_580770(protocol: Scheme;
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

proc validate_AnalyticsManagementWebpropertyUserLinksDelete_580769(
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
  var valid_580771 = path.getOrDefault("accountId")
  valid_580771 = validateParameter(valid_580771, JString, required = true,
                                 default = nil)
  if valid_580771 != nil:
    section.add "accountId", valid_580771
  var valid_580772 = path.getOrDefault("webPropertyId")
  valid_580772 = validateParameter(valid_580772, JString, required = true,
                                 default = nil)
  if valid_580772 != nil:
    section.add "webPropertyId", valid_580772
  var valid_580773 = path.getOrDefault("linkId")
  valid_580773 = validateParameter(valid_580773, JString, required = true,
                                 default = nil)
  if valid_580773 != nil:
    section.add "linkId", valid_580773
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
  var valid_580774 = query.getOrDefault("fields")
  valid_580774 = validateParameter(valid_580774, JString, required = false,
                                 default = nil)
  if valid_580774 != nil:
    section.add "fields", valid_580774
  var valid_580775 = query.getOrDefault("quotaUser")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = nil)
  if valid_580775 != nil:
    section.add "quotaUser", valid_580775
  var valid_580776 = query.getOrDefault("alt")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = newJString("json"))
  if valid_580776 != nil:
    section.add "alt", valid_580776
  var valid_580777 = query.getOrDefault("oauth_token")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "oauth_token", valid_580777
  var valid_580778 = query.getOrDefault("userIp")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "userIp", valid_580778
  var valid_580779 = query.getOrDefault("key")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = nil)
  if valid_580779 != nil:
    section.add "key", valid_580779
  var valid_580780 = query.getOrDefault("prettyPrint")
  valid_580780 = validateParameter(valid_580780, JBool, required = false,
                                 default = newJBool(false))
  if valid_580780 != nil:
    section.add "prettyPrint", valid_580780
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580781: Call_AnalyticsManagementWebpropertyUserLinksDelete_580768;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the given web property.
  ## 
  let valid = call_580781.validator(path, query, header, formData, body)
  let scheme = call_580781.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580781.url(scheme.get, call_580781.host, call_580781.base,
                         call_580781.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580781, url, valid)

proc call*(call_580782: Call_AnalyticsManagementWebpropertyUserLinksDelete_580768;
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
  var path_580783 = newJObject()
  var query_580784 = newJObject()
  add(query_580784, "fields", newJString(fields))
  add(query_580784, "quotaUser", newJString(quotaUser))
  add(query_580784, "alt", newJString(alt))
  add(query_580784, "oauth_token", newJString(oauthToken))
  add(path_580783, "accountId", newJString(accountId))
  add(query_580784, "userIp", newJString(userIp))
  add(path_580783, "webPropertyId", newJString(webPropertyId))
  add(query_580784, "key", newJString(key))
  add(path_580783, "linkId", newJString(linkId))
  add(query_580784, "prettyPrint", newJBool(prettyPrint))
  result = call_580782.call(path_580783, query_580784, nil, nil, nil)

var analyticsManagementWebpropertyUserLinksDelete* = Call_AnalyticsManagementWebpropertyUserLinksDelete_580768(
    name: "analyticsManagementWebpropertyUserLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementWebpropertyUserLinksDelete_580769,
    base: "/analytics/v3", url: url_AnalyticsManagementWebpropertyUserLinksDelete_580770,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesInsert_580803 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfilesInsert_580805(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementProfilesInsert_580804(path: JsonNode;
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
  var valid_580806 = path.getOrDefault("accountId")
  valid_580806 = validateParameter(valid_580806, JString, required = true,
                                 default = nil)
  if valid_580806 != nil:
    section.add "accountId", valid_580806
  var valid_580807 = path.getOrDefault("webPropertyId")
  valid_580807 = validateParameter(valid_580807, JString, required = true,
                                 default = nil)
  if valid_580807 != nil:
    section.add "webPropertyId", valid_580807
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
  var valid_580808 = query.getOrDefault("fields")
  valid_580808 = validateParameter(valid_580808, JString, required = false,
                                 default = nil)
  if valid_580808 != nil:
    section.add "fields", valid_580808
  var valid_580809 = query.getOrDefault("quotaUser")
  valid_580809 = validateParameter(valid_580809, JString, required = false,
                                 default = nil)
  if valid_580809 != nil:
    section.add "quotaUser", valid_580809
  var valid_580810 = query.getOrDefault("alt")
  valid_580810 = validateParameter(valid_580810, JString, required = false,
                                 default = newJString("json"))
  if valid_580810 != nil:
    section.add "alt", valid_580810
  var valid_580811 = query.getOrDefault("oauth_token")
  valid_580811 = validateParameter(valid_580811, JString, required = false,
                                 default = nil)
  if valid_580811 != nil:
    section.add "oauth_token", valid_580811
  var valid_580812 = query.getOrDefault("userIp")
  valid_580812 = validateParameter(valid_580812, JString, required = false,
                                 default = nil)
  if valid_580812 != nil:
    section.add "userIp", valid_580812
  var valid_580813 = query.getOrDefault("key")
  valid_580813 = validateParameter(valid_580813, JString, required = false,
                                 default = nil)
  if valid_580813 != nil:
    section.add "key", valid_580813
  var valid_580814 = query.getOrDefault("prettyPrint")
  valid_580814 = validateParameter(valid_580814, JBool, required = false,
                                 default = newJBool(false))
  if valid_580814 != nil:
    section.add "prettyPrint", valid_580814
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

proc call*(call_580816: Call_AnalyticsManagementProfilesInsert_580803;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new view (profile).
  ## 
  let valid = call_580816.validator(path, query, header, formData, body)
  let scheme = call_580816.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580816.url(scheme.get, call_580816.host, call_580816.base,
                         call_580816.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580816, url, valid)

proc call*(call_580817: Call_AnalyticsManagementProfilesInsert_580803;
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
  var path_580818 = newJObject()
  var query_580819 = newJObject()
  var body_580820 = newJObject()
  add(query_580819, "fields", newJString(fields))
  add(query_580819, "quotaUser", newJString(quotaUser))
  add(query_580819, "alt", newJString(alt))
  add(query_580819, "oauth_token", newJString(oauthToken))
  add(path_580818, "accountId", newJString(accountId))
  add(query_580819, "userIp", newJString(userIp))
  add(path_580818, "webPropertyId", newJString(webPropertyId))
  add(query_580819, "key", newJString(key))
  if body != nil:
    body_580820 = body
  add(query_580819, "prettyPrint", newJBool(prettyPrint))
  result = call_580817.call(path_580818, query_580819, nil, nil, body_580820)

var analyticsManagementProfilesInsert* = Call_AnalyticsManagementProfilesInsert_580803(
    name: "analyticsManagementProfilesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles",
    validator: validate_AnalyticsManagementProfilesInsert_580804,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesInsert_580805,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesList_580785 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfilesList_580787(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementProfilesList_580786(path: JsonNode;
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
  var valid_580788 = path.getOrDefault("accountId")
  valid_580788 = validateParameter(valid_580788, JString, required = true,
                                 default = nil)
  if valid_580788 != nil:
    section.add "accountId", valid_580788
  var valid_580789 = path.getOrDefault("webPropertyId")
  valid_580789 = validateParameter(valid_580789, JString, required = true,
                                 default = nil)
  if valid_580789 != nil:
    section.add "webPropertyId", valid_580789
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
  var valid_580790 = query.getOrDefault("fields")
  valid_580790 = validateParameter(valid_580790, JString, required = false,
                                 default = nil)
  if valid_580790 != nil:
    section.add "fields", valid_580790
  var valid_580791 = query.getOrDefault("quotaUser")
  valid_580791 = validateParameter(valid_580791, JString, required = false,
                                 default = nil)
  if valid_580791 != nil:
    section.add "quotaUser", valid_580791
  var valid_580792 = query.getOrDefault("alt")
  valid_580792 = validateParameter(valid_580792, JString, required = false,
                                 default = newJString("json"))
  if valid_580792 != nil:
    section.add "alt", valid_580792
  var valid_580793 = query.getOrDefault("oauth_token")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = nil)
  if valid_580793 != nil:
    section.add "oauth_token", valid_580793
  var valid_580794 = query.getOrDefault("userIp")
  valid_580794 = validateParameter(valid_580794, JString, required = false,
                                 default = nil)
  if valid_580794 != nil:
    section.add "userIp", valid_580794
  var valid_580795 = query.getOrDefault("key")
  valid_580795 = validateParameter(valid_580795, JString, required = false,
                                 default = nil)
  if valid_580795 != nil:
    section.add "key", valid_580795
  var valid_580796 = query.getOrDefault("max-results")
  valid_580796 = validateParameter(valid_580796, JInt, required = false, default = nil)
  if valid_580796 != nil:
    section.add "max-results", valid_580796
  var valid_580797 = query.getOrDefault("start-index")
  valid_580797 = validateParameter(valid_580797, JInt, required = false, default = nil)
  if valid_580797 != nil:
    section.add "start-index", valid_580797
  var valid_580798 = query.getOrDefault("prettyPrint")
  valid_580798 = validateParameter(valid_580798, JBool, required = false,
                                 default = newJBool(false))
  if valid_580798 != nil:
    section.add "prettyPrint", valid_580798
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580799: Call_AnalyticsManagementProfilesList_580785;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists views (profiles) to which the user has access.
  ## 
  let valid = call_580799.validator(path, query, header, formData, body)
  let scheme = call_580799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580799.url(scheme.get, call_580799.host, call_580799.base,
                         call_580799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580799, url, valid)

proc call*(call_580800: Call_AnalyticsManagementProfilesList_580785;
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
  var path_580801 = newJObject()
  var query_580802 = newJObject()
  add(query_580802, "fields", newJString(fields))
  add(query_580802, "quotaUser", newJString(quotaUser))
  add(query_580802, "alt", newJString(alt))
  add(query_580802, "oauth_token", newJString(oauthToken))
  add(path_580801, "accountId", newJString(accountId))
  add(query_580802, "userIp", newJString(userIp))
  add(path_580801, "webPropertyId", newJString(webPropertyId))
  add(query_580802, "key", newJString(key))
  add(query_580802, "max-results", newJInt(maxResults))
  add(query_580802, "start-index", newJInt(startIndex))
  add(query_580802, "prettyPrint", newJBool(prettyPrint))
  result = call_580800.call(path_580801, query_580802, nil, nil, nil)

var analyticsManagementProfilesList* = Call_AnalyticsManagementProfilesList_580785(
    name: "analyticsManagementProfilesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles",
    validator: validate_AnalyticsManagementProfilesList_580786,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesList_580787,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesUpdate_580838 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfilesUpdate_580840(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementProfilesUpdate_580839(path: JsonNode;
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
  var valid_580841 = path.getOrDefault("profileId")
  valid_580841 = validateParameter(valid_580841, JString, required = true,
                                 default = nil)
  if valid_580841 != nil:
    section.add "profileId", valid_580841
  var valid_580842 = path.getOrDefault("accountId")
  valid_580842 = validateParameter(valid_580842, JString, required = true,
                                 default = nil)
  if valid_580842 != nil:
    section.add "accountId", valid_580842
  var valid_580843 = path.getOrDefault("webPropertyId")
  valid_580843 = validateParameter(valid_580843, JString, required = true,
                                 default = nil)
  if valid_580843 != nil:
    section.add "webPropertyId", valid_580843
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
  var valid_580844 = query.getOrDefault("fields")
  valid_580844 = validateParameter(valid_580844, JString, required = false,
                                 default = nil)
  if valid_580844 != nil:
    section.add "fields", valid_580844
  var valid_580845 = query.getOrDefault("quotaUser")
  valid_580845 = validateParameter(valid_580845, JString, required = false,
                                 default = nil)
  if valid_580845 != nil:
    section.add "quotaUser", valid_580845
  var valid_580846 = query.getOrDefault("alt")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = newJString("json"))
  if valid_580846 != nil:
    section.add "alt", valid_580846
  var valid_580847 = query.getOrDefault("oauth_token")
  valid_580847 = validateParameter(valid_580847, JString, required = false,
                                 default = nil)
  if valid_580847 != nil:
    section.add "oauth_token", valid_580847
  var valid_580848 = query.getOrDefault("userIp")
  valid_580848 = validateParameter(valid_580848, JString, required = false,
                                 default = nil)
  if valid_580848 != nil:
    section.add "userIp", valid_580848
  var valid_580849 = query.getOrDefault("key")
  valid_580849 = validateParameter(valid_580849, JString, required = false,
                                 default = nil)
  if valid_580849 != nil:
    section.add "key", valid_580849
  var valid_580850 = query.getOrDefault("prettyPrint")
  valid_580850 = validateParameter(valid_580850, JBool, required = false,
                                 default = newJBool(false))
  if valid_580850 != nil:
    section.add "prettyPrint", valid_580850
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

proc call*(call_580852: Call_AnalyticsManagementProfilesUpdate_580838;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing view (profile).
  ## 
  let valid = call_580852.validator(path, query, header, formData, body)
  let scheme = call_580852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580852.url(scheme.get, call_580852.host, call_580852.base,
                         call_580852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580852, url, valid)

proc call*(call_580853: Call_AnalyticsManagementProfilesUpdate_580838;
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
  var path_580854 = newJObject()
  var query_580855 = newJObject()
  var body_580856 = newJObject()
  add(path_580854, "profileId", newJString(profileId))
  add(query_580855, "fields", newJString(fields))
  add(query_580855, "quotaUser", newJString(quotaUser))
  add(query_580855, "alt", newJString(alt))
  add(query_580855, "oauth_token", newJString(oauthToken))
  add(path_580854, "accountId", newJString(accountId))
  add(query_580855, "userIp", newJString(userIp))
  add(path_580854, "webPropertyId", newJString(webPropertyId))
  add(query_580855, "key", newJString(key))
  if body != nil:
    body_580856 = body
  add(query_580855, "prettyPrint", newJBool(prettyPrint))
  result = call_580853.call(path_580854, query_580855, nil, nil, body_580856)

var analyticsManagementProfilesUpdate* = Call_AnalyticsManagementProfilesUpdate_580838(
    name: "analyticsManagementProfilesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesUpdate_580839,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesUpdate_580840,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesGet_580821 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfilesGet_580823(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementProfilesGet_580822(path: JsonNode;
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
  var valid_580824 = path.getOrDefault("profileId")
  valid_580824 = validateParameter(valid_580824, JString, required = true,
                                 default = nil)
  if valid_580824 != nil:
    section.add "profileId", valid_580824
  var valid_580825 = path.getOrDefault("accountId")
  valid_580825 = validateParameter(valid_580825, JString, required = true,
                                 default = nil)
  if valid_580825 != nil:
    section.add "accountId", valid_580825
  var valid_580826 = path.getOrDefault("webPropertyId")
  valid_580826 = validateParameter(valid_580826, JString, required = true,
                                 default = nil)
  if valid_580826 != nil:
    section.add "webPropertyId", valid_580826
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
  var valid_580827 = query.getOrDefault("fields")
  valid_580827 = validateParameter(valid_580827, JString, required = false,
                                 default = nil)
  if valid_580827 != nil:
    section.add "fields", valid_580827
  var valid_580828 = query.getOrDefault("quotaUser")
  valid_580828 = validateParameter(valid_580828, JString, required = false,
                                 default = nil)
  if valid_580828 != nil:
    section.add "quotaUser", valid_580828
  var valid_580829 = query.getOrDefault("alt")
  valid_580829 = validateParameter(valid_580829, JString, required = false,
                                 default = newJString("json"))
  if valid_580829 != nil:
    section.add "alt", valid_580829
  var valid_580830 = query.getOrDefault("oauth_token")
  valid_580830 = validateParameter(valid_580830, JString, required = false,
                                 default = nil)
  if valid_580830 != nil:
    section.add "oauth_token", valid_580830
  var valid_580831 = query.getOrDefault("userIp")
  valid_580831 = validateParameter(valid_580831, JString, required = false,
                                 default = nil)
  if valid_580831 != nil:
    section.add "userIp", valid_580831
  var valid_580832 = query.getOrDefault("key")
  valid_580832 = validateParameter(valid_580832, JString, required = false,
                                 default = nil)
  if valid_580832 != nil:
    section.add "key", valid_580832
  var valid_580833 = query.getOrDefault("prettyPrint")
  valid_580833 = validateParameter(valid_580833, JBool, required = false,
                                 default = newJBool(false))
  if valid_580833 != nil:
    section.add "prettyPrint", valid_580833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580834: Call_AnalyticsManagementProfilesGet_580821; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a view (profile) to which the user has access.
  ## 
  let valid = call_580834.validator(path, query, header, formData, body)
  let scheme = call_580834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580834.url(scheme.get, call_580834.host, call_580834.base,
                         call_580834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580834, url, valid)

proc call*(call_580835: Call_AnalyticsManagementProfilesGet_580821;
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
  var path_580836 = newJObject()
  var query_580837 = newJObject()
  add(path_580836, "profileId", newJString(profileId))
  add(query_580837, "fields", newJString(fields))
  add(query_580837, "quotaUser", newJString(quotaUser))
  add(query_580837, "alt", newJString(alt))
  add(query_580837, "oauth_token", newJString(oauthToken))
  add(path_580836, "accountId", newJString(accountId))
  add(query_580837, "userIp", newJString(userIp))
  add(path_580836, "webPropertyId", newJString(webPropertyId))
  add(query_580837, "key", newJString(key))
  add(query_580837, "prettyPrint", newJBool(prettyPrint))
  result = call_580835.call(path_580836, query_580837, nil, nil, nil)

var analyticsManagementProfilesGet* = Call_AnalyticsManagementProfilesGet_580821(
    name: "analyticsManagementProfilesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesGet_580822,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesGet_580823,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesPatch_580874 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfilesPatch_580876(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementProfilesPatch_580875(path: JsonNode;
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
  var valid_580877 = path.getOrDefault("profileId")
  valid_580877 = validateParameter(valid_580877, JString, required = true,
                                 default = nil)
  if valid_580877 != nil:
    section.add "profileId", valid_580877
  var valid_580878 = path.getOrDefault("accountId")
  valid_580878 = validateParameter(valid_580878, JString, required = true,
                                 default = nil)
  if valid_580878 != nil:
    section.add "accountId", valid_580878
  var valid_580879 = path.getOrDefault("webPropertyId")
  valid_580879 = validateParameter(valid_580879, JString, required = true,
                                 default = nil)
  if valid_580879 != nil:
    section.add "webPropertyId", valid_580879
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
  var valid_580880 = query.getOrDefault("fields")
  valid_580880 = validateParameter(valid_580880, JString, required = false,
                                 default = nil)
  if valid_580880 != nil:
    section.add "fields", valid_580880
  var valid_580881 = query.getOrDefault("quotaUser")
  valid_580881 = validateParameter(valid_580881, JString, required = false,
                                 default = nil)
  if valid_580881 != nil:
    section.add "quotaUser", valid_580881
  var valid_580882 = query.getOrDefault("alt")
  valid_580882 = validateParameter(valid_580882, JString, required = false,
                                 default = newJString("json"))
  if valid_580882 != nil:
    section.add "alt", valid_580882
  var valid_580883 = query.getOrDefault("oauth_token")
  valid_580883 = validateParameter(valid_580883, JString, required = false,
                                 default = nil)
  if valid_580883 != nil:
    section.add "oauth_token", valid_580883
  var valid_580884 = query.getOrDefault("userIp")
  valid_580884 = validateParameter(valid_580884, JString, required = false,
                                 default = nil)
  if valid_580884 != nil:
    section.add "userIp", valid_580884
  var valid_580885 = query.getOrDefault("key")
  valid_580885 = validateParameter(valid_580885, JString, required = false,
                                 default = nil)
  if valid_580885 != nil:
    section.add "key", valid_580885
  var valid_580886 = query.getOrDefault("prettyPrint")
  valid_580886 = validateParameter(valid_580886, JBool, required = false,
                                 default = newJBool(false))
  if valid_580886 != nil:
    section.add "prettyPrint", valid_580886
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

proc call*(call_580888: Call_AnalyticsManagementProfilesPatch_580874;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing view (profile). This method supports patch semantics.
  ## 
  let valid = call_580888.validator(path, query, header, formData, body)
  let scheme = call_580888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580888.url(scheme.get, call_580888.host, call_580888.base,
                         call_580888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580888, url, valid)

proc call*(call_580889: Call_AnalyticsManagementProfilesPatch_580874;
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
  var path_580890 = newJObject()
  var query_580891 = newJObject()
  var body_580892 = newJObject()
  add(path_580890, "profileId", newJString(profileId))
  add(query_580891, "fields", newJString(fields))
  add(query_580891, "quotaUser", newJString(quotaUser))
  add(query_580891, "alt", newJString(alt))
  add(query_580891, "oauth_token", newJString(oauthToken))
  add(path_580890, "accountId", newJString(accountId))
  add(query_580891, "userIp", newJString(userIp))
  add(path_580890, "webPropertyId", newJString(webPropertyId))
  add(query_580891, "key", newJString(key))
  if body != nil:
    body_580892 = body
  add(query_580891, "prettyPrint", newJBool(prettyPrint))
  result = call_580889.call(path_580890, query_580891, nil, nil, body_580892)

var analyticsManagementProfilesPatch* = Call_AnalyticsManagementProfilesPatch_580874(
    name: "analyticsManagementProfilesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesPatch_580875,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesPatch_580876,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesDelete_580857 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfilesDelete_580859(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementProfilesDelete_580858(path: JsonNode;
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
  var valid_580860 = path.getOrDefault("profileId")
  valid_580860 = validateParameter(valid_580860, JString, required = true,
                                 default = nil)
  if valid_580860 != nil:
    section.add "profileId", valid_580860
  var valid_580861 = path.getOrDefault("accountId")
  valid_580861 = validateParameter(valid_580861, JString, required = true,
                                 default = nil)
  if valid_580861 != nil:
    section.add "accountId", valid_580861
  var valid_580862 = path.getOrDefault("webPropertyId")
  valid_580862 = validateParameter(valid_580862, JString, required = true,
                                 default = nil)
  if valid_580862 != nil:
    section.add "webPropertyId", valid_580862
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
  var valid_580863 = query.getOrDefault("fields")
  valid_580863 = validateParameter(valid_580863, JString, required = false,
                                 default = nil)
  if valid_580863 != nil:
    section.add "fields", valid_580863
  var valid_580864 = query.getOrDefault("quotaUser")
  valid_580864 = validateParameter(valid_580864, JString, required = false,
                                 default = nil)
  if valid_580864 != nil:
    section.add "quotaUser", valid_580864
  var valid_580865 = query.getOrDefault("alt")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = newJString("json"))
  if valid_580865 != nil:
    section.add "alt", valid_580865
  var valid_580866 = query.getOrDefault("oauth_token")
  valid_580866 = validateParameter(valid_580866, JString, required = false,
                                 default = nil)
  if valid_580866 != nil:
    section.add "oauth_token", valid_580866
  var valid_580867 = query.getOrDefault("userIp")
  valid_580867 = validateParameter(valid_580867, JString, required = false,
                                 default = nil)
  if valid_580867 != nil:
    section.add "userIp", valid_580867
  var valid_580868 = query.getOrDefault("key")
  valid_580868 = validateParameter(valid_580868, JString, required = false,
                                 default = nil)
  if valid_580868 != nil:
    section.add "key", valid_580868
  var valid_580869 = query.getOrDefault("prettyPrint")
  valid_580869 = validateParameter(valid_580869, JBool, required = false,
                                 default = newJBool(false))
  if valid_580869 != nil:
    section.add "prettyPrint", valid_580869
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580870: Call_AnalyticsManagementProfilesDelete_580857;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a view (profile).
  ## 
  let valid = call_580870.validator(path, query, header, formData, body)
  let scheme = call_580870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580870.url(scheme.get, call_580870.host, call_580870.base,
                         call_580870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580870, url, valid)

proc call*(call_580871: Call_AnalyticsManagementProfilesDelete_580857;
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
  var path_580872 = newJObject()
  var query_580873 = newJObject()
  add(path_580872, "profileId", newJString(profileId))
  add(query_580873, "fields", newJString(fields))
  add(query_580873, "quotaUser", newJString(quotaUser))
  add(query_580873, "alt", newJString(alt))
  add(query_580873, "oauth_token", newJString(oauthToken))
  add(path_580872, "accountId", newJString(accountId))
  add(query_580873, "userIp", newJString(userIp))
  add(path_580872, "webPropertyId", newJString(webPropertyId))
  add(query_580873, "key", newJString(key))
  add(query_580873, "prettyPrint", newJBool(prettyPrint))
  result = call_580871.call(path_580872, query_580873, nil, nil, nil)

var analyticsManagementProfilesDelete* = Call_AnalyticsManagementProfilesDelete_580857(
    name: "analyticsManagementProfilesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}",
    validator: validate_AnalyticsManagementProfilesDelete_580858,
    base: "/analytics/v3", url: url_AnalyticsManagementProfilesDelete_580859,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksInsert_580912 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfileUserLinksInsert_580914(protocol: Scheme;
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

proc validate_AnalyticsManagementProfileUserLinksInsert_580913(path: JsonNode;
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
  var valid_580915 = path.getOrDefault("profileId")
  valid_580915 = validateParameter(valid_580915, JString, required = true,
                                 default = nil)
  if valid_580915 != nil:
    section.add "profileId", valid_580915
  var valid_580916 = path.getOrDefault("accountId")
  valid_580916 = validateParameter(valid_580916, JString, required = true,
                                 default = nil)
  if valid_580916 != nil:
    section.add "accountId", valid_580916
  var valid_580917 = path.getOrDefault("webPropertyId")
  valid_580917 = validateParameter(valid_580917, JString, required = true,
                                 default = nil)
  if valid_580917 != nil:
    section.add "webPropertyId", valid_580917
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
  var valid_580918 = query.getOrDefault("fields")
  valid_580918 = validateParameter(valid_580918, JString, required = false,
                                 default = nil)
  if valid_580918 != nil:
    section.add "fields", valid_580918
  var valid_580919 = query.getOrDefault("quotaUser")
  valid_580919 = validateParameter(valid_580919, JString, required = false,
                                 default = nil)
  if valid_580919 != nil:
    section.add "quotaUser", valid_580919
  var valid_580920 = query.getOrDefault("alt")
  valid_580920 = validateParameter(valid_580920, JString, required = false,
                                 default = newJString("json"))
  if valid_580920 != nil:
    section.add "alt", valid_580920
  var valid_580921 = query.getOrDefault("oauth_token")
  valid_580921 = validateParameter(valid_580921, JString, required = false,
                                 default = nil)
  if valid_580921 != nil:
    section.add "oauth_token", valid_580921
  var valid_580922 = query.getOrDefault("userIp")
  valid_580922 = validateParameter(valid_580922, JString, required = false,
                                 default = nil)
  if valid_580922 != nil:
    section.add "userIp", valid_580922
  var valid_580923 = query.getOrDefault("key")
  valid_580923 = validateParameter(valid_580923, JString, required = false,
                                 default = nil)
  if valid_580923 != nil:
    section.add "key", valid_580923
  var valid_580924 = query.getOrDefault("prettyPrint")
  valid_580924 = validateParameter(valid_580924, JBool, required = false,
                                 default = newJBool(false))
  if valid_580924 != nil:
    section.add "prettyPrint", valid_580924
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

proc call*(call_580926: Call_AnalyticsManagementProfileUserLinksInsert_580912;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds a new user to the given view (profile).
  ## 
  let valid = call_580926.validator(path, query, header, formData, body)
  let scheme = call_580926.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580926.url(scheme.get, call_580926.host, call_580926.base,
                         call_580926.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580926, url, valid)

proc call*(call_580927: Call_AnalyticsManagementProfileUserLinksInsert_580912;
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
  var path_580928 = newJObject()
  var query_580929 = newJObject()
  var body_580930 = newJObject()
  add(path_580928, "profileId", newJString(profileId))
  add(query_580929, "fields", newJString(fields))
  add(query_580929, "quotaUser", newJString(quotaUser))
  add(query_580929, "alt", newJString(alt))
  add(query_580929, "oauth_token", newJString(oauthToken))
  add(path_580928, "accountId", newJString(accountId))
  add(query_580929, "userIp", newJString(userIp))
  add(path_580928, "webPropertyId", newJString(webPropertyId))
  add(query_580929, "key", newJString(key))
  if body != nil:
    body_580930 = body
  add(query_580929, "prettyPrint", newJBool(prettyPrint))
  result = call_580927.call(path_580928, query_580929, nil, nil, body_580930)

var analyticsManagementProfileUserLinksInsert* = Call_AnalyticsManagementProfileUserLinksInsert_580912(
    name: "analyticsManagementProfileUserLinksInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks",
    validator: validate_AnalyticsManagementProfileUserLinksInsert_580913,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksInsert_580914,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksList_580893 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfileUserLinksList_580895(protocol: Scheme;
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

proc validate_AnalyticsManagementProfileUserLinksList_580894(path: JsonNode;
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
  var valid_580896 = path.getOrDefault("profileId")
  valid_580896 = validateParameter(valid_580896, JString, required = true,
                                 default = nil)
  if valid_580896 != nil:
    section.add "profileId", valid_580896
  var valid_580897 = path.getOrDefault("accountId")
  valid_580897 = validateParameter(valid_580897, JString, required = true,
                                 default = nil)
  if valid_580897 != nil:
    section.add "accountId", valid_580897
  var valid_580898 = path.getOrDefault("webPropertyId")
  valid_580898 = validateParameter(valid_580898, JString, required = true,
                                 default = nil)
  if valid_580898 != nil:
    section.add "webPropertyId", valid_580898
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
  var valid_580899 = query.getOrDefault("fields")
  valid_580899 = validateParameter(valid_580899, JString, required = false,
                                 default = nil)
  if valid_580899 != nil:
    section.add "fields", valid_580899
  var valid_580900 = query.getOrDefault("quotaUser")
  valid_580900 = validateParameter(valid_580900, JString, required = false,
                                 default = nil)
  if valid_580900 != nil:
    section.add "quotaUser", valid_580900
  var valid_580901 = query.getOrDefault("alt")
  valid_580901 = validateParameter(valid_580901, JString, required = false,
                                 default = newJString("json"))
  if valid_580901 != nil:
    section.add "alt", valid_580901
  var valid_580902 = query.getOrDefault("oauth_token")
  valid_580902 = validateParameter(valid_580902, JString, required = false,
                                 default = nil)
  if valid_580902 != nil:
    section.add "oauth_token", valid_580902
  var valid_580903 = query.getOrDefault("userIp")
  valid_580903 = validateParameter(valid_580903, JString, required = false,
                                 default = nil)
  if valid_580903 != nil:
    section.add "userIp", valid_580903
  var valid_580904 = query.getOrDefault("key")
  valid_580904 = validateParameter(valid_580904, JString, required = false,
                                 default = nil)
  if valid_580904 != nil:
    section.add "key", valid_580904
  var valid_580905 = query.getOrDefault("max-results")
  valid_580905 = validateParameter(valid_580905, JInt, required = false, default = nil)
  if valid_580905 != nil:
    section.add "max-results", valid_580905
  var valid_580906 = query.getOrDefault("start-index")
  valid_580906 = validateParameter(valid_580906, JInt, required = false, default = nil)
  if valid_580906 != nil:
    section.add "start-index", valid_580906
  var valid_580907 = query.getOrDefault("prettyPrint")
  valid_580907 = validateParameter(valid_580907, JBool, required = false,
                                 default = newJBool(false))
  if valid_580907 != nil:
    section.add "prettyPrint", valid_580907
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580908: Call_AnalyticsManagementProfileUserLinksList_580893;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists profile-user links for a given view (profile).
  ## 
  let valid = call_580908.validator(path, query, header, formData, body)
  let scheme = call_580908.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580908.url(scheme.get, call_580908.host, call_580908.base,
                         call_580908.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580908, url, valid)

proc call*(call_580909: Call_AnalyticsManagementProfileUserLinksList_580893;
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
  var path_580910 = newJObject()
  var query_580911 = newJObject()
  add(path_580910, "profileId", newJString(profileId))
  add(query_580911, "fields", newJString(fields))
  add(query_580911, "quotaUser", newJString(quotaUser))
  add(query_580911, "alt", newJString(alt))
  add(query_580911, "oauth_token", newJString(oauthToken))
  add(path_580910, "accountId", newJString(accountId))
  add(query_580911, "userIp", newJString(userIp))
  add(path_580910, "webPropertyId", newJString(webPropertyId))
  add(query_580911, "key", newJString(key))
  add(query_580911, "max-results", newJInt(maxResults))
  add(query_580911, "start-index", newJInt(startIndex))
  add(query_580911, "prettyPrint", newJBool(prettyPrint))
  result = call_580909.call(path_580910, query_580911, nil, nil, nil)

var analyticsManagementProfileUserLinksList* = Call_AnalyticsManagementProfileUserLinksList_580893(
    name: "analyticsManagementProfileUserLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks",
    validator: validate_AnalyticsManagementProfileUserLinksList_580894,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksList_580895,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksUpdate_580931 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfileUserLinksUpdate_580933(protocol: Scheme;
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

proc validate_AnalyticsManagementProfileUserLinksUpdate_580932(path: JsonNode;
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
  var valid_580934 = path.getOrDefault("profileId")
  valid_580934 = validateParameter(valid_580934, JString, required = true,
                                 default = nil)
  if valid_580934 != nil:
    section.add "profileId", valid_580934
  var valid_580935 = path.getOrDefault("accountId")
  valid_580935 = validateParameter(valid_580935, JString, required = true,
                                 default = nil)
  if valid_580935 != nil:
    section.add "accountId", valid_580935
  var valid_580936 = path.getOrDefault("webPropertyId")
  valid_580936 = validateParameter(valid_580936, JString, required = true,
                                 default = nil)
  if valid_580936 != nil:
    section.add "webPropertyId", valid_580936
  var valid_580937 = path.getOrDefault("linkId")
  valid_580937 = validateParameter(valid_580937, JString, required = true,
                                 default = nil)
  if valid_580937 != nil:
    section.add "linkId", valid_580937
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
  var valid_580938 = query.getOrDefault("fields")
  valid_580938 = validateParameter(valid_580938, JString, required = false,
                                 default = nil)
  if valid_580938 != nil:
    section.add "fields", valid_580938
  var valid_580939 = query.getOrDefault("quotaUser")
  valid_580939 = validateParameter(valid_580939, JString, required = false,
                                 default = nil)
  if valid_580939 != nil:
    section.add "quotaUser", valid_580939
  var valid_580940 = query.getOrDefault("alt")
  valid_580940 = validateParameter(valid_580940, JString, required = false,
                                 default = newJString("json"))
  if valid_580940 != nil:
    section.add "alt", valid_580940
  var valid_580941 = query.getOrDefault("oauth_token")
  valid_580941 = validateParameter(valid_580941, JString, required = false,
                                 default = nil)
  if valid_580941 != nil:
    section.add "oauth_token", valid_580941
  var valid_580942 = query.getOrDefault("userIp")
  valid_580942 = validateParameter(valid_580942, JString, required = false,
                                 default = nil)
  if valid_580942 != nil:
    section.add "userIp", valid_580942
  var valid_580943 = query.getOrDefault("key")
  valid_580943 = validateParameter(valid_580943, JString, required = false,
                                 default = nil)
  if valid_580943 != nil:
    section.add "key", valid_580943
  var valid_580944 = query.getOrDefault("prettyPrint")
  valid_580944 = validateParameter(valid_580944, JBool, required = false,
                                 default = newJBool(false))
  if valid_580944 != nil:
    section.add "prettyPrint", valid_580944
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

proc call*(call_580946: Call_AnalyticsManagementProfileUserLinksUpdate_580931;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates permissions for an existing user on the given view (profile).
  ## 
  let valid = call_580946.validator(path, query, header, formData, body)
  let scheme = call_580946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580946.url(scheme.get, call_580946.host, call_580946.base,
                         call_580946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580946, url, valid)

proc call*(call_580947: Call_AnalyticsManagementProfileUserLinksUpdate_580931;
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
  var path_580948 = newJObject()
  var query_580949 = newJObject()
  var body_580950 = newJObject()
  add(path_580948, "profileId", newJString(profileId))
  add(query_580949, "fields", newJString(fields))
  add(query_580949, "quotaUser", newJString(quotaUser))
  add(query_580949, "alt", newJString(alt))
  add(query_580949, "oauth_token", newJString(oauthToken))
  add(path_580948, "accountId", newJString(accountId))
  add(query_580949, "userIp", newJString(userIp))
  add(path_580948, "webPropertyId", newJString(webPropertyId))
  add(query_580949, "key", newJString(key))
  add(path_580948, "linkId", newJString(linkId))
  if body != nil:
    body_580950 = body
  add(query_580949, "prettyPrint", newJBool(prettyPrint))
  result = call_580947.call(path_580948, query_580949, nil, nil, body_580950)

var analyticsManagementProfileUserLinksUpdate* = Call_AnalyticsManagementProfileUserLinksUpdate_580931(
    name: "analyticsManagementProfileUserLinksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileUserLinksUpdate_580932,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksUpdate_580933,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileUserLinksDelete_580951 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfileUserLinksDelete_580953(protocol: Scheme;
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

proc validate_AnalyticsManagementProfileUserLinksDelete_580952(path: JsonNode;
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
  var valid_580954 = path.getOrDefault("profileId")
  valid_580954 = validateParameter(valid_580954, JString, required = true,
                                 default = nil)
  if valid_580954 != nil:
    section.add "profileId", valid_580954
  var valid_580955 = path.getOrDefault("accountId")
  valid_580955 = validateParameter(valid_580955, JString, required = true,
                                 default = nil)
  if valid_580955 != nil:
    section.add "accountId", valid_580955
  var valid_580956 = path.getOrDefault("webPropertyId")
  valid_580956 = validateParameter(valid_580956, JString, required = true,
                                 default = nil)
  if valid_580956 != nil:
    section.add "webPropertyId", valid_580956
  var valid_580957 = path.getOrDefault("linkId")
  valid_580957 = validateParameter(valid_580957, JString, required = true,
                                 default = nil)
  if valid_580957 != nil:
    section.add "linkId", valid_580957
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
  var valid_580958 = query.getOrDefault("fields")
  valid_580958 = validateParameter(valid_580958, JString, required = false,
                                 default = nil)
  if valid_580958 != nil:
    section.add "fields", valid_580958
  var valid_580959 = query.getOrDefault("quotaUser")
  valid_580959 = validateParameter(valid_580959, JString, required = false,
                                 default = nil)
  if valid_580959 != nil:
    section.add "quotaUser", valid_580959
  var valid_580960 = query.getOrDefault("alt")
  valid_580960 = validateParameter(valid_580960, JString, required = false,
                                 default = newJString("json"))
  if valid_580960 != nil:
    section.add "alt", valid_580960
  var valid_580961 = query.getOrDefault("oauth_token")
  valid_580961 = validateParameter(valid_580961, JString, required = false,
                                 default = nil)
  if valid_580961 != nil:
    section.add "oauth_token", valid_580961
  var valid_580962 = query.getOrDefault("userIp")
  valid_580962 = validateParameter(valid_580962, JString, required = false,
                                 default = nil)
  if valid_580962 != nil:
    section.add "userIp", valid_580962
  var valid_580963 = query.getOrDefault("key")
  valid_580963 = validateParameter(valid_580963, JString, required = false,
                                 default = nil)
  if valid_580963 != nil:
    section.add "key", valid_580963
  var valid_580964 = query.getOrDefault("prettyPrint")
  valid_580964 = validateParameter(valid_580964, JBool, required = false,
                                 default = newJBool(false))
  if valid_580964 != nil:
    section.add "prettyPrint", valid_580964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580965: Call_AnalyticsManagementProfileUserLinksDelete_580951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a user from the given view (profile).
  ## 
  let valid = call_580965.validator(path, query, header, formData, body)
  let scheme = call_580965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580965.url(scheme.get, call_580965.host, call_580965.base,
                         call_580965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580965, url, valid)

proc call*(call_580966: Call_AnalyticsManagementProfileUserLinksDelete_580951;
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
  var path_580967 = newJObject()
  var query_580968 = newJObject()
  add(path_580967, "profileId", newJString(profileId))
  add(query_580968, "fields", newJString(fields))
  add(query_580968, "quotaUser", newJString(quotaUser))
  add(query_580968, "alt", newJString(alt))
  add(query_580968, "oauth_token", newJString(oauthToken))
  add(path_580967, "accountId", newJString(accountId))
  add(query_580968, "userIp", newJString(userIp))
  add(path_580967, "webPropertyId", newJString(webPropertyId))
  add(query_580968, "key", newJString(key))
  add(path_580967, "linkId", newJString(linkId))
  add(query_580968, "prettyPrint", newJBool(prettyPrint))
  result = call_580966.call(path_580967, query_580968, nil, nil, nil)

var analyticsManagementProfileUserLinksDelete* = Call_AnalyticsManagementProfileUserLinksDelete_580951(
    name: "analyticsManagementProfileUserLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/entityUserLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileUserLinksDelete_580952,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileUserLinksDelete_580953,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsInsert_580988 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementExperimentsInsert_580990(protocol: Scheme;
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

proc validate_AnalyticsManagementExperimentsInsert_580989(path: JsonNode;
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
  var valid_580991 = path.getOrDefault("profileId")
  valid_580991 = validateParameter(valid_580991, JString, required = true,
                                 default = nil)
  if valid_580991 != nil:
    section.add "profileId", valid_580991
  var valid_580992 = path.getOrDefault("accountId")
  valid_580992 = validateParameter(valid_580992, JString, required = true,
                                 default = nil)
  if valid_580992 != nil:
    section.add "accountId", valid_580992
  var valid_580993 = path.getOrDefault("webPropertyId")
  valid_580993 = validateParameter(valid_580993, JString, required = true,
                                 default = nil)
  if valid_580993 != nil:
    section.add "webPropertyId", valid_580993
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
  var valid_580994 = query.getOrDefault("fields")
  valid_580994 = validateParameter(valid_580994, JString, required = false,
                                 default = nil)
  if valid_580994 != nil:
    section.add "fields", valid_580994
  var valid_580995 = query.getOrDefault("quotaUser")
  valid_580995 = validateParameter(valid_580995, JString, required = false,
                                 default = nil)
  if valid_580995 != nil:
    section.add "quotaUser", valid_580995
  var valid_580996 = query.getOrDefault("alt")
  valid_580996 = validateParameter(valid_580996, JString, required = false,
                                 default = newJString("json"))
  if valid_580996 != nil:
    section.add "alt", valid_580996
  var valid_580997 = query.getOrDefault("oauth_token")
  valid_580997 = validateParameter(valid_580997, JString, required = false,
                                 default = nil)
  if valid_580997 != nil:
    section.add "oauth_token", valid_580997
  var valid_580998 = query.getOrDefault("userIp")
  valid_580998 = validateParameter(valid_580998, JString, required = false,
                                 default = nil)
  if valid_580998 != nil:
    section.add "userIp", valid_580998
  var valid_580999 = query.getOrDefault("key")
  valid_580999 = validateParameter(valid_580999, JString, required = false,
                                 default = nil)
  if valid_580999 != nil:
    section.add "key", valid_580999
  var valid_581000 = query.getOrDefault("prettyPrint")
  valid_581000 = validateParameter(valid_581000, JBool, required = false,
                                 default = newJBool(false))
  if valid_581000 != nil:
    section.add "prettyPrint", valid_581000
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

proc call*(call_581002: Call_AnalyticsManagementExperimentsInsert_580988;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new experiment.
  ## 
  let valid = call_581002.validator(path, query, header, formData, body)
  let scheme = call_581002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581002.url(scheme.get, call_581002.host, call_581002.base,
                         call_581002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581002, url, valid)

proc call*(call_581003: Call_AnalyticsManagementExperimentsInsert_580988;
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
  var path_581004 = newJObject()
  var query_581005 = newJObject()
  var body_581006 = newJObject()
  add(path_581004, "profileId", newJString(profileId))
  add(query_581005, "fields", newJString(fields))
  add(query_581005, "quotaUser", newJString(quotaUser))
  add(query_581005, "alt", newJString(alt))
  add(query_581005, "oauth_token", newJString(oauthToken))
  add(path_581004, "accountId", newJString(accountId))
  add(query_581005, "userIp", newJString(userIp))
  add(path_581004, "webPropertyId", newJString(webPropertyId))
  add(query_581005, "key", newJString(key))
  if body != nil:
    body_581006 = body
  add(query_581005, "prettyPrint", newJBool(prettyPrint))
  result = call_581003.call(path_581004, query_581005, nil, nil, body_581006)

var analyticsManagementExperimentsInsert* = Call_AnalyticsManagementExperimentsInsert_580988(
    name: "analyticsManagementExperimentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments",
    validator: validate_AnalyticsManagementExperimentsInsert_580989,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsInsert_580990,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsList_580969 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementExperimentsList_580971(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementExperimentsList_580970(path: JsonNode;
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
  var valid_580972 = path.getOrDefault("profileId")
  valid_580972 = validateParameter(valid_580972, JString, required = true,
                                 default = nil)
  if valid_580972 != nil:
    section.add "profileId", valid_580972
  var valid_580973 = path.getOrDefault("accountId")
  valid_580973 = validateParameter(valid_580973, JString, required = true,
                                 default = nil)
  if valid_580973 != nil:
    section.add "accountId", valid_580973
  var valid_580974 = path.getOrDefault("webPropertyId")
  valid_580974 = validateParameter(valid_580974, JString, required = true,
                                 default = nil)
  if valid_580974 != nil:
    section.add "webPropertyId", valid_580974
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
  var valid_580975 = query.getOrDefault("fields")
  valid_580975 = validateParameter(valid_580975, JString, required = false,
                                 default = nil)
  if valid_580975 != nil:
    section.add "fields", valid_580975
  var valid_580976 = query.getOrDefault("quotaUser")
  valid_580976 = validateParameter(valid_580976, JString, required = false,
                                 default = nil)
  if valid_580976 != nil:
    section.add "quotaUser", valid_580976
  var valid_580977 = query.getOrDefault("alt")
  valid_580977 = validateParameter(valid_580977, JString, required = false,
                                 default = newJString("json"))
  if valid_580977 != nil:
    section.add "alt", valid_580977
  var valid_580978 = query.getOrDefault("oauth_token")
  valid_580978 = validateParameter(valid_580978, JString, required = false,
                                 default = nil)
  if valid_580978 != nil:
    section.add "oauth_token", valid_580978
  var valid_580979 = query.getOrDefault("userIp")
  valid_580979 = validateParameter(valid_580979, JString, required = false,
                                 default = nil)
  if valid_580979 != nil:
    section.add "userIp", valid_580979
  var valid_580980 = query.getOrDefault("key")
  valid_580980 = validateParameter(valid_580980, JString, required = false,
                                 default = nil)
  if valid_580980 != nil:
    section.add "key", valid_580980
  var valid_580981 = query.getOrDefault("max-results")
  valid_580981 = validateParameter(valid_580981, JInt, required = false, default = nil)
  if valid_580981 != nil:
    section.add "max-results", valid_580981
  var valid_580982 = query.getOrDefault("start-index")
  valid_580982 = validateParameter(valid_580982, JInt, required = false, default = nil)
  if valid_580982 != nil:
    section.add "start-index", valid_580982
  var valid_580983 = query.getOrDefault("prettyPrint")
  valid_580983 = validateParameter(valid_580983, JBool, required = false,
                                 default = newJBool(false))
  if valid_580983 != nil:
    section.add "prettyPrint", valid_580983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580984: Call_AnalyticsManagementExperimentsList_580969;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists experiments to which the user has access.
  ## 
  let valid = call_580984.validator(path, query, header, formData, body)
  let scheme = call_580984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580984.url(scheme.get, call_580984.host, call_580984.base,
                         call_580984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580984, url, valid)

proc call*(call_580985: Call_AnalyticsManagementExperimentsList_580969;
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
  var path_580986 = newJObject()
  var query_580987 = newJObject()
  add(path_580986, "profileId", newJString(profileId))
  add(query_580987, "fields", newJString(fields))
  add(query_580987, "quotaUser", newJString(quotaUser))
  add(query_580987, "alt", newJString(alt))
  add(query_580987, "oauth_token", newJString(oauthToken))
  add(path_580986, "accountId", newJString(accountId))
  add(query_580987, "userIp", newJString(userIp))
  add(path_580986, "webPropertyId", newJString(webPropertyId))
  add(query_580987, "key", newJString(key))
  add(query_580987, "max-results", newJInt(maxResults))
  add(query_580987, "start-index", newJInt(startIndex))
  add(query_580987, "prettyPrint", newJBool(prettyPrint))
  result = call_580985.call(path_580986, query_580987, nil, nil, nil)

var analyticsManagementExperimentsList* = Call_AnalyticsManagementExperimentsList_580969(
    name: "analyticsManagementExperimentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments",
    validator: validate_AnalyticsManagementExperimentsList_580970,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsList_580971,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsUpdate_581025 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementExperimentsUpdate_581027(protocol: Scheme;
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

proc validate_AnalyticsManagementExperimentsUpdate_581026(path: JsonNode;
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
  var valid_581028 = path.getOrDefault("profileId")
  valid_581028 = validateParameter(valid_581028, JString, required = true,
                                 default = nil)
  if valid_581028 != nil:
    section.add "profileId", valid_581028
  var valid_581029 = path.getOrDefault("accountId")
  valid_581029 = validateParameter(valid_581029, JString, required = true,
                                 default = nil)
  if valid_581029 != nil:
    section.add "accountId", valid_581029
  var valid_581030 = path.getOrDefault("experimentId")
  valid_581030 = validateParameter(valid_581030, JString, required = true,
                                 default = nil)
  if valid_581030 != nil:
    section.add "experimentId", valid_581030
  var valid_581031 = path.getOrDefault("webPropertyId")
  valid_581031 = validateParameter(valid_581031, JString, required = true,
                                 default = nil)
  if valid_581031 != nil:
    section.add "webPropertyId", valid_581031
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
  var valid_581032 = query.getOrDefault("fields")
  valid_581032 = validateParameter(valid_581032, JString, required = false,
                                 default = nil)
  if valid_581032 != nil:
    section.add "fields", valid_581032
  var valid_581033 = query.getOrDefault("quotaUser")
  valid_581033 = validateParameter(valid_581033, JString, required = false,
                                 default = nil)
  if valid_581033 != nil:
    section.add "quotaUser", valid_581033
  var valid_581034 = query.getOrDefault("alt")
  valid_581034 = validateParameter(valid_581034, JString, required = false,
                                 default = newJString("json"))
  if valid_581034 != nil:
    section.add "alt", valid_581034
  var valid_581035 = query.getOrDefault("oauth_token")
  valid_581035 = validateParameter(valid_581035, JString, required = false,
                                 default = nil)
  if valid_581035 != nil:
    section.add "oauth_token", valid_581035
  var valid_581036 = query.getOrDefault("userIp")
  valid_581036 = validateParameter(valid_581036, JString, required = false,
                                 default = nil)
  if valid_581036 != nil:
    section.add "userIp", valid_581036
  var valid_581037 = query.getOrDefault("key")
  valid_581037 = validateParameter(valid_581037, JString, required = false,
                                 default = nil)
  if valid_581037 != nil:
    section.add "key", valid_581037
  var valid_581038 = query.getOrDefault("prettyPrint")
  valid_581038 = validateParameter(valid_581038, JBool, required = false,
                                 default = newJBool(false))
  if valid_581038 != nil:
    section.add "prettyPrint", valid_581038
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

proc call*(call_581040: Call_AnalyticsManagementExperimentsUpdate_581025;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing experiment.
  ## 
  let valid = call_581040.validator(path, query, header, formData, body)
  let scheme = call_581040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581040.url(scheme.get, call_581040.host, call_581040.base,
                         call_581040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581040, url, valid)

proc call*(call_581041: Call_AnalyticsManagementExperimentsUpdate_581025;
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
  var path_581042 = newJObject()
  var query_581043 = newJObject()
  var body_581044 = newJObject()
  add(path_581042, "profileId", newJString(profileId))
  add(query_581043, "fields", newJString(fields))
  add(query_581043, "quotaUser", newJString(quotaUser))
  add(query_581043, "alt", newJString(alt))
  add(query_581043, "oauth_token", newJString(oauthToken))
  add(path_581042, "accountId", newJString(accountId))
  add(query_581043, "userIp", newJString(userIp))
  add(path_581042, "experimentId", newJString(experimentId))
  add(path_581042, "webPropertyId", newJString(webPropertyId))
  add(query_581043, "key", newJString(key))
  if body != nil:
    body_581044 = body
  add(query_581043, "prettyPrint", newJBool(prettyPrint))
  result = call_581041.call(path_581042, query_581043, nil, nil, body_581044)

var analyticsManagementExperimentsUpdate* = Call_AnalyticsManagementExperimentsUpdate_581025(
    name: "analyticsManagementExperimentsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsUpdate_581026,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsUpdate_581027,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsGet_581007 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementExperimentsGet_581009(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementExperimentsGet_581008(path: JsonNode;
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
  var valid_581010 = path.getOrDefault("profileId")
  valid_581010 = validateParameter(valid_581010, JString, required = true,
                                 default = nil)
  if valid_581010 != nil:
    section.add "profileId", valid_581010
  var valid_581011 = path.getOrDefault("accountId")
  valid_581011 = validateParameter(valid_581011, JString, required = true,
                                 default = nil)
  if valid_581011 != nil:
    section.add "accountId", valid_581011
  var valid_581012 = path.getOrDefault("experimentId")
  valid_581012 = validateParameter(valid_581012, JString, required = true,
                                 default = nil)
  if valid_581012 != nil:
    section.add "experimentId", valid_581012
  var valid_581013 = path.getOrDefault("webPropertyId")
  valid_581013 = validateParameter(valid_581013, JString, required = true,
                                 default = nil)
  if valid_581013 != nil:
    section.add "webPropertyId", valid_581013
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
  var valid_581014 = query.getOrDefault("fields")
  valid_581014 = validateParameter(valid_581014, JString, required = false,
                                 default = nil)
  if valid_581014 != nil:
    section.add "fields", valid_581014
  var valid_581015 = query.getOrDefault("quotaUser")
  valid_581015 = validateParameter(valid_581015, JString, required = false,
                                 default = nil)
  if valid_581015 != nil:
    section.add "quotaUser", valid_581015
  var valid_581016 = query.getOrDefault("alt")
  valid_581016 = validateParameter(valid_581016, JString, required = false,
                                 default = newJString("json"))
  if valid_581016 != nil:
    section.add "alt", valid_581016
  var valid_581017 = query.getOrDefault("oauth_token")
  valid_581017 = validateParameter(valid_581017, JString, required = false,
                                 default = nil)
  if valid_581017 != nil:
    section.add "oauth_token", valid_581017
  var valid_581018 = query.getOrDefault("userIp")
  valid_581018 = validateParameter(valid_581018, JString, required = false,
                                 default = nil)
  if valid_581018 != nil:
    section.add "userIp", valid_581018
  var valid_581019 = query.getOrDefault("key")
  valid_581019 = validateParameter(valid_581019, JString, required = false,
                                 default = nil)
  if valid_581019 != nil:
    section.add "key", valid_581019
  var valid_581020 = query.getOrDefault("prettyPrint")
  valid_581020 = validateParameter(valid_581020, JBool, required = false,
                                 default = newJBool(false))
  if valid_581020 != nil:
    section.add "prettyPrint", valid_581020
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581021: Call_AnalyticsManagementExperimentsGet_581007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns an experiment to which the user has access.
  ## 
  let valid = call_581021.validator(path, query, header, formData, body)
  let scheme = call_581021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581021.url(scheme.get, call_581021.host, call_581021.base,
                         call_581021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581021, url, valid)

proc call*(call_581022: Call_AnalyticsManagementExperimentsGet_581007;
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
  var path_581023 = newJObject()
  var query_581024 = newJObject()
  add(path_581023, "profileId", newJString(profileId))
  add(query_581024, "fields", newJString(fields))
  add(query_581024, "quotaUser", newJString(quotaUser))
  add(query_581024, "alt", newJString(alt))
  add(query_581024, "oauth_token", newJString(oauthToken))
  add(path_581023, "accountId", newJString(accountId))
  add(query_581024, "userIp", newJString(userIp))
  add(path_581023, "experimentId", newJString(experimentId))
  add(path_581023, "webPropertyId", newJString(webPropertyId))
  add(query_581024, "key", newJString(key))
  add(query_581024, "prettyPrint", newJBool(prettyPrint))
  result = call_581022.call(path_581023, query_581024, nil, nil, nil)

var analyticsManagementExperimentsGet* = Call_AnalyticsManagementExperimentsGet_581007(
    name: "analyticsManagementExperimentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsGet_581008,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsGet_581009,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsPatch_581063 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementExperimentsPatch_581065(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementExperimentsPatch_581064(path: JsonNode;
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
  var valid_581066 = path.getOrDefault("profileId")
  valid_581066 = validateParameter(valid_581066, JString, required = true,
                                 default = nil)
  if valid_581066 != nil:
    section.add "profileId", valid_581066
  var valid_581067 = path.getOrDefault("accountId")
  valid_581067 = validateParameter(valid_581067, JString, required = true,
                                 default = nil)
  if valid_581067 != nil:
    section.add "accountId", valid_581067
  var valid_581068 = path.getOrDefault("experimentId")
  valid_581068 = validateParameter(valid_581068, JString, required = true,
                                 default = nil)
  if valid_581068 != nil:
    section.add "experimentId", valid_581068
  var valid_581069 = path.getOrDefault("webPropertyId")
  valid_581069 = validateParameter(valid_581069, JString, required = true,
                                 default = nil)
  if valid_581069 != nil:
    section.add "webPropertyId", valid_581069
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
  var valid_581070 = query.getOrDefault("fields")
  valid_581070 = validateParameter(valid_581070, JString, required = false,
                                 default = nil)
  if valid_581070 != nil:
    section.add "fields", valid_581070
  var valid_581071 = query.getOrDefault("quotaUser")
  valid_581071 = validateParameter(valid_581071, JString, required = false,
                                 default = nil)
  if valid_581071 != nil:
    section.add "quotaUser", valid_581071
  var valid_581072 = query.getOrDefault("alt")
  valid_581072 = validateParameter(valid_581072, JString, required = false,
                                 default = newJString("json"))
  if valid_581072 != nil:
    section.add "alt", valid_581072
  var valid_581073 = query.getOrDefault("oauth_token")
  valid_581073 = validateParameter(valid_581073, JString, required = false,
                                 default = nil)
  if valid_581073 != nil:
    section.add "oauth_token", valid_581073
  var valid_581074 = query.getOrDefault("userIp")
  valid_581074 = validateParameter(valid_581074, JString, required = false,
                                 default = nil)
  if valid_581074 != nil:
    section.add "userIp", valid_581074
  var valid_581075 = query.getOrDefault("key")
  valid_581075 = validateParameter(valid_581075, JString, required = false,
                                 default = nil)
  if valid_581075 != nil:
    section.add "key", valid_581075
  var valid_581076 = query.getOrDefault("prettyPrint")
  valid_581076 = validateParameter(valid_581076, JBool, required = false,
                                 default = newJBool(false))
  if valid_581076 != nil:
    section.add "prettyPrint", valid_581076
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

proc call*(call_581078: Call_AnalyticsManagementExperimentsPatch_581063;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing experiment. This method supports patch semantics.
  ## 
  let valid = call_581078.validator(path, query, header, formData, body)
  let scheme = call_581078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581078.url(scheme.get, call_581078.host, call_581078.base,
                         call_581078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581078, url, valid)

proc call*(call_581079: Call_AnalyticsManagementExperimentsPatch_581063;
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
  var path_581080 = newJObject()
  var query_581081 = newJObject()
  var body_581082 = newJObject()
  add(path_581080, "profileId", newJString(profileId))
  add(query_581081, "fields", newJString(fields))
  add(query_581081, "quotaUser", newJString(quotaUser))
  add(query_581081, "alt", newJString(alt))
  add(query_581081, "oauth_token", newJString(oauthToken))
  add(path_581080, "accountId", newJString(accountId))
  add(query_581081, "userIp", newJString(userIp))
  add(path_581080, "experimentId", newJString(experimentId))
  add(path_581080, "webPropertyId", newJString(webPropertyId))
  add(query_581081, "key", newJString(key))
  if body != nil:
    body_581082 = body
  add(query_581081, "prettyPrint", newJBool(prettyPrint))
  result = call_581079.call(path_581080, query_581081, nil, nil, body_581082)

var analyticsManagementExperimentsPatch* = Call_AnalyticsManagementExperimentsPatch_581063(
    name: "analyticsManagementExperimentsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsPatch_581064,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsPatch_581065,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementExperimentsDelete_581045 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementExperimentsDelete_581047(protocol: Scheme;
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

proc validate_AnalyticsManagementExperimentsDelete_581046(path: JsonNode;
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
  var valid_581048 = path.getOrDefault("profileId")
  valid_581048 = validateParameter(valid_581048, JString, required = true,
                                 default = nil)
  if valid_581048 != nil:
    section.add "profileId", valid_581048
  var valid_581049 = path.getOrDefault("accountId")
  valid_581049 = validateParameter(valid_581049, JString, required = true,
                                 default = nil)
  if valid_581049 != nil:
    section.add "accountId", valid_581049
  var valid_581050 = path.getOrDefault("experimentId")
  valid_581050 = validateParameter(valid_581050, JString, required = true,
                                 default = nil)
  if valid_581050 != nil:
    section.add "experimentId", valid_581050
  var valid_581051 = path.getOrDefault("webPropertyId")
  valid_581051 = validateParameter(valid_581051, JString, required = true,
                                 default = nil)
  if valid_581051 != nil:
    section.add "webPropertyId", valid_581051
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
  var valid_581052 = query.getOrDefault("fields")
  valid_581052 = validateParameter(valid_581052, JString, required = false,
                                 default = nil)
  if valid_581052 != nil:
    section.add "fields", valid_581052
  var valid_581053 = query.getOrDefault("quotaUser")
  valid_581053 = validateParameter(valid_581053, JString, required = false,
                                 default = nil)
  if valid_581053 != nil:
    section.add "quotaUser", valid_581053
  var valid_581054 = query.getOrDefault("alt")
  valid_581054 = validateParameter(valid_581054, JString, required = false,
                                 default = newJString("json"))
  if valid_581054 != nil:
    section.add "alt", valid_581054
  var valid_581055 = query.getOrDefault("oauth_token")
  valid_581055 = validateParameter(valid_581055, JString, required = false,
                                 default = nil)
  if valid_581055 != nil:
    section.add "oauth_token", valid_581055
  var valid_581056 = query.getOrDefault("userIp")
  valid_581056 = validateParameter(valid_581056, JString, required = false,
                                 default = nil)
  if valid_581056 != nil:
    section.add "userIp", valid_581056
  var valid_581057 = query.getOrDefault("key")
  valid_581057 = validateParameter(valid_581057, JString, required = false,
                                 default = nil)
  if valid_581057 != nil:
    section.add "key", valid_581057
  var valid_581058 = query.getOrDefault("prettyPrint")
  valid_581058 = validateParameter(valid_581058, JBool, required = false,
                                 default = newJBool(false))
  if valid_581058 != nil:
    section.add "prettyPrint", valid_581058
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581059: Call_AnalyticsManagementExperimentsDelete_581045;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete an experiment.
  ## 
  let valid = call_581059.validator(path, query, header, formData, body)
  let scheme = call_581059.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581059.url(scheme.get, call_581059.host, call_581059.base,
                         call_581059.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581059, url, valid)

proc call*(call_581060: Call_AnalyticsManagementExperimentsDelete_581045;
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
  var path_581061 = newJObject()
  var query_581062 = newJObject()
  add(path_581061, "profileId", newJString(profileId))
  add(query_581062, "fields", newJString(fields))
  add(query_581062, "quotaUser", newJString(quotaUser))
  add(query_581062, "alt", newJString(alt))
  add(query_581062, "oauth_token", newJString(oauthToken))
  add(path_581061, "accountId", newJString(accountId))
  add(query_581062, "userIp", newJString(userIp))
  add(path_581061, "experimentId", newJString(experimentId))
  add(path_581061, "webPropertyId", newJString(webPropertyId))
  add(query_581062, "key", newJString(key))
  add(query_581062, "prettyPrint", newJBool(prettyPrint))
  result = call_581060.call(path_581061, query_581062, nil, nil, nil)

var analyticsManagementExperimentsDelete* = Call_AnalyticsManagementExperimentsDelete_581045(
    name: "analyticsManagementExperimentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/experiments/{experimentId}",
    validator: validate_AnalyticsManagementExperimentsDelete_581046,
    base: "/analytics/v3", url: url_AnalyticsManagementExperimentsDelete_581047,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsInsert_581102 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementGoalsInsert_581104(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementGoalsInsert_581103(path: JsonNode;
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
  var valid_581105 = path.getOrDefault("profileId")
  valid_581105 = validateParameter(valid_581105, JString, required = true,
                                 default = nil)
  if valid_581105 != nil:
    section.add "profileId", valid_581105
  var valid_581106 = path.getOrDefault("accountId")
  valid_581106 = validateParameter(valid_581106, JString, required = true,
                                 default = nil)
  if valid_581106 != nil:
    section.add "accountId", valid_581106
  var valid_581107 = path.getOrDefault("webPropertyId")
  valid_581107 = validateParameter(valid_581107, JString, required = true,
                                 default = nil)
  if valid_581107 != nil:
    section.add "webPropertyId", valid_581107
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
  var valid_581108 = query.getOrDefault("fields")
  valid_581108 = validateParameter(valid_581108, JString, required = false,
                                 default = nil)
  if valid_581108 != nil:
    section.add "fields", valid_581108
  var valid_581109 = query.getOrDefault("quotaUser")
  valid_581109 = validateParameter(valid_581109, JString, required = false,
                                 default = nil)
  if valid_581109 != nil:
    section.add "quotaUser", valid_581109
  var valid_581110 = query.getOrDefault("alt")
  valid_581110 = validateParameter(valid_581110, JString, required = false,
                                 default = newJString("json"))
  if valid_581110 != nil:
    section.add "alt", valid_581110
  var valid_581111 = query.getOrDefault("oauth_token")
  valid_581111 = validateParameter(valid_581111, JString, required = false,
                                 default = nil)
  if valid_581111 != nil:
    section.add "oauth_token", valid_581111
  var valid_581112 = query.getOrDefault("userIp")
  valid_581112 = validateParameter(valid_581112, JString, required = false,
                                 default = nil)
  if valid_581112 != nil:
    section.add "userIp", valid_581112
  var valid_581113 = query.getOrDefault("key")
  valid_581113 = validateParameter(valid_581113, JString, required = false,
                                 default = nil)
  if valid_581113 != nil:
    section.add "key", valid_581113
  var valid_581114 = query.getOrDefault("prettyPrint")
  valid_581114 = validateParameter(valid_581114, JBool, required = false,
                                 default = newJBool(false))
  if valid_581114 != nil:
    section.add "prettyPrint", valid_581114
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

proc call*(call_581116: Call_AnalyticsManagementGoalsInsert_581102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create a new goal.
  ## 
  let valid = call_581116.validator(path, query, header, formData, body)
  let scheme = call_581116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581116.url(scheme.get, call_581116.host, call_581116.base,
                         call_581116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581116, url, valid)

proc call*(call_581117: Call_AnalyticsManagementGoalsInsert_581102;
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
  var path_581118 = newJObject()
  var query_581119 = newJObject()
  var body_581120 = newJObject()
  add(path_581118, "profileId", newJString(profileId))
  add(query_581119, "fields", newJString(fields))
  add(query_581119, "quotaUser", newJString(quotaUser))
  add(query_581119, "alt", newJString(alt))
  add(query_581119, "oauth_token", newJString(oauthToken))
  add(path_581118, "accountId", newJString(accountId))
  add(query_581119, "userIp", newJString(userIp))
  add(path_581118, "webPropertyId", newJString(webPropertyId))
  add(query_581119, "key", newJString(key))
  if body != nil:
    body_581120 = body
  add(query_581119, "prettyPrint", newJBool(prettyPrint))
  result = call_581117.call(path_581118, query_581119, nil, nil, body_581120)

var analyticsManagementGoalsInsert* = Call_AnalyticsManagementGoalsInsert_581102(
    name: "analyticsManagementGoalsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals",
    validator: validate_AnalyticsManagementGoalsInsert_581103,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsInsert_581104,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsList_581083 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementGoalsList_581085(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementGoalsList_581084(path: JsonNode; query: JsonNode;
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
  var valid_581086 = path.getOrDefault("profileId")
  valid_581086 = validateParameter(valid_581086, JString, required = true,
                                 default = nil)
  if valid_581086 != nil:
    section.add "profileId", valid_581086
  var valid_581087 = path.getOrDefault("accountId")
  valid_581087 = validateParameter(valid_581087, JString, required = true,
                                 default = nil)
  if valid_581087 != nil:
    section.add "accountId", valid_581087
  var valid_581088 = path.getOrDefault("webPropertyId")
  valid_581088 = validateParameter(valid_581088, JString, required = true,
                                 default = nil)
  if valid_581088 != nil:
    section.add "webPropertyId", valid_581088
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
  var valid_581089 = query.getOrDefault("fields")
  valid_581089 = validateParameter(valid_581089, JString, required = false,
                                 default = nil)
  if valid_581089 != nil:
    section.add "fields", valid_581089
  var valid_581090 = query.getOrDefault("quotaUser")
  valid_581090 = validateParameter(valid_581090, JString, required = false,
                                 default = nil)
  if valid_581090 != nil:
    section.add "quotaUser", valid_581090
  var valid_581091 = query.getOrDefault("alt")
  valid_581091 = validateParameter(valid_581091, JString, required = false,
                                 default = newJString("json"))
  if valid_581091 != nil:
    section.add "alt", valid_581091
  var valid_581092 = query.getOrDefault("oauth_token")
  valid_581092 = validateParameter(valid_581092, JString, required = false,
                                 default = nil)
  if valid_581092 != nil:
    section.add "oauth_token", valid_581092
  var valid_581093 = query.getOrDefault("userIp")
  valid_581093 = validateParameter(valid_581093, JString, required = false,
                                 default = nil)
  if valid_581093 != nil:
    section.add "userIp", valid_581093
  var valid_581094 = query.getOrDefault("key")
  valid_581094 = validateParameter(valid_581094, JString, required = false,
                                 default = nil)
  if valid_581094 != nil:
    section.add "key", valid_581094
  var valid_581095 = query.getOrDefault("max-results")
  valid_581095 = validateParameter(valid_581095, JInt, required = false, default = nil)
  if valid_581095 != nil:
    section.add "max-results", valid_581095
  var valid_581096 = query.getOrDefault("start-index")
  valid_581096 = validateParameter(valid_581096, JInt, required = false, default = nil)
  if valid_581096 != nil:
    section.add "start-index", valid_581096
  var valid_581097 = query.getOrDefault("prettyPrint")
  valid_581097 = validateParameter(valid_581097, JBool, required = false,
                                 default = newJBool(false))
  if valid_581097 != nil:
    section.add "prettyPrint", valid_581097
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581098: Call_AnalyticsManagementGoalsList_581083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists goals to which the user has access.
  ## 
  let valid = call_581098.validator(path, query, header, formData, body)
  let scheme = call_581098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581098.url(scheme.get, call_581098.host, call_581098.base,
                         call_581098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581098, url, valid)

proc call*(call_581099: Call_AnalyticsManagementGoalsList_581083;
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
  var path_581100 = newJObject()
  var query_581101 = newJObject()
  add(path_581100, "profileId", newJString(profileId))
  add(query_581101, "fields", newJString(fields))
  add(query_581101, "quotaUser", newJString(quotaUser))
  add(query_581101, "alt", newJString(alt))
  add(query_581101, "oauth_token", newJString(oauthToken))
  add(path_581100, "accountId", newJString(accountId))
  add(query_581101, "userIp", newJString(userIp))
  add(path_581100, "webPropertyId", newJString(webPropertyId))
  add(query_581101, "key", newJString(key))
  add(query_581101, "max-results", newJInt(maxResults))
  add(query_581101, "start-index", newJInt(startIndex))
  add(query_581101, "prettyPrint", newJBool(prettyPrint))
  result = call_581099.call(path_581100, query_581101, nil, nil, nil)

var analyticsManagementGoalsList* = Call_AnalyticsManagementGoalsList_581083(
    name: "analyticsManagementGoalsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals",
    validator: validate_AnalyticsManagementGoalsList_581084,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsList_581085,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsUpdate_581139 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementGoalsUpdate_581141(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementGoalsUpdate_581140(path: JsonNode;
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
  var valid_581142 = path.getOrDefault("profileId")
  valid_581142 = validateParameter(valid_581142, JString, required = true,
                                 default = nil)
  if valid_581142 != nil:
    section.add "profileId", valid_581142
  var valid_581143 = path.getOrDefault("accountId")
  valid_581143 = validateParameter(valid_581143, JString, required = true,
                                 default = nil)
  if valid_581143 != nil:
    section.add "accountId", valid_581143
  var valid_581144 = path.getOrDefault("webPropertyId")
  valid_581144 = validateParameter(valid_581144, JString, required = true,
                                 default = nil)
  if valid_581144 != nil:
    section.add "webPropertyId", valid_581144
  var valid_581145 = path.getOrDefault("goalId")
  valid_581145 = validateParameter(valid_581145, JString, required = true,
                                 default = nil)
  if valid_581145 != nil:
    section.add "goalId", valid_581145
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
  var valid_581146 = query.getOrDefault("fields")
  valid_581146 = validateParameter(valid_581146, JString, required = false,
                                 default = nil)
  if valid_581146 != nil:
    section.add "fields", valid_581146
  var valid_581147 = query.getOrDefault("quotaUser")
  valid_581147 = validateParameter(valid_581147, JString, required = false,
                                 default = nil)
  if valid_581147 != nil:
    section.add "quotaUser", valid_581147
  var valid_581148 = query.getOrDefault("alt")
  valid_581148 = validateParameter(valid_581148, JString, required = false,
                                 default = newJString("json"))
  if valid_581148 != nil:
    section.add "alt", valid_581148
  var valid_581149 = query.getOrDefault("oauth_token")
  valid_581149 = validateParameter(valid_581149, JString, required = false,
                                 default = nil)
  if valid_581149 != nil:
    section.add "oauth_token", valid_581149
  var valid_581150 = query.getOrDefault("userIp")
  valid_581150 = validateParameter(valid_581150, JString, required = false,
                                 default = nil)
  if valid_581150 != nil:
    section.add "userIp", valid_581150
  var valid_581151 = query.getOrDefault("key")
  valid_581151 = validateParameter(valid_581151, JString, required = false,
                                 default = nil)
  if valid_581151 != nil:
    section.add "key", valid_581151
  var valid_581152 = query.getOrDefault("prettyPrint")
  valid_581152 = validateParameter(valid_581152, JBool, required = false,
                                 default = newJBool(false))
  if valid_581152 != nil:
    section.add "prettyPrint", valid_581152
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

proc call*(call_581154: Call_AnalyticsManagementGoalsUpdate_581139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing goal.
  ## 
  let valid = call_581154.validator(path, query, header, formData, body)
  let scheme = call_581154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581154.url(scheme.get, call_581154.host, call_581154.base,
                         call_581154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581154, url, valid)

proc call*(call_581155: Call_AnalyticsManagementGoalsUpdate_581139;
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
  var path_581156 = newJObject()
  var query_581157 = newJObject()
  var body_581158 = newJObject()
  add(path_581156, "profileId", newJString(profileId))
  add(query_581157, "fields", newJString(fields))
  add(query_581157, "quotaUser", newJString(quotaUser))
  add(query_581157, "alt", newJString(alt))
  add(query_581157, "oauth_token", newJString(oauthToken))
  add(path_581156, "accountId", newJString(accountId))
  add(query_581157, "userIp", newJString(userIp))
  add(path_581156, "webPropertyId", newJString(webPropertyId))
  add(query_581157, "key", newJString(key))
  if body != nil:
    body_581158 = body
  add(query_581157, "prettyPrint", newJBool(prettyPrint))
  add(path_581156, "goalId", newJString(goalId))
  result = call_581155.call(path_581156, query_581157, nil, nil, body_581158)

var analyticsManagementGoalsUpdate* = Call_AnalyticsManagementGoalsUpdate_581139(
    name: "analyticsManagementGoalsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals/{goalId}",
    validator: validate_AnalyticsManagementGoalsUpdate_581140,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsUpdate_581141,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsGet_581121 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementGoalsGet_581123(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementGoalsGet_581122(path: JsonNode; query: JsonNode;
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
  var valid_581124 = path.getOrDefault("profileId")
  valid_581124 = validateParameter(valid_581124, JString, required = true,
                                 default = nil)
  if valid_581124 != nil:
    section.add "profileId", valid_581124
  var valid_581125 = path.getOrDefault("accountId")
  valid_581125 = validateParameter(valid_581125, JString, required = true,
                                 default = nil)
  if valid_581125 != nil:
    section.add "accountId", valid_581125
  var valid_581126 = path.getOrDefault("webPropertyId")
  valid_581126 = validateParameter(valid_581126, JString, required = true,
                                 default = nil)
  if valid_581126 != nil:
    section.add "webPropertyId", valid_581126
  var valid_581127 = path.getOrDefault("goalId")
  valid_581127 = validateParameter(valid_581127, JString, required = true,
                                 default = nil)
  if valid_581127 != nil:
    section.add "goalId", valid_581127
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
  var valid_581128 = query.getOrDefault("fields")
  valid_581128 = validateParameter(valid_581128, JString, required = false,
                                 default = nil)
  if valid_581128 != nil:
    section.add "fields", valid_581128
  var valid_581129 = query.getOrDefault("quotaUser")
  valid_581129 = validateParameter(valid_581129, JString, required = false,
                                 default = nil)
  if valid_581129 != nil:
    section.add "quotaUser", valid_581129
  var valid_581130 = query.getOrDefault("alt")
  valid_581130 = validateParameter(valid_581130, JString, required = false,
                                 default = newJString("json"))
  if valid_581130 != nil:
    section.add "alt", valid_581130
  var valid_581131 = query.getOrDefault("oauth_token")
  valid_581131 = validateParameter(valid_581131, JString, required = false,
                                 default = nil)
  if valid_581131 != nil:
    section.add "oauth_token", valid_581131
  var valid_581132 = query.getOrDefault("userIp")
  valid_581132 = validateParameter(valid_581132, JString, required = false,
                                 default = nil)
  if valid_581132 != nil:
    section.add "userIp", valid_581132
  var valid_581133 = query.getOrDefault("key")
  valid_581133 = validateParameter(valid_581133, JString, required = false,
                                 default = nil)
  if valid_581133 != nil:
    section.add "key", valid_581133
  var valid_581134 = query.getOrDefault("prettyPrint")
  valid_581134 = validateParameter(valid_581134, JBool, required = false,
                                 default = newJBool(false))
  if valid_581134 != nil:
    section.add "prettyPrint", valid_581134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581135: Call_AnalyticsManagementGoalsGet_581121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a goal to which the user has access.
  ## 
  let valid = call_581135.validator(path, query, header, formData, body)
  let scheme = call_581135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581135.url(scheme.get, call_581135.host, call_581135.base,
                         call_581135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581135, url, valid)

proc call*(call_581136: Call_AnalyticsManagementGoalsGet_581121; profileId: string;
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
  var path_581137 = newJObject()
  var query_581138 = newJObject()
  add(path_581137, "profileId", newJString(profileId))
  add(query_581138, "fields", newJString(fields))
  add(query_581138, "quotaUser", newJString(quotaUser))
  add(query_581138, "alt", newJString(alt))
  add(query_581138, "oauth_token", newJString(oauthToken))
  add(path_581137, "accountId", newJString(accountId))
  add(query_581138, "userIp", newJString(userIp))
  add(path_581137, "webPropertyId", newJString(webPropertyId))
  add(query_581138, "key", newJString(key))
  add(query_581138, "prettyPrint", newJBool(prettyPrint))
  add(path_581137, "goalId", newJString(goalId))
  result = call_581136.call(path_581137, query_581138, nil, nil, nil)

var analyticsManagementGoalsGet* = Call_AnalyticsManagementGoalsGet_581121(
    name: "analyticsManagementGoalsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals/{goalId}",
    validator: validate_AnalyticsManagementGoalsGet_581122, base: "/analytics/v3",
    url: url_AnalyticsManagementGoalsGet_581123, schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsPatch_581159 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementGoalsPatch_581161(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementGoalsPatch_581160(path: JsonNode; query: JsonNode;
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
  var valid_581162 = path.getOrDefault("profileId")
  valid_581162 = validateParameter(valid_581162, JString, required = true,
                                 default = nil)
  if valid_581162 != nil:
    section.add "profileId", valid_581162
  var valid_581163 = path.getOrDefault("accountId")
  valid_581163 = validateParameter(valid_581163, JString, required = true,
                                 default = nil)
  if valid_581163 != nil:
    section.add "accountId", valid_581163
  var valid_581164 = path.getOrDefault("webPropertyId")
  valid_581164 = validateParameter(valid_581164, JString, required = true,
                                 default = nil)
  if valid_581164 != nil:
    section.add "webPropertyId", valid_581164
  var valid_581165 = path.getOrDefault("goalId")
  valid_581165 = validateParameter(valid_581165, JString, required = true,
                                 default = nil)
  if valid_581165 != nil:
    section.add "goalId", valid_581165
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
  var valid_581166 = query.getOrDefault("fields")
  valid_581166 = validateParameter(valid_581166, JString, required = false,
                                 default = nil)
  if valid_581166 != nil:
    section.add "fields", valid_581166
  var valid_581167 = query.getOrDefault("quotaUser")
  valid_581167 = validateParameter(valid_581167, JString, required = false,
                                 default = nil)
  if valid_581167 != nil:
    section.add "quotaUser", valid_581167
  var valid_581168 = query.getOrDefault("alt")
  valid_581168 = validateParameter(valid_581168, JString, required = false,
                                 default = newJString("json"))
  if valid_581168 != nil:
    section.add "alt", valid_581168
  var valid_581169 = query.getOrDefault("oauth_token")
  valid_581169 = validateParameter(valid_581169, JString, required = false,
                                 default = nil)
  if valid_581169 != nil:
    section.add "oauth_token", valid_581169
  var valid_581170 = query.getOrDefault("userIp")
  valid_581170 = validateParameter(valid_581170, JString, required = false,
                                 default = nil)
  if valid_581170 != nil:
    section.add "userIp", valid_581170
  var valid_581171 = query.getOrDefault("key")
  valid_581171 = validateParameter(valid_581171, JString, required = false,
                                 default = nil)
  if valid_581171 != nil:
    section.add "key", valid_581171
  var valid_581172 = query.getOrDefault("prettyPrint")
  valid_581172 = validateParameter(valid_581172, JBool, required = false,
                                 default = newJBool(false))
  if valid_581172 != nil:
    section.add "prettyPrint", valid_581172
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

proc call*(call_581174: Call_AnalyticsManagementGoalsPatch_581159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing goal. This method supports patch semantics.
  ## 
  let valid = call_581174.validator(path, query, header, formData, body)
  let scheme = call_581174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581174.url(scheme.get, call_581174.host, call_581174.base,
                         call_581174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581174, url, valid)

proc call*(call_581175: Call_AnalyticsManagementGoalsPatch_581159;
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
  var path_581176 = newJObject()
  var query_581177 = newJObject()
  var body_581178 = newJObject()
  add(path_581176, "profileId", newJString(profileId))
  add(query_581177, "fields", newJString(fields))
  add(query_581177, "quotaUser", newJString(quotaUser))
  add(query_581177, "alt", newJString(alt))
  add(query_581177, "oauth_token", newJString(oauthToken))
  add(path_581176, "accountId", newJString(accountId))
  add(query_581177, "userIp", newJString(userIp))
  add(path_581176, "webPropertyId", newJString(webPropertyId))
  add(query_581177, "key", newJString(key))
  if body != nil:
    body_581178 = body
  add(query_581177, "prettyPrint", newJBool(prettyPrint))
  add(path_581176, "goalId", newJString(goalId))
  result = call_581175.call(path_581176, query_581177, nil, nil, body_581178)

var analyticsManagementGoalsPatch* = Call_AnalyticsManagementGoalsPatch_581159(
    name: "analyticsManagementGoalsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals/{goalId}",
    validator: validate_AnalyticsManagementGoalsPatch_581160,
    base: "/analytics/v3", url: url_AnalyticsManagementGoalsPatch_581161,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksInsert_581198 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfileFilterLinksInsert_581200(protocol: Scheme;
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

proc validate_AnalyticsManagementProfileFilterLinksInsert_581199(path: JsonNode;
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
  var valid_581201 = path.getOrDefault("profileId")
  valid_581201 = validateParameter(valid_581201, JString, required = true,
                                 default = nil)
  if valid_581201 != nil:
    section.add "profileId", valid_581201
  var valid_581202 = path.getOrDefault("accountId")
  valid_581202 = validateParameter(valid_581202, JString, required = true,
                                 default = nil)
  if valid_581202 != nil:
    section.add "accountId", valid_581202
  var valid_581203 = path.getOrDefault("webPropertyId")
  valid_581203 = validateParameter(valid_581203, JString, required = true,
                                 default = nil)
  if valid_581203 != nil:
    section.add "webPropertyId", valid_581203
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
  var valid_581204 = query.getOrDefault("fields")
  valid_581204 = validateParameter(valid_581204, JString, required = false,
                                 default = nil)
  if valid_581204 != nil:
    section.add "fields", valid_581204
  var valid_581205 = query.getOrDefault("quotaUser")
  valid_581205 = validateParameter(valid_581205, JString, required = false,
                                 default = nil)
  if valid_581205 != nil:
    section.add "quotaUser", valid_581205
  var valid_581206 = query.getOrDefault("alt")
  valid_581206 = validateParameter(valid_581206, JString, required = false,
                                 default = newJString("json"))
  if valid_581206 != nil:
    section.add "alt", valid_581206
  var valid_581207 = query.getOrDefault("oauth_token")
  valid_581207 = validateParameter(valid_581207, JString, required = false,
                                 default = nil)
  if valid_581207 != nil:
    section.add "oauth_token", valid_581207
  var valid_581208 = query.getOrDefault("userIp")
  valid_581208 = validateParameter(valid_581208, JString, required = false,
                                 default = nil)
  if valid_581208 != nil:
    section.add "userIp", valid_581208
  var valid_581209 = query.getOrDefault("key")
  valid_581209 = validateParameter(valid_581209, JString, required = false,
                                 default = nil)
  if valid_581209 != nil:
    section.add "key", valid_581209
  var valid_581210 = query.getOrDefault("prettyPrint")
  valid_581210 = validateParameter(valid_581210, JBool, required = false,
                                 default = newJBool(false))
  if valid_581210 != nil:
    section.add "prettyPrint", valid_581210
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

proc call*(call_581212: Call_AnalyticsManagementProfileFilterLinksInsert_581198;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new profile filter link.
  ## 
  let valid = call_581212.validator(path, query, header, formData, body)
  let scheme = call_581212.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581212.url(scheme.get, call_581212.host, call_581212.base,
                         call_581212.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581212, url, valid)

proc call*(call_581213: Call_AnalyticsManagementProfileFilterLinksInsert_581198;
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
  var path_581214 = newJObject()
  var query_581215 = newJObject()
  var body_581216 = newJObject()
  add(path_581214, "profileId", newJString(profileId))
  add(query_581215, "fields", newJString(fields))
  add(query_581215, "quotaUser", newJString(quotaUser))
  add(query_581215, "alt", newJString(alt))
  add(query_581215, "oauth_token", newJString(oauthToken))
  add(path_581214, "accountId", newJString(accountId))
  add(query_581215, "userIp", newJString(userIp))
  add(path_581214, "webPropertyId", newJString(webPropertyId))
  add(query_581215, "key", newJString(key))
  if body != nil:
    body_581216 = body
  add(query_581215, "prettyPrint", newJBool(prettyPrint))
  result = call_581213.call(path_581214, query_581215, nil, nil, body_581216)

var analyticsManagementProfileFilterLinksInsert* = Call_AnalyticsManagementProfileFilterLinksInsert_581198(
    name: "analyticsManagementProfileFilterLinksInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks",
    validator: validate_AnalyticsManagementProfileFilterLinksInsert_581199,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksInsert_581200,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksList_581179 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfileFilterLinksList_581181(protocol: Scheme;
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

proc validate_AnalyticsManagementProfileFilterLinksList_581180(path: JsonNode;
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
  var valid_581182 = path.getOrDefault("profileId")
  valid_581182 = validateParameter(valid_581182, JString, required = true,
                                 default = nil)
  if valid_581182 != nil:
    section.add "profileId", valid_581182
  var valid_581183 = path.getOrDefault("accountId")
  valid_581183 = validateParameter(valid_581183, JString, required = true,
                                 default = nil)
  if valid_581183 != nil:
    section.add "accountId", valid_581183
  var valid_581184 = path.getOrDefault("webPropertyId")
  valid_581184 = validateParameter(valid_581184, JString, required = true,
                                 default = nil)
  if valid_581184 != nil:
    section.add "webPropertyId", valid_581184
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
  var valid_581185 = query.getOrDefault("fields")
  valid_581185 = validateParameter(valid_581185, JString, required = false,
                                 default = nil)
  if valid_581185 != nil:
    section.add "fields", valid_581185
  var valid_581186 = query.getOrDefault("quotaUser")
  valid_581186 = validateParameter(valid_581186, JString, required = false,
                                 default = nil)
  if valid_581186 != nil:
    section.add "quotaUser", valid_581186
  var valid_581187 = query.getOrDefault("alt")
  valid_581187 = validateParameter(valid_581187, JString, required = false,
                                 default = newJString("json"))
  if valid_581187 != nil:
    section.add "alt", valid_581187
  var valid_581188 = query.getOrDefault("oauth_token")
  valid_581188 = validateParameter(valid_581188, JString, required = false,
                                 default = nil)
  if valid_581188 != nil:
    section.add "oauth_token", valid_581188
  var valid_581189 = query.getOrDefault("userIp")
  valid_581189 = validateParameter(valid_581189, JString, required = false,
                                 default = nil)
  if valid_581189 != nil:
    section.add "userIp", valid_581189
  var valid_581190 = query.getOrDefault("key")
  valid_581190 = validateParameter(valid_581190, JString, required = false,
                                 default = nil)
  if valid_581190 != nil:
    section.add "key", valid_581190
  var valid_581191 = query.getOrDefault("max-results")
  valid_581191 = validateParameter(valid_581191, JInt, required = false, default = nil)
  if valid_581191 != nil:
    section.add "max-results", valid_581191
  var valid_581192 = query.getOrDefault("start-index")
  valid_581192 = validateParameter(valid_581192, JInt, required = false, default = nil)
  if valid_581192 != nil:
    section.add "start-index", valid_581192
  var valid_581193 = query.getOrDefault("prettyPrint")
  valid_581193 = validateParameter(valid_581193, JBool, required = false,
                                 default = newJBool(false))
  if valid_581193 != nil:
    section.add "prettyPrint", valid_581193
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581194: Call_AnalyticsManagementProfileFilterLinksList_581179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all profile filter links for a profile.
  ## 
  let valid = call_581194.validator(path, query, header, formData, body)
  let scheme = call_581194.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581194.url(scheme.get, call_581194.host, call_581194.base,
                         call_581194.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581194, url, valid)

proc call*(call_581195: Call_AnalyticsManagementProfileFilterLinksList_581179;
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
  var path_581196 = newJObject()
  var query_581197 = newJObject()
  add(path_581196, "profileId", newJString(profileId))
  add(query_581197, "fields", newJString(fields))
  add(query_581197, "quotaUser", newJString(quotaUser))
  add(query_581197, "alt", newJString(alt))
  add(query_581197, "oauth_token", newJString(oauthToken))
  add(path_581196, "accountId", newJString(accountId))
  add(query_581197, "userIp", newJString(userIp))
  add(path_581196, "webPropertyId", newJString(webPropertyId))
  add(query_581197, "key", newJString(key))
  add(query_581197, "max-results", newJInt(maxResults))
  add(query_581197, "start-index", newJInt(startIndex))
  add(query_581197, "prettyPrint", newJBool(prettyPrint))
  result = call_581195.call(path_581196, query_581197, nil, nil, nil)

var analyticsManagementProfileFilterLinksList* = Call_AnalyticsManagementProfileFilterLinksList_581179(
    name: "analyticsManagementProfileFilterLinksList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks",
    validator: validate_AnalyticsManagementProfileFilterLinksList_581180,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksList_581181,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksUpdate_581235 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfileFilterLinksUpdate_581237(protocol: Scheme;
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

proc validate_AnalyticsManagementProfileFilterLinksUpdate_581236(path: JsonNode;
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
  var valid_581238 = path.getOrDefault("profileId")
  valid_581238 = validateParameter(valid_581238, JString, required = true,
                                 default = nil)
  if valid_581238 != nil:
    section.add "profileId", valid_581238
  var valid_581239 = path.getOrDefault("accountId")
  valid_581239 = validateParameter(valid_581239, JString, required = true,
                                 default = nil)
  if valid_581239 != nil:
    section.add "accountId", valid_581239
  var valid_581240 = path.getOrDefault("webPropertyId")
  valid_581240 = validateParameter(valid_581240, JString, required = true,
                                 default = nil)
  if valid_581240 != nil:
    section.add "webPropertyId", valid_581240
  var valid_581241 = path.getOrDefault("linkId")
  valid_581241 = validateParameter(valid_581241, JString, required = true,
                                 default = nil)
  if valid_581241 != nil:
    section.add "linkId", valid_581241
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
  var valid_581242 = query.getOrDefault("fields")
  valid_581242 = validateParameter(valid_581242, JString, required = false,
                                 default = nil)
  if valid_581242 != nil:
    section.add "fields", valid_581242
  var valid_581243 = query.getOrDefault("quotaUser")
  valid_581243 = validateParameter(valid_581243, JString, required = false,
                                 default = nil)
  if valid_581243 != nil:
    section.add "quotaUser", valid_581243
  var valid_581244 = query.getOrDefault("alt")
  valid_581244 = validateParameter(valid_581244, JString, required = false,
                                 default = newJString("json"))
  if valid_581244 != nil:
    section.add "alt", valid_581244
  var valid_581245 = query.getOrDefault("oauth_token")
  valid_581245 = validateParameter(valid_581245, JString, required = false,
                                 default = nil)
  if valid_581245 != nil:
    section.add "oauth_token", valid_581245
  var valid_581246 = query.getOrDefault("userIp")
  valid_581246 = validateParameter(valid_581246, JString, required = false,
                                 default = nil)
  if valid_581246 != nil:
    section.add "userIp", valid_581246
  var valid_581247 = query.getOrDefault("key")
  valid_581247 = validateParameter(valid_581247, JString, required = false,
                                 default = nil)
  if valid_581247 != nil:
    section.add "key", valid_581247
  var valid_581248 = query.getOrDefault("prettyPrint")
  valid_581248 = validateParameter(valid_581248, JBool, required = false,
                                 default = newJBool(false))
  if valid_581248 != nil:
    section.add "prettyPrint", valid_581248
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

proc call*(call_581250: Call_AnalyticsManagementProfileFilterLinksUpdate_581235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing profile filter link.
  ## 
  let valid = call_581250.validator(path, query, header, formData, body)
  let scheme = call_581250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581250.url(scheme.get, call_581250.host, call_581250.base,
                         call_581250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581250, url, valid)

proc call*(call_581251: Call_AnalyticsManagementProfileFilterLinksUpdate_581235;
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
  var path_581252 = newJObject()
  var query_581253 = newJObject()
  var body_581254 = newJObject()
  add(path_581252, "profileId", newJString(profileId))
  add(query_581253, "fields", newJString(fields))
  add(query_581253, "quotaUser", newJString(quotaUser))
  add(query_581253, "alt", newJString(alt))
  add(query_581253, "oauth_token", newJString(oauthToken))
  add(path_581252, "accountId", newJString(accountId))
  add(query_581253, "userIp", newJString(userIp))
  add(path_581252, "webPropertyId", newJString(webPropertyId))
  add(query_581253, "key", newJString(key))
  add(path_581252, "linkId", newJString(linkId))
  if body != nil:
    body_581254 = body
  add(query_581253, "prettyPrint", newJBool(prettyPrint))
  result = call_581251.call(path_581252, query_581253, nil, nil, body_581254)

var analyticsManagementProfileFilterLinksUpdate* = Call_AnalyticsManagementProfileFilterLinksUpdate_581235(
    name: "analyticsManagementProfileFilterLinksUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksUpdate_581236,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksUpdate_581237,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksGet_581217 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfileFilterLinksGet_581219(protocol: Scheme;
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

proc validate_AnalyticsManagementProfileFilterLinksGet_581218(path: JsonNode;
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
  var valid_581220 = path.getOrDefault("profileId")
  valid_581220 = validateParameter(valid_581220, JString, required = true,
                                 default = nil)
  if valid_581220 != nil:
    section.add "profileId", valid_581220
  var valid_581221 = path.getOrDefault("accountId")
  valid_581221 = validateParameter(valid_581221, JString, required = true,
                                 default = nil)
  if valid_581221 != nil:
    section.add "accountId", valid_581221
  var valid_581222 = path.getOrDefault("webPropertyId")
  valid_581222 = validateParameter(valid_581222, JString, required = true,
                                 default = nil)
  if valid_581222 != nil:
    section.add "webPropertyId", valid_581222
  var valid_581223 = path.getOrDefault("linkId")
  valid_581223 = validateParameter(valid_581223, JString, required = true,
                                 default = nil)
  if valid_581223 != nil:
    section.add "linkId", valid_581223
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
  var valid_581224 = query.getOrDefault("fields")
  valid_581224 = validateParameter(valid_581224, JString, required = false,
                                 default = nil)
  if valid_581224 != nil:
    section.add "fields", valid_581224
  var valid_581225 = query.getOrDefault("quotaUser")
  valid_581225 = validateParameter(valid_581225, JString, required = false,
                                 default = nil)
  if valid_581225 != nil:
    section.add "quotaUser", valid_581225
  var valid_581226 = query.getOrDefault("alt")
  valid_581226 = validateParameter(valid_581226, JString, required = false,
                                 default = newJString("json"))
  if valid_581226 != nil:
    section.add "alt", valid_581226
  var valid_581227 = query.getOrDefault("oauth_token")
  valid_581227 = validateParameter(valid_581227, JString, required = false,
                                 default = nil)
  if valid_581227 != nil:
    section.add "oauth_token", valid_581227
  var valid_581228 = query.getOrDefault("userIp")
  valid_581228 = validateParameter(valid_581228, JString, required = false,
                                 default = nil)
  if valid_581228 != nil:
    section.add "userIp", valid_581228
  var valid_581229 = query.getOrDefault("key")
  valid_581229 = validateParameter(valid_581229, JString, required = false,
                                 default = nil)
  if valid_581229 != nil:
    section.add "key", valid_581229
  var valid_581230 = query.getOrDefault("prettyPrint")
  valid_581230 = validateParameter(valid_581230, JBool, required = false,
                                 default = newJBool(false))
  if valid_581230 != nil:
    section.add "prettyPrint", valid_581230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581231: Call_AnalyticsManagementProfileFilterLinksGet_581217;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a single profile filter link.
  ## 
  let valid = call_581231.validator(path, query, header, formData, body)
  let scheme = call_581231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581231.url(scheme.get, call_581231.host, call_581231.base,
                         call_581231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581231, url, valid)

proc call*(call_581232: Call_AnalyticsManagementProfileFilterLinksGet_581217;
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
  var path_581233 = newJObject()
  var query_581234 = newJObject()
  add(path_581233, "profileId", newJString(profileId))
  add(query_581234, "fields", newJString(fields))
  add(query_581234, "quotaUser", newJString(quotaUser))
  add(query_581234, "alt", newJString(alt))
  add(query_581234, "oauth_token", newJString(oauthToken))
  add(path_581233, "accountId", newJString(accountId))
  add(query_581234, "userIp", newJString(userIp))
  add(path_581233, "webPropertyId", newJString(webPropertyId))
  add(query_581234, "key", newJString(key))
  add(path_581233, "linkId", newJString(linkId))
  add(query_581234, "prettyPrint", newJBool(prettyPrint))
  result = call_581232.call(path_581233, query_581234, nil, nil, nil)

var analyticsManagementProfileFilterLinksGet* = Call_AnalyticsManagementProfileFilterLinksGet_581217(
    name: "analyticsManagementProfileFilterLinksGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksGet_581218,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksGet_581219,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksPatch_581273 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfileFilterLinksPatch_581275(protocol: Scheme;
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

proc validate_AnalyticsManagementProfileFilterLinksPatch_581274(path: JsonNode;
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
  var valid_581276 = path.getOrDefault("profileId")
  valid_581276 = validateParameter(valid_581276, JString, required = true,
                                 default = nil)
  if valid_581276 != nil:
    section.add "profileId", valid_581276
  var valid_581277 = path.getOrDefault("accountId")
  valid_581277 = validateParameter(valid_581277, JString, required = true,
                                 default = nil)
  if valid_581277 != nil:
    section.add "accountId", valid_581277
  var valid_581278 = path.getOrDefault("webPropertyId")
  valid_581278 = validateParameter(valid_581278, JString, required = true,
                                 default = nil)
  if valid_581278 != nil:
    section.add "webPropertyId", valid_581278
  var valid_581279 = path.getOrDefault("linkId")
  valid_581279 = validateParameter(valid_581279, JString, required = true,
                                 default = nil)
  if valid_581279 != nil:
    section.add "linkId", valid_581279
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
  var valid_581280 = query.getOrDefault("fields")
  valid_581280 = validateParameter(valid_581280, JString, required = false,
                                 default = nil)
  if valid_581280 != nil:
    section.add "fields", valid_581280
  var valid_581281 = query.getOrDefault("quotaUser")
  valid_581281 = validateParameter(valid_581281, JString, required = false,
                                 default = nil)
  if valid_581281 != nil:
    section.add "quotaUser", valid_581281
  var valid_581282 = query.getOrDefault("alt")
  valid_581282 = validateParameter(valid_581282, JString, required = false,
                                 default = newJString("json"))
  if valid_581282 != nil:
    section.add "alt", valid_581282
  var valid_581283 = query.getOrDefault("oauth_token")
  valid_581283 = validateParameter(valid_581283, JString, required = false,
                                 default = nil)
  if valid_581283 != nil:
    section.add "oauth_token", valid_581283
  var valid_581284 = query.getOrDefault("userIp")
  valid_581284 = validateParameter(valid_581284, JString, required = false,
                                 default = nil)
  if valid_581284 != nil:
    section.add "userIp", valid_581284
  var valid_581285 = query.getOrDefault("key")
  valid_581285 = validateParameter(valid_581285, JString, required = false,
                                 default = nil)
  if valid_581285 != nil:
    section.add "key", valid_581285
  var valid_581286 = query.getOrDefault("prettyPrint")
  valid_581286 = validateParameter(valid_581286, JBool, required = false,
                                 default = newJBool(false))
  if valid_581286 != nil:
    section.add "prettyPrint", valid_581286
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

proc call*(call_581288: Call_AnalyticsManagementProfileFilterLinksPatch_581273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Update an existing profile filter link. This method supports patch semantics.
  ## 
  let valid = call_581288.validator(path, query, header, formData, body)
  let scheme = call_581288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581288.url(scheme.get, call_581288.host, call_581288.base,
                         call_581288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581288, url, valid)

proc call*(call_581289: Call_AnalyticsManagementProfileFilterLinksPatch_581273;
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
  var path_581290 = newJObject()
  var query_581291 = newJObject()
  var body_581292 = newJObject()
  add(path_581290, "profileId", newJString(profileId))
  add(query_581291, "fields", newJString(fields))
  add(query_581291, "quotaUser", newJString(quotaUser))
  add(query_581291, "alt", newJString(alt))
  add(query_581291, "oauth_token", newJString(oauthToken))
  add(path_581290, "accountId", newJString(accountId))
  add(query_581291, "userIp", newJString(userIp))
  add(path_581290, "webPropertyId", newJString(webPropertyId))
  add(query_581291, "key", newJString(key))
  add(path_581290, "linkId", newJString(linkId))
  if body != nil:
    body_581292 = body
  add(query_581291, "prettyPrint", newJBool(prettyPrint))
  result = call_581289.call(path_581290, query_581291, nil, nil, body_581292)

var analyticsManagementProfileFilterLinksPatch* = Call_AnalyticsManagementProfileFilterLinksPatch_581273(
    name: "analyticsManagementProfileFilterLinksPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksPatch_581274,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksPatch_581275,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfileFilterLinksDelete_581255 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementProfileFilterLinksDelete_581257(protocol: Scheme;
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

proc validate_AnalyticsManagementProfileFilterLinksDelete_581256(path: JsonNode;
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
  var valid_581258 = path.getOrDefault("profileId")
  valid_581258 = validateParameter(valid_581258, JString, required = true,
                                 default = nil)
  if valid_581258 != nil:
    section.add "profileId", valid_581258
  var valid_581259 = path.getOrDefault("accountId")
  valid_581259 = validateParameter(valid_581259, JString, required = true,
                                 default = nil)
  if valid_581259 != nil:
    section.add "accountId", valid_581259
  var valid_581260 = path.getOrDefault("webPropertyId")
  valid_581260 = validateParameter(valid_581260, JString, required = true,
                                 default = nil)
  if valid_581260 != nil:
    section.add "webPropertyId", valid_581260
  var valid_581261 = path.getOrDefault("linkId")
  valid_581261 = validateParameter(valid_581261, JString, required = true,
                                 default = nil)
  if valid_581261 != nil:
    section.add "linkId", valid_581261
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
  var valid_581262 = query.getOrDefault("fields")
  valid_581262 = validateParameter(valid_581262, JString, required = false,
                                 default = nil)
  if valid_581262 != nil:
    section.add "fields", valid_581262
  var valid_581263 = query.getOrDefault("quotaUser")
  valid_581263 = validateParameter(valid_581263, JString, required = false,
                                 default = nil)
  if valid_581263 != nil:
    section.add "quotaUser", valid_581263
  var valid_581264 = query.getOrDefault("alt")
  valid_581264 = validateParameter(valid_581264, JString, required = false,
                                 default = newJString("json"))
  if valid_581264 != nil:
    section.add "alt", valid_581264
  var valid_581265 = query.getOrDefault("oauth_token")
  valid_581265 = validateParameter(valid_581265, JString, required = false,
                                 default = nil)
  if valid_581265 != nil:
    section.add "oauth_token", valid_581265
  var valid_581266 = query.getOrDefault("userIp")
  valid_581266 = validateParameter(valid_581266, JString, required = false,
                                 default = nil)
  if valid_581266 != nil:
    section.add "userIp", valid_581266
  var valid_581267 = query.getOrDefault("key")
  valid_581267 = validateParameter(valid_581267, JString, required = false,
                                 default = nil)
  if valid_581267 != nil:
    section.add "key", valid_581267
  var valid_581268 = query.getOrDefault("prettyPrint")
  valid_581268 = validateParameter(valid_581268, JBool, required = false,
                                 default = newJBool(false))
  if valid_581268 != nil:
    section.add "prettyPrint", valid_581268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581269: Call_AnalyticsManagementProfileFilterLinksDelete_581255;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a profile filter link.
  ## 
  let valid = call_581269.validator(path, query, header, formData, body)
  let scheme = call_581269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581269.url(scheme.get, call_581269.host, call_581269.base,
                         call_581269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581269, url, valid)

proc call*(call_581270: Call_AnalyticsManagementProfileFilterLinksDelete_581255;
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
  var path_581271 = newJObject()
  var query_581272 = newJObject()
  add(path_581271, "profileId", newJString(profileId))
  add(query_581272, "fields", newJString(fields))
  add(query_581272, "quotaUser", newJString(quotaUser))
  add(query_581272, "alt", newJString(alt))
  add(query_581272, "oauth_token", newJString(oauthToken))
  add(path_581271, "accountId", newJString(accountId))
  add(query_581272, "userIp", newJString(userIp))
  add(path_581271, "webPropertyId", newJString(webPropertyId))
  add(query_581272, "key", newJString(key))
  add(path_581271, "linkId", newJString(linkId))
  add(query_581272, "prettyPrint", newJBool(prettyPrint))
  result = call_581270.call(path_581271, query_581272, nil, nil, nil)

var analyticsManagementProfileFilterLinksDelete* = Call_AnalyticsManagementProfileFilterLinksDelete_581255(
    name: "analyticsManagementProfileFilterLinksDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/profileFilterLinks/{linkId}",
    validator: validate_AnalyticsManagementProfileFilterLinksDelete_581256,
    base: "/analytics/v3", url: url_AnalyticsManagementProfileFilterLinksDelete_581257,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsInsert_581312 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementUnsampledReportsInsert_581314(protocol: Scheme;
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

proc validate_AnalyticsManagementUnsampledReportsInsert_581313(path: JsonNode;
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
  var valid_581315 = path.getOrDefault("profileId")
  valid_581315 = validateParameter(valid_581315, JString, required = true,
                                 default = nil)
  if valid_581315 != nil:
    section.add "profileId", valid_581315
  var valid_581316 = path.getOrDefault("accountId")
  valid_581316 = validateParameter(valid_581316, JString, required = true,
                                 default = nil)
  if valid_581316 != nil:
    section.add "accountId", valid_581316
  var valid_581317 = path.getOrDefault("webPropertyId")
  valid_581317 = validateParameter(valid_581317, JString, required = true,
                                 default = nil)
  if valid_581317 != nil:
    section.add "webPropertyId", valid_581317
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
  var valid_581318 = query.getOrDefault("fields")
  valid_581318 = validateParameter(valid_581318, JString, required = false,
                                 default = nil)
  if valid_581318 != nil:
    section.add "fields", valid_581318
  var valid_581319 = query.getOrDefault("quotaUser")
  valid_581319 = validateParameter(valid_581319, JString, required = false,
                                 default = nil)
  if valid_581319 != nil:
    section.add "quotaUser", valid_581319
  var valid_581320 = query.getOrDefault("alt")
  valid_581320 = validateParameter(valid_581320, JString, required = false,
                                 default = newJString("json"))
  if valid_581320 != nil:
    section.add "alt", valid_581320
  var valid_581321 = query.getOrDefault("oauth_token")
  valid_581321 = validateParameter(valid_581321, JString, required = false,
                                 default = nil)
  if valid_581321 != nil:
    section.add "oauth_token", valid_581321
  var valid_581322 = query.getOrDefault("userIp")
  valid_581322 = validateParameter(valid_581322, JString, required = false,
                                 default = nil)
  if valid_581322 != nil:
    section.add "userIp", valid_581322
  var valid_581323 = query.getOrDefault("key")
  valid_581323 = validateParameter(valid_581323, JString, required = false,
                                 default = nil)
  if valid_581323 != nil:
    section.add "key", valid_581323
  var valid_581324 = query.getOrDefault("prettyPrint")
  valid_581324 = validateParameter(valid_581324, JBool, required = false,
                                 default = newJBool(false))
  if valid_581324 != nil:
    section.add "prettyPrint", valid_581324
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

proc call*(call_581326: Call_AnalyticsManagementUnsampledReportsInsert_581312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create a new unsampled report.
  ## 
  let valid = call_581326.validator(path, query, header, formData, body)
  let scheme = call_581326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581326.url(scheme.get, call_581326.host, call_581326.base,
                         call_581326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581326, url, valid)

proc call*(call_581327: Call_AnalyticsManagementUnsampledReportsInsert_581312;
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
  var path_581328 = newJObject()
  var query_581329 = newJObject()
  var body_581330 = newJObject()
  add(path_581328, "profileId", newJString(profileId))
  add(query_581329, "fields", newJString(fields))
  add(query_581329, "quotaUser", newJString(quotaUser))
  add(query_581329, "alt", newJString(alt))
  add(query_581329, "oauth_token", newJString(oauthToken))
  add(path_581328, "accountId", newJString(accountId))
  add(query_581329, "userIp", newJString(userIp))
  add(path_581328, "webPropertyId", newJString(webPropertyId))
  add(query_581329, "key", newJString(key))
  if body != nil:
    body_581330 = body
  add(query_581329, "prettyPrint", newJBool(prettyPrint))
  result = call_581327.call(path_581328, query_581329, nil, nil, body_581330)

var analyticsManagementUnsampledReportsInsert* = Call_AnalyticsManagementUnsampledReportsInsert_581312(
    name: "analyticsManagementUnsampledReportsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports",
    validator: validate_AnalyticsManagementUnsampledReportsInsert_581313,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsInsert_581314,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsList_581293 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementUnsampledReportsList_581295(protocol: Scheme;
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

proc validate_AnalyticsManagementUnsampledReportsList_581294(path: JsonNode;
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
  var valid_581296 = path.getOrDefault("profileId")
  valid_581296 = validateParameter(valid_581296, JString, required = true,
                                 default = nil)
  if valid_581296 != nil:
    section.add "profileId", valid_581296
  var valid_581297 = path.getOrDefault("accountId")
  valid_581297 = validateParameter(valid_581297, JString, required = true,
                                 default = nil)
  if valid_581297 != nil:
    section.add "accountId", valid_581297
  var valid_581298 = path.getOrDefault("webPropertyId")
  valid_581298 = validateParameter(valid_581298, JString, required = true,
                                 default = nil)
  if valid_581298 != nil:
    section.add "webPropertyId", valid_581298
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
  var valid_581299 = query.getOrDefault("fields")
  valid_581299 = validateParameter(valid_581299, JString, required = false,
                                 default = nil)
  if valid_581299 != nil:
    section.add "fields", valid_581299
  var valid_581300 = query.getOrDefault("quotaUser")
  valid_581300 = validateParameter(valid_581300, JString, required = false,
                                 default = nil)
  if valid_581300 != nil:
    section.add "quotaUser", valid_581300
  var valid_581301 = query.getOrDefault("alt")
  valid_581301 = validateParameter(valid_581301, JString, required = false,
                                 default = newJString("json"))
  if valid_581301 != nil:
    section.add "alt", valid_581301
  var valid_581302 = query.getOrDefault("oauth_token")
  valid_581302 = validateParameter(valid_581302, JString, required = false,
                                 default = nil)
  if valid_581302 != nil:
    section.add "oauth_token", valid_581302
  var valid_581303 = query.getOrDefault("userIp")
  valid_581303 = validateParameter(valid_581303, JString, required = false,
                                 default = nil)
  if valid_581303 != nil:
    section.add "userIp", valid_581303
  var valid_581304 = query.getOrDefault("key")
  valid_581304 = validateParameter(valid_581304, JString, required = false,
                                 default = nil)
  if valid_581304 != nil:
    section.add "key", valid_581304
  var valid_581305 = query.getOrDefault("max-results")
  valid_581305 = validateParameter(valid_581305, JInt, required = false, default = nil)
  if valid_581305 != nil:
    section.add "max-results", valid_581305
  var valid_581306 = query.getOrDefault("start-index")
  valid_581306 = validateParameter(valid_581306, JInt, required = false, default = nil)
  if valid_581306 != nil:
    section.add "start-index", valid_581306
  var valid_581307 = query.getOrDefault("prettyPrint")
  valid_581307 = validateParameter(valid_581307, JBool, required = false,
                                 default = newJBool(false))
  if valid_581307 != nil:
    section.add "prettyPrint", valid_581307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581308: Call_AnalyticsManagementUnsampledReportsList_581293;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists unsampled reports to which the user has access.
  ## 
  let valid = call_581308.validator(path, query, header, formData, body)
  let scheme = call_581308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581308.url(scheme.get, call_581308.host, call_581308.base,
                         call_581308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581308, url, valid)

proc call*(call_581309: Call_AnalyticsManagementUnsampledReportsList_581293;
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
  var path_581310 = newJObject()
  var query_581311 = newJObject()
  add(path_581310, "profileId", newJString(profileId))
  add(query_581311, "fields", newJString(fields))
  add(query_581311, "quotaUser", newJString(quotaUser))
  add(query_581311, "alt", newJString(alt))
  add(query_581311, "oauth_token", newJString(oauthToken))
  add(path_581310, "accountId", newJString(accountId))
  add(query_581311, "userIp", newJString(userIp))
  add(path_581310, "webPropertyId", newJString(webPropertyId))
  add(query_581311, "key", newJString(key))
  add(query_581311, "max-results", newJInt(maxResults))
  add(query_581311, "start-index", newJInt(startIndex))
  add(query_581311, "prettyPrint", newJBool(prettyPrint))
  result = call_581309.call(path_581310, query_581311, nil, nil, nil)

var analyticsManagementUnsampledReportsList* = Call_AnalyticsManagementUnsampledReportsList_581293(
    name: "analyticsManagementUnsampledReportsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports",
    validator: validate_AnalyticsManagementUnsampledReportsList_581294,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsList_581295,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsGet_581331 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementUnsampledReportsGet_581333(protocol: Scheme;
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

proc validate_AnalyticsManagementUnsampledReportsGet_581332(path: JsonNode;
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
  var valid_581334 = path.getOrDefault("profileId")
  valid_581334 = validateParameter(valid_581334, JString, required = true,
                                 default = nil)
  if valid_581334 != nil:
    section.add "profileId", valid_581334
  var valid_581335 = path.getOrDefault("accountId")
  valid_581335 = validateParameter(valid_581335, JString, required = true,
                                 default = nil)
  if valid_581335 != nil:
    section.add "accountId", valid_581335
  var valid_581336 = path.getOrDefault("webPropertyId")
  valid_581336 = validateParameter(valid_581336, JString, required = true,
                                 default = nil)
  if valid_581336 != nil:
    section.add "webPropertyId", valid_581336
  var valid_581337 = path.getOrDefault("unsampledReportId")
  valid_581337 = validateParameter(valid_581337, JString, required = true,
                                 default = nil)
  if valid_581337 != nil:
    section.add "unsampledReportId", valid_581337
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
  var valid_581338 = query.getOrDefault("fields")
  valid_581338 = validateParameter(valid_581338, JString, required = false,
                                 default = nil)
  if valid_581338 != nil:
    section.add "fields", valid_581338
  var valid_581339 = query.getOrDefault("quotaUser")
  valid_581339 = validateParameter(valid_581339, JString, required = false,
                                 default = nil)
  if valid_581339 != nil:
    section.add "quotaUser", valid_581339
  var valid_581340 = query.getOrDefault("alt")
  valid_581340 = validateParameter(valid_581340, JString, required = false,
                                 default = newJString("json"))
  if valid_581340 != nil:
    section.add "alt", valid_581340
  var valid_581341 = query.getOrDefault("oauth_token")
  valid_581341 = validateParameter(valid_581341, JString, required = false,
                                 default = nil)
  if valid_581341 != nil:
    section.add "oauth_token", valid_581341
  var valid_581342 = query.getOrDefault("userIp")
  valid_581342 = validateParameter(valid_581342, JString, required = false,
                                 default = nil)
  if valid_581342 != nil:
    section.add "userIp", valid_581342
  var valid_581343 = query.getOrDefault("key")
  valid_581343 = validateParameter(valid_581343, JString, required = false,
                                 default = nil)
  if valid_581343 != nil:
    section.add "key", valid_581343
  var valid_581344 = query.getOrDefault("prettyPrint")
  valid_581344 = validateParameter(valid_581344, JBool, required = false,
                                 default = newJBool(false))
  if valid_581344 != nil:
    section.add "prettyPrint", valid_581344
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581345: Call_AnalyticsManagementUnsampledReportsGet_581331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a single unsampled report.
  ## 
  let valid = call_581345.validator(path, query, header, formData, body)
  let scheme = call_581345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581345.url(scheme.get, call_581345.host, call_581345.base,
                         call_581345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581345, url, valid)

proc call*(call_581346: Call_AnalyticsManagementUnsampledReportsGet_581331;
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
  var path_581347 = newJObject()
  var query_581348 = newJObject()
  add(path_581347, "profileId", newJString(profileId))
  add(query_581348, "fields", newJString(fields))
  add(query_581348, "quotaUser", newJString(quotaUser))
  add(query_581348, "alt", newJString(alt))
  add(query_581348, "oauth_token", newJString(oauthToken))
  add(path_581347, "accountId", newJString(accountId))
  add(query_581348, "userIp", newJString(userIp))
  add(path_581347, "webPropertyId", newJString(webPropertyId))
  add(query_581348, "key", newJString(key))
  add(query_581348, "prettyPrint", newJBool(prettyPrint))
  add(path_581347, "unsampledReportId", newJString(unsampledReportId))
  result = call_581346.call(path_581347, query_581348, nil, nil, nil)

var analyticsManagementUnsampledReportsGet* = Call_AnalyticsManagementUnsampledReportsGet_581331(
    name: "analyticsManagementUnsampledReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports/{unsampledReportId}",
    validator: validate_AnalyticsManagementUnsampledReportsGet_581332,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsGet_581333,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementUnsampledReportsDelete_581349 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementUnsampledReportsDelete_581351(protocol: Scheme;
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

proc validate_AnalyticsManagementUnsampledReportsDelete_581350(path: JsonNode;
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
  var valid_581352 = path.getOrDefault("profileId")
  valid_581352 = validateParameter(valid_581352, JString, required = true,
                                 default = nil)
  if valid_581352 != nil:
    section.add "profileId", valid_581352
  var valid_581353 = path.getOrDefault("accountId")
  valid_581353 = validateParameter(valid_581353, JString, required = true,
                                 default = nil)
  if valid_581353 != nil:
    section.add "accountId", valid_581353
  var valid_581354 = path.getOrDefault("webPropertyId")
  valid_581354 = validateParameter(valid_581354, JString, required = true,
                                 default = nil)
  if valid_581354 != nil:
    section.add "webPropertyId", valid_581354
  var valid_581355 = path.getOrDefault("unsampledReportId")
  valid_581355 = validateParameter(valid_581355, JString, required = true,
                                 default = nil)
  if valid_581355 != nil:
    section.add "unsampledReportId", valid_581355
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
  var valid_581356 = query.getOrDefault("fields")
  valid_581356 = validateParameter(valid_581356, JString, required = false,
                                 default = nil)
  if valid_581356 != nil:
    section.add "fields", valid_581356
  var valid_581357 = query.getOrDefault("quotaUser")
  valid_581357 = validateParameter(valid_581357, JString, required = false,
                                 default = nil)
  if valid_581357 != nil:
    section.add "quotaUser", valid_581357
  var valid_581358 = query.getOrDefault("alt")
  valid_581358 = validateParameter(valid_581358, JString, required = false,
                                 default = newJString("json"))
  if valid_581358 != nil:
    section.add "alt", valid_581358
  var valid_581359 = query.getOrDefault("oauth_token")
  valid_581359 = validateParameter(valid_581359, JString, required = false,
                                 default = nil)
  if valid_581359 != nil:
    section.add "oauth_token", valid_581359
  var valid_581360 = query.getOrDefault("userIp")
  valid_581360 = validateParameter(valid_581360, JString, required = false,
                                 default = nil)
  if valid_581360 != nil:
    section.add "userIp", valid_581360
  var valid_581361 = query.getOrDefault("key")
  valid_581361 = validateParameter(valid_581361, JString, required = false,
                                 default = nil)
  if valid_581361 != nil:
    section.add "key", valid_581361
  var valid_581362 = query.getOrDefault("prettyPrint")
  valid_581362 = validateParameter(valid_581362, JBool, required = false,
                                 default = newJBool(false))
  if valid_581362 != nil:
    section.add "prettyPrint", valid_581362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581363: Call_AnalyticsManagementUnsampledReportsDelete_581349;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes an unsampled report.
  ## 
  let valid = call_581363.validator(path, query, header, formData, body)
  let scheme = call_581363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581363.url(scheme.get, call_581363.host, call_581363.base,
                         call_581363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581363, url, valid)

proc call*(call_581364: Call_AnalyticsManagementUnsampledReportsDelete_581349;
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
  var path_581365 = newJObject()
  var query_581366 = newJObject()
  add(path_581365, "profileId", newJString(profileId))
  add(query_581366, "fields", newJString(fields))
  add(query_581366, "quotaUser", newJString(quotaUser))
  add(query_581366, "alt", newJString(alt))
  add(query_581366, "oauth_token", newJString(oauthToken))
  add(path_581365, "accountId", newJString(accountId))
  add(query_581366, "userIp", newJString(userIp))
  add(path_581365, "webPropertyId", newJString(webPropertyId))
  add(query_581366, "key", newJString(key))
  add(query_581366, "prettyPrint", newJBool(prettyPrint))
  add(path_581365, "unsampledReportId", newJString(unsampledReportId))
  result = call_581364.call(path_581365, query_581366, nil, nil, nil)

var analyticsManagementUnsampledReportsDelete* = Call_AnalyticsManagementUnsampledReportsDelete_581349(
    name: "analyticsManagementUnsampledReportsDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/unsampledReports/{unsampledReportId}",
    validator: validate_AnalyticsManagementUnsampledReportsDelete_581350,
    base: "/analytics/v3", url: url_AnalyticsManagementUnsampledReportsDelete_581351,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceInsert_581386 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementRemarketingAudienceInsert_581388(protocol: Scheme;
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

proc validate_AnalyticsManagementRemarketingAudienceInsert_581387(path: JsonNode;
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
  var valid_581389 = path.getOrDefault("accountId")
  valid_581389 = validateParameter(valid_581389, JString, required = true,
                                 default = nil)
  if valid_581389 != nil:
    section.add "accountId", valid_581389
  var valid_581390 = path.getOrDefault("webPropertyId")
  valid_581390 = validateParameter(valid_581390, JString, required = true,
                                 default = nil)
  if valid_581390 != nil:
    section.add "webPropertyId", valid_581390
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
  var valid_581391 = query.getOrDefault("fields")
  valid_581391 = validateParameter(valid_581391, JString, required = false,
                                 default = nil)
  if valid_581391 != nil:
    section.add "fields", valid_581391
  var valid_581392 = query.getOrDefault("quotaUser")
  valid_581392 = validateParameter(valid_581392, JString, required = false,
                                 default = nil)
  if valid_581392 != nil:
    section.add "quotaUser", valid_581392
  var valid_581393 = query.getOrDefault("alt")
  valid_581393 = validateParameter(valid_581393, JString, required = false,
                                 default = newJString("json"))
  if valid_581393 != nil:
    section.add "alt", valid_581393
  var valid_581394 = query.getOrDefault("oauth_token")
  valid_581394 = validateParameter(valid_581394, JString, required = false,
                                 default = nil)
  if valid_581394 != nil:
    section.add "oauth_token", valid_581394
  var valid_581395 = query.getOrDefault("userIp")
  valid_581395 = validateParameter(valid_581395, JString, required = false,
                                 default = nil)
  if valid_581395 != nil:
    section.add "userIp", valid_581395
  var valid_581396 = query.getOrDefault("key")
  valid_581396 = validateParameter(valid_581396, JString, required = false,
                                 default = nil)
  if valid_581396 != nil:
    section.add "key", valid_581396
  var valid_581397 = query.getOrDefault("prettyPrint")
  valid_581397 = validateParameter(valid_581397, JBool, required = false,
                                 default = newJBool(false))
  if valid_581397 != nil:
    section.add "prettyPrint", valid_581397
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

proc call*(call_581399: Call_AnalyticsManagementRemarketingAudienceInsert_581386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new remarketing audience.
  ## 
  let valid = call_581399.validator(path, query, header, formData, body)
  let scheme = call_581399.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581399.url(scheme.get, call_581399.host, call_581399.base,
                         call_581399.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581399, url, valid)

proc call*(call_581400: Call_AnalyticsManagementRemarketingAudienceInsert_581386;
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
  var path_581401 = newJObject()
  var query_581402 = newJObject()
  var body_581403 = newJObject()
  add(query_581402, "fields", newJString(fields))
  add(query_581402, "quotaUser", newJString(quotaUser))
  add(query_581402, "alt", newJString(alt))
  add(query_581402, "oauth_token", newJString(oauthToken))
  add(path_581401, "accountId", newJString(accountId))
  add(query_581402, "userIp", newJString(userIp))
  add(path_581401, "webPropertyId", newJString(webPropertyId))
  add(query_581402, "key", newJString(key))
  if body != nil:
    body_581403 = body
  add(query_581402, "prettyPrint", newJBool(prettyPrint))
  result = call_581400.call(path_581401, query_581402, nil, nil, body_581403)

var analyticsManagementRemarketingAudienceInsert* = Call_AnalyticsManagementRemarketingAudienceInsert_581386(
    name: "analyticsManagementRemarketingAudienceInsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences",
    validator: validate_AnalyticsManagementRemarketingAudienceInsert_581387,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceInsert_581388,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceList_581367 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementRemarketingAudienceList_581369(protocol: Scheme;
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

proc validate_AnalyticsManagementRemarketingAudienceList_581368(path: JsonNode;
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
  var valid_581370 = path.getOrDefault("accountId")
  valid_581370 = validateParameter(valid_581370, JString, required = true,
                                 default = nil)
  if valid_581370 != nil:
    section.add "accountId", valid_581370
  var valid_581371 = path.getOrDefault("webPropertyId")
  valid_581371 = validateParameter(valid_581371, JString, required = true,
                                 default = nil)
  if valid_581371 != nil:
    section.add "webPropertyId", valid_581371
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
  var valid_581372 = query.getOrDefault("fields")
  valid_581372 = validateParameter(valid_581372, JString, required = false,
                                 default = nil)
  if valid_581372 != nil:
    section.add "fields", valid_581372
  var valid_581373 = query.getOrDefault("quotaUser")
  valid_581373 = validateParameter(valid_581373, JString, required = false,
                                 default = nil)
  if valid_581373 != nil:
    section.add "quotaUser", valid_581373
  var valid_581374 = query.getOrDefault("alt")
  valid_581374 = validateParameter(valid_581374, JString, required = false,
                                 default = newJString("json"))
  if valid_581374 != nil:
    section.add "alt", valid_581374
  var valid_581375 = query.getOrDefault("type")
  valid_581375 = validateParameter(valid_581375, JString, required = false,
                                 default = newJString("all"))
  if valid_581375 != nil:
    section.add "type", valid_581375
  var valid_581376 = query.getOrDefault("oauth_token")
  valid_581376 = validateParameter(valid_581376, JString, required = false,
                                 default = nil)
  if valid_581376 != nil:
    section.add "oauth_token", valid_581376
  var valid_581377 = query.getOrDefault("userIp")
  valid_581377 = validateParameter(valid_581377, JString, required = false,
                                 default = nil)
  if valid_581377 != nil:
    section.add "userIp", valid_581377
  var valid_581378 = query.getOrDefault("key")
  valid_581378 = validateParameter(valid_581378, JString, required = false,
                                 default = nil)
  if valid_581378 != nil:
    section.add "key", valid_581378
  var valid_581379 = query.getOrDefault("max-results")
  valid_581379 = validateParameter(valid_581379, JInt, required = false, default = nil)
  if valid_581379 != nil:
    section.add "max-results", valid_581379
  var valid_581380 = query.getOrDefault("start-index")
  valid_581380 = validateParameter(valid_581380, JInt, required = false, default = nil)
  if valid_581380 != nil:
    section.add "start-index", valid_581380
  var valid_581381 = query.getOrDefault("prettyPrint")
  valid_581381 = validateParameter(valid_581381, JBool, required = false,
                                 default = newJBool(false))
  if valid_581381 != nil:
    section.add "prettyPrint", valid_581381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581382: Call_AnalyticsManagementRemarketingAudienceList_581367;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists remarketing audiences to which the user has access.
  ## 
  let valid = call_581382.validator(path, query, header, formData, body)
  let scheme = call_581382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581382.url(scheme.get, call_581382.host, call_581382.base,
                         call_581382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581382, url, valid)

proc call*(call_581383: Call_AnalyticsManagementRemarketingAudienceList_581367;
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
  var path_581384 = newJObject()
  var query_581385 = newJObject()
  add(query_581385, "fields", newJString(fields))
  add(query_581385, "quotaUser", newJString(quotaUser))
  add(query_581385, "alt", newJString(alt))
  add(query_581385, "type", newJString(`type`))
  add(query_581385, "oauth_token", newJString(oauthToken))
  add(path_581384, "accountId", newJString(accountId))
  add(query_581385, "userIp", newJString(userIp))
  add(path_581384, "webPropertyId", newJString(webPropertyId))
  add(query_581385, "key", newJString(key))
  add(query_581385, "max-results", newJInt(maxResults))
  add(query_581385, "start-index", newJInt(startIndex))
  add(query_581385, "prettyPrint", newJBool(prettyPrint))
  result = call_581383.call(path_581384, query_581385, nil, nil, nil)

var analyticsManagementRemarketingAudienceList* = Call_AnalyticsManagementRemarketingAudienceList_581367(
    name: "analyticsManagementRemarketingAudienceList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences",
    validator: validate_AnalyticsManagementRemarketingAudienceList_581368,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceList_581369,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceUpdate_581421 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementRemarketingAudienceUpdate_581423(protocol: Scheme;
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

proc validate_AnalyticsManagementRemarketingAudienceUpdate_581422(path: JsonNode;
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
  var valid_581424 = path.getOrDefault("accountId")
  valid_581424 = validateParameter(valid_581424, JString, required = true,
                                 default = nil)
  if valid_581424 != nil:
    section.add "accountId", valid_581424
  var valid_581425 = path.getOrDefault("webPropertyId")
  valid_581425 = validateParameter(valid_581425, JString, required = true,
                                 default = nil)
  if valid_581425 != nil:
    section.add "webPropertyId", valid_581425
  var valid_581426 = path.getOrDefault("remarketingAudienceId")
  valid_581426 = validateParameter(valid_581426, JString, required = true,
                                 default = nil)
  if valid_581426 != nil:
    section.add "remarketingAudienceId", valid_581426
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
  var valid_581427 = query.getOrDefault("fields")
  valid_581427 = validateParameter(valid_581427, JString, required = false,
                                 default = nil)
  if valid_581427 != nil:
    section.add "fields", valid_581427
  var valid_581428 = query.getOrDefault("quotaUser")
  valid_581428 = validateParameter(valid_581428, JString, required = false,
                                 default = nil)
  if valid_581428 != nil:
    section.add "quotaUser", valid_581428
  var valid_581429 = query.getOrDefault("alt")
  valid_581429 = validateParameter(valid_581429, JString, required = false,
                                 default = newJString("json"))
  if valid_581429 != nil:
    section.add "alt", valid_581429
  var valid_581430 = query.getOrDefault("oauth_token")
  valid_581430 = validateParameter(valid_581430, JString, required = false,
                                 default = nil)
  if valid_581430 != nil:
    section.add "oauth_token", valid_581430
  var valid_581431 = query.getOrDefault("userIp")
  valid_581431 = validateParameter(valid_581431, JString, required = false,
                                 default = nil)
  if valid_581431 != nil:
    section.add "userIp", valid_581431
  var valid_581432 = query.getOrDefault("key")
  valid_581432 = validateParameter(valid_581432, JString, required = false,
                                 default = nil)
  if valid_581432 != nil:
    section.add "key", valid_581432
  var valid_581433 = query.getOrDefault("prettyPrint")
  valid_581433 = validateParameter(valid_581433, JBool, required = false,
                                 default = newJBool(false))
  if valid_581433 != nil:
    section.add "prettyPrint", valid_581433
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

proc call*(call_581435: Call_AnalyticsManagementRemarketingAudienceUpdate_581421;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing remarketing audience.
  ## 
  let valid = call_581435.validator(path, query, header, formData, body)
  let scheme = call_581435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581435.url(scheme.get, call_581435.host, call_581435.base,
                         call_581435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581435, url, valid)

proc call*(call_581436: Call_AnalyticsManagementRemarketingAudienceUpdate_581421;
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
  var path_581437 = newJObject()
  var query_581438 = newJObject()
  var body_581439 = newJObject()
  add(query_581438, "fields", newJString(fields))
  add(query_581438, "quotaUser", newJString(quotaUser))
  add(query_581438, "alt", newJString(alt))
  add(query_581438, "oauth_token", newJString(oauthToken))
  add(path_581437, "accountId", newJString(accountId))
  add(query_581438, "userIp", newJString(userIp))
  add(path_581437, "webPropertyId", newJString(webPropertyId))
  add(query_581438, "key", newJString(key))
  add(path_581437, "remarketingAudienceId", newJString(remarketingAudienceId))
  if body != nil:
    body_581439 = body
  add(query_581438, "prettyPrint", newJBool(prettyPrint))
  result = call_581436.call(path_581437, query_581438, nil, nil, body_581439)

var analyticsManagementRemarketingAudienceUpdate* = Call_AnalyticsManagementRemarketingAudienceUpdate_581421(
    name: "analyticsManagementRemarketingAudienceUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudienceUpdate_581422,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceUpdate_581423,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceGet_581404 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementRemarketingAudienceGet_581406(protocol: Scheme;
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

proc validate_AnalyticsManagementRemarketingAudienceGet_581405(path: JsonNode;
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
  var valid_581407 = path.getOrDefault("accountId")
  valid_581407 = validateParameter(valid_581407, JString, required = true,
                                 default = nil)
  if valid_581407 != nil:
    section.add "accountId", valid_581407
  var valid_581408 = path.getOrDefault("webPropertyId")
  valid_581408 = validateParameter(valid_581408, JString, required = true,
                                 default = nil)
  if valid_581408 != nil:
    section.add "webPropertyId", valid_581408
  var valid_581409 = path.getOrDefault("remarketingAudienceId")
  valid_581409 = validateParameter(valid_581409, JString, required = true,
                                 default = nil)
  if valid_581409 != nil:
    section.add "remarketingAudienceId", valid_581409
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
  var valid_581410 = query.getOrDefault("fields")
  valid_581410 = validateParameter(valid_581410, JString, required = false,
                                 default = nil)
  if valid_581410 != nil:
    section.add "fields", valid_581410
  var valid_581411 = query.getOrDefault("quotaUser")
  valid_581411 = validateParameter(valid_581411, JString, required = false,
                                 default = nil)
  if valid_581411 != nil:
    section.add "quotaUser", valid_581411
  var valid_581412 = query.getOrDefault("alt")
  valid_581412 = validateParameter(valid_581412, JString, required = false,
                                 default = newJString("json"))
  if valid_581412 != nil:
    section.add "alt", valid_581412
  var valid_581413 = query.getOrDefault("oauth_token")
  valid_581413 = validateParameter(valid_581413, JString, required = false,
                                 default = nil)
  if valid_581413 != nil:
    section.add "oauth_token", valid_581413
  var valid_581414 = query.getOrDefault("userIp")
  valid_581414 = validateParameter(valid_581414, JString, required = false,
                                 default = nil)
  if valid_581414 != nil:
    section.add "userIp", valid_581414
  var valid_581415 = query.getOrDefault("key")
  valid_581415 = validateParameter(valid_581415, JString, required = false,
                                 default = nil)
  if valid_581415 != nil:
    section.add "key", valid_581415
  var valid_581416 = query.getOrDefault("prettyPrint")
  valid_581416 = validateParameter(valid_581416, JBool, required = false,
                                 default = newJBool(false))
  if valid_581416 != nil:
    section.add "prettyPrint", valid_581416
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581417: Call_AnalyticsManagementRemarketingAudienceGet_581404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets a remarketing audience to which the user has access.
  ## 
  let valid = call_581417.validator(path, query, header, formData, body)
  let scheme = call_581417.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581417.url(scheme.get, call_581417.host, call_581417.base,
                         call_581417.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581417, url, valid)

proc call*(call_581418: Call_AnalyticsManagementRemarketingAudienceGet_581404;
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
  var path_581419 = newJObject()
  var query_581420 = newJObject()
  add(query_581420, "fields", newJString(fields))
  add(query_581420, "quotaUser", newJString(quotaUser))
  add(query_581420, "alt", newJString(alt))
  add(query_581420, "oauth_token", newJString(oauthToken))
  add(path_581419, "accountId", newJString(accountId))
  add(query_581420, "userIp", newJString(userIp))
  add(path_581419, "webPropertyId", newJString(webPropertyId))
  add(query_581420, "key", newJString(key))
  add(path_581419, "remarketingAudienceId", newJString(remarketingAudienceId))
  add(query_581420, "prettyPrint", newJBool(prettyPrint))
  result = call_581418.call(path_581419, query_581420, nil, nil, nil)

var analyticsManagementRemarketingAudienceGet* = Call_AnalyticsManagementRemarketingAudienceGet_581404(
    name: "analyticsManagementRemarketingAudienceGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudienceGet_581405,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceGet_581406,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudiencePatch_581457 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementRemarketingAudiencePatch_581459(protocol: Scheme;
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

proc validate_AnalyticsManagementRemarketingAudiencePatch_581458(path: JsonNode;
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
  var valid_581460 = path.getOrDefault("accountId")
  valid_581460 = validateParameter(valid_581460, JString, required = true,
                                 default = nil)
  if valid_581460 != nil:
    section.add "accountId", valid_581460
  var valid_581461 = path.getOrDefault("webPropertyId")
  valid_581461 = validateParameter(valid_581461, JString, required = true,
                                 default = nil)
  if valid_581461 != nil:
    section.add "webPropertyId", valid_581461
  var valid_581462 = path.getOrDefault("remarketingAudienceId")
  valid_581462 = validateParameter(valid_581462, JString, required = true,
                                 default = nil)
  if valid_581462 != nil:
    section.add "remarketingAudienceId", valid_581462
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
  var valid_581463 = query.getOrDefault("fields")
  valid_581463 = validateParameter(valid_581463, JString, required = false,
                                 default = nil)
  if valid_581463 != nil:
    section.add "fields", valid_581463
  var valid_581464 = query.getOrDefault("quotaUser")
  valid_581464 = validateParameter(valid_581464, JString, required = false,
                                 default = nil)
  if valid_581464 != nil:
    section.add "quotaUser", valid_581464
  var valid_581465 = query.getOrDefault("alt")
  valid_581465 = validateParameter(valid_581465, JString, required = false,
                                 default = newJString("json"))
  if valid_581465 != nil:
    section.add "alt", valid_581465
  var valid_581466 = query.getOrDefault("oauth_token")
  valid_581466 = validateParameter(valid_581466, JString, required = false,
                                 default = nil)
  if valid_581466 != nil:
    section.add "oauth_token", valid_581466
  var valid_581467 = query.getOrDefault("userIp")
  valid_581467 = validateParameter(valid_581467, JString, required = false,
                                 default = nil)
  if valid_581467 != nil:
    section.add "userIp", valid_581467
  var valid_581468 = query.getOrDefault("key")
  valid_581468 = validateParameter(valid_581468, JString, required = false,
                                 default = nil)
  if valid_581468 != nil:
    section.add "key", valid_581468
  var valid_581469 = query.getOrDefault("prettyPrint")
  valid_581469 = validateParameter(valid_581469, JBool, required = false,
                                 default = newJBool(false))
  if valid_581469 != nil:
    section.add "prettyPrint", valid_581469
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

proc call*(call_581471: Call_AnalyticsManagementRemarketingAudiencePatch_581457;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an existing remarketing audience. This method supports patch semantics.
  ## 
  let valid = call_581471.validator(path, query, header, formData, body)
  let scheme = call_581471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581471.url(scheme.get, call_581471.host, call_581471.base,
                         call_581471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581471, url, valid)

proc call*(call_581472: Call_AnalyticsManagementRemarketingAudiencePatch_581457;
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
  var path_581473 = newJObject()
  var query_581474 = newJObject()
  var body_581475 = newJObject()
  add(query_581474, "fields", newJString(fields))
  add(query_581474, "quotaUser", newJString(quotaUser))
  add(query_581474, "alt", newJString(alt))
  add(query_581474, "oauth_token", newJString(oauthToken))
  add(path_581473, "accountId", newJString(accountId))
  add(query_581474, "userIp", newJString(userIp))
  add(path_581473, "webPropertyId", newJString(webPropertyId))
  add(query_581474, "key", newJString(key))
  add(path_581473, "remarketingAudienceId", newJString(remarketingAudienceId))
  if body != nil:
    body_581475 = body
  add(query_581474, "prettyPrint", newJBool(prettyPrint))
  result = call_581472.call(path_581473, query_581474, nil, nil, body_581475)

var analyticsManagementRemarketingAudiencePatch* = Call_AnalyticsManagementRemarketingAudiencePatch_581457(
    name: "analyticsManagementRemarketingAudiencePatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudiencePatch_581458,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudiencePatch_581459,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementRemarketingAudienceDelete_581440 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementRemarketingAudienceDelete_581442(protocol: Scheme;
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

proc validate_AnalyticsManagementRemarketingAudienceDelete_581441(path: JsonNode;
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
  var valid_581443 = path.getOrDefault("accountId")
  valid_581443 = validateParameter(valid_581443, JString, required = true,
                                 default = nil)
  if valid_581443 != nil:
    section.add "accountId", valid_581443
  var valid_581444 = path.getOrDefault("webPropertyId")
  valid_581444 = validateParameter(valid_581444, JString, required = true,
                                 default = nil)
  if valid_581444 != nil:
    section.add "webPropertyId", valid_581444
  var valid_581445 = path.getOrDefault("remarketingAudienceId")
  valid_581445 = validateParameter(valid_581445, JString, required = true,
                                 default = nil)
  if valid_581445 != nil:
    section.add "remarketingAudienceId", valid_581445
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
  var valid_581446 = query.getOrDefault("fields")
  valid_581446 = validateParameter(valid_581446, JString, required = false,
                                 default = nil)
  if valid_581446 != nil:
    section.add "fields", valid_581446
  var valid_581447 = query.getOrDefault("quotaUser")
  valid_581447 = validateParameter(valid_581447, JString, required = false,
                                 default = nil)
  if valid_581447 != nil:
    section.add "quotaUser", valid_581447
  var valid_581448 = query.getOrDefault("alt")
  valid_581448 = validateParameter(valid_581448, JString, required = false,
                                 default = newJString("json"))
  if valid_581448 != nil:
    section.add "alt", valid_581448
  var valid_581449 = query.getOrDefault("oauth_token")
  valid_581449 = validateParameter(valid_581449, JString, required = false,
                                 default = nil)
  if valid_581449 != nil:
    section.add "oauth_token", valid_581449
  var valid_581450 = query.getOrDefault("userIp")
  valid_581450 = validateParameter(valid_581450, JString, required = false,
                                 default = nil)
  if valid_581450 != nil:
    section.add "userIp", valid_581450
  var valid_581451 = query.getOrDefault("key")
  valid_581451 = validateParameter(valid_581451, JString, required = false,
                                 default = nil)
  if valid_581451 != nil:
    section.add "key", valid_581451
  var valid_581452 = query.getOrDefault("prettyPrint")
  valid_581452 = validateParameter(valid_581452, JBool, required = false,
                                 default = newJBool(false))
  if valid_581452 != nil:
    section.add "prettyPrint", valid_581452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581453: Call_AnalyticsManagementRemarketingAudienceDelete_581440;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Delete a remarketing audience.
  ## 
  let valid = call_581453.validator(path, query, header, formData, body)
  let scheme = call_581453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581453.url(scheme.get, call_581453.host, call_581453.base,
                         call_581453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581453, url, valid)

proc call*(call_581454: Call_AnalyticsManagementRemarketingAudienceDelete_581440;
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
  var path_581455 = newJObject()
  var query_581456 = newJObject()
  add(query_581456, "fields", newJString(fields))
  add(query_581456, "quotaUser", newJString(quotaUser))
  add(query_581456, "alt", newJString(alt))
  add(query_581456, "oauth_token", newJString(oauthToken))
  add(path_581455, "accountId", newJString(accountId))
  add(query_581456, "userIp", newJString(userIp))
  add(path_581455, "webPropertyId", newJString(webPropertyId))
  add(query_581456, "key", newJString(key))
  add(path_581455, "remarketingAudienceId", newJString(remarketingAudienceId))
  add(query_581456, "prettyPrint", newJBool(prettyPrint))
  result = call_581454.call(path_581455, query_581456, nil, nil, nil)

var analyticsManagementRemarketingAudienceDelete* = Call_AnalyticsManagementRemarketingAudienceDelete_581440(
    name: "analyticsManagementRemarketingAudienceDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/remarketingAudiences/{remarketingAudienceId}",
    validator: validate_AnalyticsManagementRemarketingAudienceDelete_581441,
    base: "/analytics/v3", url: url_AnalyticsManagementRemarketingAudienceDelete_581442,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementClientIdHashClientId_581476 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementClientIdHashClientId_581478(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementClientIdHashClientId_581477(path: JsonNode;
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
  var valid_581479 = query.getOrDefault("fields")
  valid_581479 = validateParameter(valid_581479, JString, required = false,
                                 default = nil)
  if valid_581479 != nil:
    section.add "fields", valid_581479
  var valid_581480 = query.getOrDefault("quotaUser")
  valid_581480 = validateParameter(valid_581480, JString, required = false,
                                 default = nil)
  if valid_581480 != nil:
    section.add "quotaUser", valid_581480
  var valid_581481 = query.getOrDefault("alt")
  valid_581481 = validateParameter(valid_581481, JString, required = false,
                                 default = newJString("json"))
  if valid_581481 != nil:
    section.add "alt", valid_581481
  var valid_581482 = query.getOrDefault("oauth_token")
  valid_581482 = validateParameter(valid_581482, JString, required = false,
                                 default = nil)
  if valid_581482 != nil:
    section.add "oauth_token", valid_581482
  var valid_581483 = query.getOrDefault("userIp")
  valid_581483 = validateParameter(valid_581483, JString, required = false,
                                 default = nil)
  if valid_581483 != nil:
    section.add "userIp", valid_581483
  var valid_581484 = query.getOrDefault("key")
  valid_581484 = validateParameter(valid_581484, JString, required = false,
                                 default = nil)
  if valid_581484 != nil:
    section.add "key", valid_581484
  var valid_581485 = query.getOrDefault("prettyPrint")
  valid_581485 = validateParameter(valid_581485, JBool, required = false,
                                 default = newJBool(false))
  if valid_581485 != nil:
    section.add "prettyPrint", valid_581485
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

proc call*(call_581487: Call_AnalyticsManagementClientIdHashClientId_581476;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Hashes the given Client ID.
  ## 
  let valid = call_581487.validator(path, query, header, formData, body)
  let scheme = call_581487.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581487.url(scheme.get, call_581487.host, call_581487.base,
                         call_581487.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581487, url, valid)

proc call*(call_581488: Call_AnalyticsManagementClientIdHashClientId_581476;
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
  var query_581489 = newJObject()
  var body_581490 = newJObject()
  add(query_581489, "fields", newJString(fields))
  add(query_581489, "quotaUser", newJString(quotaUser))
  add(query_581489, "alt", newJString(alt))
  add(query_581489, "oauth_token", newJString(oauthToken))
  add(query_581489, "userIp", newJString(userIp))
  add(query_581489, "key", newJString(key))
  if body != nil:
    body_581490 = body
  add(query_581489, "prettyPrint", newJBool(prettyPrint))
  result = call_581488.call(nil, query_581489, nil, nil, body_581490)

var analyticsManagementClientIdHashClientId* = Call_AnalyticsManagementClientIdHashClientId_581476(
    name: "analyticsManagementClientIdHashClientId", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/management/clientId:hashClientId",
    validator: validate_AnalyticsManagementClientIdHashClientId_581477,
    base: "/analytics/v3", url: url_AnalyticsManagementClientIdHashClientId_581478,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementSegmentsList_581491 = ref object of OpenApiRestCall_579437
proc url_AnalyticsManagementSegmentsList_581493(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementSegmentsList_581492(path: JsonNode;
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
  var valid_581494 = query.getOrDefault("fields")
  valid_581494 = validateParameter(valid_581494, JString, required = false,
                                 default = nil)
  if valid_581494 != nil:
    section.add "fields", valid_581494
  var valid_581495 = query.getOrDefault("quotaUser")
  valid_581495 = validateParameter(valid_581495, JString, required = false,
                                 default = nil)
  if valid_581495 != nil:
    section.add "quotaUser", valid_581495
  var valid_581496 = query.getOrDefault("alt")
  valid_581496 = validateParameter(valid_581496, JString, required = false,
                                 default = newJString("json"))
  if valid_581496 != nil:
    section.add "alt", valid_581496
  var valid_581497 = query.getOrDefault("oauth_token")
  valid_581497 = validateParameter(valid_581497, JString, required = false,
                                 default = nil)
  if valid_581497 != nil:
    section.add "oauth_token", valid_581497
  var valid_581498 = query.getOrDefault("userIp")
  valid_581498 = validateParameter(valid_581498, JString, required = false,
                                 default = nil)
  if valid_581498 != nil:
    section.add "userIp", valid_581498
  var valid_581499 = query.getOrDefault("key")
  valid_581499 = validateParameter(valid_581499, JString, required = false,
                                 default = nil)
  if valid_581499 != nil:
    section.add "key", valid_581499
  var valid_581500 = query.getOrDefault("max-results")
  valid_581500 = validateParameter(valid_581500, JInt, required = false, default = nil)
  if valid_581500 != nil:
    section.add "max-results", valid_581500
  var valid_581501 = query.getOrDefault("start-index")
  valid_581501 = validateParameter(valid_581501, JInt, required = false, default = nil)
  if valid_581501 != nil:
    section.add "start-index", valid_581501
  var valid_581502 = query.getOrDefault("prettyPrint")
  valid_581502 = validateParameter(valid_581502, JBool, required = false,
                                 default = newJBool(false))
  if valid_581502 != nil:
    section.add "prettyPrint", valid_581502
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581503: Call_AnalyticsManagementSegmentsList_581491;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists segments to which the user has access.
  ## 
  let valid = call_581503.validator(path, query, header, formData, body)
  let scheme = call_581503.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581503.url(scheme.get, call_581503.host, call_581503.base,
                         call_581503.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581503, url, valid)

proc call*(call_581504: Call_AnalyticsManagementSegmentsList_581491;
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
  var query_581505 = newJObject()
  add(query_581505, "fields", newJString(fields))
  add(query_581505, "quotaUser", newJString(quotaUser))
  add(query_581505, "alt", newJString(alt))
  add(query_581505, "oauth_token", newJString(oauthToken))
  add(query_581505, "userIp", newJString(userIp))
  add(query_581505, "key", newJString(key))
  add(query_581505, "max-results", newJInt(maxResults))
  add(query_581505, "start-index", newJInt(startIndex))
  add(query_581505, "prettyPrint", newJBool(prettyPrint))
  result = call_581504.call(nil, query_581505, nil, nil, nil)

var analyticsManagementSegmentsList* = Call_AnalyticsManagementSegmentsList_581491(
    name: "analyticsManagementSegmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/segments",
    validator: validate_AnalyticsManagementSegmentsList_581492,
    base: "/analytics/v3", url: url_AnalyticsManagementSegmentsList_581493,
    schemes: {Scheme.Https})
type
  Call_AnalyticsMetadataColumnsList_581506 = ref object of OpenApiRestCall_579437
proc url_AnalyticsMetadataColumnsList_581508(protocol: Scheme; host: string;
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

proc validate_AnalyticsMetadataColumnsList_581507(path: JsonNode; query: JsonNode;
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
  var valid_581509 = path.getOrDefault("reportType")
  valid_581509 = validateParameter(valid_581509, JString, required = true,
                                 default = nil)
  if valid_581509 != nil:
    section.add "reportType", valid_581509
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
  var valid_581510 = query.getOrDefault("fields")
  valid_581510 = validateParameter(valid_581510, JString, required = false,
                                 default = nil)
  if valid_581510 != nil:
    section.add "fields", valid_581510
  var valid_581511 = query.getOrDefault("quotaUser")
  valid_581511 = validateParameter(valid_581511, JString, required = false,
                                 default = nil)
  if valid_581511 != nil:
    section.add "quotaUser", valid_581511
  var valid_581512 = query.getOrDefault("alt")
  valid_581512 = validateParameter(valid_581512, JString, required = false,
                                 default = newJString("json"))
  if valid_581512 != nil:
    section.add "alt", valid_581512
  var valid_581513 = query.getOrDefault("oauth_token")
  valid_581513 = validateParameter(valid_581513, JString, required = false,
                                 default = nil)
  if valid_581513 != nil:
    section.add "oauth_token", valid_581513
  var valid_581514 = query.getOrDefault("userIp")
  valid_581514 = validateParameter(valid_581514, JString, required = false,
                                 default = nil)
  if valid_581514 != nil:
    section.add "userIp", valid_581514
  var valid_581515 = query.getOrDefault("key")
  valid_581515 = validateParameter(valid_581515, JString, required = false,
                                 default = nil)
  if valid_581515 != nil:
    section.add "key", valid_581515
  var valid_581516 = query.getOrDefault("prettyPrint")
  valid_581516 = validateParameter(valid_581516, JBool, required = false,
                                 default = newJBool(false))
  if valid_581516 != nil:
    section.add "prettyPrint", valid_581516
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581517: Call_AnalyticsMetadataColumnsList_581506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all columns for a report type
  ## 
  let valid = call_581517.validator(path, query, header, formData, body)
  let scheme = call_581517.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581517.url(scheme.get, call_581517.host, call_581517.base,
                         call_581517.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581517, url, valid)

proc call*(call_581518: Call_AnalyticsMetadataColumnsList_581506;
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
  var path_581519 = newJObject()
  var query_581520 = newJObject()
  add(query_581520, "fields", newJString(fields))
  add(query_581520, "quotaUser", newJString(quotaUser))
  add(query_581520, "alt", newJString(alt))
  add(query_581520, "oauth_token", newJString(oauthToken))
  add(query_581520, "userIp", newJString(userIp))
  add(query_581520, "key", newJString(key))
  add(path_581519, "reportType", newJString(reportType))
  add(query_581520, "prettyPrint", newJBool(prettyPrint))
  result = call_581518.call(path_581519, query_581520, nil, nil, nil)

var analyticsMetadataColumnsList* = Call_AnalyticsMetadataColumnsList_581506(
    name: "analyticsMetadataColumnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/metadata/{reportType}/columns",
    validator: validate_AnalyticsMetadataColumnsList_581507,
    base: "/analytics/v3", url: url_AnalyticsMetadataColumnsList_581508,
    schemes: {Scheme.Https})
type
  Call_AnalyticsProvisioningCreateAccountTicket_581521 = ref object of OpenApiRestCall_579437
proc url_AnalyticsProvisioningCreateAccountTicket_581523(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsProvisioningCreateAccountTicket_581522(path: JsonNode;
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
  var valid_581524 = query.getOrDefault("fields")
  valid_581524 = validateParameter(valid_581524, JString, required = false,
                                 default = nil)
  if valid_581524 != nil:
    section.add "fields", valid_581524
  var valid_581525 = query.getOrDefault("quotaUser")
  valid_581525 = validateParameter(valid_581525, JString, required = false,
                                 default = nil)
  if valid_581525 != nil:
    section.add "quotaUser", valid_581525
  var valid_581526 = query.getOrDefault("alt")
  valid_581526 = validateParameter(valid_581526, JString, required = false,
                                 default = newJString("json"))
  if valid_581526 != nil:
    section.add "alt", valid_581526
  var valid_581527 = query.getOrDefault("oauth_token")
  valid_581527 = validateParameter(valid_581527, JString, required = false,
                                 default = nil)
  if valid_581527 != nil:
    section.add "oauth_token", valid_581527
  var valid_581528 = query.getOrDefault("userIp")
  valid_581528 = validateParameter(valid_581528, JString, required = false,
                                 default = nil)
  if valid_581528 != nil:
    section.add "userIp", valid_581528
  var valid_581529 = query.getOrDefault("key")
  valid_581529 = validateParameter(valid_581529, JString, required = false,
                                 default = nil)
  if valid_581529 != nil:
    section.add "key", valid_581529
  var valid_581530 = query.getOrDefault("prettyPrint")
  valid_581530 = validateParameter(valid_581530, JBool, required = false,
                                 default = newJBool(false))
  if valid_581530 != nil:
    section.add "prettyPrint", valid_581530
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

proc call*(call_581532: Call_AnalyticsProvisioningCreateAccountTicket_581521;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an account ticket.
  ## 
  let valid = call_581532.validator(path, query, header, formData, body)
  let scheme = call_581532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581532.url(scheme.get, call_581532.host, call_581532.base,
                         call_581532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581532, url, valid)

proc call*(call_581533: Call_AnalyticsProvisioningCreateAccountTicket_581521;
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
  var query_581534 = newJObject()
  var body_581535 = newJObject()
  add(query_581534, "fields", newJString(fields))
  add(query_581534, "quotaUser", newJString(quotaUser))
  add(query_581534, "alt", newJString(alt))
  add(query_581534, "oauth_token", newJString(oauthToken))
  add(query_581534, "userIp", newJString(userIp))
  add(query_581534, "key", newJString(key))
  if body != nil:
    body_581535 = body
  add(query_581534, "prettyPrint", newJBool(prettyPrint))
  result = call_581533.call(nil, query_581534, nil, nil, body_581535)

var analyticsProvisioningCreateAccountTicket* = Call_AnalyticsProvisioningCreateAccountTicket_581521(
    name: "analyticsProvisioningCreateAccountTicket", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/provisioning/createAccountTicket",
    validator: validate_AnalyticsProvisioningCreateAccountTicket_581522,
    base: "/analytics/v3", url: url_AnalyticsProvisioningCreateAccountTicket_581523,
    schemes: {Scheme.Https})
type
  Call_AnalyticsProvisioningCreateAccountTree_581536 = ref object of OpenApiRestCall_579437
proc url_AnalyticsProvisioningCreateAccountTree_581538(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsProvisioningCreateAccountTree_581537(path: JsonNode;
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
  var valid_581539 = query.getOrDefault("fields")
  valid_581539 = validateParameter(valid_581539, JString, required = false,
                                 default = nil)
  if valid_581539 != nil:
    section.add "fields", valid_581539
  var valid_581540 = query.getOrDefault("quotaUser")
  valid_581540 = validateParameter(valid_581540, JString, required = false,
                                 default = nil)
  if valid_581540 != nil:
    section.add "quotaUser", valid_581540
  var valid_581541 = query.getOrDefault("alt")
  valid_581541 = validateParameter(valid_581541, JString, required = false,
                                 default = newJString("json"))
  if valid_581541 != nil:
    section.add "alt", valid_581541
  var valid_581542 = query.getOrDefault("oauth_token")
  valid_581542 = validateParameter(valid_581542, JString, required = false,
                                 default = nil)
  if valid_581542 != nil:
    section.add "oauth_token", valid_581542
  var valid_581543 = query.getOrDefault("userIp")
  valid_581543 = validateParameter(valid_581543, JString, required = false,
                                 default = nil)
  if valid_581543 != nil:
    section.add "userIp", valid_581543
  var valid_581544 = query.getOrDefault("key")
  valid_581544 = validateParameter(valid_581544, JString, required = false,
                                 default = nil)
  if valid_581544 != nil:
    section.add "key", valid_581544
  var valid_581545 = query.getOrDefault("prettyPrint")
  valid_581545 = validateParameter(valid_581545, JBool, required = false,
                                 default = newJBool(false))
  if valid_581545 != nil:
    section.add "prettyPrint", valid_581545
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

proc call*(call_581547: Call_AnalyticsProvisioningCreateAccountTree_581536;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Provision account.
  ## 
  let valid = call_581547.validator(path, query, header, formData, body)
  let scheme = call_581547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581547.url(scheme.get, call_581547.host, call_581547.base,
                         call_581547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581547, url, valid)

proc call*(call_581548: Call_AnalyticsProvisioningCreateAccountTree_581536;
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
  var query_581549 = newJObject()
  var body_581550 = newJObject()
  add(query_581549, "fields", newJString(fields))
  add(query_581549, "quotaUser", newJString(quotaUser))
  add(query_581549, "alt", newJString(alt))
  add(query_581549, "oauth_token", newJString(oauthToken))
  add(query_581549, "userIp", newJString(userIp))
  add(query_581549, "key", newJString(key))
  if body != nil:
    body_581550 = body
  add(query_581549, "prettyPrint", newJBool(prettyPrint))
  result = call_581548.call(nil, query_581549, nil, nil, body_581550)

var analyticsProvisioningCreateAccountTree* = Call_AnalyticsProvisioningCreateAccountTree_581536(
    name: "analyticsProvisioningCreateAccountTree", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/provisioning/createAccountTree",
    validator: validate_AnalyticsProvisioningCreateAccountTree_581537,
    base: "/analytics/v3", url: url_AnalyticsProvisioningCreateAccountTree_581538,
    schemes: {Scheme.Https})
type
  Call_AnalyticsUserDeletionUserDeletionRequestUpsert_581551 = ref object of OpenApiRestCall_579437
proc url_AnalyticsUserDeletionUserDeletionRequestUpsert_581553(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsUserDeletionUserDeletionRequestUpsert_581552(
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
  var valid_581554 = query.getOrDefault("fields")
  valid_581554 = validateParameter(valid_581554, JString, required = false,
                                 default = nil)
  if valid_581554 != nil:
    section.add "fields", valid_581554
  var valid_581555 = query.getOrDefault("quotaUser")
  valid_581555 = validateParameter(valid_581555, JString, required = false,
                                 default = nil)
  if valid_581555 != nil:
    section.add "quotaUser", valid_581555
  var valid_581556 = query.getOrDefault("alt")
  valid_581556 = validateParameter(valid_581556, JString, required = false,
                                 default = newJString("json"))
  if valid_581556 != nil:
    section.add "alt", valid_581556
  var valid_581557 = query.getOrDefault("oauth_token")
  valid_581557 = validateParameter(valid_581557, JString, required = false,
                                 default = nil)
  if valid_581557 != nil:
    section.add "oauth_token", valid_581557
  var valid_581558 = query.getOrDefault("userIp")
  valid_581558 = validateParameter(valid_581558, JString, required = false,
                                 default = nil)
  if valid_581558 != nil:
    section.add "userIp", valid_581558
  var valid_581559 = query.getOrDefault("key")
  valid_581559 = validateParameter(valid_581559, JString, required = false,
                                 default = nil)
  if valid_581559 != nil:
    section.add "key", valid_581559
  var valid_581560 = query.getOrDefault("prettyPrint")
  valid_581560 = validateParameter(valid_581560, JBool, required = false,
                                 default = newJBool(false))
  if valid_581560 != nil:
    section.add "prettyPrint", valid_581560
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

proc call*(call_581562: Call_AnalyticsUserDeletionUserDeletionRequestUpsert_581551;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Insert or update a user deletion requests.
  ## 
  let valid = call_581562.validator(path, query, header, formData, body)
  let scheme = call_581562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581562.url(scheme.get, call_581562.host, call_581562.base,
                         call_581562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581562, url, valid)

proc call*(call_581563: Call_AnalyticsUserDeletionUserDeletionRequestUpsert_581551;
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
  var query_581564 = newJObject()
  var body_581565 = newJObject()
  add(query_581564, "fields", newJString(fields))
  add(query_581564, "quotaUser", newJString(quotaUser))
  add(query_581564, "alt", newJString(alt))
  add(query_581564, "oauth_token", newJString(oauthToken))
  add(query_581564, "userIp", newJString(userIp))
  add(query_581564, "key", newJString(key))
  if body != nil:
    body_581565 = body
  add(query_581564, "prettyPrint", newJBool(prettyPrint))
  result = call_581563.call(nil, query_581564, nil, nil, body_581565)

var analyticsUserDeletionUserDeletionRequestUpsert* = Call_AnalyticsUserDeletionUserDeletionRequestUpsert_581551(
    name: "analyticsUserDeletionUserDeletionRequestUpsert",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/userDeletion/userDeletionRequests:upsert",
    validator: validate_AnalyticsUserDeletionUserDeletionRequestUpsert_581552,
    base: "/analytics/v3",
    url: url_AnalyticsUserDeletionUserDeletionRequestUpsert_581553,
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
