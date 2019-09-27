
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_597424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597424): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AnalyticsDataGet_597693 = ref object of OpenApiRestCall_597424
proc url_AnalyticsDataGet_597695(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsDataGet_597694(path: JsonNode; query: JsonNode;
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
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("quotaUser")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "quotaUser", valid_597808
  var valid_597822 = query.getOrDefault("alt")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = newJString("atom"))
  if valid_597822 != nil:
    section.add "alt", valid_597822
  var valid_597823 = query.getOrDefault("sort")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "sort", valid_597823
  var valid_597824 = query.getOrDefault("segment")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "segment", valid_597824
  assert query != nil, "query argument is necessary due to required `metrics` field"
  var valid_597825 = query.getOrDefault("metrics")
  valid_597825 = validateParameter(valid_597825, JString, required = true,
                                 default = nil)
  if valid_597825 != nil:
    section.add "metrics", valid_597825
  var valid_597826 = query.getOrDefault("oauth_token")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "oauth_token", valid_597826
  var valid_597827 = query.getOrDefault("userIp")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "userIp", valid_597827
  var valid_597828 = query.getOrDefault("dimensions")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = nil)
  if valid_597828 != nil:
    section.add "dimensions", valid_597828
  var valid_597829 = query.getOrDefault("ids")
  valid_597829 = validateParameter(valid_597829, JString, required = true,
                                 default = nil)
  if valid_597829 != nil:
    section.add "ids", valid_597829
  var valid_597830 = query.getOrDefault("key")
  valid_597830 = validateParameter(valid_597830, JString, required = false,
                                 default = nil)
  if valid_597830 != nil:
    section.add "key", valid_597830
  var valid_597831 = query.getOrDefault("max-results")
  valid_597831 = validateParameter(valid_597831, JInt, required = false, default = nil)
  if valid_597831 != nil:
    section.add "max-results", valid_597831
  var valid_597832 = query.getOrDefault("end-date")
  valid_597832 = validateParameter(valid_597832, JString, required = true,
                                 default = nil)
  if valid_597832 != nil:
    section.add "end-date", valid_597832
  var valid_597833 = query.getOrDefault("start-date")
  valid_597833 = validateParameter(valid_597833, JString, required = true,
                                 default = nil)
  if valid_597833 != nil:
    section.add "start-date", valid_597833
  var valid_597834 = query.getOrDefault("filters")
  valid_597834 = validateParameter(valid_597834, JString, required = false,
                                 default = nil)
  if valid_597834 != nil:
    section.add "filters", valid_597834
  var valid_597835 = query.getOrDefault("start-index")
  valid_597835 = validateParameter(valid_597835, JInt, required = false, default = nil)
  if valid_597835 != nil:
    section.add "start-index", valid_597835
  var valid_597836 = query.getOrDefault("prettyPrint")
  valid_597836 = validateParameter(valid_597836, JBool, required = false,
                                 default = newJBool(false))
  if valid_597836 != nil:
    section.add "prettyPrint", valid_597836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597859: Call_AnalyticsDataGet_597693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns Analytics report data for a view (profile).
  ## 
  let valid = call_597859.validator(path, query, header, formData, body)
  let scheme = call_597859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597859.url(scheme.get, call_597859.host, call_597859.base,
                         call_597859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597859, url, valid)

