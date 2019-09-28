
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Analytics
## version: v2.4
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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
  Call_AnalyticsDataGet_579693 = ref object of OpenApiRestCall_579424
proc url_AnalyticsDataGet_579695(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsDataGet_579694(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Returns Analytics report data for a view (profile).
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
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for the report data.
  ##   segment: JString
  ##          : An Analytics advanced segment to be applied to the report data.
  ##   metrics: JString (required)
  ##          : A comma-separated list of Analytics metrics. E.g., 'ga:sessions,ga:pageviews'. At least one metric must be specified to retrieve a valid Analytics report.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: JString
  ##             : A comma-separated list of Analytics dimensions. E.g., 'ga:browser,ga:city'.
  ##   ids: JString (required)
  ##      : Unique table ID for retrieving report data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : The maximum number of entries to include in this feed.
  ##   end-date: JString (required)
  ##           : End date for fetching report data. All requests should specify an end date formatted as YYYY-MM-DD.
  ##   start-date: JString (required)
  ##             : Start date for fetching report data. All requests should specify a start date formatted as YYYY-MM-DD.
  ##   filters: JString
  ##          : A comma-separated list of dimension or metric filters to be applied to the report data.
  ##   start-index: JInt
  ##              : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("atom"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("sort")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "sort", valid_579823
  var valid_579824 = query.getOrDefault("segment")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "segment", valid_579824
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_579825 = query.getOrDefault("metrics")
  valid_579825 = validateParameter(valid_579825, JString, required = true,
                                 default = nil)
  if valid_579825 != nil:
    section.add "metrics", valid_579825
  var valid_579826 = query.getOrDefault("oauth_token")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "oauth_token", valid_579826
  var valid_579827 = query.getOrDefault("userIp")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "userIp", valid_579827
  var valid_579828 = query.getOrDefault("dimensions")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "dimensions", valid_579828
  var valid_579829 = query.getOrDefault("ids")
  valid_579829 = validateParameter(valid_579829, JString, required = true,
                                 default = nil)
  if valid_579829 != nil:
    section.add "ids", valid_579829
  var valid_579830 = query.getOrDefault("key")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "key", valid_579830
  var valid_579831 = query.getOrDefault("max-results")
  valid_579831 = validateParameter(valid_579831, JInt, required = false, default = nil)
  if valid_579831 != nil:
    section.add "max-results", valid_579831
  var valid_579832 = query.getOrDefault("end-date")
  valid_579832 = validateParameter(valid_579832, JString, required = true,
                                 default = nil)
  if valid_579832 != nil:
    section.add "end-date", valid_579832
  var valid_579833 = query.getOrDefault("start-date")
  valid_579833 = validateParameter(valid_579833, JString, required = true,
                                 default = nil)
  if valid_579833 != nil:
    section.add "start-date", valid_579833
  var valid_579834 = query.getOrDefault("filters")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = nil)
  if valid_579834 != nil:
    section.add "filters", valid_579834
  var valid_579835 = query.getOrDefault("start-index")
  valid_579835 = validateParameter(valid_579835, JInt, required = false, default = nil)
  if valid_579835 != nil:
    section.add "start-index", valid_579835
  var valid_579836 = query.getOrDefault("prettyPrint")
  valid_579836 = validateParameter(valid_579836, JBool, required = false,
                                 default = newJBool(false))
  if valid_579836 != nil:
    section.add "prettyPrint", valid_579836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579859: Call_AnalyticsDataGet_579693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Analytics report data for a view (profile).
  ## 
  let valid = call_579859.validator(path, query, header, formData, body)
  let scheme = call_579859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579859.url(scheme.get, call_579859.host, call_579859.base,
                         call_579859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579859, url, valid)

proc call*(call_579930: Call_AnalyticsDataGet_579693; metrics: string; ids: string;
          endDate: string; startDate: string; fields: string = "";
          quotaUser: string = ""; alt: string = "atom"; sort: string = "";
          segment: string = ""; oauthToken: string = ""; userIp: string = "";
          dimensions: string = ""; key: string = ""; maxResults: int = 0;
          filters: string = ""; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsDataGet
  ## Returns Analytics report data for a view (profile).
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort order for the report data.
  ##   segment: string
  ##          : An Analytics advanced segment to be applied to the report data.
  ##   metrics: string (required)
  ##          : A comma-separated list of Analytics metrics. E.g., 'ga:sessions,ga:pageviews'. At least one metric must be specified to retrieve a valid Analytics report.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   dimensions: string
  ##             : A comma-separated list of Analytics dimensions. E.g., 'ga:browser,ga:city'.
  ##   ids: string (required)
  ##      : Unique table ID for retrieving report data. Table ID is of the form ga:XXXX, where XXXX is the Analytics view (profile) ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : The maximum number of entries to include in this feed.
  ##   endDate: string (required)
  ##          : End date for fetching report data. All requests should specify an end date formatted as YYYY-MM-DD.
  ##   startDate: string (required)
  ##            : Start date for fetching report data. All requests should specify a start date formatted as YYYY-MM-DD.
  ##   filters: string
  ##          : A comma-separated list of dimension or metric filters to be applied to the report data.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579931 = newJObject()
  add(query_579931, "fields", newJString(fields))
  add(query_579931, "quotaUser", newJString(quotaUser))
  add(query_579931, "alt", newJString(alt))
  add(query_579931, "sort", newJString(sort))
  add(query_579931, "segment", newJString(segment))
  add(query_579931, "metrics", newJString(metrics))
  add(query_579931, "oauth_token", newJString(oauthToken))
  add(query_579931, "userIp", newJString(userIp))
  add(query_579931, "dimensions", newJString(dimensions))
  add(query_579931, "ids", newJString(ids))
  add(query_579931, "key", newJString(key))
  add(query_579931, "max-results", newJInt(maxResults))
  add(query_579931, "end-date", newJString(endDate))
  add(query_579931, "start-date", newJString(startDate))
  add(query_579931, "filters", newJString(filters))
  add(query_579931, "start-index", newJInt(startIndex))
  add(query_579931, "prettyPrint", newJBool(prettyPrint))
  result = call_579930.call(nil, query_579931, nil, nil, nil)

var analyticsDataGet* = Call_AnalyticsDataGet_579693(name: "analyticsDataGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/data",
    validator: validate_AnalyticsDataGet_579694, base: "/analytics/v2.4",
    url: url_AnalyticsDataGet_579695, schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountsList_579971 = ref object of OpenApiRestCall_579424
proc url_AnalyticsManagementAccountsList_579973(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementAccountsList_579972(path: JsonNode;
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
  var valid_579974 = query.getOrDefault("fields")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "fields", valid_579974
  var valid_579975 = query.getOrDefault("quotaUser")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "quotaUser", valid_579975
  var valid_579976 = query.getOrDefault("alt")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = newJString("atom"))
  if valid_579976 != nil:
    section.add "alt", valid_579976
  var valid_579977 = query.getOrDefault("oauth_token")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "oauth_token", valid_579977
  var valid_579978 = query.getOrDefault("userIp")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "userIp", valid_579978
  var valid_579979 = query.getOrDefault("key")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "key", valid_579979
  var valid_579980 = query.getOrDefault("max-results")
  valid_579980 = validateParameter(valid_579980, JInt, required = false, default = nil)
  if valid_579980 != nil:
    section.add "max-results", valid_579980
  var valid_579981 = query.getOrDefault("start-index")
  valid_579981 = validateParameter(valid_579981, JInt, required = false, default = nil)
  if valid_579981 != nil:
    section.add "start-index", valid_579981
  var valid_579982 = query.getOrDefault("prettyPrint")
  valid_579982 = validateParameter(valid_579982, JBool, required = false,
                                 default = newJBool(false))
  if valid_579982 != nil:
    section.add "prettyPrint", valid_579982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579983: Call_AnalyticsManagementAccountsList_579971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all accounts to which the user has access.
  ## 
  let valid = call_579983.validator(path, query, header, formData, body)
  let scheme = call_579983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579983.url(scheme.get, call_579983.host, call_579983.base,
                         call_579983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579983, url, valid)

proc call*(call_579984: Call_AnalyticsManagementAccountsList_579971;
          fields: string = ""; quotaUser: string = ""; alt: string = "atom";
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
  var query_579985 = newJObject()
  add(query_579985, "fields", newJString(fields))
  add(query_579985, "quotaUser", newJString(quotaUser))
  add(query_579985, "alt", newJString(alt))
  add(query_579985, "oauth_token", newJString(oauthToken))
  add(query_579985, "userIp", newJString(userIp))
  add(query_579985, "key", newJString(key))
  add(query_579985, "max-results", newJInt(maxResults))
  add(query_579985, "start-index", newJInt(startIndex))
  add(query_579985, "prettyPrint", newJBool(prettyPrint))
  result = call_579984.call(nil, query_579985, nil, nil, nil)

var analyticsManagementAccountsList* = Call_AnalyticsManagementAccountsList_579971(
    name: "analyticsManagementAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts",
    validator: validate_AnalyticsManagementAccountsList_579972,
    base: "/analytics/v2.4", url: url_AnalyticsManagementAccountsList_579973,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesList_579986 = ref object of OpenApiRestCall_579424
proc url_AnalyticsManagementWebpropertiesList_579988(protocol: Scheme;
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

proc validate_AnalyticsManagementWebpropertiesList_579987(path: JsonNode;
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
  var valid_580003 = path.getOrDefault("accountId")
  valid_580003 = validateParameter(valid_580003, JString, required = true,
                                 default = nil)
  if valid_580003 != nil:
    section.add "accountId", valid_580003
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
  var valid_580004 = query.getOrDefault("fields")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "fields", valid_580004
  var valid_580005 = query.getOrDefault("quotaUser")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "quotaUser", valid_580005
  var valid_580006 = query.getOrDefault("alt")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = newJString("atom"))
  if valid_580006 != nil:
    section.add "alt", valid_580006
  var valid_580007 = query.getOrDefault("oauth_token")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "oauth_token", valid_580007
  var valid_580008 = query.getOrDefault("userIp")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "userIp", valid_580008
  var valid_580009 = query.getOrDefault("key")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "key", valid_580009
  var valid_580010 = query.getOrDefault("max-results")
  valid_580010 = validateParameter(valid_580010, JInt, required = false, default = nil)
  if valid_580010 != nil:
    section.add "max-results", valid_580010
  var valid_580011 = query.getOrDefault("start-index")
  valid_580011 = validateParameter(valid_580011, JInt, required = false, default = nil)
  if valid_580011 != nil:
    section.add "start-index", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(false))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580013: Call_AnalyticsManagementWebpropertiesList_579986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists web properties to which the user has access.
  ## 
  let valid = call_580013.validator(path, query, header, formData, body)
  let scheme = call_580013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580013.url(scheme.get, call_580013.host, call_580013.base,
                         call_580013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580013, url, valid)

proc call*(call_580014: Call_AnalyticsManagementWebpropertiesList_579986;
          accountId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "atom"; oauthToken: string = ""; userIp: string = "";
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
  var path_580015 = newJObject()
  var query_580016 = newJObject()
  add(query_580016, "fields", newJString(fields))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(query_580016, "alt", newJString(alt))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(path_580015, "accountId", newJString(accountId))
  add(query_580016, "userIp", newJString(userIp))
  add(query_580016, "key", newJString(key))
  add(query_580016, "max-results", newJInt(maxResults))
  add(query_580016, "start-index", newJInt(startIndex))
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  result = call_580014.call(path_580015, query_580016, nil, nil, nil)

var analyticsManagementWebpropertiesList* = Call_AnalyticsManagementWebpropertiesList_579986(
    name: "analyticsManagementWebpropertiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties",
    validator: validate_AnalyticsManagementWebpropertiesList_579987,
    base: "/analytics/v2.4", url: url_AnalyticsManagementWebpropertiesList_579988,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesList_580017 = ref object of OpenApiRestCall_579424
proc url_AnalyticsManagementProfilesList_580019(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementProfilesList_580018(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists views (profiles) to which the user has access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   accountId: JString (required)
  ##            : Account ID for the views (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts to which the user has access.
  ##   webPropertyId: JString (required)
  ##                : Web property ID for the views (profiles) to retrieve. Can either be a specific web property ID or '~all', which refers to all the web properties to which the user has access.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `accountId` field"
  var valid_580020 = path.getOrDefault("accountId")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "accountId", valid_580020
  var valid_580021 = path.getOrDefault("webPropertyId")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "webPropertyId", valid_580021
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
  var valid_580022 = query.getOrDefault("fields")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "fields", valid_580022
  var valid_580023 = query.getOrDefault("quotaUser")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "quotaUser", valid_580023
  var valid_580024 = query.getOrDefault("alt")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = newJString("atom"))
  if valid_580024 != nil:
    section.add "alt", valid_580024
  var valid_580025 = query.getOrDefault("oauth_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "oauth_token", valid_580025
  var valid_580026 = query.getOrDefault("userIp")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "userIp", valid_580026
  var valid_580027 = query.getOrDefault("key")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "key", valid_580027
  var valid_580028 = query.getOrDefault("max-results")
  valid_580028 = validateParameter(valid_580028, JInt, required = false, default = nil)
  if valid_580028 != nil:
    section.add "max-results", valid_580028
  var valid_580029 = query.getOrDefault("start-index")
  valid_580029 = validateParameter(valid_580029, JInt, required = false, default = nil)
  if valid_580029 != nil:
    section.add "start-index", valid_580029
  var valid_580030 = query.getOrDefault("prettyPrint")
  valid_580030 = validateParameter(valid_580030, JBool, required = false,
                                 default = newJBool(false))
  if valid_580030 != nil:
    section.add "prettyPrint", valid_580030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580031: Call_AnalyticsManagementProfilesList_580017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists views (profiles) to which the user has access.
  ## 
  let valid = call_580031.validator(path, query, header, formData, body)
  let scheme = call_580031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580031.url(scheme.get, call_580031.host, call_580031.base,
                         call_580031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580031, url, valid)

proc call*(call_580032: Call_AnalyticsManagementProfilesList_580017;
          accountId: string; webPropertyId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "atom"; oauthToken: string = "";
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
  ##            : Account ID for the views (profiles) to retrieve. Can either be a specific account ID or '~all', which refers to all the accounts to which the user has access.
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
  var path_580033 = newJObject()
  var query_580034 = newJObject()
  add(query_580034, "fields", newJString(fields))
  add(query_580034, "quotaUser", newJString(quotaUser))
  add(query_580034, "alt", newJString(alt))
  add(query_580034, "oauth_token", newJString(oauthToken))
  add(path_580033, "accountId", newJString(accountId))
  add(query_580034, "userIp", newJString(userIp))
  add(path_580033, "webPropertyId", newJString(webPropertyId))
  add(query_580034, "key", newJString(key))
  add(query_580034, "max-results", newJInt(maxResults))
  add(query_580034, "start-index", newJInt(startIndex))
  add(query_580034, "prettyPrint", newJBool(prettyPrint))
  result = call_580032.call(path_580033, query_580034, nil, nil, nil)

var analyticsManagementProfilesList* = Call_AnalyticsManagementProfilesList_580017(
    name: "analyticsManagementProfilesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles",
    validator: validate_AnalyticsManagementProfilesList_580018,
    base: "/analytics/v2.4", url: url_AnalyticsManagementProfilesList_580019,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsList_580035 = ref object of OpenApiRestCall_579424
proc url_AnalyticsManagementGoalsList_580037(protocol: Scheme; host: string;
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

proc validate_AnalyticsManagementGoalsList_580036(path: JsonNode; query: JsonNode;
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
  var valid_580038 = path.getOrDefault("profileId")
  valid_580038 = validateParameter(valid_580038, JString, required = true,
                                 default = nil)
  if valid_580038 != nil:
    section.add "profileId", valid_580038
  var valid_580039 = path.getOrDefault("accountId")
  valid_580039 = validateParameter(valid_580039, JString, required = true,
                                 default = nil)
  if valid_580039 != nil:
    section.add "accountId", valid_580039
  var valid_580040 = path.getOrDefault("webPropertyId")
  valid_580040 = validateParameter(valid_580040, JString, required = true,
                                 default = nil)
  if valid_580040 != nil:
    section.add "webPropertyId", valid_580040
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
  var valid_580041 = query.getOrDefault("fields")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "fields", valid_580041
  var valid_580042 = query.getOrDefault("quotaUser")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "quotaUser", valid_580042
  var valid_580043 = query.getOrDefault("alt")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = newJString("atom"))
  if valid_580043 != nil:
    section.add "alt", valid_580043
  var valid_580044 = query.getOrDefault("oauth_token")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "oauth_token", valid_580044
  var valid_580045 = query.getOrDefault("userIp")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "userIp", valid_580045
  var valid_580046 = query.getOrDefault("key")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "key", valid_580046
  var valid_580047 = query.getOrDefault("max-results")
  valid_580047 = validateParameter(valid_580047, JInt, required = false, default = nil)
  if valid_580047 != nil:
    section.add "max-results", valid_580047
  var valid_580048 = query.getOrDefault("start-index")
  valid_580048 = validateParameter(valid_580048, JInt, required = false, default = nil)
  if valid_580048 != nil:
    section.add "start-index", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(false))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580050: Call_AnalyticsManagementGoalsList_580035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists goals to which the user has access.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_AnalyticsManagementGoalsList_580035;
          profileId: string; accountId: string; webPropertyId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "atom";
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
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  add(path_580052, "profileId", newJString(profileId))
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(path_580052, "accountId", newJString(accountId))
  add(query_580053, "userIp", newJString(userIp))
  add(path_580052, "webPropertyId", newJString(webPropertyId))
  add(query_580053, "key", newJString(key))
  add(query_580053, "max-results", newJInt(maxResults))
  add(query_580053, "start-index", newJInt(startIndex))
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  result = call_580051.call(path_580052, query_580053, nil, nil, nil)

var analyticsManagementGoalsList* = Call_AnalyticsManagementGoalsList_580035(
    name: "analyticsManagementGoalsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals",
    validator: validate_AnalyticsManagementGoalsList_580036,
    base: "/analytics/v2.4", url: url_AnalyticsManagementGoalsList_580037,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementSegmentsList_580054 = ref object of OpenApiRestCall_579424
proc url_AnalyticsManagementSegmentsList_580056(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AnalyticsManagementSegmentsList_580055(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists advanced segments to which the user has access.
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
  ##              : The maximum number of advanced segments to include in this response.
  ##   start-index: JInt
  ##              : An index of the first advanced segment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580057 = query.getOrDefault("fields")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "fields", valid_580057
  var valid_580058 = query.getOrDefault("quotaUser")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "quotaUser", valid_580058
  var valid_580059 = query.getOrDefault("alt")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("atom"))
  if valid_580059 != nil:
    section.add "alt", valid_580059
  var valid_580060 = query.getOrDefault("oauth_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "oauth_token", valid_580060
  var valid_580061 = query.getOrDefault("userIp")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "userIp", valid_580061
  var valid_580062 = query.getOrDefault("key")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "key", valid_580062
  var valid_580063 = query.getOrDefault("max-results")
  valid_580063 = validateParameter(valid_580063, JInt, required = false, default = nil)
  if valid_580063 != nil:
    section.add "max-results", valid_580063
  var valid_580064 = query.getOrDefault("start-index")
  valid_580064 = validateParameter(valid_580064, JInt, required = false, default = nil)
  if valid_580064 != nil:
    section.add "start-index", valid_580064
  var valid_580065 = query.getOrDefault("prettyPrint")
  valid_580065 = validateParameter(valid_580065, JBool, required = false,
                                 default = newJBool(false))
  if valid_580065 != nil:
    section.add "prettyPrint", valid_580065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580066: Call_AnalyticsManagementSegmentsList_580054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists advanced segments to which the user has access.
  ## 
  let valid = call_580066.validator(path, query, header, formData, body)
  let scheme = call_580066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580066.url(scheme.get, call_580066.host, call_580066.base,
                         call_580066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580066, url, valid)

proc call*(call_580067: Call_AnalyticsManagementSegmentsList_580054;
          fields: string = ""; quotaUser: string = ""; alt: string = "atom";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          maxResults: int = 0; startIndex: int = 0; prettyPrint: bool = false): Recallable =
  ## analyticsManagementSegmentsList
  ## Lists advanced segments to which the user has access.
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
  ##             : The maximum number of advanced segments to include in this response.
  ##   startIndex: int
  ##             : An index of the first advanced segment to retrieve. Use this parameter as a pagination mechanism along with the max-results parameter.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580068 = newJObject()
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "userIp", newJString(userIp))
  add(query_580068, "key", newJString(key))
  add(query_580068, "max-results", newJInt(maxResults))
  add(query_580068, "start-index", newJInt(startIndex))
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  result = call_580067.call(nil, query_580068, nil, nil, nil)

var analyticsManagementSegmentsList* = Call_AnalyticsManagementSegmentsList_580054(
    name: "analyticsManagementSegmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/segments",
    validator: validate_AnalyticsManagementSegmentsList_580055,
    base: "/analytics/v2.4", url: url_AnalyticsManagementSegmentsList_580056,
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
