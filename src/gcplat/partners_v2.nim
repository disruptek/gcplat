
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
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
  gcpServiceName = "partners"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PartnersAnalyticsList_593690 = ref object of OpenApiRestCall_593421
proc url_PartnersAnalyticsList_593692(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersAnalyticsList_593691(path: JsonNode; query: JsonNode;
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
  var valid_593804 = query.getOrDefault("upload_protocol")
  valid_593804 = validateParameter(valid_593804, JString, required = false,
                                 default = nil)
  if valid_593804 != nil:
    section.add "upload_protocol", valid_593804
  var valid_593805 = query.getOrDefault("fields")
  valid_593805 = validateParameter(valid_593805, JString, required = false,
                                 default = nil)
  if valid_593805 != nil:
    section.add "fields", valid_593805
  var valid_593806 = query.getOrDefault("pageToken")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "pageToken", valid_593806
  var valid_593807 = query.getOrDefault("quotaUser")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "quotaUser", valid_593807
  var valid_593808 = query.getOrDefault("requestMetadata.locale")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "requestMetadata.locale", valid_593808
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("pp")
  valid_593823 = validateParameter(valid_593823, JBool, required = false,
                                 default = newJBool(true))
  if valid_593823 != nil:
    section.add "pp", valid_593823
  var valid_593824 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_593824
  var valid_593825 = query.getOrDefault("oauth_token")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "oauth_token", valid_593825
  var valid_593826 = query.getOrDefault("callback")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "callback", valid_593826
  var valid_593827 = query.getOrDefault("access_token")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "access_token", valid_593827
  var valid_593828 = query.getOrDefault("uploadType")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = nil)
  if valid_593828 != nil:
    section.add "uploadType", valid_593828
  var valid_593829 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_593829 = validateParameter(valid_593829, JString, required = false,
                                 default = nil)
  if valid_593829 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_593829
  var valid_593830 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_593830 = validateParameter(valid_593830, JString, required = false,
                                 default = nil)
  if valid_593830 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_593830
  var valid_593831 = query.getOrDefault("key")
  valid_593831 = validateParameter(valid_593831, JString, required = false,
                                 default = nil)
  if valid_593831 != nil:
    section.add "key", valid_593831
  var valid_593832 = query.getOrDefault("$.xgafv")
  valid_593832 = validateParameter(valid_593832, JString, required = false,
                                 default = newJString("1"))
  if valid_593832 != nil:
    section.add "$.xgafv", valid_593832
  var valid_593833 = query.getOrDefault("pageSize")
  valid_593833 = validateParameter(valid_593833, JInt, required = false, default = nil)
  if valid_593833 != nil:
    section.add "pageSize", valid_593833
  var valid_593834 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_593834 = validateParameter(valid_593834, JString, required = false,
                                 default = nil)
  if valid_593834 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_593834
  var valid_593835 = query.getOrDefault("requestMetadata.experimentIds")
  valid_593835 = validateParameter(valid_593835, JArray, required = false,
                                 default = nil)
  if valid_593835 != nil:
    section.add "requestMetadata.experimentIds", valid_593835
  var valid_593836 = query.getOrDefault("prettyPrint")
  valid_593836 = validateParameter(valid_593836, JBool, required = false,
                                 default = newJBool(true))
  if valid_593836 != nil:
    section.add "prettyPrint", valid_593836
  var valid_593837 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "requestMetadata.partnersSessionId", valid_593837
  var valid_593838 = query.getOrDefault("bearer_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "bearer_token", valid_593838
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593861: Call_PartnersAnalyticsList_593690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists analytics data for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  let valid = call_593861.validator(path, query, header, formData, body)
  let scheme = call_593861.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593861.url(scheme.get, call_593861.host, call_593861.base,
                         call_593861.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593861, url, valid)

proc call*(call_593932: Call_PartnersAnalyticsList_593690;
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
  var query_593933 = newJObject()
  add(query_593933, "upload_protocol", newJString(uploadProtocol))
  add(query_593933, "fields", newJString(fields))
  add(query_593933, "pageToken", newJString(pageToken))
  add(query_593933, "quotaUser", newJString(quotaUser))
  add(query_593933, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_593933, "alt", newJString(alt))
  add(query_593933, "pp", newJBool(pp))
  add(query_593933, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_593933, "oauth_token", newJString(oauthToken))
  add(query_593933, "callback", newJString(callback))
  add(query_593933, "access_token", newJString(accessToken))
  add(query_593933, "uploadType", newJString(uploadType))
  add(query_593933, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_593933, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_593933, "key", newJString(key))
  add(query_593933, "$.xgafv", newJString(Xgafv))
  add(query_593933, "pageSize", newJInt(pageSize))
  add(query_593933, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_593933.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_593933, "prettyPrint", newJBool(prettyPrint))
  add(query_593933, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_593933, "bearer_token", newJString(bearerToken))
  result = call_593932.call(nil, query_593933, nil, nil, nil)

var partnersAnalyticsList* = Call_PartnersAnalyticsList_593690(
    name: "partnersAnalyticsList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/analytics",
    validator: validate_PartnersAnalyticsList_593691, base: "/",
    url: url_PartnersAnalyticsList_593692, schemes: {Scheme.Https})
type
  Call_PartnersClientMessagesLog_593973 = ref object of OpenApiRestCall_593421
proc url_PartnersClientMessagesLog_593975(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersClientMessagesLog_593974(path: JsonNode; query: JsonNode;
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
  var valid_593976 = query.getOrDefault("upload_protocol")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "upload_protocol", valid_593976
  var valid_593977 = query.getOrDefault("fields")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "fields", valid_593977
  var valid_593978 = query.getOrDefault("quotaUser")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "quotaUser", valid_593978
  var valid_593979 = query.getOrDefault("alt")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = newJString("json"))
  if valid_593979 != nil:
    section.add "alt", valid_593979
  var valid_593980 = query.getOrDefault("pp")
  valid_593980 = validateParameter(valid_593980, JBool, required = false,
                                 default = newJBool(true))
  if valid_593980 != nil:
    section.add "pp", valid_593980
  var valid_593981 = query.getOrDefault("oauth_token")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "oauth_token", valid_593981
  var valid_593982 = query.getOrDefault("callback")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "callback", valid_593982
  var valid_593983 = query.getOrDefault("access_token")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "access_token", valid_593983
  var valid_593984 = query.getOrDefault("uploadType")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "uploadType", valid_593984
  var valid_593985 = query.getOrDefault("key")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = nil)
  if valid_593985 != nil:
    section.add "key", valid_593985
  var valid_593986 = query.getOrDefault("$.xgafv")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = newJString("1"))
  if valid_593986 != nil:
    section.add "$.xgafv", valid_593986
  var valid_593987 = query.getOrDefault("prettyPrint")
  valid_593987 = validateParameter(valid_593987, JBool, required = false,
                                 default = newJBool(true))
  if valid_593987 != nil:
    section.add "prettyPrint", valid_593987
  var valid_593988 = query.getOrDefault("bearer_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "bearer_token", valid_593988
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

proc call*(call_593990: Call_PartnersClientMessagesLog_593973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Logs a generic message from the client, such as
  ## `Failed to render component`, `Profile page is running slow`,
  ## `More than 500 users have accessed this result.`, etc.
  ## 
  let valid = call_593990.validator(path, query, header, formData, body)
  let scheme = call_593990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593990.url(scheme.get, call_593990.host, call_593990.base,
                         call_593990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593990, url, valid)

proc call*(call_593991: Call_PartnersClientMessagesLog_593973;
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
  var query_593992 = newJObject()
  var body_593993 = newJObject()
  add(query_593992, "upload_protocol", newJString(uploadProtocol))
  add(query_593992, "fields", newJString(fields))
  add(query_593992, "quotaUser", newJString(quotaUser))
  add(query_593992, "alt", newJString(alt))
  add(query_593992, "pp", newJBool(pp))
  add(query_593992, "oauth_token", newJString(oauthToken))
  add(query_593992, "callback", newJString(callback))
  add(query_593992, "access_token", newJString(accessToken))
  add(query_593992, "uploadType", newJString(uploadType))
  add(query_593992, "key", newJString(key))
  add(query_593992, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593993 = body
  add(query_593992, "prettyPrint", newJBool(prettyPrint))
  add(query_593992, "bearer_token", newJString(bearerToken))
  result = call_593991.call(nil, query_593992, nil, nil, body_593993)

var partnersClientMessagesLog* = Call_PartnersClientMessagesLog_593973(
    name: "partnersClientMessagesLog", meth: HttpMethod.HttpPost,
    host: "partners.googleapis.com", route: "/v2/clientMessages:log",
    validator: validate_PartnersClientMessagesLog_593974, base: "/",
    url: url_PartnersClientMessagesLog_593975, schemes: {Scheme.Https})
type
  Call_PartnersCompaniesList_593994 = ref object of OpenApiRestCall_593421
proc url_PartnersCompaniesList_593996(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersCompaniesList_593995(path: JsonNode; query: JsonNode;
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
  var valid_593997 = query.getOrDefault("upload_protocol")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "upload_protocol", valid_593997
  var valid_593998 = query.getOrDefault("maxMonthlyBudget.units")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "maxMonthlyBudget.units", valid_593998
  var valid_593999 = query.getOrDefault("fields")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "fields", valid_593999
  var valid_594000 = query.getOrDefault("industries")
  valid_594000 = validateParameter(valid_594000, JArray, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "industries", valid_594000
  var valid_594001 = query.getOrDefault("quotaUser")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "quotaUser", valid_594001
  var valid_594002 = query.getOrDefault("pageToken")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "pageToken", valid_594002
  var valid_594003 = query.getOrDefault("view")
  valid_594003 = validateParameter(valid_594003, JString, required = false, default = newJString(
      "COMPANY_VIEW_UNSPECIFIED"))
  if valid_594003 != nil:
    section.add "view", valid_594003
  var valid_594004 = query.getOrDefault("alt")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("json"))
  if valid_594004 != nil:
    section.add "alt", valid_594004
  var valid_594005 = query.getOrDefault("requestMetadata.locale")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "requestMetadata.locale", valid_594005
  var valid_594006 = query.getOrDefault("gpsMotivations")
  valid_594006 = validateParameter(valid_594006, JArray, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "gpsMotivations", valid_594006
  var valid_594007 = query.getOrDefault("pp")
  valid_594007 = validateParameter(valid_594007, JBool, required = false,
                                 default = newJBool(true))
  if valid_594007 != nil:
    section.add "pp", valid_594007
  var valid_594008 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_594008
  var valid_594009 = query.getOrDefault("specializations")
  valid_594009 = validateParameter(valid_594009, JArray, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "specializations", valid_594009
  var valid_594010 = query.getOrDefault("oauth_token")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "oauth_token", valid_594010
  var valid_594011 = query.getOrDefault("callback")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "callback", valid_594011
  var valid_594012 = query.getOrDefault("access_token")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "access_token", valid_594012
  var valid_594013 = query.getOrDefault("uploadType")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "uploadType", valid_594013
  var valid_594014 = query.getOrDefault("minMonthlyBudget.currencyCode")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "minMonthlyBudget.currencyCode", valid_594014
  var valid_594015 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_594015
  var valid_594016 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_594016
  var valid_594017 = query.getOrDefault("orderBy")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "orderBy", valid_594017
  var valid_594018 = query.getOrDefault("services")
  valid_594018 = validateParameter(valid_594018, JArray, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "services", valid_594018
  var valid_594019 = query.getOrDefault("maxMonthlyBudget.nanos")
  valid_594019 = validateParameter(valid_594019, JInt, required = false, default = nil)
  if valid_594019 != nil:
    section.add "maxMonthlyBudget.nanos", valid_594019
  var valid_594020 = query.getOrDefault("key")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "key", valid_594020
  var valid_594021 = query.getOrDefault("websiteUrl")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "websiteUrl", valid_594021
  var valid_594022 = query.getOrDefault("maxMonthlyBudget.currencyCode")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "maxMonthlyBudget.currencyCode", valid_594022
  var valid_594023 = query.getOrDefault("$.xgafv")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = newJString("1"))
  if valid_594023 != nil:
    section.add "$.xgafv", valid_594023
  var valid_594024 = query.getOrDefault("pageSize")
  valid_594024 = validateParameter(valid_594024, JInt, required = false, default = nil)
  if valid_594024 != nil:
    section.add "pageSize", valid_594024
  var valid_594025 = query.getOrDefault("minMonthlyBudget.units")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "minMonthlyBudget.units", valid_594025
  var valid_594026 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_594026
  var valid_594027 = query.getOrDefault("address")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "address", valid_594027
  var valid_594028 = query.getOrDefault("languageCodes")
  valid_594028 = validateParameter(valid_594028, JArray, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "languageCodes", valid_594028
  var valid_594029 = query.getOrDefault("requestMetadata.experimentIds")
  valid_594029 = validateParameter(valid_594029, JArray, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "requestMetadata.experimentIds", valid_594029
  var valid_594030 = query.getOrDefault("companyName")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "companyName", valid_594030
  var valid_594031 = query.getOrDefault("prettyPrint")
  valid_594031 = validateParameter(valid_594031, JBool, required = false,
                                 default = newJBool(true))
  if valid_594031 != nil:
    section.add "prettyPrint", valid_594031
  var valid_594032 = query.getOrDefault("minMonthlyBudget.nanos")
  valid_594032 = validateParameter(valid_594032, JInt, required = false, default = nil)
  if valid_594032 != nil:
    section.add "minMonthlyBudget.nanos", valid_594032
  var valid_594033 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "requestMetadata.partnersSessionId", valid_594033
  var valid_594034 = query.getOrDefault("bearer_token")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "bearer_token", valid_594034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594035: Call_PartnersCompaniesList_593994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists companies.
  ## 
  let valid = call_594035.validator(path, query, header, formData, body)
  let scheme = call_594035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594035.url(scheme.get, call_594035.host, call_594035.base,
                         call_594035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594035, url, valid)

proc call*(call_594036: Call_PartnersCompaniesList_593994;
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
  var query_594037 = newJObject()
  add(query_594037, "upload_protocol", newJString(uploadProtocol))
  add(query_594037, "maxMonthlyBudget.units", newJString(maxMonthlyBudgetUnits))
  add(query_594037, "fields", newJString(fields))
  if industries != nil:
    query_594037.add "industries", industries
  add(query_594037, "quotaUser", newJString(quotaUser))
  add(query_594037, "pageToken", newJString(pageToken))
  add(query_594037, "view", newJString(view))
  add(query_594037, "alt", newJString(alt))
  add(query_594037, "requestMetadata.locale", newJString(requestMetadataLocale))
  if gpsMotivations != nil:
    query_594037.add "gpsMotivations", gpsMotivations
  add(query_594037, "pp", newJBool(pp))
  add(query_594037, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  if specializations != nil:
    query_594037.add "specializations", specializations
  add(query_594037, "oauth_token", newJString(oauthToken))
  add(query_594037, "callback", newJString(callback))
  add(query_594037, "access_token", newJString(accessToken))
  add(query_594037, "uploadType", newJString(uploadType))
  add(query_594037, "minMonthlyBudget.currencyCode",
      newJString(minMonthlyBudgetCurrencyCode))
  add(query_594037, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_594037, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_594037, "orderBy", newJString(orderBy))
  if services != nil:
    query_594037.add "services", services
  add(query_594037, "maxMonthlyBudget.nanos", newJInt(maxMonthlyBudgetNanos))
  add(query_594037, "key", newJString(key))
  add(query_594037, "websiteUrl", newJString(websiteUrl))
  add(query_594037, "maxMonthlyBudget.currencyCode",
      newJString(maxMonthlyBudgetCurrencyCode))
  add(query_594037, "$.xgafv", newJString(Xgafv))
  add(query_594037, "pageSize", newJInt(pageSize))
  add(query_594037, "minMonthlyBudget.units", newJString(minMonthlyBudgetUnits))
  add(query_594037, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_594037, "address", newJString(address))
  if languageCodes != nil:
    query_594037.add "languageCodes", languageCodes
  if requestMetadataExperimentIds != nil:
    query_594037.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_594037, "companyName", newJString(companyName))
  add(query_594037, "prettyPrint", newJBool(prettyPrint))
  add(query_594037, "minMonthlyBudget.nanos", newJInt(minMonthlyBudgetNanos))
  add(query_594037, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_594037, "bearer_token", newJString(bearerToken))
  result = call_594036.call(nil, query_594037, nil, nil, nil)

var partnersCompaniesList* = Call_PartnersCompaniesList_593994(
    name: "partnersCompaniesList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/companies",
    validator: validate_PartnersCompaniesList_593995, base: "/",
    url: url_PartnersCompaniesList_593996, schemes: {Scheme.Https})
type
  Call_PartnersUpdateCompanies_594038 = ref object of OpenApiRestCall_593421
proc url_PartnersUpdateCompanies_594040(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersUpdateCompanies_594039(path: JsonNode; query: JsonNode;
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
  var valid_594041 = query.getOrDefault("upload_protocol")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "upload_protocol", valid_594041
  var valid_594042 = query.getOrDefault("fields")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "fields", valid_594042
  var valid_594043 = query.getOrDefault("quotaUser")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "quotaUser", valid_594043
  var valid_594044 = query.getOrDefault("requestMetadata.locale")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "requestMetadata.locale", valid_594044
  var valid_594045 = query.getOrDefault("alt")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = newJString("json"))
  if valid_594045 != nil:
    section.add "alt", valid_594045
  var valid_594046 = query.getOrDefault("pp")
  valid_594046 = validateParameter(valid_594046, JBool, required = false,
                                 default = newJBool(true))
  if valid_594046 != nil:
    section.add "pp", valid_594046
  var valid_594047 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_594047
  var valid_594048 = query.getOrDefault("oauth_token")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "oauth_token", valid_594048
  var valid_594049 = query.getOrDefault("callback")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "callback", valid_594049
  var valid_594050 = query.getOrDefault("access_token")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "access_token", valid_594050
  var valid_594051 = query.getOrDefault("uploadType")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "uploadType", valid_594051
  var valid_594052 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_594052
  var valid_594053 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_594053
  var valid_594054 = query.getOrDefault("key")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "key", valid_594054
  var valid_594055 = query.getOrDefault("$.xgafv")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = newJString("1"))
  if valid_594055 != nil:
    section.add "$.xgafv", valid_594055
  var valid_594056 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_594056
  var valid_594057 = query.getOrDefault("requestMetadata.experimentIds")
  valid_594057 = validateParameter(valid_594057, JArray, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "requestMetadata.experimentIds", valid_594057
  var valid_594058 = query.getOrDefault("prettyPrint")
  valid_594058 = validateParameter(valid_594058, JBool, required = false,
                                 default = newJBool(true))
  if valid_594058 != nil:
    section.add "prettyPrint", valid_594058
  var valid_594059 = query.getOrDefault("updateMask")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "updateMask", valid_594059
  var valid_594060 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "requestMetadata.partnersSessionId", valid_594060
  var valid_594061 = query.getOrDefault("bearer_token")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "bearer_token", valid_594061
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

proc call*(call_594063: Call_PartnersUpdateCompanies_594038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  let valid = call_594063.validator(path, query, header, formData, body)
  let scheme = call_594063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594063.url(scheme.get, call_594063.host, call_594063.base,
                         call_594063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594063, url, valid)

proc call*(call_594064: Call_PartnersUpdateCompanies_594038;
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
  var query_594065 = newJObject()
  var body_594066 = newJObject()
  add(query_594065, "upload_protocol", newJString(uploadProtocol))
  add(query_594065, "fields", newJString(fields))
  add(query_594065, "quotaUser", newJString(quotaUser))
  add(query_594065, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_594065, "alt", newJString(alt))
  add(query_594065, "pp", newJBool(pp))
  add(query_594065, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_594065, "oauth_token", newJString(oauthToken))
  add(query_594065, "callback", newJString(callback))
  add(query_594065, "access_token", newJString(accessToken))
  add(query_594065, "uploadType", newJString(uploadType))
  add(query_594065, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_594065, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_594065, "key", newJString(key))
  add(query_594065, "$.xgafv", newJString(Xgafv))
  add(query_594065, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_594065.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_594066 = body
  add(query_594065, "prettyPrint", newJBool(prettyPrint))
  add(query_594065, "updateMask", newJString(updateMask))
  add(query_594065, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_594065, "bearer_token", newJString(bearerToken))
  result = call_594064.call(nil, query_594065, nil, nil, body_594066)

var partnersUpdateCompanies* = Call_PartnersUpdateCompanies_594038(
    name: "partnersUpdateCompanies", meth: HttpMethod.HttpPatch,
    host: "partners.googleapis.com", route: "/v2/companies",
    validator: validate_PartnersUpdateCompanies_594039, base: "/",
    url: url_PartnersUpdateCompanies_594040, schemes: {Scheme.Https})
type
  Call_PartnersCompaniesGet_594067 = ref object of OpenApiRestCall_593421
proc url_PartnersCompaniesGet_594069(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "companyId" in path, "`companyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/companies/"),
               (kind: VariableSegment, value: "companyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnersCompaniesGet_594068(path: JsonNode; query: JsonNode;
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
  var valid_594084 = path.getOrDefault("companyId")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "companyId", valid_594084
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
  var valid_594085 = query.getOrDefault("upload_protocol")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "upload_protocol", valid_594085
  var valid_594086 = query.getOrDefault("fields")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "fields", valid_594086
  var valid_594087 = query.getOrDefault("view")
  valid_594087 = validateParameter(valid_594087, JString, required = false, default = newJString(
      "COMPANY_VIEW_UNSPECIFIED"))
  if valid_594087 != nil:
    section.add "view", valid_594087
  var valid_594088 = query.getOrDefault("quotaUser")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "quotaUser", valid_594088
  var valid_594089 = query.getOrDefault("requestMetadata.locale")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "requestMetadata.locale", valid_594089
  var valid_594090 = query.getOrDefault("alt")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = newJString("json"))
  if valid_594090 != nil:
    section.add "alt", valid_594090
  var valid_594091 = query.getOrDefault("pp")
  valid_594091 = validateParameter(valid_594091, JBool, required = false,
                                 default = newJBool(true))
  if valid_594091 != nil:
    section.add "pp", valid_594091
  var valid_594092 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_594092
  var valid_594093 = query.getOrDefault("oauth_token")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "oauth_token", valid_594093
  var valid_594094 = query.getOrDefault("callback")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "callback", valid_594094
  var valid_594095 = query.getOrDefault("access_token")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "access_token", valid_594095
  var valid_594096 = query.getOrDefault("uploadType")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "uploadType", valid_594096
  var valid_594097 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_594097
  var valid_594098 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_594098
  var valid_594099 = query.getOrDefault("currencyCode")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "currencyCode", valid_594099
  var valid_594100 = query.getOrDefault("orderBy")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "orderBy", valid_594100
  var valid_594101 = query.getOrDefault("key")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "key", valid_594101
  var valid_594102 = query.getOrDefault("$.xgafv")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = newJString("1"))
  if valid_594102 != nil:
    section.add "$.xgafv", valid_594102
  var valid_594103 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_594103
  var valid_594104 = query.getOrDefault("address")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "address", valid_594104
  var valid_594105 = query.getOrDefault("requestMetadata.experimentIds")
  valid_594105 = validateParameter(valid_594105, JArray, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "requestMetadata.experimentIds", valid_594105
  var valid_594106 = query.getOrDefault("prettyPrint")
  valid_594106 = validateParameter(valid_594106, JBool, required = false,
                                 default = newJBool(true))
  if valid_594106 != nil:
    section.add "prettyPrint", valid_594106
  var valid_594107 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "requestMetadata.partnersSessionId", valid_594107
  var valid_594108 = query.getOrDefault("bearer_token")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "bearer_token", valid_594108
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594109: Call_PartnersCompaniesGet_594067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a company.
  ## 
  let valid = call_594109.validator(path, query, header, formData, body)
  let scheme = call_594109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594109.url(scheme.get, call_594109.host, call_594109.base,
                         call_594109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594109, url, valid)

proc call*(call_594110: Call_PartnersCompaniesGet_594067; companyId: string;
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
  var path_594111 = newJObject()
  var query_594112 = newJObject()
  add(query_594112, "upload_protocol", newJString(uploadProtocol))
  add(query_594112, "fields", newJString(fields))
  add(query_594112, "view", newJString(view))
  add(query_594112, "quotaUser", newJString(quotaUser))
  add(query_594112, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_594112, "alt", newJString(alt))
  add(query_594112, "pp", newJBool(pp))
  add(query_594112, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_594112, "oauth_token", newJString(oauthToken))
  add(query_594112, "callback", newJString(callback))
  add(query_594112, "access_token", newJString(accessToken))
  add(query_594112, "uploadType", newJString(uploadType))
  add(query_594112, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_594112, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_594112, "currencyCode", newJString(currencyCode))
  add(query_594112, "orderBy", newJString(orderBy))
  add(query_594112, "key", newJString(key))
  add(query_594112, "$.xgafv", newJString(Xgafv))
  add(query_594112, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  add(query_594112, "address", newJString(address))
  if requestMetadataExperimentIds != nil:
    query_594112.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_594112, "prettyPrint", newJBool(prettyPrint))
  add(path_594111, "companyId", newJString(companyId))
  add(query_594112, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_594112, "bearer_token", newJString(bearerToken))
  result = call_594110.call(path_594111, query_594112, nil, nil, nil)

var partnersCompaniesGet* = Call_PartnersCompaniesGet_594067(
    name: "partnersCompaniesGet", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/companies/{companyId}",
    validator: validate_PartnersCompaniesGet_594068, base: "/",
    url: url_PartnersCompaniesGet_594069, schemes: {Scheme.Https})
type
  Call_PartnersCompaniesLeadsCreate_594113 = ref object of OpenApiRestCall_593421
proc url_PartnersCompaniesLeadsCreate_594115(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PartnersCompaniesLeadsCreate_594114(path: JsonNode; query: JsonNode;
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
  var valid_594116 = path.getOrDefault("companyId")
  valid_594116 = validateParameter(valid_594116, JString, required = true,
                                 default = nil)
  if valid_594116 != nil:
    section.add "companyId", valid_594116
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
  var valid_594117 = query.getOrDefault("upload_protocol")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "upload_protocol", valid_594117
  var valid_594118 = query.getOrDefault("fields")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = nil)
  if valid_594118 != nil:
    section.add "fields", valid_594118
  var valid_594119 = query.getOrDefault("quotaUser")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "quotaUser", valid_594119
  var valid_594120 = query.getOrDefault("alt")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = newJString("json"))
  if valid_594120 != nil:
    section.add "alt", valid_594120
  var valid_594121 = query.getOrDefault("pp")
  valid_594121 = validateParameter(valid_594121, JBool, required = false,
                                 default = newJBool(true))
  if valid_594121 != nil:
    section.add "pp", valid_594121
  var valid_594122 = query.getOrDefault("oauth_token")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "oauth_token", valid_594122
  var valid_594123 = query.getOrDefault("callback")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "callback", valid_594123
  var valid_594124 = query.getOrDefault("access_token")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "access_token", valid_594124
  var valid_594125 = query.getOrDefault("uploadType")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "uploadType", valid_594125
  var valid_594126 = query.getOrDefault("key")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "key", valid_594126
  var valid_594127 = query.getOrDefault("$.xgafv")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = newJString("1"))
  if valid_594127 != nil:
    section.add "$.xgafv", valid_594127
  var valid_594128 = query.getOrDefault("prettyPrint")
  valid_594128 = validateParameter(valid_594128, JBool, required = false,
                                 default = newJBool(true))
  if valid_594128 != nil:
    section.add "prettyPrint", valid_594128
  var valid_594129 = query.getOrDefault("bearer_token")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "bearer_token", valid_594129
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

proc call*(call_594131: Call_PartnersCompaniesLeadsCreate_594113; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an advertiser lead for the given company ID.
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_PartnersCompaniesLeadsCreate_594113;
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
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  var body_594135 = newJObject()
  add(query_594134, "upload_protocol", newJString(uploadProtocol))
  add(query_594134, "fields", newJString(fields))
  add(query_594134, "quotaUser", newJString(quotaUser))
  add(query_594134, "alt", newJString(alt))
  add(query_594134, "pp", newJBool(pp))
  add(query_594134, "oauth_token", newJString(oauthToken))
  add(query_594134, "callback", newJString(callback))
  add(query_594134, "access_token", newJString(accessToken))
  add(query_594134, "uploadType", newJString(uploadType))
  add(query_594134, "key", newJString(key))
  add(query_594134, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594135 = body
  add(query_594134, "prettyPrint", newJBool(prettyPrint))
  add(path_594133, "companyId", newJString(companyId))
  add(query_594134, "bearer_token", newJString(bearerToken))
  result = call_594132.call(path_594133, query_594134, nil, nil, body_594135)

var partnersCompaniesLeadsCreate* = Call_PartnersCompaniesLeadsCreate_594113(
    name: "partnersCompaniesLeadsCreate", meth: HttpMethod.HttpPost,
    host: "partners.googleapis.com", route: "/v2/companies/{companyId}/leads",
    validator: validate_PartnersCompaniesLeadsCreate_594114, base: "/",
    url: url_PartnersCompaniesLeadsCreate_594115, schemes: {Scheme.Https})
type
  Call_PartnersLeadsList_594136 = ref object of OpenApiRestCall_593421
proc url_PartnersLeadsList_594138(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersLeadsList_594137(path: JsonNode; query: JsonNode;
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
  var valid_594139 = query.getOrDefault("upload_protocol")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "upload_protocol", valid_594139
  var valid_594140 = query.getOrDefault("fields")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = nil)
  if valid_594140 != nil:
    section.add "fields", valid_594140
  var valid_594141 = query.getOrDefault("pageToken")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "pageToken", valid_594141
  var valid_594142 = query.getOrDefault("quotaUser")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "quotaUser", valid_594142
  var valid_594143 = query.getOrDefault("requestMetadata.locale")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "requestMetadata.locale", valid_594143
  var valid_594144 = query.getOrDefault("alt")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = newJString("json"))
  if valid_594144 != nil:
    section.add "alt", valid_594144
  var valid_594145 = query.getOrDefault("pp")
  valid_594145 = validateParameter(valid_594145, JBool, required = false,
                                 default = newJBool(true))
  if valid_594145 != nil:
    section.add "pp", valid_594145
  var valid_594146 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_594146
  var valid_594147 = query.getOrDefault("oauth_token")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "oauth_token", valid_594147
  var valid_594148 = query.getOrDefault("callback")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "callback", valid_594148
  var valid_594149 = query.getOrDefault("access_token")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "access_token", valid_594149
  var valid_594150 = query.getOrDefault("uploadType")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "uploadType", valid_594150
  var valid_594151 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_594151
  var valid_594152 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_594152
  var valid_594153 = query.getOrDefault("orderBy")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "orderBy", valid_594153
  var valid_594154 = query.getOrDefault("key")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "key", valid_594154
  var valid_594155 = query.getOrDefault("$.xgafv")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = newJString("1"))
  if valid_594155 != nil:
    section.add "$.xgafv", valid_594155
  var valid_594156 = query.getOrDefault("pageSize")
  valid_594156 = validateParameter(valid_594156, JInt, required = false, default = nil)
  if valid_594156 != nil:
    section.add "pageSize", valid_594156
  var valid_594157 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_594157
  var valid_594158 = query.getOrDefault("requestMetadata.experimentIds")
  valid_594158 = validateParameter(valid_594158, JArray, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "requestMetadata.experimentIds", valid_594158
  var valid_594159 = query.getOrDefault("prettyPrint")
  valid_594159 = validateParameter(valid_594159, JBool, required = false,
                                 default = newJBool(true))
  if valid_594159 != nil:
    section.add "prettyPrint", valid_594159
  var valid_594160 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "requestMetadata.partnersSessionId", valid_594160
  var valid_594161 = query.getOrDefault("bearer_token")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "bearer_token", valid_594161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594162: Call_PartnersLeadsList_594136; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists advertiser leads for a user's associated company.
  ## Should only be called within the context of an authorized logged in user.
  ## 
  let valid = call_594162.validator(path, query, header, formData, body)
  let scheme = call_594162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594162.url(scheme.get, call_594162.host, call_594162.base,
                         call_594162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594162, url, valid)

proc call*(call_594163: Call_PartnersLeadsList_594136; uploadProtocol: string = "";
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
  var query_594164 = newJObject()
  add(query_594164, "upload_protocol", newJString(uploadProtocol))
  add(query_594164, "fields", newJString(fields))
  add(query_594164, "pageToken", newJString(pageToken))
  add(query_594164, "quotaUser", newJString(quotaUser))
  add(query_594164, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_594164, "alt", newJString(alt))
  add(query_594164, "pp", newJBool(pp))
  add(query_594164, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_594164, "oauth_token", newJString(oauthToken))
  add(query_594164, "callback", newJString(callback))
  add(query_594164, "access_token", newJString(accessToken))
  add(query_594164, "uploadType", newJString(uploadType))
  add(query_594164, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_594164, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_594164, "orderBy", newJString(orderBy))
  add(query_594164, "key", newJString(key))
  add(query_594164, "$.xgafv", newJString(Xgafv))
  add(query_594164, "pageSize", newJInt(pageSize))
  add(query_594164, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_594164.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_594164, "prettyPrint", newJBool(prettyPrint))
  add(query_594164, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_594164, "bearer_token", newJString(bearerToken))
  result = call_594163.call(nil, query_594164, nil, nil, nil)

var partnersLeadsList* = Call_PartnersLeadsList_594136(name: "partnersLeadsList",
    meth: HttpMethod.HttpGet, host: "partners.googleapis.com", route: "/v2/leads",
    validator: validate_PartnersLeadsList_594137, base: "/",
    url: url_PartnersLeadsList_594138, schemes: {Scheme.Https})
type
  Call_PartnersUpdateLeads_594165 = ref object of OpenApiRestCall_593421
proc url_PartnersUpdateLeads_594167(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersUpdateLeads_594166(path: JsonNode; query: JsonNode;
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
  var valid_594168 = query.getOrDefault("upload_protocol")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "upload_protocol", valid_594168
  var valid_594169 = query.getOrDefault("fields")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "fields", valid_594169
  var valid_594170 = query.getOrDefault("quotaUser")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "quotaUser", valid_594170
  var valid_594171 = query.getOrDefault("requestMetadata.locale")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "requestMetadata.locale", valid_594171
  var valid_594172 = query.getOrDefault("alt")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = newJString("json"))
  if valid_594172 != nil:
    section.add "alt", valid_594172
  var valid_594173 = query.getOrDefault("pp")
  valid_594173 = validateParameter(valid_594173, JBool, required = false,
                                 default = newJBool(true))
  if valid_594173 != nil:
    section.add "pp", valid_594173
  var valid_594174 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_594174
  var valid_594175 = query.getOrDefault("oauth_token")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "oauth_token", valid_594175
  var valid_594176 = query.getOrDefault("callback")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = nil)
  if valid_594176 != nil:
    section.add "callback", valid_594176
  var valid_594177 = query.getOrDefault("access_token")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "access_token", valid_594177
  var valid_594178 = query.getOrDefault("uploadType")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "uploadType", valid_594178
  var valid_594179 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_594179
  var valid_594180 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_594180
  var valid_594181 = query.getOrDefault("key")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "key", valid_594181
  var valid_594182 = query.getOrDefault("$.xgafv")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = newJString("1"))
  if valid_594182 != nil:
    section.add "$.xgafv", valid_594182
  var valid_594183 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_594183
  var valid_594184 = query.getOrDefault("requestMetadata.experimentIds")
  valid_594184 = validateParameter(valid_594184, JArray, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "requestMetadata.experimentIds", valid_594184
  var valid_594185 = query.getOrDefault("prettyPrint")
  valid_594185 = validateParameter(valid_594185, JBool, required = false,
                                 default = newJBool(true))
  if valid_594185 != nil:
    section.add "prettyPrint", valid_594185
  var valid_594186 = query.getOrDefault("updateMask")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "updateMask", valid_594186
  var valid_594187 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "requestMetadata.partnersSessionId", valid_594187
  var valid_594188 = query.getOrDefault("bearer_token")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "bearer_token", valid_594188
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

proc call*(call_594190: Call_PartnersUpdateLeads_594165; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the specified lead.
  ## 
  let valid = call_594190.validator(path, query, header, formData, body)
  let scheme = call_594190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594190.url(scheme.get, call_594190.host, call_594190.base,
                         call_594190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594190, url, valid)

proc call*(call_594191: Call_PartnersUpdateLeads_594165;
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
  var query_594192 = newJObject()
  var body_594193 = newJObject()
  add(query_594192, "upload_protocol", newJString(uploadProtocol))
  add(query_594192, "fields", newJString(fields))
  add(query_594192, "quotaUser", newJString(quotaUser))
  add(query_594192, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_594192, "alt", newJString(alt))
  add(query_594192, "pp", newJBool(pp))
  add(query_594192, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_594192, "oauth_token", newJString(oauthToken))
  add(query_594192, "callback", newJString(callback))
  add(query_594192, "access_token", newJString(accessToken))
  add(query_594192, "uploadType", newJString(uploadType))
  add(query_594192, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_594192, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_594192, "key", newJString(key))
  add(query_594192, "$.xgafv", newJString(Xgafv))
  add(query_594192, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_594192.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_594193 = body
  add(query_594192, "prettyPrint", newJBool(prettyPrint))
  add(query_594192, "updateMask", newJString(updateMask))
  add(query_594192, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_594192, "bearer_token", newJString(bearerToken))
  result = call_594191.call(nil, query_594192, nil, nil, body_594193)

var partnersUpdateLeads* = Call_PartnersUpdateLeads_594165(
    name: "partnersUpdateLeads", meth: HttpMethod.HttpPatch,
    host: "partners.googleapis.com", route: "/v2/leads",
    validator: validate_PartnersUpdateLeads_594166, base: "/",
    url: url_PartnersUpdateLeads_594167, schemes: {Scheme.Https})
type
  Call_PartnersOffersList_594194 = ref object of OpenApiRestCall_593421
proc url_PartnersOffersList_594196(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersOffersList_594195(path: JsonNode; query: JsonNode;
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
  var valid_594197 = query.getOrDefault("upload_protocol")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "upload_protocol", valid_594197
  var valid_594198 = query.getOrDefault("fields")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "fields", valid_594198
  var valid_594199 = query.getOrDefault("quotaUser")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "quotaUser", valid_594199
  var valid_594200 = query.getOrDefault("requestMetadata.locale")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "requestMetadata.locale", valid_594200
  var valid_594201 = query.getOrDefault("alt")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = newJString("json"))
  if valid_594201 != nil:
    section.add "alt", valid_594201
  var valid_594202 = query.getOrDefault("pp")
  valid_594202 = validateParameter(valid_594202, JBool, required = false,
                                 default = newJBool(true))
  if valid_594202 != nil:
    section.add "pp", valid_594202
  var valid_594203 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_594203
  var valid_594204 = query.getOrDefault("oauth_token")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "oauth_token", valid_594204
  var valid_594205 = query.getOrDefault("callback")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "callback", valid_594205
  var valid_594206 = query.getOrDefault("access_token")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "access_token", valid_594206
  var valid_594207 = query.getOrDefault("uploadType")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "uploadType", valid_594207
  var valid_594208 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_594208
  var valid_594209 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_594209
  var valid_594210 = query.getOrDefault("key")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "key", valid_594210
  var valid_594211 = query.getOrDefault("$.xgafv")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = newJString("1"))
  if valid_594211 != nil:
    section.add "$.xgafv", valid_594211
  var valid_594212 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_594212
  var valid_594213 = query.getOrDefault("requestMetadata.experimentIds")
  valid_594213 = validateParameter(valid_594213, JArray, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "requestMetadata.experimentIds", valid_594213
  var valid_594214 = query.getOrDefault("prettyPrint")
  valid_594214 = validateParameter(valid_594214, JBool, required = false,
                                 default = newJBool(true))
  if valid_594214 != nil:
    section.add "prettyPrint", valid_594214
  var valid_594215 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "requestMetadata.partnersSessionId", valid_594215
  var valid_594216 = query.getOrDefault("bearer_token")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "bearer_token", valid_594216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594217: Call_PartnersOffersList_594194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Offers available for the current user
  ## 
  let valid = call_594217.validator(path, query, header, formData, body)
  let scheme = call_594217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594217.url(scheme.get, call_594217.host, call_594217.base,
                         call_594217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594217, url, valid)

proc call*(call_594218: Call_PartnersOffersList_594194;
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
  var query_594219 = newJObject()
  add(query_594219, "upload_protocol", newJString(uploadProtocol))
  add(query_594219, "fields", newJString(fields))
  add(query_594219, "quotaUser", newJString(quotaUser))
  add(query_594219, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_594219, "alt", newJString(alt))
  add(query_594219, "pp", newJBool(pp))
  add(query_594219, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_594219, "oauth_token", newJString(oauthToken))
  add(query_594219, "callback", newJString(callback))
  add(query_594219, "access_token", newJString(accessToken))
  add(query_594219, "uploadType", newJString(uploadType))
  add(query_594219, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_594219, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_594219, "key", newJString(key))
  add(query_594219, "$.xgafv", newJString(Xgafv))
  add(query_594219, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_594219.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_594219, "prettyPrint", newJBool(prettyPrint))
  add(query_594219, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_594219, "bearer_token", newJString(bearerToken))
  result = call_594218.call(nil, query_594219, nil, nil, nil)

var partnersOffersList* = Call_PartnersOffersList_594194(
    name: "partnersOffersList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/offers",
    validator: validate_PartnersOffersList_594195, base: "/",
    url: url_PartnersOffersList_594196, schemes: {Scheme.Https})
type
  Call_PartnersOffersHistoryList_594220 = ref object of OpenApiRestCall_593421
proc url_PartnersOffersHistoryList_594222(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersOffersHistoryList_594221(path: JsonNode; query: JsonNode;
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
  var valid_594223 = query.getOrDefault("upload_protocol")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "upload_protocol", valid_594223
  var valid_594224 = query.getOrDefault("fields")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = nil)
  if valid_594224 != nil:
    section.add "fields", valid_594224
  var valid_594225 = query.getOrDefault("pageToken")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = nil)
  if valid_594225 != nil:
    section.add "pageToken", valid_594225
  var valid_594226 = query.getOrDefault("quotaUser")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "quotaUser", valid_594226
  var valid_594227 = query.getOrDefault("entireCompany")
  valid_594227 = validateParameter(valid_594227, JBool, required = false, default = nil)
  if valid_594227 != nil:
    section.add "entireCompany", valid_594227
  var valid_594228 = query.getOrDefault("requestMetadata.locale")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = nil)
  if valid_594228 != nil:
    section.add "requestMetadata.locale", valid_594228
  var valid_594229 = query.getOrDefault("alt")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = newJString("json"))
  if valid_594229 != nil:
    section.add "alt", valid_594229
  var valid_594230 = query.getOrDefault("pp")
  valid_594230 = validateParameter(valid_594230, JBool, required = false,
                                 default = newJBool(true))
  if valid_594230 != nil:
    section.add "pp", valid_594230
  var valid_594231 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_594231
  var valid_594232 = query.getOrDefault("oauth_token")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "oauth_token", valid_594232
  var valid_594233 = query.getOrDefault("callback")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "callback", valid_594233
  var valid_594234 = query.getOrDefault("access_token")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "access_token", valid_594234
  var valid_594235 = query.getOrDefault("uploadType")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "uploadType", valid_594235
  var valid_594236 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_594236
  var valid_594237 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = nil)
  if valid_594237 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_594237
  var valid_594238 = query.getOrDefault("orderBy")
  valid_594238 = validateParameter(valid_594238, JString, required = false,
                                 default = nil)
  if valid_594238 != nil:
    section.add "orderBy", valid_594238
  var valid_594239 = query.getOrDefault("key")
  valid_594239 = validateParameter(valid_594239, JString, required = false,
                                 default = nil)
  if valid_594239 != nil:
    section.add "key", valid_594239
  var valid_594240 = query.getOrDefault("$.xgafv")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = newJString("1"))
  if valid_594240 != nil:
    section.add "$.xgafv", valid_594240
  var valid_594241 = query.getOrDefault("pageSize")
  valid_594241 = validateParameter(valid_594241, JInt, required = false, default = nil)
  if valid_594241 != nil:
    section.add "pageSize", valid_594241
  var valid_594242 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_594242 = validateParameter(valid_594242, JString, required = false,
                                 default = nil)
  if valid_594242 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_594242
  var valid_594243 = query.getOrDefault("requestMetadata.experimentIds")
  valid_594243 = validateParameter(valid_594243, JArray, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "requestMetadata.experimentIds", valid_594243
  var valid_594244 = query.getOrDefault("prettyPrint")
  valid_594244 = validateParameter(valid_594244, JBool, required = false,
                                 default = newJBool(true))
  if valid_594244 != nil:
    section.add "prettyPrint", valid_594244
  var valid_594245 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "requestMetadata.partnersSessionId", valid_594245
  var valid_594246 = query.getOrDefault("bearer_token")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "bearer_token", valid_594246
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594247: Call_PartnersOffersHistoryList_594220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the Historical Offers for the current user (or user's entire company)
  ## 
  let valid = call_594247.validator(path, query, header, formData, body)
  let scheme = call_594247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594247.url(scheme.get, call_594247.host, call_594247.base,
                         call_594247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594247, url, valid)

proc call*(call_594248: Call_PartnersOffersHistoryList_594220;
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
  var query_594249 = newJObject()
  add(query_594249, "upload_protocol", newJString(uploadProtocol))
  add(query_594249, "fields", newJString(fields))
  add(query_594249, "pageToken", newJString(pageToken))
  add(query_594249, "quotaUser", newJString(quotaUser))
  add(query_594249, "entireCompany", newJBool(entireCompany))
  add(query_594249, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_594249, "alt", newJString(alt))
  add(query_594249, "pp", newJBool(pp))
  add(query_594249, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_594249, "oauth_token", newJString(oauthToken))
  add(query_594249, "callback", newJString(callback))
  add(query_594249, "access_token", newJString(accessToken))
  add(query_594249, "uploadType", newJString(uploadType))
  add(query_594249, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_594249, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_594249, "orderBy", newJString(orderBy))
  add(query_594249, "key", newJString(key))
  add(query_594249, "$.xgafv", newJString(Xgafv))
  add(query_594249, "pageSize", newJInt(pageSize))
  add(query_594249, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_594249.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_594249, "prettyPrint", newJBool(prettyPrint))
  add(query_594249, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_594249, "bearer_token", newJString(bearerToken))
  result = call_594248.call(nil, query_594249, nil, nil, nil)

var partnersOffersHistoryList* = Call_PartnersOffersHistoryList_594220(
    name: "partnersOffersHistoryList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/offers/history",
    validator: validate_PartnersOffersHistoryList_594221, base: "/",
    url: url_PartnersOffersHistoryList_594222, schemes: {Scheme.Https})
type
  Call_PartnersGetPartnersstatus_594250 = ref object of OpenApiRestCall_593421
proc url_PartnersGetPartnersstatus_594252(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersGetPartnersstatus_594251(path: JsonNode; query: JsonNode;
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
  var valid_594253 = query.getOrDefault("upload_protocol")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "upload_protocol", valid_594253
  var valid_594254 = query.getOrDefault("fields")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "fields", valid_594254
  var valid_594255 = query.getOrDefault("quotaUser")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "quotaUser", valid_594255
  var valid_594256 = query.getOrDefault("requestMetadata.locale")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "requestMetadata.locale", valid_594256
  var valid_594257 = query.getOrDefault("alt")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = newJString("json"))
  if valid_594257 != nil:
    section.add "alt", valid_594257
  var valid_594258 = query.getOrDefault("pp")
  valid_594258 = validateParameter(valid_594258, JBool, required = false,
                                 default = newJBool(true))
  if valid_594258 != nil:
    section.add "pp", valid_594258
  var valid_594259 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_594259
  var valid_594260 = query.getOrDefault("oauth_token")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "oauth_token", valid_594260
  var valid_594261 = query.getOrDefault("callback")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = nil)
  if valid_594261 != nil:
    section.add "callback", valid_594261
  var valid_594262 = query.getOrDefault("access_token")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "access_token", valid_594262
  var valid_594263 = query.getOrDefault("uploadType")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "uploadType", valid_594263
  var valid_594264 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_594264
  var valid_594265 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = nil)
  if valid_594265 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_594265
  var valid_594266 = query.getOrDefault("key")
  valid_594266 = validateParameter(valid_594266, JString, required = false,
                                 default = nil)
  if valid_594266 != nil:
    section.add "key", valid_594266
  var valid_594267 = query.getOrDefault("$.xgafv")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = newJString("1"))
  if valid_594267 != nil:
    section.add "$.xgafv", valid_594267
  var valid_594268 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = nil)
  if valid_594268 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_594268
  var valid_594269 = query.getOrDefault("requestMetadata.experimentIds")
  valid_594269 = validateParameter(valid_594269, JArray, required = false,
                                 default = nil)
  if valid_594269 != nil:
    section.add "requestMetadata.experimentIds", valid_594269
  var valid_594270 = query.getOrDefault("prettyPrint")
  valid_594270 = validateParameter(valid_594270, JBool, required = false,
                                 default = newJBool(true))
  if valid_594270 != nil:
    section.add "prettyPrint", valid_594270
  var valid_594271 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "requestMetadata.partnersSessionId", valid_594271
  var valid_594272 = query.getOrDefault("bearer_token")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "bearer_token", valid_594272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594273: Call_PartnersGetPartnersstatus_594250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets Partners Status of the logged in user's agency.
  ## Should only be called if the logged in user is the admin of the agency.
  ## 
  let valid = call_594273.validator(path, query, header, formData, body)
  let scheme = call_594273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594273.url(scheme.get, call_594273.host, call_594273.base,
                         call_594273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594273, url, valid)

proc call*(call_594274: Call_PartnersGetPartnersstatus_594250;
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
  var query_594275 = newJObject()
  add(query_594275, "upload_protocol", newJString(uploadProtocol))
  add(query_594275, "fields", newJString(fields))
  add(query_594275, "quotaUser", newJString(quotaUser))
  add(query_594275, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_594275, "alt", newJString(alt))
  add(query_594275, "pp", newJBool(pp))
  add(query_594275, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_594275, "oauth_token", newJString(oauthToken))
  add(query_594275, "callback", newJString(callback))
  add(query_594275, "access_token", newJString(accessToken))
  add(query_594275, "uploadType", newJString(uploadType))
  add(query_594275, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_594275, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_594275, "key", newJString(key))
  add(query_594275, "$.xgafv", newJString(Xgafv))
  add(query_594275, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_594275.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_594275, "prettyPrint", newJBool(prettyPrint))
  add(query_594275, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_594275, "bearer_token", newJString(bearerToken))
  result = call_594274.call(nil, query_594275, nil, nil, nil)

var partnersGetPartnersstatus* = Call_PartnersGetPartnersstatus_594250(
    name: "partnersGetPartnersstatus", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/partnersstatus",
    validator: validate_PartnersGetPartnersstatus_594251, base: "/",
    url: url_PartnersGetPartnersstatus_594252, schemes: {Scheme.Https})
type
  Call_PartnersUserEventsLog_594276 = ref object of OpenApiRestCall_593421
proc url_PartnersUserEventsLog_594278(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersUserEventsLog_594277(path: JsonNode; query: JsonNode;
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
  var valid_594279 = query.getOrDefault("upload_protocol")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = nil)
  if valid_594279 != nil:
    section.add "upload_protocol", valid_594279
  var valid_594280 = query.getOrDefault("fields")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "fields", valid_594280
  var valid_594281 = query.getOrDefault("quotaUser")
  valid_594281 = validateParameter(valid_594281, JString, required = false,
                                 default = nil)
  if valid_594281 != nil:
    section.add "quotaUser", valid_594281
  var valid_594282 = query.getOrDefault("alt")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = newJString("json"))
  if valid_594282 != nil:
    section.add "alt", valid_594282
  var valid_594283 = query.getOrDefault("pp")
  valid_594283 = validateParameter(valid_594283, JBool, required = false,
                                 default = newJBool(true))
  if valid_594283 != nil:
    section.add "pp", valid_594283
  var valid_594284 = query.getOrDefault("oauth_token")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "oauth_token", valid_594284
  var valid_594285 = query.getOrDefault("callback")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = nil)
  if valid_594285 != nil:
    section.add "callback", valid_594285
  var valid_594286 = query.getOrDefault("access_token")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "access_token", valid_594286
  var valid_594287 = query.getOrDefault("uploadType")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "uploadType", valid_594287
  var valid_594288 = query.getOrDefault("key")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = nil)
  if valid_594288 != nil:
    section.add "key", valid_594288
  var valid_594289 = query.getOrDefault("$.xgafv")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = newJString("1"))
  if valid_594289 != nil:
    section.add "$.xgafv", valid_594289
  var valid_594290 = query.getOrDefault("prettyPrint")
  valid_594290 = validateParameter(valid_594290, JBool, required = false,
                                 default = newJBool(true))
  if valid_594290 != nil:
    section.add "prettyPrint", valid_594290
  var valid_594291 = query.getOrDefault("bearer_token")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "bearer_token", valid_594291
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

proc call*(call_594293: Call_PartnersUserEventsLog_594276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Logs a user event.
  ## 
  let valid = call_594293.validator(path, query, header, formData, body)
  let scheme = call_594293.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594293.url(scheme.get, call_594293.host, call_594293.base,
                         call_594293.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594293, url, valid)

proc call*(call_594294: Call_PartnersUserEventsLog_594276;
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
  var query_594295 = newJObject()
  var body_594296 = newJObject()
  add(query_594295, "upload_protocol", newJString(uploadProtocol))
  add(query_594295, "fields", newJString(fields))
  add(query_594295, "quotaUser", newJString(quotaUser))
  add(query_594295, "alt", newJString(alt))
  add(query_594295, "pp", newJBool(pp))
  add(query_594295, "oauth_token", newJString(oauthToken))
  add(query_594295, "callback", newJString(callback))
  add(query_594295, "access_token", newJString(accessToken))
  add(query_594295, "uploadType", newJString(uploadType))
  add(query_594295, "key", newJString(key))
  add(query_594295, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594296 = body
  add(query_594295, "prettyPrint", newJBool(prettyPrint))
  add(query_594295, "bearer_token", newJString(bearerToken))
  result = call_594294.call(nil, query_594295, nil, nil, body_594296)

var partnersUserEventsLog* = Call_PartnersUserEventsLog_594276(
    name: "partnersUserEventsLog", meth: HttpMethod.HttpPost,
    host: "partners.googleapis.com", route: "/v2/userEvents:log",
    validator: validate_PartnersUserEventsLog_594277, base: "/",
    url: url_PartnersUserEventsLog_594278, schemes: {Scheme.Https})
type
  Call_PartnersUserStatesList_594297 = ref object of OpenApiRestCall_593421
proc url_PartnersUserStatesList_594299(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersUserStatesList_594298(path: JsonNode; query: JsonNode;
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
  var valid_594300 = query.getOrDefault("upload_protocol")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "upload_protocol", valid_594300
  var valid_594301 = query.getOrDefault("fields")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "fields", valid_594301
  var valid_594302 = query.getOrDefault("quotaUser")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "quotaUser", valid_594302
  var valid_594303 = query.getOrDefault("requestMetadata.locale")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "requestMetadata.locale", valid_594303
  var valid_594304 = query.getOrDefault("alt")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = newJString("json"))
  if valid_594304 != nil:
    section.add "alt", valid_594304
  var valid_594305 = query.getOrDefault("pp")
  valid_594305 = validateParameter(valid_594305, JBool, required = false,
                                 default = newJBool(true))
  if valid_594305 != nil:
    section.add "pp", valid_594305
  var valid_594306 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_594306
  var valid_594307 = query.getOrDefault("oauth_token")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "oauth_token", valid_594307
  var valid_594308 = query.getOrDefault("callback")
  valid_594308 = validateParameter(valid_594308, JString, required = false,
                                 default = nil)
  if valid_594308 != nil:
    section.add "callback", valid_594308
  var valid_594309 = query.getOrDefault("access_token")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "access_token", valid_594309
  var valid_594310 = query.getOrDefault("uploadType")
  valid_594310 = validateParameter(valid_594310, JString, required = false,
                                 default = nil)
  if valid_594310 != nil:
    section.add "uploadType", valid_594310
  var valid_594311 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_594311 = validateParameter(valid_594311, JString, required = false,
                                 default = nil)
  if valid_594311 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_594311
  var valid_594312 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = nil)
  if valid_594312 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_594312
  var valid_594313 = query.getOrDefault("key")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "key", valid_594313
  var valid_594314 = query.getOrDefault("$.xgafv")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = newJString("1"))
  if valid_594314 != nil:
    section.add "$.xgafv", valid_594314
  var valid_594315 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = nil)
  if valid_594315 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_594315
  var valid_594316 = query.getOrDefault("requestMetadata.experimentIds")
  valid_594316 = validateParameter(valid_594316, JArray, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "requestMetadata.experimentIds", valid_594316
  var valid_594317 = query.getOrDefault("prettyPrint")
  valid_594317 = validateParameter(valid_594317, JBool, required = false,
                                 default = newJBool(true))
  if valid_594317 != nil:
    section.add "prettyPrint", valid_594317
  var valid_594318 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "requestMetadata.partnersSessionId", valid_594318
  var valid_594319 = query.getOrDefault("bearer_token")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "bearer_token", valid_594319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594320: Call_PartnersUserStatesList_594297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists states for current user.
  ## 
  let valid = call_594320.validator(path, query, header, formData, body)
  let scheme = call_594320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594320.url(scheme.get, call_594320.host, call_594320.base,
                         call_594320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594320, url, valid)

proc call*(call_594321: Call_PartnersUserStatesList_594297;
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
  var query_594322 = newJObject()
  add(query_594322, "upload_protocol", newJString(uploadProtocol))
  add(query_594322, "fields", newJString(fields))
  add(query_594322, "quotaUser", newJString(quotaUser))
  add(query_594322, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_594322, "alt", newJString(alt))
  add(query_594322, "pp", newJBool(pp))
  add(query_594322, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_594322, "oauth_token", newJString(oauthToken))
  add(query_594322, "callback", newJString(callback))
  add(query_594322, "access_token", newJString(accessToken))
  add(query_594322, "uploadType", newJString(uploadType))
  add(query_594322, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_594322, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_594322, "key", newJString(key))
  add(query_594322, "$.xgafv", newJString(Xgafv))
  add(query_594322, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_594322.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_594322, "prettyPrint", newJBool(prettyPrint))
  add(query_594322, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_594322, "bearer_token", newJString(bearerToken))
  result = call_594321.call(nil, query_594322, nil, nil, nil)

var partnersUserStatesList* = Call_PartnersUserStatesList_594297(
    name: "partnersUserStatesList", meth: HttpMethod.HttpGet,
    host: "partners.googleapis.com", route: "/v2/userStates",
    validator: validate_PartnersUserStatesList_594298, base: "/",
    url: url_PartnersUserStatesList_594299, schemes: {Scheme.Https})
type
  Call_PartnersUsersUpdateProfile_594323 = ref object of OpenApiRestCall_593421
proc url_PartnersUsersUpdateProfile_594325(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PartnersUsersUpdateProfile_594324(path: JsonNode; query: JsonNode;
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
  var valid_594326 = query.getOrDefault("upload_protocol")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = nil)
  if valid_594326 != nil:
    section.add "upload_protocol", valid_594326
  var valid_594327 = query.getOrDefault("fields")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = nil)
  if valid_594327 != nil:
    section.add "fields", valid_594327
  var valid_594328 = query.getOrDefault("quotaUser")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "quotaUser", valid_594328
  var valid_594329 = query.getOrDefault("requestMetadata.locale")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = nil)
  if valid_594329 != nil:
    section.add "requestMetadata.locale", valid_594329
  var valid_594330 = query.getOrDefault("alt")
  valid_594330 = validateParameter(valid_594330, JString, required = false,
                                 default = newJString("json"))
  if valid_594330 != nil:
    section.add "alt", valid_594330
  var valid_594331 = query.getOrDefault("pp")
  valid_594331 = validateParameter(valid_594331, JBool, required = false,
                                 default = newJBool(true))
  if valid_594331 != nil:
    section.add "pp", valid_594331
  var valid_594332 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = nil)
  if valid_594332 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_594332
  var valid_594333 = query.getOrDefault("oauth_token")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "oauth_token", valid_594333
  var valid_594334 = query.getOrDefault("callback")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = nil)
  if valid_594334 != nil:
    section.add "callback", valid_594334
  var valid_594335 = query.getOrDefault("access_token")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = nil)
  if valid_594335 != nil:
    section.add "access_token", valid_594335
  var valid_594336 = query.getOrDefault("uploadType")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "uploadType", valid_594336
  var valid_594337 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_594337
  var valid_594338 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_594338
  var valid_594339 = query.getOrDefault("key")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "key", valid_594339
  var valid_594340 = query.getOrDefault("$.xgafv")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = newJString("1"))
  if valid_594340 != nil:
    section.add "$.xgafv", valid_594340
  var valid_594341 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_594341
  var valid_594342 = query.getOrDefault("requestMetadata.experimentIds")
  valid_594342 = validateParameter(valid_594342, JArray, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "requestMetadata.experimentIds", valid_594342
  var valid_594343 = query.getOrDefault("prettyPrint")
  valid_594343 = validateParameter(valid_594343, JBool, required = false,
                                 default = newJBool(true))
  if valid_594343 != nil:
    section.add "prettyPrint", valid_594343
  var valid_594344 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "requestMetadata.partnersSessionId", valid_594344
  var valid_594345 = query.getOrDefault("bearer_token")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = nil)
  if valid_594345 != nil:
    section.add "bearer_token", valid_594345
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

proc call*(call_594347: Call_PartnersUsersUpdateProfile_594323; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a user's profile. A user can only update their own profile and
  ## should only be called within the context of a logged in user.
  ## 
  let valid = call_594347.validator(path, query, header, formData, body)
  let scheme = call_594347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594347.url(scheme.get, call_594347.host, call_594347.base,
                         call_594347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594347, url, valid)

proc call*(call_594348: Call_PartnersUsersUpdateProfile_594323;
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
  var query_594349 = newJObject()
  var body_594350 = newJObject()
  add(query_594349, "upload_protocol", newJString(uploadProtocol))
  add(query_594349, "fields", newJString(fields))
  add(query_594349, "quotaUser", newJString(quotaUser))
  add(query_594349, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_594349, "alt", newJString(alt))
  add(query_594349, "pp", newJBool(pp))
  add(query_594349, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_594349, "oauth_token", newJString(oauthToken))
  add(query_594349, "callback", newJString(callback))
  add(query_594349, "access_token", newJString(accessToken))
  add(query_594349, "uploadType", newJString(uploadType))
  add(query_594349, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_594349, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_594349, "key", newJString(key))
  add(query_594349, "$.xgafv", newJString(Xgafv))
  add(query_594349, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_594349.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_594350 = body
  add(query_594349, "prettyPrint", newJBool(prettyPrint))
  add(query_594349, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_594349, "bearer_token", newJString(bearerToken))
  result = call_594348.call(nil, query_594349, nil, nil, body_594350)

var partnersUsersUpdateProfile* = Call_PartnersUsersUpdateProfile_594323(
    name: "partnersUsersUpdateProfile", meth: HttpMethod.HttpPatch,
    host: "partners.googleapis.com", route: "/v2/users/profile",
    validator: validate_PartnersUsersUpdateProfile_594324, base: "/",
    url: url_PartnersUsersUpdateProfile_594325, schemes: {Scheme.Https})
type
  Call_PartnersUsersGet_594351 = ref object of OpenApiRestCall_593421
proc url_PartnersUsersGet_594353(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PartnersUsersGet_594352(path: JsonNode; query: JsonNode;
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
  var valid_594354 = path.getOrDefault("userId")
  valid_594354 = validateParameter(valid_594354, JString, required = true,
                                 default = nil)
  if valid_594354 != nil:
    section.add "userId", valid_594354
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
  var valid_594355 = query.getOrDefault("upload_protocol")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = nil)
  if valid_594355 != nil:
    section.add "upload_protocol", valid_594355
  var valid_594356 = query.getOrDefault("fields")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "fields", valid_594356
  var valid_594357 = query.getOrDefault("quotaUser")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = nil)
  if valid_594357 != nil:
    section.add "quotaUser", valid_594357
  var valid_594358 = query.getOrDefault("requestMetadata.locale")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "requestMetadata.locale", valid_594358
  var valid_594359 = query.getOrDefault("alt")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = newJString("json"))
  if valid_594359 != nil:
    section.add "alt", valid_594359
  var valid_594360 = query.getOrDefault("pp")
  valid_594360 = validateParameter(valid_594360, JBool, required = false,
                                 default = newJBool(true))
  if valid_594360 != nil:
    section.add "pp", valid_594360
  var valid_594361 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_594361
  var valid_594362 = query.getOrDefault("userView")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_594362 != nil:
    section.add "userView", valid_594362
  var valid_594363 = query.getOrDefault("oauth_token")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "oauth_token", valid_594363
  var valid_594364 = query.getOrDefault("callback")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = nil)
  if valid_594364 != nil:
    section.add "callback", valid_594364
  var valid_594365 = query.getOrDefault("access_token")
  valid_594365 = validateParameter(valid_594365, JString, required = false,
                                 default = nil)
  if valid_594365 != nil:
    section.add "access_token", valid_594365
  var valid_594366 = query.getOrDefault("uploadType")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "uploadType", valid_594366
  var valid_594367 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_594367
  var valid_594368 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_594368 = validateParameter(valid_594368, JString, required = false,
                                 default = nil)
  if valid_594368 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_594368
  var valid_594369 = query.getOrDefault("key")
  valid_594369 = validateParameter(valid_594369, JString, required = false,
                                 default = nil)
  if valid_594369 != nil:
    section.add "key", valid_594369
  var valid_594370 = query.getOrDefault("$.xgafv")
  valid_594370 = validateParameter(valid_594370, JString, required = false,
                                 default = newJString("1"))
  if valid_594370 != nil:
    section.add "$.xgafv", valid_594370
  var valid_594371 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_594371 = validateParameter(valid_594371, JString, required = false,
                                 default = nil)
  if valid_594371 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_594371
  var valid_594372 = query.getOrDefault("requestMetadata.experimentIds")
  valid_594372 = validateParameter(valid_594372, JArray, required = false,
                                 default = nil)
  if valid_594372 != nil:
    section.add "requestMetadata.experimentIds", valid_594372
  var valid_594373 = query.getOrDefault("prettyPrint")
  valid_594373 = validateParameter(valid_594373, JBool, required = false,
                                 default = newJBool(true))
  if valid_594373 != nil:
    section.add "prettyPrint", valid_594373
  var valid_594374 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_594374 = validateParameter(valid_594374, JString, required = false,
                                 default = nil)
  if valid_594374 != nil:
    section.add "requestMetadata.partnersSessionId", valid_594374
  var valid_594375 = query.getOrDefault("bearer_token")
  valid_594375 = validateParameter(valid_594375, JString, required = false,
                                 default = nil)
  if valid_594375 != nil:
    section.add "bearer_token", valid_594375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594376: Call_PartnersUsersGet_594351; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a user.
  ## 
  let valid = call_594376.validator(path, query, header, formData, body)
  let scheme = call_594376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594376.url(scheme.get, call_594376.host, call_594376.base,
                         call_594376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594376, url, valid)

proc call*(call_594377: Call_PartnersUsersGet_594351; userId: string;
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
  var path_594378 = newJObject()
  var query_594379 = newJObject()
  add(query_594379, "upload_protocol", newJString(uploadProtocol))
  add(query_594379, "fields", newJString(fields))
  add(query_594379, "quotaUser", newJString(quotaUser))
  add(query_594379, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_594379, "alt", newJString(alt))
  add(query_594379, "pp", newJBool(pp))
  add(query_594379, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_594379, "userView", newJString(userView))
  add(query_594379, "oauth_token", newJString(oauthToken))
  add(query_594379, "callback", newJString(callback))
  add(query_594379, "access_token", newJString(accessToken))
  add(query_594379, "uploadType", newJString(uploadType))
  add(query_594379, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_594379, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_594379, "key", newJString(key))
  add(query_594379, "$.xgafv", newJString(Xgafv))
  add(query_594379, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_594379.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_594379, "prettyPrint", newJBool(prettyPrint))
  add(path_594378, "userId", newJString(userId))
  add(query_594379, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_594379, "bearer_token", newJString(bearerToken))
  result = call_594377.call(path_594378, query_594379, nil, nil, nil)

var partnersUsersGet* = Call_PartnersUsersGet_594351(name: "partnersUsersGet",
    meth: HttpMethod.HttpGet, host: "partners.googleapis.com",
    route: "/v2/users/{userId}", validator: validate_PartnersUsersGet_594352,
    base: "/", url: url_PartnersUsersGet_594353, schemes: {Scheme.Https})
type
  Call_PartnersUsersCreateCompanyRelation_594380 = ref object of OpenApiRestCall_593421
proc url_PartnersUsersCreateCompanyRelation_594382(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PartnersUsersCreateCompanyRelation_594381(path: JsonNode;
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
  var valid_594383 = path.getOrDefault("userId")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "userId", valid_594383
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
  var valid_594384 = query.getOrDefault("upload_protocol")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = nil)
  if valid_594384 != nil:
    section.add "upload_protocol", valid_594384
  var valid_594385 = query.getOrDefault("fields")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = nil)
  if valid_594385 != nil:
    section.add "fields", valid_594385
  var valid_594386 = query.getOrDefault("quotaUser")
  valid_594386 = validateParameter(valid_594386, JString, required = false,
                                 default = nil)
  if valid_594386 != nil:
    section.add "quotaUser", valid_594386
  var valid_594387 = query.getOrDefault("requestMetadata.locale")
  valid_594387 = validateParameter(valid_594387, JString, required = false,
                                 default = nil)
  if valid_594387 != nil:
    section.add "requestMetadata.locale", valid_594387
  var valid_594388 = query.getOrDefault("alt")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = newJString("json"))
  if valid_594388 != nil:
    section.add "alt", valid_594388
  var valid_594389 = query.getOrDefault("pp")
  valid_594389 = validateParameter(valid_594389, JBool, required = false,
                                 default = newJBool(true))
  if valid_594389 != nil:
    section.add "pp", valid_594389
  var valid_594390 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_594390 = validateParameter(valid_594390, JString, required = false,
                                 default = nil)
  if valid_594390 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_594390
  var valid_594391 = query.getOrDefault("oauth_token")
  valid_594391 = validateParameter(valid_594391, JString, required = false,
                                 default = nil)
  if valid_594391 != nil:
    section.add "oauth_token", valid_594391
  var valid_594392 = query.getOrDefault("callback")
  valid_594392 = validateParameter(valid_594392, JString, required = false,
                                 default = nil)
  if valid_594392 != nil:
    section.add "callback", valid_594392
  var valid_594393 = query.getOrDefault("access_token")
  valid_594393 = validateParameter(valid_594393, JString, required = false,
                                 default = nil)
  if valid_594393 != nil:
    section.add "access_token", valid_594393
  var valid_594394 = query.getOrDefault("uploadType")
  valid_594394 = validateParameter(valid_594394, JString, required = false,
                                 default = nil)
  if valid_594394 != nil:
    section.add "uploadType", valid_594394
  var valid_594395 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_594395 = validateParameter(valid_594395, JString, required = false,
                                 default = nil)
  if valid_594395 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_594395
  var valid_594396 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_594396 = validateParameter(valid_594396, JString, required = false,
                                 default = nil)
  if valid_594396 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_594396
  var valid_594397 = query.getOrDefault("key")
  valid_594397 = validateParameter(valid_594397, JString, required = false,
                                 default = nil)
  if valid_594397 != nil:
    section.add "key", valid_594397
  var valid_594398 = query.getOrDefault("$.xgafv")
  valid_594398 = validateParameter(valid_594398, JString, required = false,
                                 default = newJString("1"))
  if valid_594398 != nil:
    section.add "$.xgafv", valid_594398
  var valid_594399 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_594399 = validateParameter(valid_594399, JString, required = false,
                                 default = nil)
  if valid_594399 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_594399
  var valid_594400 = query.getOrDefault("requestMetadata.experimentIds")
  valid_594400 = validateParameter(valid_594400, JArray, required = false,
                                 default = nil)
  if valid_594400 != nil:
    section.add "requestMetadata.experimentIds", valid_594400
  var valid_594401 = query.getOrDefault("prettyPrint")
  valid_594401 = validateParameter(valid_594401, JBool, required = false,
                                 default = newJBool(true))
  if valid_594401 != nil:
    section.add "prettyPrint", valid_594401
  var valid_594402 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "requestMetadata.partnersSessionId", valid_594402
  var valid_594403 = query.getOrDefault("bearer_token")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = nil)
  if valid_594403 != nil:
    section.add "bearer_token", valid_594403
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

proc call*(call_594405: Call_PartnersUsersCreateCompanyRelation_594380;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a user's company relation. Affiliates the user to a company.
  ## 
  let valid = call_594405.validator(path, query, header, formData, body)
  let scheme = call_594405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594405.url(scheme.get, call_594405.host, call_594405.base,
                         call_594405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594405, url, valid)

proc call*(call_594406: Call_PartnersUsersCreateCompanyRelation_594380;
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
  var path_594407 = newJObject()
  var query_594408 = newJObject()
  var body_594409 = newJObject()
  add(query_594408, "upload_protocol", newJString(uploadProtocol))
  add(query_594408, "fields", newJString(fields))
  add(query_594408, "quotaUser", newJString(quotaUser))
  add(query_594408, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_594408, "alt", newJString(alt))
  add(query_594408, "pp", newJBool(pp))
  add(query_594408, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_594408, "oauth_token", newJString(oauthToken))
  add(query_594408, "callback", newJString(callback))
  add(query_594408, "access_token", newJString(accessToken))
  add(query_594408, "uploadType", newJString(uploadType))
  add(query_594408, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_594408, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_594408, "key", newJString(key))
  add(query_594408, "$.xgafv", newJString(Xgafv))
  add(query_594408, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_594408.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  if body != nil:
    body_594409 = body
  add(query_594408, "prettyPrint", newJBool(prettyPrint))
  add(path_594407, "userId", newJString(userId))
  add(query_594408, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_594408, "bearer_token", newJString(bearerToken))
  result = call_594406.call(path_594407, query_594408, nil, nil, body_594409)

var partnersUsersCreateCompanyRelation* = Call_PartnersUsersCreateCompanyRelation_594380(
    name: "partnersUsersCreateCompanyRelation", meth: HttpMethod.HttpPut,
    host: "partners.googleapis.com", route: "/v2/users/{userId}/companyRelation",
    validator: validate_PartnersUsersCreateCompanyRelation_594381, base: "/",
    url: url_PartnersUsersCreateCompanyRelation_594382, schemes: {Scheme.Https})
type
  Call_PartnersUsersDeleteCompanyRelation_594410 = ref object of OpenApiRestCall_593421
proc url_PartnersUsersDeleteCompanyRelation_594412(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_PartnersUsersDeleteCompanyRelation_594411(path: JsonNode;
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
  var valid_594413 = path.getOrDefault("userId")
  valid_594413 = validateParameter(valid_594413, JString, required = true,
                                 default = nil)
  if valid_594413 != nil:
    section.add "userId", valid_594413
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
  var valid_594414 = query.getOrDefault("upload_protocol")
  valid_594414 = validateParameter(valid_594414, JString, required = false,
                                 default = nil)
  if valid_594414 != nil:
    section.add "upload_protocol", valid_594414
  var valid_594415 = query.getOrDefault("fields")
  valid_594415 = validateParameter(valid_594415, JString, required = false,
                                 default = nil)
  if valid_594415 != nil:
    section.add "fields", valid_594415
  var valid_594416 = query.getOrDefault("quotaUser")
  valid_594416 = validateParameter(valid_594416, JString, required = false,
                                 default = nil)
  if valid_594416 != nil:
    section.add "quotaUser", valid_594416
  var valid_594417 = query.getOrDefault("requestMetadata.locale")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "requestMetadata.locale", valid_594417
  var valid_594418 = query.getOrDefault("alt")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = newJString("json"))
  if valid_594418 != nil:
    section.add "alt", valid_594418
  var valid_594419 = query.getOrDefault("pp")
  valid_594419 = validateParameter(valid_594419, JBool, required = false,
                                 default = newJBool(true))
  if valid_594419 != nil:
    section.add "pp", valid_594419
  var valid_594420 = query.getOrDefault("requestMetadata.userOverrides.ipAddress")
  valid_594420 = validateParameter(valid_594420, JString, required = false,
                                 default = nil)
  if valid_594420 != nil:
    section.add "requestMetadata.userOverrides.ipAddress", valid_594420
  var valid_594421 = query.getOrDefault("oauth_token")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "oauth_token", valid_594421
  var valid_594422 = query.getOrDefault("callback")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "callback", valid_594422
  var valid_594423 = query.getOrDefault("access_token")
  valid_594423 = validateParameter(valid_594423, JString, required = false,
                                 default = nil)
  if valid_594423 != nil:
    section.add "access_token", valid_594423
  var valid_594424 = query.getOrDefault("uploadType")
  valid_594424 = validateParameter(valid_594424, JString, required = false,
                                 default = nil)
  if valid_594424 != nil:
    section.add "uploadType", valid_594424
  var valid_594425 = query.getOrDefault("requestMetadata.trafficSource.trafficSourceId")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = nil)
  if valid_594425 != nil:
    section.add "requestMetadata.trafficSource.trafficSourceId", valid_594425
  var valid_594426 = query.getOrDefault("requestMetadata.trafficSource.trafficSubId")
  valid_594426 = validateParameter(valid_594426, JString, required = false,
                                 default = nil)
  if valid_594426 != nil:
    section.add "requestMetadata.trafficSource.trafficSubId", valid_594426
  var valid_594427 = query.getOrDefault("key")
  valid_594427 = validateParameter(valid_594427, JString, required = false,
                                 default = nil)
  if valid_594427 != nil:
    section.add "key", valid_594427
  var valid_594428 = query.getOrDefault("$.xgafv")
  valid_594428 = validateParameter(valid_594428, JString, required = false,
                                 default = newJString("1"))
  if valid_594428 != nil:
    section.add "$.xgafv", valid_594428
  var valid_594429 = query.getOrDefault("requestMetadata.userOverrides.userId")
  valid_594429 = validateParameter(valid_594429, JString, required = false,
                                 default = nil)
  if valid_594429 != nil:
    section.add "requestMetadata.userOverrides.userId", valid_594429
  var valid_594430 = query.getOrDefault("requestMetadata.experimentIds")
  valid_594430 = validateParameter(valid_594430, JArray, required = false,
                                 default = nil)
  if valid_594430 != nil:
    section.add "requestMetadata.experimentIds", valid_594430
  var valid_594431 = query.getOrDefault("prettyPrint")
  valid_594431 = validateParameter(valid_594431, JBool, required = false,
                                 default = newJBool(true))
  if valid_594431 != nil:
    section.add "prettyPrint", valid_594431
  var valid_594432 = query.getOrDefault("requestMetadata.partnersSessionId")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = nil)
  if valid_594432 != nil:
    section.add "requestMetadata.partnersSessionId", valid_594432
  var valid_594433 = query.getOrDefault("bearer_token")
  valid_594433 = validateParameter(valid_594433, JString, required = false,
                                 default = nil)
  if valid_594433 != nil:
    section.add "bearer_token", valid_594433
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594434: Call_PartnersUsersDeleteCompanyRelation_594410;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a user's company relation. Unaffiliaites the user from a company.
  ## 
  let valid = call_594434.validator(path, query, header, formData, body)
  let scheme = call_594434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594434.url(scheme.get, call_594434.host, call_594434.base,
                         call_594434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594434, url, valid)

proc call*(call_594435: Call_PartnersUsersDeleteCompanyRelation_594410;
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
  var path_594436 = newJObject()
  var query_594437 = newJObject()
  add(query_594437, "upload_protocol", newJString(uploadProtocol))
  add(query_594437, "fields", newJString(fields))
  add(query_594437, "quotaUser", newJString(quotaUser))
  add(query_594437, "requestMetadata.locale", newJString(requestMetadataLocale))
  add(query_594437, "alt", newJString(alt))
  add(query_594437, "pp", newJBool(pp))
  add(query_594437, "requestMetadata.userOverrides.ipAddress",
      newJString(requestMetadataUserOverridesIpAddress))
  add(query_594437, "oauth_token", newJString(oauthToken))
  add(query_594437, "callback", newJString(callback))
  add(query_594437, "access_token", newJString(accessToken))
  add(query_594437, "uploadType", newJString(uploadType))
  add(query_594437, "requestMetadata.trafficSource.trafficSourceId",
      newJString(requestMetadataTrafficSourceTrafficSourceId))
  add(query_594437, "requestMetadata.trafficSource.trafficSubId",
      newJString(requestMetadataTrafficSourceTrafficSubId))
  add(query_594437, "key", newJString(key))
  add(query_594437, "$.xgafv", newJString(Xgafv))
  add(query_594437, "requestMetadata.userOverrides.userId",
      newJString(requestMetadataUserOverridesUserId))
  if requestMetadataExperimentIds != nil:
    query_594437.add "requestMetadata.experimentIds", requestMetadataExperimentIds
  add(query_594437, "prettyPrint", newJBool(prettyPrint))
  add(path_594436, "userId", newJString(userId))
  add(query_594437, "requestMetadata.partnersSessionId",
      newJString(requestMetadataPartnersSessionId))
  add(query_594437, "bearer_token", newJString(bearerToken))
  result = call_594435.call(path_594436, query_594437, nil, nil, nil)

var partnersUsersDeleteCompanyRelation* = Call_PartnersUsersDeleteCompanyRelation_594410(
    name: "partnersUsersDeleteCompanyRelation", meth: HttpMethod.HttpDelete,
    host: "partners.googleapis.com", route: "/v2/users/{userId}/companyRelation",
    validator: validate_PartnersUsersDeleteCompanyRelation_594411, base: "/",
    url: url_PartnersUsersDeleteCompanyRelation_594412, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
