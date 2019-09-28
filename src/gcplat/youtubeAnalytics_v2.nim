
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: YouTube Analytics
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Retrieves your YouTube Analytics data.
## 
## https://developers.google.com/youtube/analytics
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "youtubeAnalytics"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_YoutubeAnalyticsGroupItemsInsert_579951 = ref object of OpenApiRestCall_579408
proc url_YoutubeAnalyticsGroupItemsInsert_579953(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsInsert_579952(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a group item.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
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
  section = newJObject()
  var valid_579954 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "onBehalfOfContentOwner", valid_579954
  var valid_579955 = query.getOrDefault("upload_protocol")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "upload_protocol", valid_579955
  var valid_579956 = query.getOrDefault("fields")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "fields", valid_579956
  var valid_579957 = query.getOrDefault("quotaUser")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "quotaUser", valid_579957
  var valid_579958 = query.getOrDefault("alt")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = newJString("json"))
  if valid_579958 != nil:
    section.add "alt", valid_579958
  var valid_579959 = query.getOrDefault("oauth_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "oauth_token", valid_579959
  var valid_579960 = query.getOrDefault("callback")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "callback", valid_579960
  var valid_579961 = query.getOrDefault("access_token")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "access_token", valid_579961
  var valid_579962 = query.getOrDefault("uploadType")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "uploadType", valid_579962
  var valid_579963 = query.getOrDefault("key")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "key", valid_579963
  var valid_579964 = query.getOrDefault("$.xgafv")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = newJString("1"))
  if valid_579964 != nil:
    section.add "$.xgafv", valid_579964
  var valid_579965 = query.getOrDefault("prettyPrint")
  valid_579965 = validateParameter(valid_579965, JBool, required = false,
                                 default = newJBool(true))
  if valid_579965 != nil:
    section.add "prettyPrint", valid_579965
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

proc call*(call_579967: Call_YoutubeAnalyticsGroupItemsInsert_579951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a group item.
  ## 
  let valid = call_579967.validator(path, query, header, formData, body)
  let scheme = call_579967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579967.url(scheme.get, call_579967.host, call_579967.base,
                         call_579967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579967, url, valid)

proc call*(call_579968: Call_YoutubeAnalyticsGroupItemsInsert_579951;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupItemsInsert
  ## Creates a group item.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  var query_579969 = newJObject()
  var body_579970 = newJObject()
  add(query_579969, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579969, "upload_protocol", newJString(uploadProtocol))
  add(query_579969, "fields", newJString(fields))
  add(query_579969, "quotaUser", newJString(quotaUser))
  add(query_579969, "alt", newJString(alt))
  add(query_579969, "oauth_token", newJString(oauthToken))
  add(query_579969, "callback", newJString(callback))
  add(query_579969, "access_token", newJString(accessToken))
  add(query_579969, "uploadType", newJString(uploadType))
  add(query_579969, "key", newJString(key))
  add(query_579969, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579970 = body
  add(query_579969, "prettyPrint", newJBool(prettyPrint))
  result = call_579968.call(nil, query_579969, nil, nil, body_579970)

var youtubeAnalyticsGroupItemsInsert* = Call_YoutubeAnalyticsGroupItemsInsert_579951(
    name: "youtubeAnalyticsGroupItemsInsert", meth: HttpMethod.HttpPost,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsInsert_579952, base: "/",
    url: url_YoutubeAnalyticsGroupItemsInsert_579953, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupItemsList_579677 = ref object of OpenApiRestCall_579408
proc url_YoutubeAnalyticsGroupItemsList_579679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsList_579678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of group items that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   groupId: JString
  ##          : The `groupId` parameter specifies the unique ID of the group for which you
  ## want to retrieve group items.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579791 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "onBehalfOfContentOwner", valid_579791
  var valid_579792 = query.getOrDefault("upload_protocol")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "upload_protocol", valid_579792
  var valid_579793 = query.getOrDefault("fields")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "fields", valid_579793
  var valid_579794 = query.getOrDefault("quotaUser")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "quotaUser", valid_579794
  var valid_579808 = query.getOrDefault("alt")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = newJString("json"))
  if valid_579808 != nil:
    section.add "alt", valid_579808
  var valid_579809 = query.getOrDefault("oauth_token")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "oauth_token", valid_579809
  var valid_579810 = query.getOrDefault("callback")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "callback", valid_579810
  var valid_579811 = query.getOrDefault("access_token")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "access_token", valid_579811
  var valid_579812 = query.getOrDefault("uploadType")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "uploadType", valid_579812
  var valid_579813 = query.getOrDefault("groupId")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "groupId", valid_579813
  var valid_579814 = query.getOrDefault("key")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "key", valid_579814
  var valid_579815 = query.getOrDefault("$.xgafv")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = newJString("1"))
  if valid_579815 != nil:
    section.add "$.xgafv", valid_579815
  var valid_579816 = query.getOrDefault("prettyPrint")
  valid_579816 = validateParameter(valid_579816, JBool, required = false,
                                 default = newJBool(true))
  if valid_579816 != nil:
    section.add "prettyPrint", valid_579816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579839: Call_YoutubeAnalyticsGroupItemsList_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of group items that match the API request parameters.
  ## 
  let valid = call_579839.validator(path, query, header, formData, body)
  let scheme = call_579839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579839.url(scheme.get, call_579839.host, call_579839.base,
                         call_579839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579839, url, valid)

proc call*(call_579910: Call_YoutubeAnalyticsGroupItemsList_579677;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; groupId: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupItemsList
  ## Returns a collection of group items that match the API request parameters.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   groupId: string
  ##          : The `groupId` parameter specifies the unique ID of the group for which you
  ## want to retrieve group items.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579911 = newJObject()
  add(query_579911, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579911, "upload_protocol", newJString(uploadProtocol))
  add(query_579911, "fields", newJString(fields))
  add(query_579911, "quotaUser", newJString(quotaUser))
  add(query_579911, "alt", newJString(alt))
  add(query_579911, "oauth_token", newJString(oauthToken))
  add(query_579911, "callback", newJString(callback))
  add(query_579911, "access_token", newJString(accessToken))
  add(query_579911, "uploadType", newJString(uploadType))
  add(query_579911, "groupId", newJString(groupId))
  add(query_579911, "key", newJString(key))
  add(query_579911, "$.xgafv", newJString(Xgafv))
  add(query_579911, "prettyPrint", newJBool(prettyPrint))
  result = call_579910.call(nil, query_579911, nil, nil, nil)

var youtubeAnalyticsGroupItemsList* = Call_YoutubeAnalyticsGroupItemsList_579677(
    name: "youtubeAnalyticsGroupItemsList", meth: HttpMethod.HttpGet,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsList_579678, base: "/",
    url: url_YoutubeAnalyticsGroupItemsList_579679, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupItemsDelete_579971 = ref object of OpenApiRestCall_579408
proc url_YoutubeAnalyticsGroupItemsDelete_579973(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsDelete_579972(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes an item from a group.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: JString
  ##     : The `id` parameter specifies the YouTube group item ID of the group item
  ## that is being deleted.
  ##   alt: JString
  ##      : Data format for response.
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
  section = newJObject()
  var valid_579974 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "onBehalfOfContentOwner", valid_579974
  var valid_579975 = query.getOrDefault("upload_protocol")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "upload_protocol", valid_579975
  var valid_579976 = query.getOrDefault("fields")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "fields", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("id")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "id", valid_579978
  var valid_579979 = query.getOrDefault("alt")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("json"))
  if valid_579979 != nil:
    section.add "alt", valid_579979
  var valid_579980 = query.getOrDefault("oauth_token")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "oauth_token", valid_579980
  var valid_579981 = query.getOrDefault("callback")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "callback", valid_579981
  var valid_579982 = query.getOrDefault("access_token")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "access_token", valid_579982
  var valid_579983 = query.getOrDefault("uploadType")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "uploadType", valid_579983
  var valid_579984 = query.getOrDefault("key")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "key", valid_579984
  var valid_579985 = query.getOrDefault("$.xgafv")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("1"))
  if valid_579985 != nil:
    section.add "$.xgafv", valid_579985
  var valid_579986 = query.getOrDefault("prettyPrint")
  valid_579986 = validateParameter(valid_579986, JBool, required = false,
                                 default = newJBool(true))
  if valid_579986 != nil:
    section.add "prettyPrint", valid_579986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579987: Call_YoutubeAnalyticsGroupItemsDelete_579971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes an item from a group.
  ## 
  let valid = call_579987.validator(path, query, header, formData, body)
  let scheme = call_579987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579987.url(scheme.get, call_579987.host, call_579987.base,
                         call_579987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579987, url, valid)

proc call*(call_579988: Call_YoutubeAnalyticsGroupItemsDelete_579971;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupItemsDelete
  ## Removes an item from a group.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: string
  ##     : The `id` parameter specifies the YouTube group item ID of the group item
  ## that is being deleted.
  ##   alt: string
  ##      : Data format for response.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579989 = newJObject()
  add(query_579989, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579989, "upload_protocol", newJString(uploadProtocol))
  add(query_579989, "fields", newJString(fields))
  add(query_579989, "quotaUser", newJString(quotaUser))
  add(query_579989, "id", newJString(id))
  add(query_579989, "alt", newJString(alt))
  add(query_579989, "oauth_token", newJString(oauthToken))
  add(query_579989, "callback", newJString(callback))
  add(query_579989, "access_token", newJString(accessToken))
  add(query_579989, "uploadType", newJString(uploadType))
  add(query_579989, "key", newJString(key))
  add(query_579989, "$.xgafv", newJString(Xgafv))
  add(query_579989, "prettyPrint", newJBool(prettyPrint))
  result = call_579988.call(nil, query_579989, nil, nil, nil)

var youtubeAnalyticsGroupItemsDelete* = Call_YoutubeAnalyticsGroupItemsDelete_579971(
    name: "youtubeAnalyticsGroupItemsDelete", meth: HttpMethod.HttpDelete,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsDelete_579972, base: "/",
    url: url_YoutubeAnalyticsGroupItemsDelete_579973, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsUpdate_580011 = ref object of OpenApiRestCall_579408
proc url_YoutubeAnalyticsGroupsUpdate_580013(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsUpdate_580012(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a group. For example, you could change a group's title.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
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
  section = newJObject()
  var valid_580014 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "onBehalfOfContentOwner", valid_580014
  var valid_580015 = query.getOrDefault("upload_protocol")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "upload_protocol", valid_580015
  var valid_580016 = query.getOrDefault("fields")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "fields", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("alt")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("json"))
  if valid_580018 != nil:
    section.add "alt", valid_580018
  var valid_580019 = query.getOrDefault("oauth_token")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "oauth_token", valid_580019
  var valid_580020 = query.getOrDefault("callback")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "callback", valid_580020
  var valid_580021 = query.getOrDefault("access_token")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "access_token", valid_580021
  var valid_580022 = query.getOrDefault("uploadType")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "uploadType", valid_580022
  var valid_580023 = query.getOrDefault("key")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "key", valid_580023
  var valid_580024 = query.getOrDefault("$.xgafv")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = newJString("1"))
  if valid_580024 != nil:
    section.add "$.xgafv", valid_580024
  var valid_580025 = query.getOrDefault("prettyPrint")
  valid_580025 = validateParameter(valid_580025, JBool, required = false,
                                 default = newJBool(true))
  if valid_580025 != nil:
    section.add "prettyPrint", valid_580025
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

proc call*(call_580027: Call_YoutubeAnalyticsGroupsUpdate_580011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a group. For example, you could change a group's title.
  ## 
  let valid = call_580027.validator(path, query, header, formData, body)
  let scheme = call_580027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580027.url(scheme.get, call_580027.host, call_580027.base,
                         call_580027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580027, url, valid)

proc call*(call_580028: Call_YoutubeAnalyticsGroupsUpdate_580011;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupsUpdate
  ## Modifies a group. For example, you could change a group's title.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  var query_580029 = newJObject()
  var body_580030 = newJObject()
  add(query_580029, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580029, "upload_protocol", newJString(uploadProtocol))
  add(query_580029, "fields", newJString(fields))
  add(query_580029, "quotaUser", newJString(quotaUser))
  add(query_580029, "alt", newJString(alt))
  add(query_580029, "oauth_token", newJString(oauthToken))
  add(query_580029, "callback", newJString(callback))
  add(query_580029, "access_token", newJString(accessToken))
  add(query_580029, "uploadType", newJString(uploadType))
  add(query_580029, "key", newJString(key))
  add(query_580029, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580030 = body
  add(query_580029, "prettyPrint", newJBool(prettyPrint))
  result = call_580028.call(nil, query_580029, nil, nil, body_580030)

var youtubeAnalyticsGroupsUpdate* = Call_YoutubeAnalyticsGroupsUpdate_580011(
    name: "youtubeAnalyticsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsUpdate_580012, base: "/",
    url: url_YoutubeAnalyticsGroupsUpdate_580013, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsInsert_580031 = ref object of OpenApiRestCall_579408
proc url_YoutubeAnalyticsGroupsInsert_580033(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsInsert_580032(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a group.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
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
  section = newJObject()
  var valid_580034 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "onBehalfOfContentOwner", valid_580034
  var valid_580035 = query.getOrDefault("upload_protocol")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "upload_protocol", valid_580035
  var valid_580036 = query.getOrDefault("fields")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "fields", valid_580036
  var valid_580037 = query.getOrDefault("quotaUser")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "quotaUser", valid_580037
  var valid_580038 = query.getOrDefault("alt")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = newJString("json"))
  if valid_580038 != nil:
    section.add "alt", valid_580038
  var valid_580039 = query.getOrDefault("oauth_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "oauth_token", valid_580039
  var valid_580040 = query.getOrDefault("callback")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "callback", valid_580040
  var valid_580041 = query.getOrDefault("access_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "access_token", valid_580041
  var valid_580042 = query.getOrDefault("uploadType")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "uploadType", valid_580042
  var valid_580043 = query.getOrDefault("key")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "key", valid_580043
  var valid_580044 = query.getOrDefault("$.xgafv")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = newJString("1"))
  if valid_580044 != nil:
    section.add "$.xgafv", valid_580044
  var valid_580045 = query.getOrDefault("prettyPrint")
  valid_580045 = validateParameter(valid_580045, JBool, required = false,
                                 default = newJBool(true))
  if valid_580045 != nil:
    section.add "prettyPrint", valid_580045
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

proc call*(call_580047: Call_YoutubeAnalyticsGroupsInsert_580031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a group.
  ## 
  let valid = call_580047.validator(path, query, header, formData, body)
  let scheme = call_580047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580047.url(scheme.get, call_580047.host, call_580047.base,
                         call_580047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580047, url, valid)

proc call*(call_580048: Call_YoutubeAnalyticsGroupsInsert_580031;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupsInsert
  ## Creates a group.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
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
  var query_580049 = newJObject()
  var body_580050 = newJObject()
  add(query_580049, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580049, "upload_protocol", newJString(uploadProtocol))
  add(query_580049, "fields", newJString(fields))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(query_580049, "alt", newJString(alt))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(query_580049, "callback", newJString(callback))
  add(query_580049, "access_token", newJString(accessToken))
  add(query_580049, "uploadType", newJString(uploadType))
  add(query_580049, "key", newJString(key))
  add(query_580049, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580050 = body
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  result = call_580048.call(nil, query_580049, nil, nil, body_580050)

var youtubeAnalyticsGroupsInsert* = Call_YoutubeAnalyticsGroupsInsert_580031(
    name: "youtubeAnalyticsGroupsInsert", meth: HttpMethod.HttpPost,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsInsert_580032, base: "/",
    url: url_YoutubeAnalyticsGroupsInsert_580033, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsList_579990 = ref object of OpenApiRestCall_579408
proc url_YoutubeAnalyticsGroupsList_579992(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsList_579991(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of groups that match the API request parameters. For
  ## example, you can retrieve all groups that the authenticated user owns,
  ## or you can retrieve one or more groups by their unique IDs.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   mine: JBool
  ##       : This parameter can only be used in a properly authorized request. Set this
  ## parameter's value to true to retrieve all groups owned by the authenticated
  ## user.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The `pageToken` parameter identifies a specific page in the result set that
  ## should be returned. In an API response, the `nextPageToken` property
  ## identifies the next page that can be retrieved.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: JString
  ##     : The `id` parameter specifies a comma-separated list of the YouTube group
  ## ID(s) for the resource(s) that are being retrieved. Each group must be
  ## owned by the authenticated user. In a `group` resource, the `id` property
  ## specifies the group's YouTube group ID.
  ## 
  ## Note that if you do not specify a value for the `id` parameter, then you
  ## must set the `mine` parameter to `true`.
  ##   alt: JString
  ##      : Data format for response.
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
  section = newJObject()
  var valid_579993 = query.getOrDefault("onBehalfOfContentOwner")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "onBehalfOfContentOwner", valid_579993
  var valid_579994 = query.getOrDefault("mine")
  valid_579994 = validateParameter(valid_579994, JBool, required = false, default = nil)
  if valid_579994 != nil:
    section.add "mine", valid_579994
  var valid_579995 = query.getOrDefault("upload_protocol")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "upload_protocol", valid_579995
  var valid_579996 = query.getOrDefault("fields")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "fields", valid_579996
  var valid_579997 = query.getOrDefault("pageToken")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "pageToken", valid_579997
  var valid_579998 = query.getOrDefault("quotaUser")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "quotaUser", valid_579998
  var valid_579999 = query.getOrDefault("id")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "id", valid_579999
  var valid_580000 = query.getOrDefault("alt")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("json"))
  if valid_580000 != nil:
    section.add "alt", valid_580000
  var valid_580001 = query.getOrDefault("oauth_token")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "oauth_token", valid_580001
  var valid_580002 = query.getOrDefault("callback")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "callback", valid_580002
  var valid_580003 = query.getOrDefault("access_token")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "access_token", valid_580003
  var valid_580004 = query.getOrDefault("uploadType")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "uploadType", valid_580004
  var valid_580005 = query.getOrDefault("key")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "key", valid_580005
  var valid_580006 = query.getOrDefault("$.xgafv")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = newJString("1"))
  if valid_580006 != nil:
    section.add "$.xgafv", valid_580006
  var valid_580007 = query.getOrDefault("prettyPrint")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(true))
  if valid_580007 != nil:
    section.add "prettyPrint", valid_580007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580008: Call_YoutubeAnalyticsGroupsList_579990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of groups that match the API request parameters. For
  ## example, you can retrieve all groups that the authenticated user owns,
  ## or you can retrieve one or more groups by their unique IDs.
  ## 
  let valid = call_580008.validator(path, query, header, formData, body)
  let scheme = call_580008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580008.url(scheme.get, call_580008.host, call_580008.base,
                         call_580008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580008, url, valid)

proc call*(call_580009: Call_YoutubeAnalyticsGroupsList_579990;
          onBehalfOfContentOwner: string = ""; mine: bool = false;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; id: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupsList
  ## Returns a collection of groups that match the API request parameters. For
  ## example, you can retrieve all groups that the authenticated user owns,
  ## or you can retrieve one or more groups by their unique IDs.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   mine: bool
  ##       : This parameter can only be used in a properly authorized request. Set this
  ## parameter's value to true to retrieve all groups owned by the authenticated
  ## user.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The `pageToken` parameter identifies a specific page in the result set that
  ## should be returned. In an API response, the `nextPageToken` property
  ## identifies the next page that can be retrieved.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: string
  ##     : The `id` parameter specifies a comma-separated list of the YouTube group
  ## ID(s) for the resource(s) that are being retrieved. Each group must be
  ## owned by the authenticated user. In a `group` resource, the `id` property
  ## specifies the group's YouTube group ID.
  ## 
  ## Note that if you do not specify a value for the `id` parameter, then you
  ## must set the `mine` parameter to `true`.
  ##   alt: string
  ##      : Data format for response.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580010 = newJObject()
  add(query_580010, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580010, "mine", newJBool(mine))
  add(query_580010, "upload_protocol", newJString(uploadProtocol))
  add(query_580010, "fields", newJString(fields))
  add(query_580010, "pageToken", newJString(pageToken))
  add(query_580010, "quotaUser", newJString(quotaUser))
  add(query_580010, "id", newJString(id))
  add(query_580010, "alt", newJString(alt))
  add(query_580010, "oauth_token", newJString(oauthToken))
  add(query_580010, "callback", newJString(callback))
  add(query_580010, "access_token", newJString(accessToken))
  add(query_580010, "uploadType", newJString(uploadType))
  add(query_580010, "key", newJString(key))
  add(query_580010, "$.xgafv", newJString(Xgafv))
  add(query_580010, "prettyPrint", newJBool(prettyPrint))
  result = call_580009.call(nil, query_580010, nil, nil, nil)

var youtubeAnalyticsGroupsList* = Call_YoutubeAnalyticsGroupsList_579990(
    name: "youtubeAnalyticsGroupsList", meth: HttpMethod.HttpGet,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsList_579991, base: "/",
    url: url_YoutubeAnalyticsGroupsList_579992, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsDelete_580051 = ref object of OpenApiRestCall_579408
proc url_YoutubeAnalyticsGroupsDelete_580053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsDelete_580052(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a group.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   onBehalfOfContentOwner: JString
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: JString
  ##     : The `id` parameter specifies the YouTube group ID of the group that is
  ## being deleted.
  ##   alt: JString
  ##      : Data format for response.
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
  section = newJObject()
  var valid_580054 = query.getOrDefault("onBehalfOfContentOwner")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "onBehalfOfContentOwner", valid_580054
  var valid_580055 = query.getOrDefault("upload_protocol")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "upload_protocol", valid_580055
  var valid_580056 = query.getOrDefault("fields")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "fields", valid_580056
  var valid_580057 = query.getOrDefault("quotaUser")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "quotaUser", valid_580057
  var valid_580058 = query.getOrDefault("id")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "id", valid_580058
  var valid_580059 = query.getOrDefault("alt")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = newJString("json"))
  if valid_580059 != nil:
    section.add "alt", valid_580059
  var valid_580060 = query.getOrDefault("oauth_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "oauth_token", valid_580060
  var valid_580061 = query.getOrDefault("callback")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "callback", valid_580061
  var valid_580062 = query.getOrDefault("access_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "access_token", valid_580062
  var valid_580063 = query.getOrDefault("uploadType")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "uploadType", valid_580063
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
  var valid_580065 = query.getOrDefault("$.xgafv")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = newJString("1"))
  if valid_580065 != nil:
    section.add "$.xgafv", valid_580065
  var valid_580066 = query.getOrDefault("prettyPrint")
  valid_580066 = validateParameter(valid_580066, JBool, required = false,
                                 default = newJBool(true))
  if valid_580066 != nil:
    section.add "prettyPrint", valid_580066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580067: Call_YoutubeAnalyticsGroupsDelete_580051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a group.
  ## 
  let valid = call_580067.validator(path, query, header, formData, body)
  let scheme = call_580067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580067.url(scheme.get, call_580067.host, call_580067.base,
                         call_580067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580067, url, valid)

proc call*(call_580068: Call_YoutubeAnalyticsGroupsDelete_580051;
          onBehalfOfContentOwner: string = ""; uploadProtocol: string = "";
          fields: string = ""; quotaUser: string = ""; id: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## youtubeAnalyticsGroupsDelete
  ## Deletes a group.
  ##   onBehalfOfContentOwner: string
  ##                         : This parameter can only be used in a properly authorized request. **Note:**
  ## This parameter is intended exclusively for YouTube content partners that
  ## own and manage many different YouTube channels.
  ## 
  ## The `onBehalfOfContentOwner` parameter indicates that the request's
  ## authorization credentials identify a YouTube user who is acting on behalf
  ## of the content owner specified in the parameter value. It allows content
  ## owners to authenticate once and get access to all their video and channel
  ## data, without having to provide authentication credentials for each
  ## individual channel. The account that the user authenticates with must be
  ## linked to the specified YouTube content owner.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: string
  ##     : The `id` parameter specifies the YouTube group ID of the group that is
  ## being deleted.
  ##   alt: string
  ##      : Data format for response.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580069 = newJObject()
  add(query_580069, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_580069, "upload_protocol", newJString(uploadProtocol))
  add(query_580069, "fields", newJString(fields))
  add(query_580069, "quotaUser", newJString(quotaUser))
  add(query_580069, "id", newJString(id))
  add(query_580069, "alt", newJString(alt))
  add(query_580069, "oauth_token", newJString(oauthToken))
  add(query_580069, "callback", newJString(callback))
  add(query_580069, "access_token", newJString(accessToken))
  add(query_580069, "uploadType", newJString(uploadType))
  add(query_580069, "key", newJString(key))
  add(query_580069, "$.xgafv", newJString(Xgafv))
  add(query_580069, "prettyPrint", newJBool(prettyPrint))
  result = call_580068.call(nil, query_580069, nil, nil, nil)

var youtubeAnalyticsGroupsDelete* = Call_YoutubeAnalyticsGroupsDelete_580051(
    name: "youtubeAnalyticsGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsDelete_580052, base: "/",
    url: url_YoutubeAnalyticsGroupsDelete_580053, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsReportsQuery_580070 = ref object of OpenApiRestCall_579408
proc url_YoutubeAnalyticsReportsQuery_580072(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsReportsQuery_580071(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve your YouTube Analytics reports.
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
  ##   endDate: JString
  ##          : The end date for fetching YouTube Analytics data. The value should be in
  ## `YYYY-MM-DD` format.
  ## required: true, pattern: [0-9]{4}-[0-9]{2}-[0-9]{2}
  ##   currency: JString
  ##           : The currency to which financial metrics should be converted. The default is
  ## US Dollar (USD). If the result contains no financial metrics, this flag
  ## will be ignored. Responds with an error if the specified currency is not
  ## recognized.",
  ## pattern: [A-Z]{3}
  ##   startDate: JString
  ##            : The start date for fetching YouTube Analytics data. The value should be in
  ## `YYYY-MM-DD` format.
  ## required: true, pattern: "[0-9]{4}-[0-9]{2}-[0-9]{2}
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort
  ## order for YouTube Analytics data. By default the sort order is ascending.
  ## The '`-`' prefix causes descending sort order.",
  ## pattern: [-0-9a-zA-Z,]+
  ##   metrics: JString
  ##          : A comma-separated list of YouTube Analytics metrics, such as `views` or
  ## `likes,dislikes`. See the
  ## [Available Reports](/youtube/analytics/v2/available_reports)  document for
  ## a list of the reports that you can retrieve and the metrics
  ## available in each report, and see the
  ## [Metrics](/youtube/analytics/v2/dimsmets/mets) document for definitions of
  ## those metrics.
  ## required: true, pattern: [0-9a-zA-Z,]+
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   maxResults: JInt
  ##             : The maximum number of rows to include in the response.",
  ## minValue: 1
  ##   dimensions: JString
  ##             : A comma-separated list of YouTube Analytics dimensions, such as `views` or
  ## `ageGroup,gender`. See the [Available
  ## Reports](/youtube/analytics/v2/available_reports) document for a list of
  ## the reports that you can retrieve and the dimensions used for those
  ## reports. Also see the [Dimensions](/youtube/analytics/v2/dimsmets/dims)
  ## document for definitions of those dimensions."
  ## pattern: [0-9a-zA-Z,]+
  ##   ids: JString
  ##      : Identifies the YouTube channel or content owner for which you are
  ## retrieving YouTube Analytics data.
  ## 
  ## - To request data for a YouTube user, set the `ids` parameter value to
  ##   `channel==CHANNEL_ID`, where `CHANNEL_ID` specifies the unique YouTube
  ##   channel ID.
  ## - To request data for a YouTube CMS content owner, set the `ids` parameter
  ##   value to `contentOwner==OWNER_NAME`, where `OWNER_NAME` is the CMS name
  ##   of the content owner.
  ## required: true, pattern: [a-zA-Z]+==[a-zA-Z0-9_+-]+
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeHistoricalChannelData: JBool
  ##                               : If set to true historical data (i.e. channel data from before the linking
  ## of the channel to the content owner) will be retrieved.",
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   filters: JString
  ##          : A list of filters that should be applied when retrieving YouTube Analytics
  ## data. The [Available Reports](/youtube/analytics/v2/available_reports)
  ## document identifies the dimensions that can be used to filter each report,
  ## and the [Dimensions](/youtube/analytics/v2/dimsmets/dims)  document defines
  ## those dimensions. If a request uses multiple filters, join them together
  ## with a semicolon (`;`), and the returned result table will satisfy both
  ## filters. For example, a filters parameter value of
  ## `video==dMH0bHeiRNg;country==IT` restricts the result set to include data
  ## for the given video in Italy.",
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  ##             : An index of the first entity to retrieve. Use this parameter as a
  ## pagination mechanism along with the max-results parameter (one-based,
  ## inclusive).",
  ## minValue: 1
  section = newJObject()
  var valid_580073 = query.getOrDefault("upload_protocol")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "upload_protocol", valid_580073
  var valid_580074 = query.getOrDefault("fields")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "fields", valid_580074
  var valid_580075 = query.getOrDefault("quotaUser")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "quotaUser", valid_580075
  var valid_580076 = query.getOrDefault("alt")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("json"))
  if valid_580076 != nil:
    section.add "alt", valid_580076
  var valid_580077 = query.getOrDefault("endDate")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "endDate", valid_580077
  var valid_580078 = query.getOrDefault("currency")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "currency", valid_580078
  var valid_580079 = query.getOrDefault("startDate")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "startDate", valid_580079
  var valid_580080 = query.getOrDefault("sort")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "sort", valid_580080
  var valid_580081 = query.getOrDefault("metrics")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "metrics", valid_580081
  var valid_580082 = query.getOrDefault("oauth_token")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "oauth_token", valid_580082
  var valid_580083 = query.getOrDefault("callback")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "callback", valid_580083
  var valid_580084 = query.getOrDefault("access_token")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "access_token", valid_580084
  var valid_580085 = query.getOrDefault("uploadType")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "uploadType", valid_580085
  var valid_580086 = query.getOrDefault("maxResults")
  valid_580086 = validateParameter(valid_580086, JInt, required = false, default = nil)
  if valid_580086 != nil:
    section.add "maxResults", valid_580086
  var valid_580087 = query.getOrDefault("dimensions")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "dimensions", valid_580087
  var valid_580088 = query.getOrDefault("ids")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "ids", valid_580088
  var valid_580089 = query.getOrDefault("key")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "key", valid_580089
  var valid_580090 = query.getOrDefault("includeHistoricalChannelData")
  valid_580090 = validateParameter(valid_580090, JBool, required = false, default = nil)
  if valid_580090 != nil:
    section.add "includeHistoricalChannelData", valid_580090
  var valid_580091 = query.getOrDefault("$.xgafv")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = newJString("1"))
  if valid_580091 != nil:
    section.add "$.xgafv", valid_580091
  var valid_580092 = query.getOrDefault("filters")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "filters", valid_580092
  var valid_580093 = query.getOrDefault("prettyPrint")
  valid_580093 = validateParameter(valid_580093, JBool, required = false,
                                 default = newJBool(true))
  if valid_580093 != nil:
    section.add "prettyPrint", valid_580093
  var valid_580094 = query.getOrDefault("startIndex")
  valid_580094 = validateParameter(valid_580094, JInt, required = false, default = nil)
  if valid_580094 != nil:
    section.add "startIndex", valid_580094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580095: Call_YoutubeAnalyticsReportsQuery_580070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve your YouTube Analytics reports.
  ## 
  let valid = call_580095.validator(path, query, header, formData, body)
  let scheme = call_580095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580095.url(scheme.get, call_580095.host, call_580095.base,
                         call_580095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580095, url, valid)

proc call*(call_580096: Call_YoutubeAnalyticsReportsQuery_580070;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; endDate: string = ""; currency: string = "";
          startDate: string = ""; sort: string = ""; metrics: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; maxResults: int = 0; dimensions: string = "";
          ids: string = ""; key: string = "";
          includeHistoricalChannelData: bool = false; Xgafv: string = "1";
          filters: string = ""; prettyPrint: bool = true; startIndex: int = 0): Recallable =
  ## youtubeAnalyticsReportsQuery
  ## Retrieve your YouTube Analytics reports.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   endDate: string
  ##          : The end date for fetching YouTube Analytics data. The value should be in
  ## `YYYY-MM-DD` format.
  ## required: true, pattern: [0-9]{4}-[0-9]{2}-[0-9]{2}
  ##   currency: string
  ##           : The currency to which financial metrics should be converted. The default is
  ## US Dollar (USD). If the result contains no financial metrics, this flag
  ## will be ignored. Responds with an error if the specified currency is not
  ## recognized.",
  ## pattern: [A-Z]{3}
  ##   startDate: string
  ##            : The start date for fetching YouTube Analytics data. The value should be in
  ## `YYYY-MM-DD` format.
  ## required: true, pattern: "[0-9]{4}-[0-9]{2}-[0-9]{2}
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort
  ## order for YouTube Analytics data. By default the sort order is ascending.
  ## The '`-`' prefix causes descending sort order.",
  ## pattern: [-0-9a-zA-Z,]+
  ##   metrics: string
  ##          : A comma-separated list of YouTube Analytics metrics, such as `views` or
  ## `likes,dislikes`. See the
  ## [Available Reports](/youtube/analytics/v2/available_reports)  document for
  ## a list of the reports that you can retrieve and the metrics
  ## available in each report, and see the
  ## [Metrics](/youtube/analytics/v2/dimsmets/mets) document for definitions of
  ## those metrics.
  ## required: true, pattern: [0-9a-zA-Z,]+
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   maxResults: int
  ##             : The maximum number of rows to include in the response.",
  ## minValue: 1
  ##   dimensions: string
  ##             : A comma-separated list of YouTube Analytics dimensions, such as `views` or
  ## `ageGroup,gender`. See the [Available
  ## Reports](/youtube/analytics/v2/available_reports) document for a list of
  ## the reports that you can retrieve and the dimensions used for those
  ## reports. Also see the [Dimensions](/youtube/analytics/v2/dimsmets/dims)
  ## document for definitions of those dimensions."
  ## pattern: [0-9a-zA-Z,]+
  ##   ids: string
  ##      : Identifies the YouTube channel or content owner for which you are
  ## retrieving YouTube Analytics data.
  ## 
  ## - To request data for a YouTube user, set the `ids` parameter value to
  ##   `channel==CHANNEL_ID`, where `CHANNEL_ID` specifies the unique YouTube
  ##   channel ID.
  ## - To request data for a YouTube CMS content owner, set the `ids` parameter
  ##   value to `contentOwner==OWNER_NAME`, where `OWNER_NAME` is the CMS name
  ##   of the content owner.
  ## required: true, pattern: [a-zA-Z]+==[a-zA-Z0-9_+-]+
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   includeHistoricalChannelData: bool
  ##                               : If set to true historical data (i.e. channel data from before the linking
  ## of the channel to the content owner) will be retrieved.",
  ##   Xgafv: string
  ##        : V1 error format.
  ##   filters: string
  ##          : A list of filters that should be applied when retrieving YouTube Analytics
  ## data. The [Available Reports](/youtube/analytics/v2/available_reports)
  ## document identifies the dimensions that can be used to filter each report,
  ## and the [Dimensions](/youtube/analytics/v2/dimsmets/dims)  document defines
  ## those dimensions. If a request uses multiple filters, join them together
  ## with a semicolon (`;`), and the returned result table will satisfy both
  ## filters. For example, a filters parameter value of
  ## `video==dMH0bHeiRNg;country==IT` restricts the result set to include data
  ## for the given video in Italy.",
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a
  ## pagination mechanism along with the max-results parameter (one-based,
  ## inclusive).",
  ## minValue: 1
  var query_580097 = newJObject()
  add(query_580097, "upload_protocol", newJString(uploadProtocol))
  add(query_580097, "fields", newJString(fields))
  add(query_580097, "quotaUser", newJString(quotaUser))
  add(query_580097, "alt", newJString(alt))
  add(query_580097, "endDate", newJString(endDate))
  add(query_580097, "currency", newJString(currency))
  add(query_580097, "startDate", newJString(startDate))
  add(query_580097, "sort", newJString(sort))
  add(query_580097, "metrics", newJString(metrics))
  add(query_580097, "oauth_token", newJString(oauthToken))
  add(query_580097, "callback", newJString(callback))
  add(query_580097, "access_token", newJString(accessToken))
  add(query_580097, "uploadType", newJString(uploadType))
  add(query_580097, "maxResults", newJInt(maxResults))
  add(query_580097, "dimensions", newJString(dimensions))
  add(query_580097, "ids", newJString(ids))
  add(query_580097, "key", newJString(key))
  add(query_580097, "includeHistoricalChannelData",
      newJBool(includeHistoricalChannelData))
  add(query_580097, "$.xgafv", newJString(Xgafv))
  add(query_580097, "filters", newJString(filters))
  add(query_580097, "prettyPrint", newJBool(prettyPrint))
  add(query_580097, "startIndex", newJInt(startIndex))
  result = call_580096.call(nil, query_580097, nil, nil, nil)

var youtubeAnalyticsReportsQuery* = Call_YoutubeAnalyticsReportsQuery_580070(
    name: "youtubeAnalyticsReportsQuery", meth: HttpMethod.HttpGet,
    host: "youtubeanalytics.googleapis.com", route: "/v2/reports",
    validator: validate_YoutubeAnalyticsReportsQuery_580071, base: "/",
    url: url_YoutubeAnalyticsReportsQuery_580072, schemes: {Scheme.Https})
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
