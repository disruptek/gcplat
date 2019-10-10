
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Partners
## version: v2
## termsOfService: (not provided)
## license: (not provided)
## 
## Searches certified companies and creates contact leads with them, and also audits the usage of clients.
## 
## https://developers.google.com/partners/
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

  OpenApiRestCall_588450 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588450](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588450): Option[Scheme] {.used.} =
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
  gcpServiceName = "partners"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PartnersAnalyticsList_588719 = ref object of OpenApiRestCall_588450
proc url_PartnersAnalyticsList_588721(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersAnalyticsList_588720(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists analytics data for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListAnalyticsResponse.next_page_token`
  ## returned from the previous call to
  ## ListAnalytics.
  ## Will be a date string in `YYYY-MM-DD` format representing the end date
  ## of the date range of results to return.
  ## If unspecified or set to "", default value is the current date.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. Server may return fewer analytics than requested.
  ## If unspecified or set to 0, default value is 30.
  ## Specifies the number of days in the date range when querying analytics.
  ## The `page_token` represents the end date of the date range
  ## and the start date is calculated using the `page_size` as the number
  ## of days BEFORE the end date.
  ## Must be a non-negative integer.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_588833 = query.getOrDefault("upload_protocol")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "upload_protocol", valid_588833
  var valid_588834 = query.getOrDefault("fields")
  valid_588834 = validateParameter(valid_588834, JString, required = false,
                                 default = nil)
  if valid_588834 != nil:
    section.add "fields", valid_588834
  var valid_588835 = query.getOrDefault("pageToken")
  valid_588835 = validateParameter(valid_588835, JString, required = false,
                                 default = nil)
  if valid_588835 != nil:
    section.add "pageToken", valid_588835
  var valid_588836 = query.getOrDefault("quotaUser")
  valid_588836 = validateParameter(valid_588836, JString, required = false,
                                 default = nil)
  if valid_588836 != nil:
    section.add "quotaUser", valid_588836
  var valid_588837 = query.getOrDefault("requestMetadata.locale")
  valid_588837 = validateParameter(valid_588837, JString, required = false,
                                 default = nil)
  if valid_588837 != nil:
    section.add "requestMetadata.locale", valid_588837
  var valid_588851 = query.getOrDefault("alt")
  valid_588851 = validateParameter(valid_588851, JString, required = false,
                                 default = newJString("json"))
  if valid_588851 != nil:
    section.add "alt", valid_588851
  var valid_588852 = query.getOrDefault("pp")
  valid_588852 = validateParameter(valid_588852, JBool, required = false,
                                 default = newJBool(true))
  if valid_588852 != nil:
    section.add "pp", valid_588852
  var valid_588853 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_588853 = validateParameter(valid_588853, JString, required = false,
                                 default = nil)
  if valid_588853 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_588853
  var valid_588854 = query.getOrDefault("oauth_token")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = nil)
  if valid_588854 != nil:
    section.add "oauth_token", valid_588854
  var valid_588855 = query.getOrDefault("callback")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = nil)
  if valid_588855 != nil:
    section.add "callback", valid_588855
  var valid_588856 = query.getOrDefault("access_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "access_token", valid_588856
  var valid_588857 = query.getOrDefault("uploadType")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "uploadType", valid_588857
  var valid_588858 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_588858
  var valid_588859 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("$.xgafv")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = newJString("1"))
  if valid_588861 != nil:
    section.add "$.xgafv", valid_588861
  var valid_588862 = query.getOrDefault("pageSize")
  valid_588862 = validateParameter(valid_588862, JInt, required = false, default = nil)
  if valid_588862 != nil:
    section.add "pageSize", valid_588862
  var valid_588863 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = nil)
  if valid_588863 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_588863
  var valid_588864 = query.getOrDefault("requestMetadata.experimentIds")
  valid_588864 = validateParameter(valid_588864, JArray, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "requestMetadata.experimentIds", valid_588864
  var valid_588865 = query.getOrDefault("prettyPrint")
  valid_588865 = validateParameter(valid_588865, JBool, required = false,
                                 default = newJBool(true))
  if valid_588865 != nil:
    section.add "prettyPrint", valid_588865
  var valid_588866 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "requestMetadata.partnersSessionId", valid_588866
  var valid_588867 = query.getOrDefault("bearer_token")
  valid_588867 = validateParameter(valid_588867, JString, required = false,
                                 default = nil)
  if valid_588867 != nil:
    section.add "bearer_token", valid_588867
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588890: Call_PartnersAnalyticsList_588719; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists analytics data for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  let valid = call_588890.validator(path, query, header, formData, body)
  let scheme = call_588890.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588890.url(scheme.get, call_588890.host, call_588890.base,
                         call_588890.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588890, url, valid)

proc call*(call_588961: Call_PartnersAnalyticsList_588719;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; requestMetadataLocale: string = "";
          alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; pageSize: int = 0;
          requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersAnalyticsList
  ## Lists analytics data for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListAnalyticsResponse.next_page_token`
  ## returned from the previous call to
  ## ListAnalytics.
  ## Will be a date string in `YYYY-MM-DD` format representing the end date
  ## of the date range of results to return.
  ## If unspecified or set to "", default value is the current date.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer analytics than requested.
  ## If unspecified or set to 0, default value is 30.
  ## Specifies the number of days in the date range when querying analytics.
  ## The `page_token` represents the end date of the date range
  ## and the start date is calculated using the `page_size` as the number
  ## of days BEFORE the end date.
  ## Must be a non-negative integer.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_588962 = newJObject()
  add(query_588962, "upload_protocol", newJString(uploadProtocol))
  add(query_588962, "fields", newJString(fields))
  add(query_588962, "pageToken", newJString(pageToken))
  add(query_588962, "quotaUser", newJString(quotaUser))
  add(query_588962, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_588962, "alt", newJString(alt))
  add(query_588962, "pp", newJBool(pp))
  add(query_588962, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_588962, "oauth_token", newJString(oauthToken))
  add(query_588962, "callback", newJString(callback))
  add(query_588962, "access_token", newJString(accessToken))
  add(query_588962, "uploadType", newJString(uploadType))
  add(query_588962, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_588962, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_588962, "key", newJString(key))
  add(query_588962, "$.xgafv", newJString(Xgafv))
  add(query_588962, "pageSize", newJInt(pageSize))
  add(query_588962, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_588962.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_588962, "prettyPrint", newJBool(prettyPrint))
  add(query_588962, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_588962, "bearer_token", newJString(bearerToken))
  result = call_588961.call(nil, query_588962, nil, nil, nil)

var partnersAnalyticsList* = Call_PartnersAnalyticsList_588719(
    name: "partnersAnalyticsList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/analytics",
    validator: validate_PartnersAnalyticsList_588720, base: "/",
    url: url_PartnersAnalyticsList_588721, schemes: {Scheme.Https})
type
  Call_PartnersClientMessagesLog_589002 = ref object of OpenApiRestCall_588450
proc url_PartnersClientMessagesLog_589004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersClientMessagesLog_589003(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Logs a generic message from the client, such as
  ## `Failed to render component`, `Profile page is running slow`,
  ## `More than 500 users have accessed this result.`, etc.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589005 = query.getOrDefault("upload_protocol")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "upload_protocol", valid_589005
  var valid_589006 = query.getOrDefault("fields")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "fields", valid_589006
  var valid_589007 = query.getOrDefault("quotaUser")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "quotaUser", valid_589007
  var valid_589008 = query.getOrDefault("alt")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = newJString("json"))
  if valid_589008 != nil:
    section.add "alt", valid_589008
  var valid_589009 = query.getOrDefault("pp")
  valid_589009 = validateParameter(valid_589009, JBool, required = false,
                                 default = newJBool(true))
  if valid_589009 != nil:
    section.add "pp", valid_589009
  var valid_589010 = query.getOrDefault("oauth_token")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "oauth_token", valid_589010
  var valid_589011 = query.getOrDefault("callback")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "callback", valid_589011
  var valid_589012 = query.getOrDefault("access_token")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "access_token", valid_589012
  var valid_589013 = query.getOrDefault("uploadType")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "uploadType", valid_589013
  var valid_589014 = query.getOrDefault("key")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "key", valid_589014
  var valid_589015 = query.getOrDefault("$.xgafv")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("1"))
  if valid_589015 != nil:
    section.add "$.xgafv", valid_589015
  var valid_589016 = query.getOrDefault("prettyPrint")
  valid_589016 = validateParameter(valid_589016, JBool, required = false,
                                 default = newJBool(true))
  if valid_589016 != nil:
    section.add "prettyPrint", valid_589016
  var valid_589017 = query.getOrDefault("bearer_token")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "bearer_token", valid_589017
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

proc call*(call_589019: Call_PartnersClientMessagesLog_589002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Logs a generic message from the client, such as
  ## `Failed to render component`, `Profile page is running slow`,
  ## `More than 500 users have accessed this result.`, etc.
  ## 
  let valid = call_589019.validator(path, query, header, formData, body)
  let scheme = call_589019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589019.url(scheme.get, call_589019.host, call_589019.base,
                         call_589019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589019, url, valid)

proc call*(call_589020: Call_PartnersClientMessagesLog_589002;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## partnersClientMessagesLog
  ## Logs a generic message from the client, such as
  ## `Failed to render component`, `Profile page is running slow`,
  ## `More than 500 users have accessed this result.`, etc.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_589021 = newJObject()
  var body_589022 = newJObject()
  add(query_589021, "upload_protocol", newJString(uploadProtocol))
  add(query_589021, "fields", newJString(fields))
  add(query_589021, "quotaUser", newJString(quotaUser))
  add(query_589021, "alt", newJString(alt))
  add(query_589021, "pp", newJBool(pp))
  add(query_589021, "oauth_token", newJString(oauthToken))
  add(query_589021, "callback", newJString(callback))
  add(query_589021, "access_token", newJString(accessToken))
  add(query_589021, "uploadType", newJString(uploadType))
  add(query_589021, "key", newJString(key))
  add(query_589021, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589022 = body
  add(query_589021, "prettyPrint", newJBool(prettyPrint))
  add(query_589021, "bearer_token", newJString(bearerToken))
  result = call_589020.call(nil, query_589021, nil, nil, body_589022)

var partnersClientMessagesLog* = Call_PartnersClientMessagesLog_589002(
    name: "partnersClientMessagesLog", meth: HttpMethod.HttpPost,
    host: "partners.googleapis.com", route: "/v2/clientMessages:log",
    validator: validate_PartnersClientMessagesLog_589003, base: "/",
    url: url_PartnersClientMessagesLog_589004, schemes: {Scheme.Https})
type
  Call_PartnersCompaniesList_589023 = ref object of OpenApiRestCall_588450
proc url_PartnersCompaniesList_589025(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersCompaniesList_589024(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists companies.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxMonthlyBudget.units: JString
  ##                         : The whole units of the amount.
  ## For example if `currencyCode` is `"USD"`, then 1 unit is one US dollar.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   industries: JArray
  ##             : List of industries the company can help with.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListCompaniesResponse.next_page_token`
  ## returned from the previous call to
  ## ListCompanies.
  ##   view: JString
  ##       : The view of the `Company` resource to be returned. This must not be
  ## `COMPANY_VIEW_UNSPECIFIED`.
  ##   alt: JString
  ##      : Data format for response.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   gpsMotivations: JArray
  ##                 : List of reasons for using Google Partner Search to get companies.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   specializations: JArray
  ##                  : List of specializations that the returned agencies should provide. If this
  ## is not empty, any returned agency must have at least one of these
  ## specializations, or one of the services in the "services" field.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   minMonthlyBudget.currencyCode: JString
  ##                                : The 3-letter currency code defined in ISO 4217.
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   orderBy: JString
  ##          : How to order addresses within the returned companies. Currently, only
  ## `address` and `address desc` is supported which will sorted by closest to
  ## farthest in distance from given address and farthest to closest distance
  ## from given address respectively.
  ##   services: JArray
  ##           : List of services that the returned agencies should provide. If this is
  ## not empty, any returned agency must have at least one of these services,
  ## or one of the specializations in the "specializations" field.
  ##   maxMonthlyBudget.nanos: JInt
  ##                         : Number of nano (10^-9) units of the amount.
  ## The value must be between -999,999,999 and +999,999,999 inclusive.
  ## If `units` is positive, `nanos` must be positive or zero.
  ## If `units` is zero, `nanos` can be positive, zero, or negative.
  ## If `units` is negative, `nanos` must be negative or zero.
  ## For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   websiteUrl: JString
  ##             : Website URL that will help to find a better matched company.
  ## .
  ##   maxMonthlyBudget.currencyCode: JString
  ##                                : The 3-letter currency code defined in ISO 4217.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. Server may return fewer companies than requested.
  ## If unspecified, server picks an appropriate default.
  ##   minMonthlyBudget.units: JString
  ##                         : The whole units of the amount.
  ## For example if `currencyCode` is `"USD"`, then 1 unit is one US dollar.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   address: JString
  ##          : The address to use when searching for companies.
  ## If not given, the geo-located address of the request is used.
  ##   languageCodes: JArray
  ##                : List of language codes that company can support. Only primary language
  ## subtags are accepted as defined by
  ## <a href="https://tools.ietf.org/html/bcp47">BCP 47</a>
  ## (IETF BCP 47, "Tags for Identifying Languages").
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   companyName: JString
  ##              : Company name to search for.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   minMonthlyBudget.nanos: JInt
  ##                         : Number of nano (10^-9) units of the amount.
  ## The value must be between -999,999,999 and +999,999,999 inclusive.
  ## If `units` is positive, `nanos` must be positive or zero.
  ## If `units` is zero, `nanos` can be positive, zero, or negative.
  ## If `units` is negative, `nanos` must be negative or zero.
  ## For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589026 = query.getOrDefault("upload_protocol")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "upload_protocol", valid_589026
  var valid_589027 = query.getOrDefault("maxMonthlyBudget.units")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "maxMonthlyBudget.units", valid_589027
  var valid_589028 = query.getOrDefault("fields")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "fields", valid_589028
  var valid_589029 = query.getOrDefault("industries")
  valid_589029 = validateParameter(valid_589029, JArray, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "industries", valid_589029
  var valid_589030 = query.getOrDefault("quotaUser")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "quotaUser", valid_589030
  var valid_589031 = query.getOrDefault("pageToken")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "pageToken", valid_589031
  var valid_589032 = query.getOrDefault("view")
  valid_589032 = validateParameter(valid_589032, JString, required = false, default = newJString(
      "COMPANY_VIEW_UNSPECIFIED"))
  if valid_589032 != nil:
    section.add "view", valid_589032
  var valid_589033 = query.getOrDefault("alt")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("json"))
  if valid_589033 != nil:
    section.add "alt", valid_589033
  var valid_589034 = query.getOrDefault("requestMetadata.locale")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "requestMetadata.locale", valid_589034
  var valid_589035 = query.getOrDefault("gpsMotivations")
  valid_589035 = validateParameter(valid_589035, JArray, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "gpsMotivations", valid_589035
  var valid_589036 = query.getOrDefault("pp")
  valid_589036 = validateParameter(valid_589036, JBool, required = false,
                                 default = newJBool(true))
  if valid_589036 != nil:
    section.add "pp", valid_589036
  var valid_589037 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_589037
  var valid_589038 = query.getOrDefault("specializations")
  valid_589038 = validateParameter(valid_589038, JArray, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "specializations", valid_589038
  var valid_589039 = query.getOrDefault("oauth_token")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "oauth_token", valid_589039
  var valid_589040 = query.getOrDefault("callback")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "callback", valid_589040
  var valid_589041 = query.getOrDefault("access_token")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "access_token", valid_589041
  var valid_589042 = query.getOrDefault("uploadType")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "uploadType", valid_589042
  var valid_589043 = query.getOrDefault("minMonthlyBudget.currencyCode")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "minMonthlyBudget.currencyCode", valid_589043
  var valid_589044 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_589044
  var valid_589045 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_589045
  var valid_589046 = query.getOrDefault("orderBy")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "orderBy", valid_589046
  var valid_589047 = query.getOrDefault("services")
  valid_589047 = validateParameter(valid_589047, JArray, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "services", valid_589047
  var valid_589048 = query.getOrDefault("maxMonthlyBudget.nanos")
  valid_589048 = validateParameter(valid_589048, JInt, required = false, default = nil)
  if valid_589048 != nil:
    section.add "maxMonthlyBudget.nanos", valid_589048
  var valid_589049 = query.getOrDefault("key")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "key", valid_589049
  var valid_589050 = query.getOrDefault("websiteUrl")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "websiteUrl", valid_589050
  var valid_589051 = query.getOrDefault("maxMonthlyBudget.currencyCode")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "maxMonthlyBudget.currencyCode", valid_589051
  var valid_589052 = query.getOrDefault("$.xgafv")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = newJString("1"))
  if valid_589052 != nil:
    section.add "$.xgafv", valid_589052
  var valid_589053 = query.getOrDefault("pageSize")
  valid_589053 = validateParameter(valid_589053, JInt, required = false, default = nil)
  if valid_589053 != nil:
    section.add "pageSize", valid_589053
  var valid_589054 = query.getOrDefault("minMonthlyBudget.units")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "minMonthlyBudget.units", valid_589054
  var valid_589055 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_589055
  var valid_589056 = query.getOrDefault("address")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "address", valid_589056
  var valid_589057 = query.getOrDefault("languageCodes")
  valid_589057 = validateParameter(valid_589057, JArray, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "languageCodes", valid_589057
  var valid_589058 = query.getOrDefault("requestMetadata.experimentIds")
  valid_589058 = validateParameter(valid_589058, JArray, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "requestMetadata.experimentIds", valid_589058
  var valid_589059 = query.getOrDefault("companyName")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "companyName", valid_589059
  var valid_589060 = query.getOrDefault("prettyPrint")
  valid_589060 = validateParameter(valid_589060, JBool, required = false,
                                 default = newJBool(true))
  if valid_589060 != nil:
    section.add "prettyPrint", valid_589060
  var valid_589061 = query.getOrDefault("minMonthlyBudget.nanos")
  valid_589061 = validateParameter(valid_589061, JInt, required = false, default = nil)
  if valid_589061 != nil:
    section.add "minMonthlyBudget.nanos", valid_589061
  var valid_589062 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "requestMetadata.partnersSessionId", valid_589062
  var valid_589063 = query.getOrDefault("bearer_token")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "bearer_token", valid_589063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589064: Call_PartnersCompaniesList_589023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists companies.
  ## 
  let valid = call_589064.validator(path, query, header, formData, body)
  let scheme = call_589064.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589064.url(scheme.get, call_589064.host, call_589064.base,
                         call_589064.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589064, url, valid)

proc call*(call_589065: Call_PartnersCompaniesList_589023;
          uploadProtocol: string = ""; maxMonthlyBudgetUnits: string = "";
          fields: string = ""; industries: JsonNode = nil; quotaUser: string = "";
          pageToken: string = ""; view: string = "COMPANY_VIEW_UNSPECIFIED";
          alt: string = "json"; requestMetadataLocale: string = "";
          gpsMotivations: JsonNode = nil; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          specializations: JsonNode = nil; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          minMonthlyBudgetCurrencyCode: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          orderBy: string = ""; services: JsonNode = nil;
          maxMonthlyBudgetNanos: int = 0; key: string = ""; websiteUrl: string = "";
          maxMonthlyBudgetCurrencyCode: string = ""; Xgafv: string = "1";
          pageSize: int = 0; minMonthlyBudgetUnits: string = "";
          requestMetadataUserOverridesUserId: string = ""; address: string = "";
          languageCodes: JsonNode = nil;
          requestMetadataExperimentIds: JsonNode = nil; companyName: string = "";
          prettyPrint: bool = true; minMonthlyBudgetNanos: int = 0;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersCompaniesList
  ## Lists companies.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxMonthlyBudgetUnits: string
  ##                        : The whole units of the amount.
  ## For example if `currencyCode` is `"USD"`, then 1 unit is one US dollar.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   industries: JArray
  ##             : List of industries the company can help with.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListCompaniesResponse.next_page_token`
  ## returned from the previous call to
  ## ListCompanies.
  ##   view: string
  ##       : The view of the `Company` resource to be returned. This must not be
  ## `COMPANY_VIEW_UNSPECIFIED`.
  ##   alt: string
  ##      : Data format for response.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   gpsMotivations: JArray
  ##                 : List of reasons for using Google Partner Search to get companies.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   specializations: JArray
  ##                  : List of specializations that the returned agencies should provide. If this
  ## is not empty, any returned agency must have at least one of these
  ## specializations, or one of the services in the "services" field.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   minMonthlyBudgetCurrencyCode: string
  ##                               : The 3-letter currency code defined in ISO 4217.
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   orderBy: string
  ##          : How to order addresses within the returned companies. Currently, only
  ## `address` and `address desc` is supported which will sorted by closest to
  ## farthest in distance from given address and farthest to closest distance
  ## from given address respectively.
  ##   services: JArray
  ##           : List of services that the returned agencies should provide. If this is
  ## not empty, any returned agency must have at least one of these services,
  ## or one of the specializations in the "specializations" field.
  ##   maxMonthlyBudgetNanos: int
  ##                        : Number of nano (10^-9) units of the amount.
  ## The value must be between -999,999,999 and +999,999,999 inclusive.
  ## If `units` is positive, `nanos` must be positive or zero.
  ## If `units` is zero, `nanos` can be positive, zero, or negative.
  ## If `units` is negative, `nanos` must be negative or zero.
  ## For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   websiteUrl: string
  ##             : Website URL that will help to find a better matched company.
  ## .
  ##   maxMonthlyBudgetCurrencyCode: string
  ##                               : The 3-letter currency code defined in ISO 4217.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer companies than requested.
  ## If unspecified, server picks an appropriate default.
  ##   minMonthlyBudgetUnits: string
  ##                        : The whole units of the amount.
  ## For example if `currencyCode` is `"USD"`, then 1 unit is one US dollar.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   address: string
  ##          : The address to use when searching for companies.
  ## If not given, the geo-located address of the request is used.
  ##   languageCodes: JArray
  ##                : List of language codes that company can support. Only primary language
  ## subtags are accepted as defined by
  ## <a href="https://tools.ietf.org/html/bcp47">BCP 47</a>
  ## (IETF BCP 47, "Tags for Identifying Languages").
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   companyName: string
  ##              : Company name to search for.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   minMonthlyBudgetNanos: int
  ##                        : Number of nano (10^-9) units of the amount.
  ## The value must be between -999,999,999 and +999,999,999 inclusive.
  ## If `units` is positive, `nanos` must be positive or zero.
  ## If `units` is zero, `nanos` can be positive, zero, or negative.
  ## If `units` is negative, `nanos` must be negative or zero.
  ## For example $-1.75 is represented as `units`=-1 and `nanos`=-750,000,000.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_589066 = newJObject()
  add(query_589066, "upload_protocol", newJString(uploadProtocol))
  add(query_589066, "maxMonthlyBudget.units", newJString(maxMonthlyBudgetUnits))
  add(query_589066, "fields", newJString(fields))
  if industries != nil:
    query_589066.add "industries", industries
  add(query_589066, "quotaUser", newJString(quotaUser))
  add(query_589066, "pageToken", newJString(pageToken))
  add(query_589066, "view", newJString(view))
  add(query_589066, "alt", newJString(alt))
  add(query_589066, "requestMetadata.locale", newJString(requestMetadataLocale))
  if gpsMotivations != nil:
    query_589066.add "gpsMotivations", gpsMotivations
  add(query_589066, "pp", newJBool(pp))
  add(query_589066, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  if specializations != nil:
    query_589066.add "specializations", specializations
  add(query_589066, "oauth_token", newJString(oauthToken))
  add(query_589066, "callback", newJString(callback))
  add(query_589066, "access_token", newJString(accessToken))
  add(query_589066, "uploadType", newJString(uploadType))
  add(query_589066, "minMonthlyBudget.currencyCode",
      newJString(minMonthlyBudgetCurrencyCode))
  add(query_589066, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_589066, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_589066, "orderBy", newJString(orderBy))
  if services != nil:
    query_589066.add "services", services
  add(query_589066, "maxMonthlyBudget.nanos", newJInt(maxMonthlyBudgetNanos))
  add(query_589066, "key", newJString(key))
  add(query_589066, "websiteUrl", newJString(websiteUrl))
  add(query_589066, "maxMonthlyBudget.currencyCode",
      newJString(maxMonthlyBudgetCurrencyCode))
  add(query_589066, "$.xgafv", newJString(Xgafv))
  add(query_589066, "pageSize", newJInt(pageSize))
  add(query_589066, "minMonthlyBudget.units", newJString(minMonthlyBudgetUnits))
  add(query_589066, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_589066, "address", newJString(address))
  if languageCodes != nil:
    query_589066.add "languageCodes", languageCodes
  if requestMetadataExperimentIds != nil:
    query_589066.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_589066, "companyName", newJString(companyName))
  add(query_589066, "prettyPrint", newJBool(prettyPrint))
  add(query_589066, "minMonthlyBudget.nanos", newJInt(minMonthlyBudgetNanos))
  add(query_589066, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_589066, "bearer_token", newJString(bearerToken))
  result = call_589065.call(nil, query_589066, nil, nil, nil)

var partnersCompaniesList* = Call_PartnersCompaniesList_589023(
    name: "partnersCompaniesList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/companies",
    validator: validate_PartnersCompaniesList_589024, base: "/",
    url: url_PartnersCompaniesList_589025, schemes: {Scheme.Https})
type
  Call_PartnersUpdateCompanies_589067 = ref object of OpenApiRestCall_588450
proc url_PartnersUpdateCompanies_589069(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUpdateCompanies_589068(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated.
  ## Required with at least 1 value in FieldMask's paths.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589070 = query.getOrDefault("upload_protocol")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "upload_protocol", valid_589070
  var valid_589071 = query.getOrDefault("fields")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "fields", valid_589071
  var valid_589072 = query.getOrDefault("quotaUser")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "quotaUser", valid_589072
  var valid_589073 = query.getOrDefault("requestMetadata.locale")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "requestMetadata.locale", valid_589073
  var valid_589074 = query.getOrDefault("alt")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = newJString("json"))
  if valid_589074 != nil:
    section.add "alt", valid_589074
  var valid_589075 = query.getOrDefault("pp")
  valid_589075 = validateParameter(valid_589075, JBool, required = false,
                                 default = newJBool(true))
  if valid_589075 != nil:
    section.add "pp", valid_589075
  var valid_589076 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_589076
  var valid_589077 = query.getOrDefault("oauth_token")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "oauth_token", valid_589077
  var valid_589078 = query.getOrDefault("callback")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "callback", valid_589078
  var valid_589079 = query.getOrDefault("access_token")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "access_token", valid_589079
  var valid_589080 = query.getOrDefault("uploadType")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "uploadType", valid_589080
  var valid_589081 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_589081
  var valid_589082 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_589082
  var valid_589083 = query.getOrDefault("key")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "key", valid_589083
  var valid_589084 = query.getOrDefault("$.xgafv")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = newJString("1"))
  if valid_589084 != nil:
    section.add "$.xgafv", valid_589084
  var valid_589085 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_589085
  var valid_589086 = query.getOrDefault("requestMetadata.experimentIds")
  valid_589086 = validateParameter(valid_589086, JArray, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "requestMetadata.experimentIds", valid_589086
  var valid_589087 = query.getOrDefault("prettyPrint")
  valid_589087 = validateParameter(valid_589087, JBool, required = false,
                                 default = newJBool(true))
  if valid_589087 != nil:
    section.add "prettyPrint", valid_589087
  var valid_589088 = query.getOrDefault("updateMask")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "updateMask", valid_589088
  var valid_589089 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "requestMetadata.partnersSessionId", valid_589089
  var valid_589090 = query.getOrDefault("bearer_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "bearer_token", valid_589090
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

proc call*(call_589092: Call_PartnersUpdateCompanies_589067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  let valid = call_589092.validator(path, query, header, formData, body)
  let scheme = call_589092.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589092.url(scheme.get, call_589092.host, call_589092.base,
                         call_589092.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589092, url, valid)

proc call*(call_589093: Call_PartnersUpdateCompanies_589067;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = "";
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersUpdateCompanies
  ## Update company.
  ## Should only be called within the context of an authorized logged in user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  ## Required with at least 1 value in FieldMask's paths.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_589094 = newJObject()
  var body_589095 = newJObject()
  add(query_589094, "upload_protocol", newJString(uploadProtocol))
  add(query_589094, "fields", newJString(fields))
  add(query_589094, "quotaUser", newJString(quotaUser))
  add(query_589094, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_589094, "alt", newJString(alt))
  add(query_589094, "pp", newJBool(pp))
  add(query_589094, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_589094, "oauth_token", newJString(oauthToken))
  add(query_589094, "callback", newJString(callback))
  add(query_589094, "access_token", newJString(accessToken))
  add(query_589094, "uploadType", newJString(uploadType))
  add(query_589094, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_589094, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_589094, "key", newJString(key))
  add(query_589094, "$.xgafv", newJString(Xgafv))
  add(query_589094, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_589094.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_589095 = body
  add(query_589094, "prettyPrint", newJBool(prettyPrint))
  add(query_589094, "updateMask", newJString(updateMask))
  add(query_589094, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_589094, "bearer_token", newJString(bearerToken))
  result = call_589093.call(nil, query_589094, nil, nil, body_589095)

var partnersUpdateCompanies* = Call_PartnersUpdateCompanies_589067(
    name: "partnersUpdateCompanies", meth: HttpMethod.HttpPatch,
    host: "partners.googleapis.com", route: "/v2/companies",
    validator: validate_PartnersUpdateCompanies_589068, base: "/",
    url: url_PartnersUpdateCompanies_589069, schemes: {Scheme.Https})
type
  Call_PartnersCompaniesGet_589096 = ref object of OpenApiRestCall_588450
proc url_PartnersCompaniesGet_589098(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "companyId" in path, "`companyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/companies/"),
               (kind: VariableSegment, value: "companyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnersCompaniesGet_589097(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a company.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   companyId: JString (required)
  ##            : The ID of the company to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `companyId` field"
  var valid_589113 = path.getOrDefault("companyId")
  valid_589113 = validateParameter(valid_589113, JString, required = true,
                                 default = nil)
  if valid_589113 != nil:
    section.add "companyId", valid_589113
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: JString
  ##       : The view of `Company` resource to be returned. This must not be
  ## `COMPANY_VIEW_UNSPECIFIED`.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   currencyCode: JString
  ##               : If the company's budget is in a different currency code than this one, then
  ## the converted budget is converted to this currency code.
  ##   orderBy: JString
  ##          : How to order addresses within the returned company. Currently, only
  ## `address` and `address desc` is supported which will sorted by closest to
  ## farthest in distance from given address and farthest to closest distance
  ## from given address respectively.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   address: JString
  ##          : The address to use for sorting the company's addresses by proximity.
  ## If not given, the geo-located address of the request is used.
  ## Used when order_by is set.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589114 = query.getOrDefault("upload_protocol")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "upload_protocol", valid_589114
  var valid_589115 = query.getOrDefault("fields")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "fields", valid_589115
  var valid_589116 = query.getOrDefault("view")
  valid_589116 = validateParameter(valid_589116, JString, required = false, default = newJString(
      "COMPANY_VIEW_UNSPECIFIED"))
  if valid_589116 != nil:
    section.add "view", valid_589116
  var valid_589117 = query.getOrDefault("quotaUser")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "quotaUser", valid_589117
  var valid_589118 = query.getOrDefault("requestMetadata.locale")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "requestMetadata.locale", valid_589118
  var valid_589119 = query.getOrDefault("alt")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = newJString("json"))
  if valid_589119 != nil:
    section.add "alt", valid_589119
  var valid_589120 = query.getOrDefault("pp")
  valid_589120 = validateParameter(valid_589120, JBool, required = false,
                                 default = newJBool(true))
  if valid_589120 != nil:
    section.add "pp", valid_589120
  var valid_589121 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_589121
  var valid_589122 = query.getOrDefault("oauth_token")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "oauth_token", valid_589122
  var valid_589123 = query.getOrDefault("callback")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "callback", valid_589123
  var valid_589124 = query.getOrDefault("access_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "access_token", valid_589124
  var valid_589125 = query.getOrDefault("uploadType")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "uploadType", valid_589125
  var valid_589126 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_589126
  var valid_589127 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_589127
  var valid_589128 = query.getOrDefault("currencyCode")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "currencyCode", valid_589128
  var valid_589129 = query.getOrDefault("orderBy")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "orderBy", valid_589129
  var valid_589130 = query.getOrDefault("key")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "key", valid_589130
  var valid_589131 = query.getOrDefault("$.xgafv")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = newJString("1"))
  if valid_589131 != nil:
    section.add "$.xgafv", valid_589131
  var valid_589132 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_589132
  var valid_589133 = query.getOrDefault("address")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "address", valid_589133
  var valid_589134 = query.getOrDefault("requestMetadata.experimentIds")
  valid_589134 = validateParameter(valid_589134, JArray, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "requestMetadata.experimentIds", valid_589134
  var valid_589135 = query.getOrDefault("prettyPrint")
  valid_589135 = validateParameter(valid_589135, JBool, required = false,
                                 default = newJBool(true))
  if valid_589135 != nil:
    section.add "prettyPrint", valid_589135
  var valid_589136 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "requestMetadata.partnersSessionId", valid_589136
  var valid_589137 = query.getOrDefault("bearer_token")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "bearer_token", valid_589137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589138: Call_PartnersCompaniesGet_589096; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a company.
  ## 
  let valid = call_589138.validator(path, query, header, formData, body)
  let scheme = call_589138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589138.url(scheme.get, call_589138.host, call_589138.base,
                         call_589138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589138, url, valid)

proc call*(call_589139: Call_PartnersCompaniesGet_589096; companyId: string;
          uploadProtocol: string = ""; fields: string = "";
          view: string = "COMPANY_VIEW_UNSPECIFIED"; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          currencyCode: string = ""; orderBy: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          address: string = ""; requestMetadataExperimentIds: JsonNode = nil;
          prettyPrint: bool = true; requestMetadataPartnersSessionId: string = "";
          bearerToken: string = ""): Recallable =
  ## partnersCompaniesGet
  ## Gets a company.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   view: string
  ##       : The view of `Company` resource to be returned. This must not be
  ## `COMPANY_VIEW_UNSPECIFIED`.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   currencyCode: string
  ##               : If the company's budget is in a different currency code than this one, then
  ## the converted budget is converted to this currency code.
  ##   orderBy: string
  ##          : How to order addresses within the returned company. Currently, only
  ## `address` and `address desc` is supported which will sorted by closest to
  ## farthest in distance from given address and farthest to closest distance
  ## from given address respectively.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   address: string
  ##          : The address to use for sorting the company's addresses by proximity.
  ## If not given, the geo-located address of the request is used.
  ## Used when order_by is set.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   companyId: string (required)
  ##            : The ID of the company to retrieve.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589140 = newJObject()
  var query_589141 = newJObject()
  add(query_589141, "upload_protocol", newJString(uploadProtocol))
  add(query_589141, "fields", newJString(fields))
  add(query_589141, "view", newJString(view))
  add(query_589141, "quotaUser", newJString(quotaUser))
  add(query_589141, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_589141, "alt", newJString(alt))
  add(query_589141, "pp", newJBool(pp))
  add(query_589141, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_589141, "oauth_token", newJString(oauthToken))
  add(query_589141, "callback", newJString(callback))
  add(query_589141, "access_token", newJString(accessToken))
  add(query_589141, "uploadType", newJString(uploadType))
  add(query_589141, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_589141, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_589141, "currencyCode", newJString(currencyCode))
  add(query_589141, "orderBy", newJString(orderBy))
  add(query_589141, "key", newJString(key))
  add(query_589141, "$.xgafv", newJString(Xgafv))
  add(query_589141, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_589141, "address", newJString(address))
  if requestMetadataExperimentIds != nil:
    query_589141.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_589141, "prettyPrint", newJBool(prettyPrint))
  add(path_589140, "companyId", newJString(companyId))
  add(query_589141, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_589141, "bearer_token", newJString(bearerToken))
  result = call_589139.call(path_589140, query_589141, nil, nil, nil)

var partnersCompaniesGet* = Call_PartnersCompaniesGet_589096(
    name: "partnersCompaniesGet", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/companies/{companyId}",
    validator: validate_PartnersCompaniesGet_589097, base: "/",
    url: url_PartnersCompaniesGet_589098, schemes: {Scheme.Https})
type
  Call_PartnersCompaniesLeadsCreate_589142 = ref object of OpenApiRestCall_588450
proc url_PartnersCompaniesLeadsCreate_589144(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "companyId" in path, "`companyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/companies/"),
               (kind: VariableSegment, value: "companyId"),
               (kind: ConstantSegment, value: "/leads")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnersCompaniesLeadsCreate_589143(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an advertiser lead for the given company ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   companyId: JString (required)
  ##            : The ID of the company to contact.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `companyId` field"
  var valid_589145 = path.getOrDefault("companyId")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "companyId", valid_589145
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589146 = query.getOrDefault("upload_protocol")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "upload_protocol", valid_589146
  var valid_589147 = query.getOrDefault("fields")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "fields", valid_589147
  var valid_589148 = query.getOrDefault("quotaUser")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "quotaUser", valid_589148
  var valid_589149 = query.getOrDefault("alt")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("json"))
  if valid_589149 != nil:
    section.add "alt", valid_589149
  var valid_589150 = query.getOrDefault("pp")
  valid_589150 = validateParameter(valid_589150, JBool, required = false,
                                 default = newJBool(true))
  if valid_589150 != nil:
    section.add "pp", valid_589150
  var valid_589151 = query.getOrDefault("oauth_token")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "oauth_token", valid_589151
  var valid_589152 = query.getOrDefault("callback")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "callback", valid_589152
  var valid_589153 = query.getOrDefault("access_token")
  valid_589153 = validateParameter(valid_589153, JString, required = false,
                                 default = nil)
  if valid_589153 != nil:
    section.add "access_token", valid_589153
  var valid_589154 = query.getOrDefault("uploadType")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "uploadType", valid_589154
  var valid_589155 = query.getOrDefault("key")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "key", valid_589155
  var valid_589156 = query.getOrDefault("$.xgafv")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = newJString("1"))
  if valid_589156 != nil:
    section.add "$.xgafv", valid_589156
  var valid_589157 = query.getOrDefault("prettyPrint")
  valid_589157 = validateParameter(valid_589157, JBool, required = false,
                                 default = newJBool(true))
  if valid_589157 != nil:
    section.add "prettyPrint", valid_589157
  var valid_589158 = query.getOrDefault("bearer_token")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "bearer_token", valid_589158
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

proc call*(call_589160: Call_PartnersCompaniesLeadsCreate_589142; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an advertiser lead for the given company ID.
  ## 
  let valid = call_589160.validator(path, query, header, formData, body)
  let scheme = call_589160.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589160.url(scheme.get, call_589160.host, call_589160.base,
                         call_589160.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589160, url, valid)

proc call*(call_589161: Call_PartnersCompaniesLeadsCreate_589142;
          companyId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## partnersCompaniesLeadsCreate
  ## Creates an advertiser lead for the given company ID.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   companyId: string (required)
  ##            : The ID of the company to contact.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589162 = newJObject()
  var query_589163 = newJObject()
  var body_589164 = newJObject()
  add(query_589163, "upload_protocol", newJString(uploadProtocol))
  add(query_589163, "fields", newJString(fields))
  add(query_589163, "quotaUser", newJString(quotaUser))
  add(query_589163, "alt", newJString(alt))
  add(query_589163, "pp", newJBool(pp))
  add(query_589163, "oauth_token", newJString(oauthToken))
  add(query_589163, "callback", newJString(callback))
  add(query_589163, "access_token", newJString(accessToken))
  add(query_589163, "uploadType", newJString(uploadType))
  add(query_589163, "key", newJString(key))
  add(query_589163, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589164 = body
  add(query_589163, "prettyPrint", newJBool(prettyPrint))
  add(path_589162, "companyId", newJString(companyId))
  add(query_589163, "bearer_token", newJString(bearerToken))
  result = call_589161.call(path_589162, query_589163, nil, nil, body_589164)

var partnersCompaniesLeadsCreate* = Call_PartnersCompaniesLeadsCreate_589142(
    name: "partnersCompaniesLeadsCreate", meth: HttpMethod.HttpPost,
    host: "partners.googleapis.com", route: "/v2/companies/{companyId}/leads",
    validator: validate_PartnersCompaniesLeadsCreate_589143, base: "/",
    url: url_PartnersCompaniesLeadsCreate_589144, schemes: {Scheme.Https})
type
  Call_PartnersLeadsList_589165 = ref object of OpenApiRestCall_588450
proc url_PartnersLeadsList_589167(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersLeadsList_589166(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Lists advertiser leads for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListLeadsResponse.next_page_token`
  ## returned from the previous call to
  ## ListLeads.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   orderBy: JString
  ##          : How to order Leads. Currently, only `create_time`
  ## and `create_time desc` are supported
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Requested page size. Server may return fewer leads than requested.
  ## If unspecified, server picks an appropriate default.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589168 = query.getOrDefault("upload_protocol")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "upload_protocol", valid_589168
  var valid_589169 = query.getOrDefault("fields")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "fields", valid_589169
  var valid_589170 = query.getOrDefault("pageToken")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "pageToken", valid_589170
  var valid_589171 = query.getOrDefault("quotaUser")
  valid_589171 = validateParameter(valid_589171, JString, required = false,
                                 default = nil)
  if valid_589171 != nil:
    section.add "quotaUser", valid_589171
  var valid_589172 = query.getOrDefault("requestMetadata.locale")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "requestMetadata.locale", valid_589172
  var valid_589173 = query.getOrDefault("alt")
  valid_589173 = validateParameter(valid_589173, JString, required = false,
                                 default = newJString("json"))
  if valid_589173 != nil:
    section.add "alt", valid_589173
  var valid_589174 = query.getOrDefault("pp")
  valid_589174 = validateParameter(valid_589174, JBool, required = false,
                                 default = newJBool(true))
  if valid_589174 != nil:
    section.add "pp", valid_589174
  var valid_589175 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_589175
  var valid_589176 = query.getOrDefault("oauth_token")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "oauth_token", valid_589176
  var valid_589177 = query.getOrDefault("callback")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "callback", valid_589177
  var valid_589178 = query.getOrDefault("access_token")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "access_token", valid_589178
  var valid_589179 = query.getOrDefault("uploadType")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "uploadType", valid_589179
  var valid_589180 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_589180
  var valid_589181 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_589181
  var valid_589182 = query.getOrDefault("orderBy")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "orderBy", valid_589182
  var valid_589183 = query.getOrDefault("key")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "key", valid_589183
  var valid_589184 = query.getOrDefault("$.xgafv")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = newJString("1"))
  if valid_589184 != nil:
    section.add "$.xgafv", valid_589184
  var valid_589185 = query.getOrDefault("pageSize")
  valid_589185 = validateParameter(valid_589185, JInt, required = false, default = nil)
  if valid_589185 != nil:
    section.add "pageSize", valid_589185
  var valid_589186 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_589186
  var valid_589187 = query.getOrDefault("requestMetadata.experimentIds")
  valid_589187 = validateParameter(valid_589187, JArray, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "requestMetadata.experimentIds", valid_589187
  var valid_589188 = query.getOrDefault("prettyPrint")
  valid_589188 = validateParameter(valid_589188, JBool, required = false,
                                 default = newJBool(true))
  if valid_589188 != nil:
    section.add "prettyPrint", valid_589188
  var valid_589189 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_589189 = validateParameter(valid_589189, JString, required = false,
                                 default = nil)
  if valid_589189 != nil:
    section.add "requestMetadata.partnersSessionId", valid_589189
  var valid_589190 = query.getOrDefault("bearer_token")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "bearer_token", valid_589190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589191: Call_PartnersLeadsList_589165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists advertiser leads for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  let valid = call_589191.validator(path, query, header, formData, body)
  let scheme = call_589191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589191.url(scheme.get, call_589191.host, call_589191.base,
                         call_589191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589191, url, valid)

proc call*(call_589192: Call_PartnersLeadsList_589165; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          orderBy: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersLeadsList
  ## Lists advertiser leads for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A token identifying a page of results that the server returns.
  ## Typically, this is the value of `ListLeadsResponse.next_page_token`
  ## returned from the previous call to
  ## ListLeads.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   orderBy: string
  ##          : How to order Leads. Currently, only `create_time`
  ## and `create_time desc` are supported
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Requested page size. Server may return fewer leads than requested.
  ## If unspecified, server picks an appropriate default.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_589193 = newJObject()
  add(query_589193, "upload_protocol", newJString(uploadProtocol))
  add(query_589193, "fields", newJString(fields))
  add(query_589193, "pageToken", newJString(pageToken))
  add(query_589193, "quotaUser", newJString(quotaUser))
  add(query_589193, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_589193, "alt", newJString(alt))
  add(query_589193, "pp", newJBool(pp))
  add(query_589193, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_589193, "oauth_token", newJString(oauthToken))
  add(query_589193, "callback", newJString(callback))
  add(query_589193, "access_token", newJString(accessToken))
  add(query_589193, "uploadType", newJString(uploadType))
  add(query_589193, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_589193, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_589193, "orderBy", newJString(orderBy))
  add(query_589193, "key", newJString(key))
  add(query_589193, "$.xgafv", newJString(Xgafv))
  add(query_589193, "pageSize", newJInt(pageSize))
  add(query_589193, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_589193.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_589193, "prettyPrint", newJBool(prettyPrint))
  add(query_589193, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_589193, "bearer_token", newJString(bearerToken))
  result = call_589192.call(nil, query_589193, nil, nil, nil)

var partnersLeadsList* = Call_PartnersLeadsList_589165(name: "partnersLeadsList",
    meth: HttpMethod.HttpGet, host: "partners.googleapis.com", route: "/v2/leads",
    validator: validate_PartnersLeadsList_589166, base: "/",
    url: url_PartnersLeadsList_589167, schemes: {Scheme.Https})
type
  Call_PartnersUpdateLeads_589194 = ref object of OpenApiRestCall_588450
proc url_PartnersUpdateLeads_589196(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUpdateLeads_589195(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates the specified lead.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Standard field mask for the set of fields to be updated.
  ## Required with at least 1 value in FieldMask's paths.
  ## Only `state` and `adwords_customer_id` are currently supported.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589197 = query.getOrDefault("upload_protocol")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "upload_protocol", valid_589197
  var valid_589198 = query.getOrDefault("fields")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "fields", valid_589198
  var valid_589199 = query.getOrDefault("quotaUser")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "quotaUser", valid_589199
  var valid_589200 = query.getOrDefault("requestMetadata.locale")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "requestMetadata.locale", valid_589200
  var valid_589201 = query.getOrDefault("alt")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = newJString("json"))
  if valid_589201 != nil:
    section.add "alt", valid_589201
  var valid_589202 = query.getOrDefault("pp")
  valid_589202 = validateParameter(valid_589202, JBool, required = false,
                                 default = newJBool(true))
  if valid_589202 != nil:
    section.add "pp", valid_589202
  var valid_589203 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_589203
  var valid_589204 = query.getOrDefault("oauth_token")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "oauth_token", valid_589204
  var valid_589205 = query.getOrDefault("callback")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "callback", valid_589205
  var valid_589206 = query.getOrDefault("access_token")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "access_token", valid_589206
  var valid_589207 = query.getOrDefault("uploadType")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "uploadType", valid_589207
  var valid_589208 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_589208
  var valid_589209 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_589209
  var valid_589210 = query.getOrDefault("key")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "key", valid_589210
  var valid_589211 = query.getOrDefault("$.xgafv")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = newJString("1"))
  if valid_589211 != nil:
    section.add "$.xgafv", valid_589211
  var valid_589212 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_589212
  var valid_589213 = query.getOrDefault("requestMetadata.experimentIds")
  valid_589213 = validateParameter(valid_589213, JArray, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "requestMetadata.experimentIds", valid_589213
  var valid_589214 = query.getOrDefault("prettyPrint")
  valid_589214 = validateParameter(valid_589214, JBool, required = false,
                                 default = newJBool(true))
  if valid_589214 != nil:
    section.add "prettyPrint", valid_589214
  var valid_589215 = query.getOrDefault("updateMask")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "updateMask", valid_589215
  var valid_589216 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "requestMetadata.partnersSessionId", valid_589216
  var valid_589217 = query.getOrDefault("bearer_token")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "bearer_token", valid_589217
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

proc call*(call_589219: Call_PartnersUpdateLeads_589194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified lead.
  ## 
  let valid = call_589219.validator(path, query, header, formData, body)
  let scheme = call_589219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589219.url(scheme.get, call_589219.host, call_589219.base,
                         call_589219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589219, url, valid)

proc call*(call_589220: Call_PartnersUpdateLeads_589194;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = "";
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersUpdateLeads
  ## Updates the specified lead.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Standard field mask for the set of fields to be updated.
  ## Required with at least 1 value in FieldMask's paths.
  ## Only `state` and `adwords_customer_id` are currently supported.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_589221 = newJObject()
  var body_589222 = newJObject()
  add(query_589221, "upload_protocol", newJString(uploadProtocol))
  add(query_589221, "fields", newJString(fields))
  add(query_589221, "quotaUser", newJString(quotaUser))
  add(query_589221, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_589221, "alt", newJString(alt))
  add(query_589221, "pp", newJBool(pp))
  add(query_589221, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_589221, "oauth_token", newJString(oauthToken))
  add(query_589221, "callback", newJString(callback))
  add(query_589221, "access_token", newJString(accessToken))
  add(query_589221, "uploadType", newJString(uploadType))
  add(query_589221, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_589221, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_589221, "key", newJString(key))
  add(query_589221, "$.xgafv", newJString(Xgafv))
  add(query_589221, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_589221.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_589222 = body
  add(query_589221, "prettyPrint", newJBool(prettyPrint))
  add(query_589221, "updateMask", newJString(updateMask))
  add(query_589221, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_589221, "bearer_token", newJString(bearerToken))
  result = call_589220.call(nil, query_589221, nil, nil, body_589222)

var partnersUpdateLeads* = Call_PartnersUpdateLeads_589194(
    name: "partnersUpdateLeads", meth: HttpMethod.HttpPatch,
    host: "partners.googleapis.com", route: "/v2/leads",
    validator: validate_PartnersUpdateLeads_589195, base: "/",
    url: url_PartnersUpdateLeads_589196, schemes: {Scheme.Https})
type
  Call_PartnersOffersList_589223 = ref object of OpenApiRestCall_588450
proc url_PartnersOffersList_589225(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersOffersList_589224(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Lists the Offers available for the current user
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589226 = query.getOrDefault("upload_protocol")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "upload_protocol", valid_589226
  var valid_589227 = query.getOrDefault("fields")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "fields", valid_589227
  var valid_589228 = query.getOrDefault("quotaUser")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "quotaUser", valid_589228
  var valid_589229 = query.getOrDefault("requestMetadata.locale")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "requestMetadata.locale", valid_589229
  var valid_589230 = query.getOrDefault("alt")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = newJString("json"))
  if valid_589230 != nil:
    section.add "alt", valid_589230
  var valid_589231 = query.getOrDefault("pp")
  valid_589231 = validateParameter(valid_589231, JBool, required = false,
                                 default = newJBool(true))
  if valid_589231 != nil:
    section.add "pp", valid_589231
  var valid_589232 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_589232
  var valid_589233 = query.getOrDefault("oauth_token")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "oauth_token", valid_589233
  var valid_589234 = query.getOrDefault("callback")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "callback", valid_589234
  var valid_589235 = query.getOrDefault("access_token")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = nil)
  if valid_589235 != nil:
    section.add "access_token", valid_589235
  var valid_589236 = query.getOrDefault("uploadType")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "uploadType", valid_589236
  var valid_589237 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_589237
  var valid_589238 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_589238
  var valid_589239 = query.getOrDefault("key")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "key", valid_589239
  var valid_589240 = query.getOrDefault("$.xgafv")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = newJString("1"))
  if valid_589240 != nil:
    section.add "$.xgafv", valid_589240
  var valid_589241 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_589241
  var valid_589242 = query.getOrDefault("requestMetadata.experimentIds")
  valid_589242 = validateParameter(valid_589242, JArray, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "requestMetadata.experimentIds", valid_589242
  var valid_589243 = query.getOrDefault("prettyPrint")
  valid_589243 = validateParameter(valid_589243, JBool, required = false,
                                 default = newJBool(true))
  if valid_589243 != nil:
    section.add "prettyPrint", valid_589243
  var valid_589244 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "requestMetadata.partnersSessionId", valid_589244
  var valid_589245 = query.getOrDefault("bearer_token")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "bearer_token", valid_589245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589246: Call_PartnersOffersList_589223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Offers available for the current user
  ## 
  let valid = call_589246.validator(path, query, header, formData, body)
  let scheme = call_589246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589246.url(scheme.get, call_589246.host, call_589246.base,
                         call_589246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589246, url, valid)

proc call*(call_589247: Call_PartnersOffersList_589223;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersOffersList
  ## Lists the Offers available for the current user
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_589248 = newJObject()
  add(query_589248, "upload_protocol", newJString(uploadProtocol))
  add(query_589248, "fields", newJString(fields))
  add(query_589248, "quotaUser", newJString(quotaUser))
  add(query_589248, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_589248, "alt", newJString(alt))
  add(query_589248, "pp", newJBool(pp))
  add(query_589248, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_589248, "oauth_token", newJString(oauthToken))
  add(query_589248, "callback", newJString(callback))
  add(query_589248, "access_token", newJString(accessToken))
  add(query_589248, "uploadType", newJString(uploadType))
  add(query_589248, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_589248, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_589248, "key", newJString(key))
  add(query_589248, "$.xgafv", newJString(Xgafv))
  add(query_589248, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_589248.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_589248, "prettyPrint", newJBool(prettyPrint))
  add(query_589248, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_589248, "bearer_token", newJString(bearerToken))
  result = call_589247.call(nil, query_589248, nil, nil, nil)

var partnersOffersList* = Call_PartnersOffersList_589223(
    name: "partnersOffersList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/offers",
    validator: validate_PartnersOffersList_589224, base: "/",
    url: url_PartnersOffersList_589225, schemes: {Scheme.Https})
type
  Call_PartnersOffersHistoryList_589249 = ref object of OpenApiRestCall_588450
proc url_PartnersOffersHistoryList_589251(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersOffersHistoryList_589250(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the Historical Offers for the current user (or user's entire company)
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to retrieve a specific page.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   entireCompany: JBool
  ##                : if true, show history for the entire company.  Requires user to be admin.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   orderBy: JString
  ##          : Comma-separated list of fields to order by, e.g.: "foo,bar,baz".
  ## Use "foo desc" to sort descending.
  ## List of valid field names is: name, offer_code, expiration_time, status,
  ##     last_modified_time, sender_name, creation_time, country_code,
  ##     offer_type.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of rows to return per page.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589252 = query.getOrDefault("upload_protocol")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "upload_protocol", valid_589252
  var valid_589253 = query.getOrDefault("fields")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "fields", valid_589253
  var valid_589254 = query.getOrDefault("pageToken")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = nil)
  if valid_589254 != nil:
    section.add "pageToken", valid_589254
  var valid_589255 = query.getOrDefault("quotaUser")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "quotaUser", valid_589255
  var valid_589256 = query.getOrDefault("entireCompany")
  valid_589256 = validateParameter(valid_589256, JBool, required = false, default = nil)
  if valid_589256 != nil:
    section.add "entireCompany", valid_589256
  var valid_589257 = query.getOrDefault("requestMetadata.locale")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "requestMetadata.locale", valid_589257
  var valid_589258 = query.getOrDefault("alt")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = newJString("json"))
  if valid_589258 != nil:
    section.add "alt", valid_589258
  var valid_589259 = query.getOrDefault("pp")
  valid_589259 = validateParameter(valid_589259, JBool, required = false,
                                 default = newJBool(true))
  if valid_589259 != nil:
    section.add "pp", valid_589259
  var valid_589260 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_589260
  var valid_589261 = query.getOrDefault("oauth_token")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "oauth_token", valid_589261
  var valid_589262 = query.getOrDefault("callback")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "callback", valid_589262
  var valid_589263 = query.getOrDefault("access_token")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "access_token", valid_589263
  var valid_589264 = query.getOrDefault("uploadType")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "uploadType", valid_589264
  var valid_589265 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_589265
  var valid_589266 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_589266
  var valid_589267 = query.getOrDefault("orderBy")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "orderBy", valid_589267
  var valid_589268 = query.getOrDefault("key")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "key", valid_589268
  var valid_589269 = query.getOrDefault("$.xgafv")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = newJString("1"))
  if valid_589269 != nil:
    section.add "$.xgafv", valid_589269
  var valid_589270 = query.getOrDefault("pageSize")
  valid_589270 = validateParameter(valid_589270, JInt, required = false, default = nil)
  if valid_589270 != nil:
    section.add "pageSize", valid_589270
  var valid_589271 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_589271 = validateParameter(valid_589271, JString, required = false,
                                 default = nil)
  if valid_589271 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_589271
  var valid_589272 = query.getOrDefault("requestMetadata.experimentIds")
  valid_589272 = validateParameter(valid_589272, JArray, required = false,
                                 default = nil)
  if valid_589272 != nil:
    section.add "requestMetadata.experimentIds", valid_589272
  var valid_589273 = query.getOrDefault("prettyPrint")
  valid_589273 = validateParameter(valid_589273, JBool, required = false,
                                 default = newJBool(true))
  if valid_589273 != nil:
    section.add "prettyPrint", valid_589273
  var valid_589274 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "requestMetadata.partnersSessionId", valid_589274
  var valid_589275 = query.getOrDefault("bearer_token")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "bearer_token", valid_589275
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589276: Call_PartnersOffersHistoryList_589249; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Historical Offers for the current user (or user's entire company)
  ## 
  let valid = call_589276.validator(path, query, header, formData, body)
  let scheme = call_589276.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589276.url(scheme.get, call_589276.host, call_589276.base,
                         call_589276.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589276, url, valid)

proc call*(call_589277: Call_PartnersOffersHistoryList_589249;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; entireCompany: bool = false;
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = "";
          orderBy: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersOffersHistoryList
  ## Lists the Historical Offers for the current user (or user's entire company)
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to retrieve a specific page.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   entireCompany: bool
  ##                : if true, show history for the entire company.  Requires user to be admin.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   orderBy: string
  ##          : Comma-separated list of fields to order by, e.g.: "foo,bar,baz".
  ## Use "foo desc" to sort descending.
  ## List of valid field names is: name, offer_code, expiration_time, status,
  ##     last_modified_time, sender_name, creation_time, country_code,
  ##     offer_type.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of rows to return per page.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_589278 = newJObject()
  add(query_589278, "upload_protocol", newJString(uploadProtocol))
  add(query_589278, "fields", newJString(fields))
  add(query_589278, "pageToken", newJString(pageToken))
  add(query_589278, "quotaUser", newJString(quotaUser))
  add(query_589278, "entireCompany", newJBool(entireCompany))
  add(query_589278, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_589278, "alt", newJString(alt))
  add(query_589278, "pp", newJBool(pp))
  add(query_589278, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_589278, "oauth_token", newJString(oauthToken))
  add(query_589278, "callback", newJString(callback))
  add(query_589278, "access_token", newJString(accessToken))
  add(query_589278, "uploadType", newJString(uploadType))
  add(query_589278, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_589278, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_589278, "orderBy", newJString(orderBy))
  add(query_589278, "key", newJString(key))
  add(query_589278, "$.xgafv", newJString(Xgafv))
  add(query_589278, "pageSize", newJInt(pageSize))
  add(query_589278, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_589278.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_589278, "prettyPrint", newJBool(prettyPrint))
  add(query_589278, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_589278, "bearer_token", newJString(bearerToken))
  result = call_589277.call(nil, query_589278, nil, nil, nil)

var partnersOffersHistoryList* = Call_PartnersOffersHistoryList_589249(
    name: "partnersOffersHistoryList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/offers/history",
    validator: validate_PartnersOffersHistoryList_589250, base: "/",
    url: url_PartnersOffersHistoryList_589251, schemes: {Scheme.Https})
type
  Call_PartnersGetPartnersstatus_589279 = ref object of OpenApiRestCall_588450
proc url_PartnersGetPartnersstatus_589281(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersGetPartnersstatus_589280(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets Partners Status of the logged in user's agency.
  ## Should only be called if the logged in user is the admin of the agency.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589282 = query.getOrDefault("upload_protocol")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "upload_protocol", valid_589282
  var valid_589283 = query.getOrDefault("fields")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "fields", valid_589283
  var valid_589284 = query.getOrDefault("quotaUser")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "quotaUser", valid_589284
  var valid_589285 = query.getOrDefault("requestMetadata.locale")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "requestMetadata.locale", valid_589285
  var valid_589286 = query.getOrDefault("alt")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = newJString("json"))
  if valid_589286 != nil:
    section.add "alt", valid_589286
  var valid_589287 = query.getOrDefault("pp")
  valid_589287 = validateParameter(valid_589287, JBool, required = false,
                                 default = newJBool(true))
  if valid_589287 != nil:
    section.add "pp", valid_589287
  var valid_589288 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_589288 = validateParameter(valid_589288, JString, required = false,
                                 default = nil)
  if valid_589288 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_589288
  var valid_589289 = query.getOrDefault("oauth_token")
  valid_589289 = validateParameter(valid_589289, JString, required = false,
                                 default = nil)
  if valid_589289 != nil:
    section.add "oauth_token", valid_589289
  var valid_589290 = query.getOrDefault("callback")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "callback", valid_589290
  var valid_589291 = query.getOrDefault("access_token")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "access_token", valid_589291
  var valid_589292 = query.getOrDefault("uploadType")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = nil)
  if valid_589292 != nil:
    section.add "uploadType", valid_589292
  var valid_589293 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_589293
  var valid_589294 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_589294
  var valid_589295 = query.getOrDefault("key")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "key", valid_589295
  var valid_589296 = query.getOrDefault("$.xgafv")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = newJString("1"))
  if valid_589296 != nil:
    section.add "$.xgafv", valid_589296
  var valid_589297 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_589297
  var valid_589298 = query.getOrDefault("requestMetadata.experimentIds")
  valid_589298 = validateParameter(valid_589298, JArray, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "requestMetadata.experimentIds", valid_589298
  var valid_589299 = query.getOrDefault("prettyPrint")
  valid_589299 = validateParameter(valid_589299, JBool, required = false,
                                 default = newJBool(true))
  if valid_589299 != nil:
    section.add "prettyPrint", valid_589299
  var valid_589300 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "requestMetadata.partnersSessionId", valid_589300
  var valid_589301 = query.getOrDefault("bearer_token")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "bearer_token", valid_589301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589302: Call_PartnersGetPartnersstatus_589279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets Partners Status of the logged in user's agency.
  ## Should only be called if the logged in user is the admin of the agency.
  ## 
  let valid = call_589302.validator(path, query, header, formData, body)
  let scheme = call_589302.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589302.url(scheme.get, call_589302.host, call_589302.base,
                         call_589302.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589302, url, valid)

proc call*(call_589303: Call_PartnersGetPartnersstatus_589279;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersGetPartnersstatus
  ## Gets Partners Status of the logged in user's agency.
  ## Should only be called if the logged in user is the admin of the agency.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_589304 = newJObject()
  add(query_589304, "upload_protocol", newJString(uploadProtocol))
  add(query_589304, "fields", newJString(fields))
  add(query_589304, "quotaUser", newJString(quotaUser))
  add(query_589304, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_589304, "alt", newJString(alt))
  add(query_589304, "pp", newJBool(pp))
  add(query_589304, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_589304, "oauth_token", newJString(oauthToken))
  add(query_589304, "callback", newJString(callback))
  add(query_589304, "access_token", newJString(accessToken))
  add(query_589304, "uploadType", newJString(uploadType))
  add(query_589304, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_589304, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_589304, "key", newJString(key))
  add(query_589304, "$.xgafv", newJString(Xgafv))
  add(query_589304, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_589304.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_589304, "prettyPrint", newJBool(prettyPrint))
  add(query_589304, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_589304, "bearer_token", newJString(bearerToken))
  result = call_589303.call(nil, query_589304, nil, nil, nil)

var partnersGetPartnersstatus* = Call_PartnersGetPartnersstatus_589279(
    name: "partnersGetPartnersstatus", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/partnersstatus",
    validator: validate_PartnersGetPartnersstatus_589280, base: "/",
    url: url_PartnersGetPartnersstatus_589281, schemes: {Scheme.Https})
type
  Call_PartnersUserEventsLog_589305 = ref object of OpenApiRestCall_588450
proc url_PartnersUserEventsLog_589307(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUserEventsLog_589306(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Logs a user event.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589308 = query.getOrDefault("upload_protocol")
  valid_589308 = validateParameter(valid_589308, JString, required = false,
                                 default = nil)
  if valid_589308 != nil:
    section.add "upload_protocol", valid_589308
  var valid_589309 = query.getOrDefault("fields")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "fields", valid_589309
  var valid_589310 = query.getOrDefault("quotaUser")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "quotaUser", valid_589310
  var valid_589311 = query.getOrDefault("alt")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = newJString("json"))
  if valid_589311 != nil:
    section.add "alt", valid_589311
  var valid_589312 = query.getOrDefault("pp")
  valid_589312 = validateParameter(valid_589312, JBool, required = false,
                                 default = newJBool(true))
  if valid_589312 != nil:
    section.add "pp", valid_589312
  var valid_589313 = query.getOrDefault("oauth_token")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "oauth_token", valid_589313
  var valid_589314 = query.getOrDefault("callback")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "callback", valid_589314
  var valid_589315 = query.getOrDefault("access_token")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "access_token", valid_589315
  var valid_589316 = query.getOrDefault("uploadType")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "uploadType", valid_589316
  var valid_589317 = query.getOrDefault("key")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "key", valid_589317
  var valid_589318 = query.getOrDefault("$.xgafv")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = newJString("1"))
  if valid_589318 != nil:
    section.add "$.xgafv", valid_589318
  var valid_589319 = query.getOrDefault("prettyPrint")
  valid_589319 = validateParameter(valid_589319, JBool, required = false,
                                 default = newJBool(true))
  if valid_589319 != nil:
    section.add "prettyPrint", valid_589319
  var valid_589320 = query.getOrDefault("bearer_token")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "bearer_token", valid_589320
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

proc call*(call_589322: Call_PartnersUserEventsLog_589305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Logs a user event.
  ## 
  let valid = call_589322.validator(path, query, header, formData, body)
  let scheme = call_589322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589322.url(scheme.get, call_589322.host, call_589322.base,
                         call_589322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589322, url, valid)

proc call*(call_589323: Call_PartnersUserEventsLog_589305;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; pp: bool = true; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## partnersUserEventsLog
  ## Logs a user event.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_589324 = newJObject()
  var body_589325 = newJObject()
  add(query_589324, "upload_protocol", newJString(uploadProtocol))
  add(query_589324, "fields", newJString(fields))
  add(query_589324, "quotaUser", newJString(quotaUser))
  add(query_589324, "alt", newJString(alt))
  add(query_589324, "pp", newJBool(pp))
  add(query_589324, "oauth_token", newJString(oauthToken))
  add(query_589324, "callback", newJString(callback))
  add(query_589324, "access_token", newJString(accessToken))
  add(query_589324, "uploadType", newJString(uploadType))
  add(query_589324, "key", newJString(key))
  add(query_589324, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589325 = body
  add(query_589324, "prettyPrint", newJBool(prettyPrint))
  add(query_589324, "bearer_token", newJString(bearerToken))
  result = call_589323.call(nil, query_589324, nil, nil, body_589325)

var partnersUserEventsLog* = Call_PartnersUserEventsLog_589305(
    name: "partnersUserEventsLog", meth: HttpMethod.HttpPost,
    host: "partners.googleapis.com", route: "/v2/userEvents:log",
    validator: validate_PartnersUserEventsLog_589306, base: "/",
    url: url_PartnersUserEventsLog_589307, schemes: {Scheme.Https})
type
  Call_PartnersUserStatesList_589326 = ref object of OpenApiRestCall_588450
proc url_PartnersUserStatesList_589328(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUserStatesList_589327(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists states for current user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589329 = query.getOrDefault("upload_protocol")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "upload_protocol", valid_589329
  var valid_589330 = query.getOrDefault("fields")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "fields", valid_589330
  var valid_589331 = query.getOrDefault("quotaUser")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "quotaUser", valid_589331
  var valid_589332 = query.getOrDefault("requestMetadata.locale")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "requestMetadata.locale", valid_589332
  var valid_589333 = query.getOrDefault("alt")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = newJString("json"))
  if valid_589333 != nil:
    section.add "alt", valid_589333
  var valid_589334 = query.getOrDefault("pp")
  valid_589334 = validateParameter(valid_589334, JBool, required = false,
                                 default = newJBool(true))
  if valid_589334 != nil:
    section.add "pp", valid_589334
  var valid_589335 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_589335
  var valid_589336 = query.getOrDefault("oauth_token")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "oauth_token", valid_589336
  var valid_589337 = query.getOrDefault("callback")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "callback", valid_589337
  var valid_589338 = query.getOrDefault("access_token")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "access_token", valid_589338
  var valid_589339 = query.getOrDefault("uploadType")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "uploadType", valid_589339
  var valid_589340 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_589340
  var valid_589341 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_589341 = validateParameter(valid_589341, JString, required = false,
                                 default = nil)
  if valid_589341 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_589341
  var valid_589342 = query.getOrDefault("key")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "key", valid_589342
  var valid_589343 = query.getOrDefault("$.xgafv")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = newJString("1"))
  if valid_589343 != nil:
    section.add "$.xgafv", valid_589343
  var valid_589344 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_589344
  var valid_589345 = query.getOrDefault("requestMetadata.experimentIds")
  valid_589345 = validateParameter(valid_589345, JArray, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "requestMetadata.experimentIds", valid_589345
  var valid_589346 = query.getOrDefault("prettyPrint")
  valid_589346 = validateParameter(valid_589346, JBool, required = false,
                                 default = newJBool(true))
  if valid_589346 != nil:
    section.add "prettyPrint", valid_589346
  var valid_589347 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "requestMetadata.partnersSessionId", valid_589347
  var valid_589348 = query.getOrDefault("bearer_token")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "bearer_token", valid_589348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589349: Call_PartnersUserStatesList_589326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists states for current user.
  ## 
  let valid = call_589349.validator(path, query, header, formData, body)
  let scheme = call_589349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589349.url(scheme.get, call_589349.host, call_589349.base,
                         call_589349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589349, url, valid)

proc call*(call_589350: Call_PartnersUserStatesList_589326;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersUserStatesList
  ## Lists states for current user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_589351 = newJObject()
  add(query_589351, "upload_protocol", newJString(uploadProtocol))
  add(query_589351, "fields", newJString(fields))
  add(query_589351, "quotaUser", newJString(quotaUser))
  add(query_589351, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_589351, "alt", newJString(alt))
  add(query_589351, "pp", newJBool(pp))
  add(query_589351, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_589351, "oauth_token", newJString(oauthToken))
  add(query_589351, "callback", newJString(callback))
  add(query_589351, "access_token", newJString(accessToken))
  add(query_589351, "uploadType", newJString(uploadType))
  add(query_589351, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_589351, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_589351, "key", newJString(key))
  add(query_589351, "$.xgafv", newJString(Xgafv))
  add(query_589351, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_589351.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_589351, "prettyPrint", newJBool(prettyPrint))
  add(query_589351, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_589351, "bearer_token", newJString(bearerToken))
  result = call_589350.call(nil, query_589351, nil, nil, nil)

var partnersUserStatesList* = Call_PartnersUserStatesList_589326(
    name: "partnersUserStatesList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/userStates",
    validator: validate_PartnersUserStatesList_589327, base: "/",
    url: url_PartnersUserStatesList_589328, schemes: {Scheme.Https})
type
  Call_PartnersUsersUpdateProfile_589352 = ref object of OpenApiRestCall_588450
proc url_PartnersUsersUpdateProfile_589354(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PartnersUsersUpdateProfile_589353(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a user's profile. A user can only update their own profile and
  ## should only be called within the context of a logged in user.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589355 = query.getOrDefault("upload_protocol")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "upload_protocol", valid_589355
  var valid_589356 = query.getOrDefault("fields")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = nil)
  if valid_589356 != nil:
    section.add "fields", valid_589356
  var valid_589357 = query.getOrDefault("quotaUser")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "quotaUser", valid_589357
  var valid_589358 = query.getOrDefault("requestMetadata.locale")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "requestMetadata.locale", valid_589358
  var valid_589359 = query.getOrDefault("alt")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = newJString("json"))
  if valid_589359 != nil:
    section.add "alt", valid_589359
  var valid_589360 = query.getOrDefault("pp")
  valid_589360 = validateParameter(valid_589360, JBool, required = false,
                                 default = newJBool(true))
  if valid_589360 != nil:
    section.add "pp", valid_589360
  var valid_589361 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_589361
  var valid_589362 = query.getOrDefault("oauth_token")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "oauth_token", valid_589362
  var valid_589363 = query.getOrDefault("callback")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "callback", valid_589363
  var valid_589364 = query.getOrDefault("access_token")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "access_token", valid_589364
  var valid_589365 = query.getOrDefault("uploadType")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "uploadType", valid_589365
  var valid_589366 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_589366
  var valid_589367 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = nil)
  if valid_589367 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_589367
  var valid_589368 = query.getOrDefault("key")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "key", valid_589368
  var valid_589369 = query.getOrDefault("$.xgafv")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = newJString("1"))
  if valid_589369 != nil:
    section.add "$.xgafv", valid_589369
  var valid_589370 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_589370
  var valid_589371 = query.getOrDefault("requestMetadata.experimentIds")
  valid_589371 = validateParameter(valid_589371, JArray, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "requestMetadata.experimentIds", valid_589371
  var valid_589372 = query.getOrDefault("prettyPrint")
  valid_589372 = validateParameter(valid_589372, JBool, required = false,
                                 default = newJBool(true))
  if valid_589372 != nil:
    section.add "prettyPrint", valid_589372
  var valid_589373 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = nil)
  if valid_589373 != nil:
    section.add "requestMetadata.partnersSessionId", valid_589373
  var valid_589374 = query.getOrDefault("bearer_token")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "bearer_token", valid_589374
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

proc call*(call_589376: Call_PartnersUsersUpdateProfile_589352; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a user's profile. A user can only update their own profile and
  ## should only be called within the context of a logged in user.
  ## 
  let valid = call_589376.validator(path, query, header, formData, body)
  let scheme = call_589376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589376.url(scheme.get, call_589376.host, call_589376.base,
                         call_589376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589376, url, valid)

proc call*(call_589377: Call_PartnersUsersUpdateProfile_589352;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; body: JsonNode = nil;
          prettyPrint: bool = true; requestMetadataPartnersSessionId: string = "";
          bearerToken: string = ""): Recallable =
  ## partnersUsersUpdateProfile
  ## Updates a user's profile. A user can only update their own profile and
  ## should only be called within the context of a logged in user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var query_589378 = newJObject()
  var body_589379 = newJObject()
  add(query_589378, "upload_protocol", newJString(uploadProtocol))
  add(query_589378, "fields", newJString(fields))
  add(query_589378, "quotaUser", newJString(quotaUser))
  add(query_589378, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_589378, "alt", newJString(alt))
  add(query_589378, "pp", newJBool(pp))
  add(query_589378, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_589378, "oauth_token", newJString(oauthToken))
  add(query_589378, "callback", newJString(callback))
  add(query_589378, "access_token", newJString(accessToken))
  add(query_589378, "uploadType", newJString(uploadType))
  add(query_589378, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_589378, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_589378, "key", newJString(key))
  add(query_589378, "$.xgafv", newJString(Xgafv))
  add(query_589378, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_589378.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_589379 = body
  add(query_589378, "prettyPrint", newJBool(prettyPrint))
  add(query_589378, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_589378, "bearer_token", newJString(bearerToken))
  result = call_589377.call(nil, query_589378, nil, nil, body_589379)

var partnersUsersUpdateProfile* = Call_PartnersUsersUpdateProfile_589352(
    name: "partnersUsersUpdateProfile", meth: HttpMethod.HttpPatch,
    host: "partners.googleapis.com", route: "/v2/users/profile",
    validator: validate_PartnersUsersUpdateProfile_589353, base: "/",
    url: url_PartnersUsersUpdateProfile_589354, schemes: {Scheme.Https})
type
  Call_PartnersUsersGet_589380 = ref object of OpenApiRestCall_588450
proc url_PartnersUsersGet_589382(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnersUsersGet_589381(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Gets a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : Identifier of the user. Can be set to <code>me</code> to mean the currently
  ## authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_589383 = path.getOrDefault("userId")
  valid_589383 = validateParameter(valid_589383, JString, required = true,
                                 default = nil)
  if valid_589383 != nil:
    section.add "userId", valid_589383
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   userView: JString
  ##           : Specifies what parts of the user information to return.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589384 = query.getOrDefault("upload_protocol")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "upload_protocol", valid_589384
  var valid_589385 = query.getOrDefault("fields")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "fields", valid_589385
  var valid_589386 = query.getOrDefault("quotaUser")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "quotaUser", valid_589386
  var valid_589387 = query.getOrDefault("requestMetadata.locale")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "requestMetadata.locale", valid_589387
  var valid_589388 = query.getOrDefault("alt")
  valid_589388 = validateParameter(valid_589388, JString, required = false,
                                 default = newJString("json"))
  if valid_589388 != nil:
    section.add "alt", valid_589388
  var valid_589389 = query.getOrDefault("pp")
  valid_589389 = validateParameter(valid_589389, JBool, required = false,
                                 default = newJBool(true))
  if valid_589389 != nil:
    section.add "pp", valid_589389
  var valid_589390 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_589390
  var valid_589391 = query.getOrDefault("userView")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589391 != nil:
    section.add "userView", valid_589391
  var valid_589392 = query.getOrDefault("oauth_token")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = nil)
  if valid_589392 != nil:
    section.add "oauth_token", valid_589392
  var valid_589393 = query.getOrDefault("callback")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "callback", valid_589393
  var valid_589394 = query.getOrDefault("access_token")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "access_token", valid_589394
  var valid_589395 = query.getOrDefault("uploadType")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "uploadType", valid_589395
  var valid_589396 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_589396
  var valid_589397 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_589397
  var valid_589398 = query.getOrDefault("key")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "key", valid_589398
  var valid_589399 = query.getOrDefault("$.xgafv")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = newJString("1"))
  if valid_589399 != nil:
    section.add "$.xgafv", valid_589399
  var valid_589400 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_589400
  var valid_589401 = query.getOrDefault("requestMetadata.experimentIds")
  valid_589401 = validateParameter(valid_589401, JArray, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "requestMetadata.experimentIds", valid_589401
  var valid_589402 = query.getOrDefault("prettyPrint")
  valid_589402 = validateParameter(valid_589402, JBool, required = false,
                                 default = newJBool(true))
  if valid_589402 != nil:
    section.add "prettyPrint", valid_589402
  var valid_589403 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = nil)
  if valid_589403 != nil:
    section.add "requestMetadata.partnersSessionId", valid_589403
  var valid_589404 = query.getOrDefault("bearer_token")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "bearer_token", valid_589404
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589405: Call_PartnersUsersGet_589380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a user.
  ## 
  let valid = call_589405.validator(path, query, header, formData, body)
  let scheme = call_589405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589405.url(scheme.get, call_589405.host, call_589405.base,
                         call_589405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589405, url, valid)

proc call*(call_589406: Call_PartnersUsersGet_589380; userId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          requestMetadataLocale: string = ""; alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          userView: string = "BASIC"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersUsersGet
  ## Gets a user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   userView: string
  ##           : Specifies what parts of the user information to return.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : Identifier of the user. Can be set to <code>me</code> to mean the currently
  ## authenticated user.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589407 = newJObject()
  var query_589408 = newJObject()
  add(query_589408, "upload_protocol", newJString(uploadProtocol))
  add(query_589408, "fields", newJString(fields))
  add(query_589408, "quotaUser", newJString(quotaUser))
  add(query_589408, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_589408, "alt", newJString(alt))
  add(query_589408, "pp", newJBool(pp))
  add(query_589408, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_589408, "userView", newJString(userView))
  add(query_589408, "oauth_token", newJString(oauthToken))
  add(query_589408, "callback", newJString(callback))
  add(query_589408, "access_token", newJString(accessToken))
  add(query_589408, "uploadType", newJString(uploadType))
  add(query_589408, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_589408, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_589408, "key", newJString(key))
  add(query_589408, "$.xgafv", newJString(Xgafv))
  add(query_589408, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_589408.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_589408, "prettyPrint", newJBool(prettyPrint))
  add(path_589407, "userId", newJString(userId))
  add(query_589408, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_589408, "bearer_token", newJString(bearerToken))
  result = call_589406.call(path_589407, query_589408, nil, nil, nil)

var partnersUsersGet* = Call_PartnersUsersGet_589380(name: "partnersUsersGet",
    meth: HttpMethod.HttpGet, host: "partners.googleapis.com",
    route: "/v2/users/{userId}", validator: validate_PartnersUsersGet_589381,
    base: "/", url: url_PartnersUsersGet_589382, schemes: {Scheme.Https})
type
  Call_PartnersUsersCreateCompanyRelation_589409 = ref object of OpenApiRestCall_588450
proc url_PartnersUsersCreateCompanyRelation_589411(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/companyRelation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnersUsersCreateCompanyRelation_589410(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a user's company relation. Affiliates the user to a company.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The ID of the user. Can be set to <code>me</code> to mean
  ## the currently authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_589412 = path.getOrDefault("userId")
  valid_589412 = validateParameter(valid_589412, JString, required = true,
                                 default = nil)
  if valid_589412 != nil:
    section.add "userId", valid_589412
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589413 = query.getOrDefault("upload_protocol")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "upload_protocol", valid_589413
  var valid_589414 = query.getOrDefault("fields")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "fields", valid_589414
  var valid_589415 = query.getOrDefault("quotaUser")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "quotaUser", valid_589415
  var valid_589416 = query.getOrDefault("requestMetadata.locale")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "requestMetadata.locale", valid_589416
  var valid_589417 = query.getOrDefault("alt")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = newJString("json"))
  if valid_589417 != nil:
    section.add "alt", valid_589417
  var valid_589418 = query.getOrDefault("pp")
  valid_589418 = validateParameter(valid_589418, JBool, required = false,
                                 default = newJBool(true))
  if valid_589418 != nil:
    section.add "pp", valid_589418
  var valid_589419 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = nil)
  if valid_589419 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_589419
  var valid_589420 = query.getOrDefault("oauth_token")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "oauth_token", valid_589420
  var valid_589421 = query.getOrDefault("callback")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "callback", valid_589421
  var valid_589422 = query.getOrDefault("access_token")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "access_token", valid_589422
  var valid_589423 = query.getOrDefault("uploadType")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "uploadType", valid_589423
  var valid_589424 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = nil)
  if valid_589424 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_589424
  var valid_589425 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_589425
  var valid_589426 = query.getOrDefault("key")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "key", valid_589426
  var valid_589427 = query.getOrDefault("$.xgafv")
  valid_589427 = validateParameter(valid_589427, JString, required = false,
                                 default = newJString("1"))
  if valid_589427 != nil:
    section.add "$.xgafv", valid_589427
  var valid_589428 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_589428 = validateParameter(valid_589428, JString, required = false,
                                 default = nil)
  if valid_589428 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_589428
  var valid_589429 = query.getOrDefault("requestMetadata.experimentIds")
  valid_589429 = validateParameter(valid_589429, JArray, required = false,
                                 default = nil)
  if valid_589429 != nil:
    section.add "requestMetadata.experimentIds", valid_589429
  var valid_589430 = query.getOrDefault("prettyPrint")
  valid_589430 = validateParameter(valid_589430, JBool, required = false,
                                 default = newJBool(true))
  if valid_589430 != nil:
    section.add "prettyPrint", valid_589430
  var valid_589431 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "requestMetadata.partnersSessionId", valid_589431
  var valid_589432 = query.getOrDefault("bearer_token")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "bearer_token", valid_589432
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

proc call*(call_589434: Call_PartnersUsersCreateCompanyRelation_589409;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a user's company relation. Affiliates the user to a company.
  ## 
  let valid = call_589434.validator(path, query, header, formData, body)
  let scheme = call_589434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589434.url(scheme.get, call_589434.host, call_589434.base,
                         call_589434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589434, url, valid)

proc call*(call_589435: Call_PartnersUsersCreateCompanyRelation_589409;
          userId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; requestMetadataLocale: string = "";
          alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; body: JsonNode = nil;
          prettyPrint: bool = true; requestMetadataPartnersSessionId: string = "";
          bearerToken: string = ""): Recallable =
  ## partnersUsersCreateCompanyRelation
  ## Creates a user's company relation. Affiliates the user to a company.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user. Can be set to <code>me</code> to mean
  ## the currently authenticated user.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589436 = newJObject()
  var query_589437 = newJObject()
  var body_589438 = newJObject()
  add(query_589437, "upload_protocol", newJString(uploadProtocol))
  add(query_589437, "fields", newJString(fields))
  add(query_589437, "quotaUser", newJString(quotaUser))
  add(query_589437, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_589437, "alt", newJString(alt))
  add(query_589437, "pp", newJBool(pp))
  add(query_589437, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_589437, "oauth_token", newJString(oauthToken))
  add(query_589437, "callback", newJString(callback))
  add(query_589437, "access_token", newJString(accessToken))
  add(query_589437, "uploadType", newJString(uploadType))
  add(query_589437, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_589437, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_589437, "key", newJString(key))
  add(query_589437, "$.xgafv", newJString(Xgafv))
  add(query_589437, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_589437.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_589438 = body
  add(query_589437, "prettyPrint", newJBool(prettyPrint))
  add(path_589436, "userId", newJString(userId))
  add(query_589437, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_589437, "bearer_token", newJString(bearerToken))
  result = call_589435.call(path_589436, query_589437, nil, nil, body_589438)

var partnersUsersCreateCompanyRelation* = Call_PartnersUsersCreateCompanyRelation_589409(
    name: "partnersUsersCreateCompanyRelation", meth: HttpMethod.HttpPut,
    host: "partners.googleapis.com", route: "/v2/users/{userId}/companyRelation",
    validator: validate_PartnersUsersCreateCompanyRelation_589410, base: "/",
    url: url_PartnersUsersCreateCompanyRelation_589411, schemes: {Scheme.Https})
type
  Call_PartnersUsersDeleteCompanyRelation_589439 = ref object of OpenApiRestCall_588450
proc url_PartnersUsersDeleteCompanyRelation_589441(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/companyRelation")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnersUsersDeleteCompanyRelation_589440(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a user's company relation. Unaffiliaites the user from a company.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userId: JString (required)
  ##         : The ID of the user. Can be set to <code>me</code> to mean
  ## the currently authenticated user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userId` field"
  var valid_589442 = path.getOrDefault("userId")
  valid_589442 = validateParameter(valid_589442, JString, required = true,
                                 default = nil)
  if valid_589442 != nil:
    section.add "userId", valid_589442
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadata.locale: JString
  ##                         : Locale to use for the current request.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   requestMetadata.userOverrides.ipAddress: JString
  ##                                          : IP address to use instead of the user's geo-located IP address.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadata.trafficSource.trafficSourceId: JString
  ##                                                : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadata.trafficSource.trafficSubId: JString
  ##                                             : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   requestMetadata.userOverrides.userId: JString
  ##                                       : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadata.experimentIds: JArray
  ##                                : Experiment IDs the current request belongs to.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMetadata.partnersSessionId: JString
  ##                                    : Google Partners session ID.
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589443 = query.getOrDefault("upload_protocol")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "upload_protocol", valid_589443
  var valid_589444 = query.getOrDefault("fields")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "fields", valid_589444
  var valid_589445 = query.getOrDefault("quotaUser")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "quotaUser", valid_589445
  var valid_589446 = query.getOrDefault("requestMetadata.locale")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "requestMetadata.locale", valid_589446
  var valid_589447 = query.getOrDefault("alt")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = newJString("json"))
  if valid_589447 != nil:
    section.add "alt", valid_589447
  var valid_589448 = query.getOrDefault("pp")
  valid_589448 = validateParameter(valid_589448, JBool, required = false,
                                 default = newJBool(true))
  if valid_589448 != nil:
    section.add "pp", valid_589448
  var valid_589449 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_589449
  var valid_589450 = query.getOrDefault("oauth_token")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "oauth_token", valid_589450
  var valid_589451 = query.getOrDefault("callback")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "callback", valid_589451
  var valid_589452 = query.getOrDefault("access_token")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "access_token", valid_589452
  var valid_589453 = query.getOrDefault("uploadType")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "uploadType", valid_589453
  var valid_589454 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_589454
  var valid_589455 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_589455
  var valid_589456 = query.getOrDefault("key")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "key", valid_589456
  var valid_589457 = query.getOrDefault("$.xgafv")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = newJString("1"))
  if valid_589457 != nil:
    section.add "$.xgafv", valid_589457
  var valid_589458 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_589458
  var valid_589459 = query.getOrDefault("requestMetadata.experimentIds")
  valid_589459 = validateParameter(valid_589459, JArray, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "requestMetadata.experimentIds", valid_589459
  var valid_589460 = query.getOrDefault("prettyPrint")
  valid_589460 = validateParameter(valid_589460, JBool, required = false,
                                 default = newJBool(true))
  if valid_589460 != nil:
    section.add "prettyPrint", valid_589460
  var valid_589461 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "requestMetadata.partnersSessionId", valid_589461
  var valid_589462 = query.getOrDefault("bearer_token")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = nil)
  if valid_589462 != nil:
    section.add "bearer_token", valid_589462
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589463: Call_PartnersUsersDeleteCompanyRelation_589439;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a user's company relation. Unaffiliaites the user from a company.
  ## 
  let valid = call_589463.validator(path, query, header, formData, body)
  let scheme = call_589463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589463.url(scheme.get, call_589463.host, call_589463.base,
                         call_589463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589463, url, valid)

proc call*(call_589464: Call_PartnersUsersDeleteCompanyRelation_589439;
          userId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; requestMetadataLocale: string = "";
          alt: string = "json"; pp: bool = true;
          requestMetadataUserOverridesIpAddress: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = "";
          requestMetadataTrafficSourceTrafficSourceId: string = "";
          requestMetadataTrafficSourceTrafficSubId: string = ""; key: string = "";
          Xgafv: string = "1"; requestMetadataUserOverridesUserId: string = "";
          requestMetadataExperimentIds: JsonNode = nil; prettyPrint: bool = true;
          requestMetadataPartnersSessionId: string = ""; bearerToken: string = ""): Recallable =
  ## partnersUsersDeleteCompanyRelation
  ## Deletes a user's company relation. Unaffiliaites the user from a company.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   requestMetadataLocale: string
  ##                        : Locale to use for the current request.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   requestMetadataUserOverridesIpAddress: string
  ##                                        : IP address to use instead of the user's geo-located IP address.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   requestMetadataTrafficSourceTrafficSourceId: string
  ##                                              : Identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   requestMetadataTrafficSourceTrafficSubId: string
  ##                                           : Second level identifier to indicate where the traffic comes from.
  ## An identifier has multiple letters created by a team which redirected the
  ## traffic to us.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   requestMetadataUserOverridesUserId: string
  ##                                     : Logged-in user ID to impersonate instead of the user's ID.
  ##   requestMetadataExperimentIds: JArray
  ##                               : Experiment IDs the current request belongs to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user. Can be set to <code>me</code> to mean
  ## the currently authenticated user.
  ##   requestMetadataPartnersSessionId: string
  ##                                   : Google Partners session ID.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589465 = newJObject()
  var query_589466 = newJObject()
  add(query_589466, "upload_protocol", newJString(uploadProtocol))
  add(query_589466, "fields", newJString(fields))
  add(query_589466, "quotaUser", newJString(quotaUser))
  add(query_589466, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_589466, "alt", newJString(alt))
  add(query_589466, "pp", newJBool(pp))
  add(query_589466, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_589466, "oauth_token", newJString(oauthToken))
  add(query_589466, "callback", newJString(callback))
  add(query_589466, "access_token", newJString(accessToken))
  add(query_589466, "uploadType", newJString(uploadType))
  add(query_589466, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_589466, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_589466, "key", newJString(key))
  add(query_589466, "$.xgafv", newJString(Xgafv))
  add(query_589466, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_589466.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_589466, "prettyPrint", newJBool(prettyPrint))
  add(path_589465, "userId", newJString(userId))
  add(query_589466, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_589466, "bearer_token", newJString(bearerToken))
  result = call_589464.call(path_589465, query_589466, nil, nil, nil)

var partnersUsersDeleteCompanyRelation* = Call_PartnersUsersDeleteCompanyRelation_589439(
    name: "partnersUsersDeleteCompanyRelation", meth: HttpMethod.HttpDelete,
    host: "partners.googleapis.com", route: "/v2/users/{userId}/companyRelation",
    validator: validate_PartnersUsersDeleteCompanyRelation_589440, base: "/",
    url: url_PartnersUsersDeleteCompanyRelation_589441, schemes: {Scheme.Https})
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