proc call*(call_597930: Call_AnalyticsDataGet_597693; metrics: string; ids: string;
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
  var query_597931 = newJObject()
  add(query_597931, "fields", newJString(fields))
  add(query_597931, "quotaUser", newJString(quotaUser))
  add(query_597931, "alt", newJString(alt))
  add(query_597931, "sort", newJString(sort))
  add(query_597931, "segment", newJString(segment))
  add(query_597931, "metrics", newJString(metrics))
  add(query_597931, "oauth_token", newJString(oauthToken))
  add(query_597931, "userIp", newJString(userIp))
  add(query_597931, "dimensions", newJString(dimensions))
  add(query_597931, "ids", newJString(ids))
  add(query_597931, "key", newJString(key))
  add(query_597931, "max-results", newJInt(maxResults))
  add(query_597931, "end-date", newJString(endDate))
  add(query_597931, "start-date", newJString(startDate))
  add(query_597931, "filters", newJString(filters))
  add(query_597931, "start-index", newJInt(startIndex))
  add(query_597931, "prettyPrint", newJBool(prettyPrint))
  result = call_597930.call(nil, query_597931, nil, nil, nil)

var analyticsDataGet* = Call_AnalyticsDataGet_597693(name: "analyticsDataGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/data",
    validator: validate_AnalyticsDataGet_597694, base: "/analytics/v2.4",
    url: url_AnalyticsDataGet_597695, schemes: {Scheme.Https})
type
  Call_AnalyticsManagementAccountsList_597971 = ref object of OpenApiRestCall_597424
proc url_AnalyticsManagementAccountsList_597973(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsManagementAccountsList_597972(path: JsonNode;
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
  var valid_597974 = query.getOrDefault("fields")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "fields", valid_597974
  var valid_597975 = query.getOrDefault("quotaUser")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "quotaUser", valid_597975
  var valid_597976 = query.getOrDefault("alt")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = newJString("atom"))
  if valid_597976 != nil:
    section.add "alt", valid_597976
  var valid_597977 = query.getOrDefault("oauth_token")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "oauth_token", valid_597977
  var valid_597978 = query.getOrDefault("userIp")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "userIp", valid_597978
  var valid_597979 = query.getOrDefault("key")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "key", valid_597979
  var valid_597980 = query.getOrDefault("max-results")
  valid_597980 = validateParameter(valid_597980, JInt, required = false, default = nil)
  if valid_597980 != nil:
    section.add "max-results", valid_597980
  var valid_597981 = query.getOrDefault("start-index")
  valid_597981 = validateParameter(valid_597981, JInt, required = false, default = nil)
  if valid_597981 != nil:
    section.add "start-index", valid_597981
  var valid_597982 = query.getOrDefault("prettyPrint")
  valid_597982 = validateParameter(valid_597982, JBool, required = false,
                                 default = newJBool(false))
  if valid_597982 != nil:
    section.add "prettyPrint", valid_597982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597983: Call_AnalyticsManagementAccountsList_597971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all accounts to which the user has access.
  ## 
  let valid = call_597983.validator(path, query, header, formData, body)
  let scheme = call_597983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597983.url(scheme.get, call_597983.host, call_597983.base,
                         call_597983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597983, url, valid)

proc call*(call_597984: Call_AnalyticsManagementAccountsList_597971;
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
  var query_597985 = newJObject()
  add(query_597985, "fields", newJString(fields))
  add(query_597985, "quotaUser", newJString(quotaUser))
  add(query_597985, "alt", newJString(alt))
  add(query_597985, "oauth_token", newJString(oauthToken))
  add(query_597985, "userIp", newJString(userIp))
  add(query_597985, "key", newJString(key))
  add(query_597985, "max-results", newJInt(maxResults))
  add(query_597985, "start-index", newJInt(startIndex))
  add(query_597985, "prettyPrint", newJBool(prettyPrint))
  result = call_597984.call(nil, query_597985, nil, nil, nil)

var analyticsManagementAccountsList* = Call_AnalyticsManagementAccountsList_597971(
    name: "analyticsManagementAccountsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts",
    validator: validate_AnalyticsManagementAccountsList_597972,
    base: "/analytics/v2.4", url: url_AnalyticsManagementAccountsList_597973,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementWebpropertiesList_597986 = ref object of OpenApiRestCall_597424
proc url_AnalyticsManagementWebpropertiesList_597988(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AnalyticsManagementWebpropertiesList_597987(path: JsonNode;
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
  var valid_598003 = path.getOrDefault("accountId")
  valid_598003 = validateParameter(valid_598003, JString, required = true,
                                 default = nil)
  if valid_598003 != nil:
    section.add "accountId", valid_598003
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
  var valid_598004 = query.getOrDefault("fields")
  valid_598004 = validateParameter(valid_598004, JString, required = false,
                                 default = nil)
  if valid_598004 != nil:
    section.add "fields", valid_598004
  var valid_598005 = query.getOrDefault("quotaUser")
  valid_598005 = validateParameter(valid_598005, JString, required = false,
                                 default = nil)
  if valid_598005 != nil:
    section.add "quotaUser", valid_598005
  var valid_598006 = query.getOrDefault("alt")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = newJString("atom"))
  if valid_598006 != nil:
    section.add "alt", valid_598006
  var valid_598007 = query.getOrDefault("oauth_token")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = nil)
  if valid_598007 != nil:
    section.add "oauth_token", valid_598007
  var valid_598008 = query.getOrDefault("userIp")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = nil)
  if valid_598008 != nil:
    section.add "userIp", valid_598008
  var valid_598009 = query.getOrDefault("key")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "key", valid_598009
  var valid_598010 = query.getOrDefault("max-results")
  valid_598010 = validateParameter(valid_598010, JInt, required = false, default = nil)
  if valid_598010 != nil:
    section.add "max-results", valid_598010
  var valid_598011 = query.getOrDefault("start-index")
  valid_598011 = validateParameter(valid_598011, JInt, required = false, default = nil)
  if valid_598011 != nil:
    section.add "start-index", valid_598011
  var valid_598012 = query.getOrDefault("prettyPrint")
  valid_598012 = validateParameter(valid_598012, JBool, required = false,
                                 default = newJBool(false))
  if valid_598012 != nil:
    section.add "prettyPrint", valid_598012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598013: Call_AnalyticsManagementWebpropertiesList_597986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists web properties to which the user has access.
  ## 
  let valid = call_598013.validator(path, query, header, formData, body)
  let scheme = call_598013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598013.url(scheme.get, call_598013.host, call_598013.base,
                         call_598013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598013, url, valid)

proc call*(call_598014: Call_AnalyticsManagementWebpropertiesList_597986;
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
  var path_598015 = newJObject()
  var query_598016 = newJObject()
  add(query_598016, "fields", newJString(fields))
  add(query_598016, "quotaUser", newJString(quotaUser))
  add(query_598016, "alt", newJString(alt))
  add(query_598016, "oauth_token", newJString(oauthToken))
  add(path_598015, "accountId", newJString(accountId))
  add(query_598016, "userIp", newJString(userIp))
  add(query_598016, "key", newJString(key))
  add(query_598016, "max-results", newJInt(maxResults))
  add(query_598016, "start-index", newJInt(startIndex))
  add(query_598016, "prettyPrint", newJBool(prettyPrint))
  result = call_598014.call(path_598015, query_598016, nil, nil, nil)

var analyticsManagementWebpropertiesList* = Call_AnalyticsManagementWebpropertiesList_597986(
    name: "analyticsManagementWebpropertiesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/management/accounts/{accountId}/webproperties",
    validator: validate_AnalyticsManagementWebpropertiesList_597987,
    base: "/analytics/v2.4", url: url_AnalyticsManagementWebpropertiesList_597988,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementProfilesList_598017 = ref object of OpenApiRestCall_597424
proc url_AnalyticsManagementProfilesList_598019(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AnalyticsManagementProfilesList_598018(path: JsonNode;
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
  var valid_598020 = path.getOrDefault("accountId")
  valid_598020 = validateParameter(valid_598020, JString, required = true,
                                 default = nil)
  if valid_598020 != nil:
    section.add "accountId", valid_598020
  var valid_598021 = path.getOrDefault("webPropertyId")
  valid_598021 = validateParameter(valid_598021, JString, required = true,
                                 default = nil)
  if valid_598021 != nil:
    section.add "webPropertyId", valid_598021
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
  var valid_598022 = query.getOrDefault("fields")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = nil)
  if valid_598022 != nil:
    section.add "fields", valid_598022
  var valid_598023 = query.getOrDefault("quotaUser")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = nil)
  if valid_598023 != nil:
    section.add "quotaUser", valid_598023
  var valid_598024 = query.getOrDefault("alt")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = newJString("atom"))
  if valid_598024 != nil:
    section.add "alt", valid_598024
  var valid_598025 = query.getOrDefault("oauth_token")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = nil)
  if valid_598025 != nil:
    section.add "oauth_token", valid_598025
  var valid_598026 = query.getOrDefault("userIp")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = nil)
  if valid_598026 != nil:
    section.add "userIp", valid_598026
  var valid_598027 = query.getOrDefault("key")
  valid_598027 = validateParameter(valid_598027, JString, required = false,
                                 default = nil)
  if valid_598027 != nil:
    section.add "key", valid_598027
  var valid_598028 = query.getOrDefault("max-results")
  valid_598028 = validateParameter(valid_598028, JInt, required = false, default = nil)
  if valid_598028 != nil:
    section.add "max-results", valid_598028
  var valid_598029 = query.getOrDefault("start-index")
  valid_598029 = validateParameter(valid_598029, JInt, required = false, default = nil)
  if valid_598029 != nil:
    section.add "start-index", valid_598029
  var valid_598030 = query.getOrDefault("prettyPrint")
  valid_598030 = validateParameter(valid_598030, JBool, required = false,
                                 default = newJBool(false))
  if valid_598030 != nil:
    section.add "prettyPrint", valid_598030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598031: Call_AnalyticsManagementProfilesList_598017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists views (profiles) to which the user has access.
  ## 
  let valid = call_598031.validator(path, query, header, formData, body)
  let scheme = call_598031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598031.url(scheme.get, call_598031.host, call_598031.base,
                         call_598031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598031, url, valid)

proc call*(call_598032: Call_AnalyticsManagementProfilesList_598017;
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
  var path_598033 = newJObject()
  var query_598034 = newJObject()
  add(query_598034, "fields", newJString(fields))
  add(query_598034, "quotaUser", newJString(quotaUser))
  add(query_598034, "alt", newJString(alt))
  add(query_598034, "oauth_token", newJString(oauthToken))
  add(path_598033, "accountId", newJString(accountId))
  add(query_598034, "userIp", newJString(userIp))
  add(path_598033, "webPropertyId", newJString(webPropertyId))
  add(query_598034, "key", newJString(key))
  add(query_598034, "max-results", newJInt(maxResults))
  add(query_598034, "start-index", newJInt(startIndex))
  add(query_598034, "prettyPrint", newJBool(prettyPrint))
  result = call_598032.call(path_598033, query_598034, nil, nil, nil)

var analyticsManagementProfilesList* = Call_AnalyticsManagementProfilesList_598017(
    name: "analyticsManagementProfilesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles",
    validator: validate_AnalyticsManagementProfilesList_598018,
    base: "/analytics/v2.4", url: url_AnalyticsManagementProfilesList_598019,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementGoalsList_598035 = ref object of OpenApiRestCall_597424
proc url_AnalyticsManagementGoalsList_598037(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_AnalyticsManagementGoalsList_598036(path: JsonNode; query: JsonNode;
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
  var valid_598038 = path.getOrDefault("profileId")
  valid_598038 = validateParameter(valid_598038, JString, required = true,
                                 default = nil)
  if valid_598038 != nil:
    section.add "profileId", valid_598038
  var valid_598039 = path.getOrDefault("accountId")
  valid_598039 = validateParameter(valid_598039, JString, required = true,
                                 default = nil)
  if valid_598039 != nil:
    section.add "accountId", valid_598039
  var valid_598040 = path.getOrDefault("webPropertyId")
  valid_598040 = validateParameter(valid_598040, JString, required = true,
                                 default = nil)
  if valid_598040 != nil:
    section.add "webPropertyId", valid_598040
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
  var valid_598041 = query.getOrDefault("fields")
  valid_598041 = validateParameter(valid_598041, JString, required = false,
                                 default = nil)
  if valid_598041 != nil:
    section.add "fields", valid_598041
  var valid_598042 = query.getOrDefault("quotaUser")
  valid_598042 = validateParameter(valid_598042, JString, required = false,
                                 default = nil)
  if valid_598042 != nil:
    section.add "quotaUser", valid_598042
  var valid_598043 = query.getOrDefault("alt")
  valid_598043 = validateParameter(valid_598043, JString, required = false,
                                 default = newJString("atom"))
  if valid_598043 != nil:
    section.add "alt", valid_598043
  var valid_598044 = query.getOrDefault("oauth_token")
  valid_598044 = validateParameter(valid_598044, JString, required = false,
                                 default = nil)
  if valid_598044 != nil:
    section.add "oauth_token", valid_598044
  var valid_598045 = query.getOrDefault("userIp")
  valid_598045 = validateParameter(valid_598045, JString, required = false,
                                 default = nil)
  if valid_598045 != nil:
    section.add "userIp", valid_598045
  var valid_598046 = query.getOrDefault("key")
  valid_598046 = validateParameter(valid_598046, JString, required = false,
                                 default = nil)
  if valid_598046 != nil:
    section.add "key", valid_598046
  var valid_598047 = query.getOrDefault("max-results")
  valid_598047 = validateParameter(valid_598047, JInt, required = false, default = nil)
  if valid_598047 != nil:
    section.add "max-results", valid_598047
  var valid_598048 = query.getOrDefault("start-index")
  valid_598048 = validateParameter(valid_598048, JInt, required = false, default = nil)
  if valid_598048 != nil:
    section.add "start-index", valid_598048
  var valid_598049 = query.getOrDefault("prettyPrint")
  valid_598049 = validateParameter(valid_598049, JBool, required = false,
                                 default = newJBool(false))
  if valid_598049 != nil:
    section.add "prettyPrint", valid_598049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598050: Call_AnalyticsManagementGoalsList_598035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists goals to which the user has access.
  ## 
  let valid = call_598050.validator(path, query, header, formData, body)
  let scheme = call_598050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598050.url(scheme.get, call_598050.host, call_598050.base,
                         call_598050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598050, url, valid)

proc call*(call_598051: Call_AnalyticsManagementGoalsList_598035;
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
  var path_598052 = newJObject()
  var query_598053 = newJObject()
  add(path_598052, "profileId", newJString(profileId))
  add(query_598053, "fields", newJString(fields))
  add(query_598053, "quotaUser", newJString(quotaUser))
  add(query_598053, "alt", newJString(alt))
  add(query_598053, "oauth_token", newJString(oauthToken))
  add(path_598052, "accountId", newJString(accountId))
  add(query_598053, "userIp", newJString(userIp))
  add(path_598052, "webPropertyId", newJString(webPropertyId))
  add(query_598053, "key", newJString(key))
  add(query_598053, "max-results", newJInt(maxResults))
  add(query_598053, "start-index", newJInt(startIndex))
  add(query_598053, "prettyPrint", newJBool(prettyPrint))
  result = call_598051.call(path_598052, query_598053, nil, nil, nil)

var analyticsManagementGoalsList* = Call_AnalyticsManagementGoalsList_598035(
    name: "analyticsManagementGoalsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/accounts/{accountId}/webproperties/{webPropertyId}/profiles/{profileId}/goals",
    validator: validate_AnalyticsManagementGoalsList_598036,
    base: "/analytics/v2.4", url: url_AnalyticsManagementGoalsList_598037,
    schemes: {Scheme.Https})
type
  Call_AnalyticsManagementSegmentsList_598054 = ref object of OpenApiRestCall_597424
proc url_AnalyticsManagementSegmentsList_598056(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AnalyticsManagementSegmentsList_598055(path: JsonNode;
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
  var valid_598057 = query.getOrDefault("fields")
  valid_598057 = validateParameter(valid_598057, JString, required = false,
                                 default = nil)
  if valid_598057 != nil:
    section.add "fields", valid_598057
  var valid_598058 = query.getOrDefault("quotaUser")
  valid_598058 = validateParameter(valid_598058, JString, required = false,
                                 default = nil)
  if valid_598058 != nil:
    section.add "quotaUser", valid_598058
  var valid_598059 = query.getOrDefault("alt")
  valid_598059 = validateParameter(valid_598059, JString, required = false,
                                 default = newJString("atom"))
  if valid_598059 != nil:
    section.add "alt", valid_598059
  var valid_598060 = query.getOrDefault("oauth_token")
  valid_598060 = validateParameter(valid_598060, JString, required = false,
                                 default = nil)
  if valid_598060 != nil:
    section.add "oauth_token", valid_598060
  var valid_598061 = query.getOrDefault("userIp")
  valid_598061 = validateParameter(valid_598061, JString, required = false,
                                 default = nil)
  if valid_598061 != nil:
    section.add "userIp", valid_598061
  var valid_598062 = query.getOrDefault("key")
  valid_598062 = validateParameter(valid_598062, JString, required = false,
                                 default = nil)
  if valid_598062 != nil:
    section.add "key", valid_598062
  var valid_598063 = query.getOrDefault("max-results")
  valid_598063 = validateParameter(valid_598063, JInt, required = false, default = nil)
  if valid_598063 != nil:
    section.add "max-results", valid_598063
  var valid_598064 = query.getOrDefault("start-index")
  valid_598064 = validateParameter(valid_598064, JInt, required = false, default = nil)
  if valid_598064 != nil:
    section.add "start-index", valid_598064
  var valid_598065 = query.getOrDefault("prettyPrint")
  valid_598065 = validateParameter(valid_598065, JBool, required = false,
                                 default = newJBool(false))
  if valid_598065 != nil:
    section.add "prettyPrint", valid_598065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598066: Call_AnalyticsManagementSegmentsList_598054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists advanced segments to which the user has access.
  ## 
  let valid = call_598066.validator(path, query, header, formData, body)
  let scheme = call_598066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598066.url(scheme.get, call_598066.host, call_598066.base,
                         call_598066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598066, url, valid)

proc call*(call_598067: Call_AnalyticsManagementSegmentsList_598054;
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
  var query_598068 = newJObject()
  add(query_598068, "fields", newJString(fields))
  add(query_598068, "quotaUser", newJString(quotaUser))
  add(query_598068, "alt", newJString(alt))
  add(query_598068, "oauth_token", newJString(oauthToken))
  add(query_598068, "userIp", newJString(userIp))
  add(query_598068, "key", newJString(key))
  add(query_598068, "max-results", newJInt(maxResults))
  add(query_598068, "start-index", newJInt(startIndex))
  add(query_598068, "prettyPrint", newJBool(prettyPrint))
  result = call_598067.call(nil, query_598068, nil, nil, nil)

var analyticsManagementSegmentsList* = Call_AnalyticsManagementSegmentsList_598054(
    name: "analyticsManagementSegmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/management/segments",
    validator: validate_AnalyticsManagementSegmentsList_598055,
    base: "/analytics/v2.4", url: url_AnalyticsManagementSegmentsList_598056,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
