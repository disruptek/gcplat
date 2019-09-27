
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_YoutubeAnalyticsGroupItemsInsert_593951 = ref object of OpenApiRestCall_593408
proc url_YoutubeAnalyticsGroupItemsInsert_593953(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsInsert_593952(path: JsonNode;
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
  var valid_593954 = query.getOrDefault("onBehalfOfContentOwner")
  valid_593954 = validateParameter(valid_593954, JString, required = false,
                                 default = nil)
  if valid_593954 != nil:
    section.add "onBehalfOfContentOwner", valid_593954
  var valid_593955 = query.getOrDefault("upload_protocol")
  valid_593955 = validateParameter(valid_593955, JString, required = false,
                                 default = nil)
  if valid_593955 != nil:
    section.add "upload_protocol", valid_593955
  var valid_593956 = query.getOrDefault("fields")
  valid_593956 = validateParameter(valid_593956, JString, required = false,
                                 default = nil)
  if valid_593956 != nil:
    section.add "fields", valid_593956
  var valid_593957 = query.getOrDefault("quotaUser")
  valid_593957 = validateParameter(valid_593957, JString, required = false,
                                 default = nil)
  if valid_593957 != nil:
    section.add "quotaUser", valid_593957
  var valid_593958 = query.getOrDefault("alt")
  valid_593958 = validateParameter(valid_593958, JString, required = false,
                                 default = newJString("json"))
  if valid_593958 != nil:
    section.add "alt", valid_593958
  var valid_593959 = query.getOrDefault("oauth_token")
  valid_593959 = validateParameter(valid_593959, JString, required = false,
                                 default = nil)
  if valid_593959 != nil:
    section.add "oauth_token", valid_593959
  var valid_593960 = query.getOrDefault("callback")
  valid_593960 = validateParameter(valid_593960, JString, required = false,
                                 default = nil)
  if valid_593960 != nil:
    section.add "callback", valid_593960
  var valid_593961 = query.getOrDefault("access_token")
  valid_593961 = validateParameter(valid_593961, JString, required = false,
                                 default = nil)
  if valid_593961 != nil:
    section.add "access_token", valid_593961
  var valid_593962 = query.getOrDefault("uploadType")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "uploadType", valid_593962
  var valid_593963 = query.getOrDefault("key")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "key", valid_593963
  var valid_593964 = query.getOrDefault("$.xgafv")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = newJString("1"))
  if valid_593964 != nil:
    section.add "$.xgafv", valid_593964
  var valid_593965 = query.getOrDefault("prettyPrint")
  valid_593965 = validateParameter(valid_593965, JBool, required = false,
                                 default = newJBool(true))
  if valid_593965 != nil:
    section.add "prettyPrint", valid_593965
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

proc call*(call_593967: Call_YoutubeAnalyticsGroupItemsInsert_593951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a group item.
  ## 
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_YoutubeAnalyticsGroupItemsInsert_593951;
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
  var query_593969 = newJObject()
  var body_593970 = newJObject()
  add(query_593969, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_593969, "upload_protocol", newJString(uploadProtocol))
  add(query_593969, "fields", newJString(fields))
  add(query_593969, "quotaUser", newJString(quotaUser))
  add(query_593969, "alt", newJString(alt))
  add(query_593969, "oauth_token", newJString(oauthToken))
  add(query_593969, "callback", newJString(callback))
  add(query_593969, "access_token", newJString(accessToken))
  add(query_593969, "uploadType", newJString(uploadType))
  add(query_593969, "key", newJString(key))
  add(query_593969, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593970 = body
  add(query_593969, "prettyPrint", newJBool(prettyPrint))
  result = call_593968.call(nil, query_593969, nil, nil, body_593970)

var youtubeAnalyticsGroupItemsInsert* = Call_YoutubeAnalyticsGroupItemsInsert_593951(
    name: "youtubeAnalyticsGroupItemsInsert", meth: HttpMethod.HttpPost,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsInsert_593952, base: "/",
    url: url_YoutubeAnalyticsGroupItemsInsert_593953, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupItemsList_593677 = ref object of OpenApiRestCall_593408
proc url_YoutubeAnalyticsGroupItemsList_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsList_593678(path: JsonNode;
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
  var valid_593791 = query.getOrDefault("onBehalfOfContentOwner")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "onBehalfOfContentOwner", valid_593791
  var valid_593792 = query.getOrDefault("upload_protocol")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "upload_protocol", valid_593792
  var valid_593793 = query.getOrDefault("fields")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "fields", valid_593793
  var valid_593794 = query.getOrDefault("quotaUser")
  valid_593794 = validateParameter(valid_593794, JString, required = false,
                                 default = nil)
  if valid_593794 != nil:
    section.add "quotaUser", valid_593794
  var valid_593808 = query.getOrDefault("alt")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = newJString("json"))
  if valid_593808 != nil:
    section.add "alt", valid_593808
  var valid_593809 = query.getOrDefault("oauth_token")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "oauth_token", valid_593809
  var valid_593810 = query.getOrDefault("callback")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "callback", valid_593810
  var valid_593811 = query.getOrDefault("access_token")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "access_token", valid_593811
  var valid_593812 = query.getOrDefault("uploadType")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "uploadType", valid_593812
  var valid_593813 = query.getOrDefault("groupId")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "groupId", valid_593813
  var valid_593814 = query.getOrDefault("key")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "key", valid_593814
  var valid_593815 = query.getOrDefault("$.xgafv")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = newJString("1"))
  if valid_593815 != nil:
    section.add "$.xgafv", valid_593815
  var valid_593816 = query.getOrDefault("prettyPrint")
  valid_593816 = validateParameter(valid_593816, JBool, required = false,
                                 default = newJBool(true))
  if valid_593816 != nil:
    section.add "prettyPrint", valid_593816
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593839: Call_YoutubeAnalyticsGroupItemsList_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of group items that match the API request parameters.
  ## 
  let valid = call_593839.validator(path, query, header, formData, body)
  let scheme = call_593839.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593839.url(scheme.get, call_593839.host, call_593839.base,
                         call_593839.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593839, url, valid)

proc call*(call_593910: Call_YoutubeAnalyticsGroupItemsList_593677;
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
  var query_593911 = newJObject()
  add(query_593911, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_593911, "upload_protocol", newJString(uploadProtocol))
  add(query_593911, "fields", newJString(fields))
  add(query_593911, "quotaUser", newJString(quotaUser))
  add(query_593911, "alt", newJString(alt))
  add(query_593911, "oauth_token", newJString(oauthToken))
  add(query_593911, "callback", newJString(callback))
  add(query_593911, "access_token", newJString(accessToken))
  add(query_593911, "uploadType", newJString(uploadType))
  add(query_593911, "groupId", newJString(groupId))
  add(query_593911, "key", newJString(key))
  add(query_593911, "$.xgafv", newJString(Xgafv))
  add(query_593911, "prettyPrint", newJBool(prettyPrint))
  result = call_593910.call(nil, query_593911, nil, nil, nil)

var youtubeAnalyticsGroupItemsList* = Call_YoutubeAnalyticsGroupItemsList_593677(
    name: "youtubeAnalyticsGroupItemsList", meth: HttpMethod.HttpGet,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsList_593678, base: "/",
    url: url_YoutubeAnalyticsGroupItemsList_593679, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupItemsDelete_593971 = ref object of OpenApiRestCall_593408
proc url_YoutubeAnalyticsGroupItemsDelete_593973(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsDelete_593972(path: JsonNode;
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
  var valid_593974 = query.getOrDefault("onBehalfOfContentOwner")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "onBehalfOfContentOwner", valid_593974
  var valid_593975 = query.getOrDefault("upload_protocol")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "upload_protocol", valid_593975
  var valid_593976 = query.getOrDefault("fields")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "fields", valid_593976
  var valid_593977 = query.getOrDefault("quotaUser")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "quotaUser", valid_593977
  var valid_593978 = query.getOrDefault("id")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "id", valid_593978
  var valid_593979 = query.getOrDefault("alt")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = newJString("json"))
  if valid_593979 != nil:
    section.add "alt", valid_593979
  var valid_593980 = query.getOrDefault("oauth_token")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "oauth_token", valid_593980
  var valid_593981 = query.getOrDefault("callback")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "callback", valid_593981
  var valid_593982 = query.getOrDefault("access_token")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "access_token", valid_593982
  var valid_593983 = query.getOrDefault("uploadType")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "uploadType", valid_593983
  var valid_593984 = query.getOrDefault("key")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "key", valid_593984
  var valid_593985 = query.getOrDefault("$.xgafv")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("1"))
  if valid_593985 != nil:
    section.add "$.xgafv", valid_593985
  var valid_593986 = query.getOrDefault("prettyPrint")
  valid_593986 = validateParameter(valid_593986, JBool, required = false,
                                 default = newJBool(true))
  if valid_593986 != nil:
    section.add "prettyPrint", valid_593986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593987: Call_YoutubeAnalyticsGroupItemsDelete_593971;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes an item from a group.
  ## 
  let valid = call_593987.validator(path, query, header, formData, body)
  let scheme = call_593987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593987.url(scheme.get, call_593987.host, call_593987.base,
                         call_593987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593987, url, valid)

proc call*(call_593988: Call_YoutubeAnalyticsGroupItemsDelete_593971;
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
  var query_593989 = newJObject()
  add(query_593989, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_593989, "upload_protocol", newJString(uploadProtocol))
  add(query_593989, "fields", newJString(fields))
  add(query_593989, "quotaUser", newJString(quotaUser))
  add(query_593989, "id", newJString(id))
  add(query_593989, "alt", newJString(alt))
  add(query_593989, "oauth_token", newJString(oauthToken))
  add(query_593989, "callback", newJString(callback))
  add(query_593989, "access_token", newJString(accessToken))
  add(query_593989, "uploadType", newJString(uploadType))
  add(query_593989, "key", newJString(key))
  add(query_593989, "$.xgafv", newJString(Xgafv))
  add(query_593989, "prettyPrint", newJBool(prettyPrint))
  result = call_593988.call(nil, query_593989, nil, nil, nil)

var youtubeAnalyticsGroupItemsDelete* = Call_YoutubeAnalyticsGroupItemsDelete_593971(
    name: "youtubeAnalyticsGroupItemsDelete", meth: HttpMethod.HttpDelete,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsDelete_593972, base: "/",
    url: url_YoutubeAnalyticsGroupItemsDelete_593973, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsUpdate_594011 = ref object of OpenApiRestCall_593408
proc url_YoutubeAnalyticsGroupsUpdate_594013(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsUpdate_594012(path: JsonNode; query: JsonNode;
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
  var valid_594014 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "onBehalfOfContentOwner", valid_594014
  var valid_594015 = query.getOrDefault("upload_protocol")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "upload_protocol", valid_594015
  var valid_594016 = query.getOrDefault("fields")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "fields", valid_594016
  var valid_594017 = query.getOrDefault("quotaUser")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "quotaUser", valid_594017
  var valid_594018 = query.getOrDefault("alt")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = newJString("json"))
  if valid_594018 != nil:
    section.add "alt", valid_594018
  var valid_594019 = query.getOrDefault("oauth_token")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "oauth_token", valid_594019
  var valid_594020 = query.getOrDefault("callback")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "callback", valid_594020
  var valid_594021 = query.getOrDefault("access_token")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "access_token", valid_594021
  var valid_594022 = query.getOrDefault("uploadType")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "uploadType", valid_594022
  var valid_594023 = query.getOrDefault("key")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "key", valid_594023
  var valid_594024 = query.getOrDefault("$.xgafv")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = newJString("1"))
  if valid_594024 != nil:
    section.add "$.xgafv", valid_594024
  var valid_594025 = query.getOrDefault("prettyPrint")
  valid_594025 = validateParameter(valid_594025, JBool, required = false,
                                 default = newJBool(true))
  if valid_594025 != nil:
    section.add "prettyPrint", valid_594025
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

proc call*(call_594027: Call_YoutubeAnalyticsGroupsUpdate_594011; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a group. For example, you could change a group's title.
  ## 
  let valid = call_594027.validator(path, query, header, formData, body)
  let scheme = call_594027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594027.url(scheme.get, call_594027.host, call_594027.base,
                         call_594027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594027, url, valid)

proc call*(call_594028: Call_YoutubeAnalyticsGroupsUpdate_594011;
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
  var query_594029 = newJObject()
  var body_594030 = newJObject()
  add(query_594029, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594029, "upload_protocol", newJString(uploadProtocol))
  add(query_594029, "fields", newJString(fields))
  add(query_594029, "quotaUser", newJString(quotaUser))
  add(query_594029, "alt", newJString(alt))
  add(query_594029, "oauth_token", newJString(oauthToken))
  add(query_594029, "callback", newJString(callback))
  add(query_594029, "access_token", newJString(accessToken))
  add(query_594029, "uploadType", newJString(uploadType))
  add(query_594029, "key", newJString(key))
  add(query_594029, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594030 = body
  add(query_594029, "prettyPrint", newJBool(prettyPrint))
  result = call_594028.call(nil, query_594029, nil, nil, body_594030)

var youtubeAnalyticsGroupsUpdate* = Call_YoutubeAnalyticsGroupsUpdate_594011(
    name: "youtubeAnalyticsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsUpdate_594012, base: "/",
    url: url_YoutubeAnalyticsGroupsUpdate_594013, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsInsert_594031 = ref object of OpenApiRestCall_593408
proc url_YoutubeAnalyticsGroupsInsert_594033(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsInsert_594032(path: JsonNode; query: JsonNode;
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
  var valid_594034 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "onBehalfOfContentOwner", valid_594034
  var valid_594035 = query.getOrDefault("upload_protocol")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "upload_protocol", valid_594035
  var valid_594036 = query.getOrDefault("fields")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "fields", valid_594036
  var valid_594037 = query.getOrDefault("quotaUser")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "quotaUser", valid_594037
  var valid_594038 = query.getOrDefault("alt")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = newJString("json"))
  if valid_594038 != nil:
    section.add "alt", valid_594038
  var valid_594039 = query.getOrDefault("oauth_token")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "oauth_token", valid_594039
  var valid_594040 = query.getOrDefault("callback")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "callback", valid_594040
  var valid_594041 = query.getOrDefault("access_token")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "access_token", valid_594041
  var valid_594042 = query.getOrDefault("uploadType")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "uploadType", valid_594042
  var valid_594043 = query.getOrDefault("key")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "key", valid_594043
  var valid_594044 = query.getOrDefault("$.xgafv")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = newJString("1"))
  if valid_594044 != nil:
    section.add "$.xgafv", valid_594044
  var valid_594045 = query.getOrDefault("prettyPrint")
  valid_594045 = validateParameter(valid_594045, JBool, required = false,
                                 default = newJBool(true))
  if valid_594045 != nil:
    section.add "prettyPrint", valid_594045
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

proc call*(call_594047: Call_YoutubeAnalyticsGroupsInsert_594031; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a group.
  ## 
  let valid = call_594047.validator(path, query, header, formData, body)
  let scheme = call_594047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594047.url(scheme.get, call_594047.host, call_594047.base,
                         call_594047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594047, url, valid)

proc call*(call_594048: Call_YoutubeAnalyticsGroupsInsert_594031;
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
  var query_594049 = newJObject()
  var body_594050 = newJObject()
  add(query_594049, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594049, "upload_protocol", newJString(uploadProtocol))
  add(query_594049, "fields", newJString(fields))
  add(query_594049, "quotaUser", newJString(quotaUser))
  add(query_594049, "alt", newJString(alt))
  add(query_594049, "oauth_token", newJString(oauthToken))
  add(query_594049, "callback", newJString(callback))
  add(query_594049, "access_token", newJString(accessToken))
  add(query_594049, "uploadType", newJString(uploadType))
  add(query_594049, "key", newJString(key))
  add(query_594049, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594050 = body
  add(query_594049, "prettyPrint", newJBool(prettyPrint))
  result = call_594048.call(nil, query_594049, nil, nil, body_594050)

var youtubeAnalyticsGroupsInsert* = Call_YoutubeAnalyticsGroupsInsert_594031(
    name: "youtubeAnalyticsGroupsInsert", meth: HttpMethod.HttpPost,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsInsert_594032, base: "/",
    url: url_YoutubeAnalyticsGroupsInsert_594033, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsList_593990 = ref object of OpenApiRestCall_593408
proc url_YoutubeAnalyticsGroupsList_593992(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsList_593991(path: JsonNode; query: JsonNode;
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
  var valid_593993 = query.getOrDefault("onBehalfOfContentOwner")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "onBehalfOfContentOwner", valid_593993
  var valid_593994 = query.getOrDefault("mine")
  valid_593994 = validateParameter(valid_593994, JBool, required = false, default = nil)
  if valid_593994 != nil:
    section.add "mine", valid_593994
  var valid_593995 = query.getOrDefault("upload_protocol")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "upload_protocol", valid_593995
  var valid_593996 = query.getOrDefault("fields")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "fields", valid_593996
  var valid_593997 = query.getOrDefault("pageToken")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "pageToken", valid_593997
  var valid_593998 = query.getOrDefault("quotaUser")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "quotaUser", valid_593998
  var valid_593999 = query.getOrDefault("id")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "id", valid_593999
  var valid_594000 = query.getOrDefault("alt")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = newJString("json"))
  if valid_594000 != nil:
    section.add "alt", valid_594000
  var valid_594001 = query.getOrDefault("oauth_token")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "oauth_token", valid_594001
  var valid_594002 = query.getOrDefault("callback")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "callback", valid_594002
  var valid_594003 = query.getOrDefault("access_token")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "access_token", valid_594003
  var valid_594004 = query.getOrDefault("uploadType")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "uploadType", valid_594004
  var valid_594005 = query.getOrDefault("key")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "key", valid_594005
  var valid_594006 = query.getOrDefault("$.xgafv")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = newJString("1"))
  if valid_594006 != nil:
    section.add "$.xgafv", valid_594006
  var valid_594007 = query.getOrDefault("prettyPrint")
  valid_594007 = validateParameter(valid_594007, JBool, required = false,
                                 default = newJBool(true))
  if valid_594007 != nil:
    section.add "prettyPrint", valid_594007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594008: Call_YoutubeAnalyticsGroupsList_593990; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of groups that match the API request parameters. For
  ## example, you can retrieve all groups that the authenticated user owns,
  ## or you can retrieve one or more groups by their unique IDs.
  ## 
  let valid = call_594008.validator(path, query, header, formData, body)
  let scheme = call_594008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594008.url(scheme.get, call_594008.host, call_594008.base,
                         call_594008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594008, url, valid)

proc call*(call_594009: Call_YoutubeAnalyticsGroupsList_593990;
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
  var query_594010 = newJObject()
  add(query_594010, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594010, "mine", newJBool(mine))
  add(query_594010, "upload_protocol", newJString(uploadProtocol))
  add(query_594010, "fields", newJString(fields))
  add(query_594010, "pageToken", newJString(pageToken))
  add(query_594010, "quotaUser", newJString(quotaUser))
  add(query_594010, "id", newJString(id))
  add(query_594010, "alt", newJString(alt))
  add(query_594010, "oauth_token", newJString(oauthToken))
  add(query_594010, "callback", newJString(callback))
  add(query_594010, "access_token", newJString(accessToken))
  add(query_594010, "uploadType", newJString(uploadType))
  add(query_594010, "key", newJString(key))
  add(query_594010, "$.xgafv", newJString(Xgafv))
  add(query_594010, "prettyPrint", newJBool(prettyPrint))
  result = call_594009.call(nil, query_594010, nil, nil, nil)

var youtubeAnalyticsGroupsList* = Call_YoutubeAnalyticsGroupsList_593990(
    name: "youtubeAnalyticsGroupsList", meth: HttpMethod.HttpGet,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsList_593991, base: "/",
    url: url_YoutubeAnalyticsGroupsList_593992, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsDelete_594051 = ref object of OpenApiRestCall_593408
proc url_YoutubeAnalyticsGroupsDelete_594053(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsDelete_594052(path: JsonNode; query: JsonNode;
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
  var valid_594054 = query.getOrDefault("onBehalfOfContentOwner")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "onBehalfOfContentOwner", valid_594054
  var valid_594055 = query.getOrDefault("upload_protocol")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "upload_protocol", valid_594055
  var valid_594056 = query.getOrDefault("fields")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "fields", valid_594056
  var valid_594057 = query.getOrDefault("quotaUser")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "quotaUser", valid_594057
  var valid_594058 = query.getOrDefault("id")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "id", valid_594058
  var valid_594059 = query.getOrDefault("alt")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = newJString("json"))
  if valid_594059 != nil:
    section.add "alt", valid_594059
  var valid_594060 = query.getOrDefault("oauth_token")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "oauth_token", valid_594060
  var valid_594061 = query.getOrDefault("callback")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "callback", valid_594061
  var valid_594062 = query.getOrDefault("access_token")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "access_token", valid_594062
  var valid_594063 = query.getOrDefault("uploadType")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "uploadType", valid_594063
  var valid_594064 = query.getOrDefault("key")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "key", valid_594064
  var valid_594065 = query.getOrDefault("$.xgafv")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = newJString("1"))
  if valid_594065 != nil:
    section.add "$.xgafv", valid_594065
  var valid_594066 = query.getOrDefault("prettyPrint")
  valid_594066 = validateParameter(valid_594066, JBool, required = false,
                                 default = newJBool(true))
  if valid_594066 != nil:
    section.add "prettyPrint", valid_594066
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594067: Call_YoutubeAnalyticsGroupsDelete_594051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a group.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_YoutubeAnalyticsGroupsDelete_594051;
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
  var query_594069 = newJObject()
  add(query_594069, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_594069, "upload_protocol", newJString(uploadProtocol))
  add(query_594069, "fields", newJString(fields))
  add(query_594069, "quotaUser", newJString(quotaUser))
  add(query_594069, "id", newJString(id))
  add(query_594069, "alt", newJString(alt))
  add(query_594069, "oauth_token", newJString(oauthToken))
  add(query_594069, "callback", newJString(callback))
  add(query_594069, "access_token", newJString(accessToken))
  add(query_594069, "uploadType", newJString(uploadType))
  add(query_594069, "key", newJString(key))
  add(query_594069, "$.xgafv", newJString(Xgafv))
  add(query_594069, "prettyPrint", newJBool(prettyPrint))
  result = call_594068.call(nil, query_594069, nil, nil, nil)

var youtubeAnalyticsGroupsDelete* = Call_YoutubeAnalyticsGroupsDelete_594051(
    name: "youtubeAnalyticsGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsDelete_594052, base: "/",
    url: url_YoutubeAnalyticsGroupsDelete_594053, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsReportsQuery_594070 = ref object of OpenApiRestCall_593408
proc url_YoutubeAnalyticsReportsQuery_594072(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsReportsQuery_594071(path: JsonNode; query: JsonNode;
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
  var valid_594073 = query.getOrDefault("upload_protocol")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "upload_protocol", valid_594073
  var valid_594074 = query.getOrDefault("fields")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "fields", valid_594074
  var valid_594075 = query.getOrDefault("quotaUser")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "quotaUser", valid_594075
  var valid_594076 = query.getOrDefault("alt")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = newJString("json"))
  if valid_594076 != nil:
    section.add "alt", valid_594076
  var valid_594077 = query.getOrDefault("endDate")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "endDate", valid_594077
  var valid_594078 = query.getOrDefault("currency")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "currency", valid_594078
  var valid_594079 = query.getOrDefault("startDate")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "startDate", valid_594079
  var valid_594080 = query.getOrDefault("sort")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "sort", valid_594080
  var valid_594081 = query.getOrDefault("metrics")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "metrics", valid_594081
  var valid_594082 = query.getOrDefault("oauth_token")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = nil)
  if valid_594082 != nil:
    section.add "oauth_token", valid_594082
  var valid_594083 = query.getOrDefault("callback")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "callback", valid_594083
  var valid_594084 = query.getOrDefault("access_token")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "access_token", valid_594084
  var valid_594085 = query.getOrDefault("uploadType")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "uploadType", valid_594085
  var valid_594086 = query.getOrDefault("maxResults")
  valid_594086 = validateParameter(valid_594086, JInt, required = false, default = nil)
  if valid_594086 != nil:
    section.add "maxResults", valid_594086
  var valid_594087 = query.getOrDefault("dimensions")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "dimensions", valid_594087
  var valid_594088 = query.getOrDefault("ids")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "ids", valid_594088
  var valid_594089 = query.getOrDefault("key")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "key", valid_594089
  var valid_594090 = query.getOrDefault("includeHistoricalChannelData")
  valid_594090 = validateParameter(valid_594090, JBool, required = false, default = nil)
  if valid_594090 != nil:
    section.add "includeHistoricalChannelData", valid_594090
  var valid_594091 = query.getOrDefault("$.xgafv")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = newJString("1"))
  if valid_594091 != nil:
    section.add "$.xgafv", valid_594091
  var valid_594092 = query.getOrDefault("filters")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "filters", valid_594092
  var valid_594093 = query.getOrDefault("prettyPrint")
  valid_594093 = validateParameter(valid_594093, JBool, required = false,
                                 default = newJBool(true))
  if valid_594093 != nil:
    section.add "prettyPrint", valid_594093
  var valid_594094 = query.getOrDefault("startIndex")
  valid_594094 = validateParameter(valid_594094, JInt, required = false, default = nil)
  if valid_594094 != nil:
    section.add "startIndex", valid_594094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594095: Call_YoutubeAnalyticsReportsQuery_594070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve your YouTube Analytics reports.
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_YoutubeAnalyticsReportsQuery_594070;
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
  var query_594097 = newJObject()
  add(query_594097, "upload_protocol", newJString(uploadProtocol))
  add(query_594097, "fields", newJString(fields))
  add(query_594097, "quotaUser", newJString(quotaUser))
  add(query_594097, "alt", newJString(alt))
  add(query_594097, "endDate", newJString(endDate))
  add(query_594097, "currency", newJString(currency))
  add(query_594097, "startDate", newJString(startDate))
  add(query_594097, "sort", newJString(sort))
  add(query_594097, "metrics", newJString(metrics))
  add(query_594097, "oauth_token", newJString(oauthToken))
  add(query_594097, "callback", newJString(callback))
  add(query_594097, "access_token", newJString(accessToken))
  add(query_594097, "uploadType", newJString(uploadType))
  add(query_594097, "maxResults", newJInt(maxResults))
  add(query_594097, "dimensions", newJString(dimensions))
  add(query_594097, "ids", newJString(ids))
  add(query_594097, "key", newJString(key))
  add(query_594097, "includeHistoricalChannelData",
      newJBool(includeHistoricalChannelData))
  add(query_594097, "$.xgafv", newJString(Xgafv))
  add(query_594097, "filters", newJString(filters))
  add(query_594097, "prettyPrint", newJBool(prettyPrint))
  add(query_594097, "startIndex", newJInt(startIndex))
  result = call_594096.call(nil, query_594097, nil, nil, nil)

var youtubeAnalyticsReportsQuery* = Call_YoutubeAnalyticsReportsQuery_594070(
    name: "youtubeAnalyticsReportsQuery", meth: HttpMethod.HttpGet,
    host: "youtubeanalytics.googleapis.com", route: "/v2/reports",
    validator: validate_YoutubeAnalyticsReportsQuery_594071, base: "/",
    url: url_YoutubeAnalyticsReportsQuery_594072, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
