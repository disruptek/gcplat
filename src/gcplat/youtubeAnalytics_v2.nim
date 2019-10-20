
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "youtubeAnalytics"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_YoutubeAnalyticsGroupItemsInsert_578884 = ref object of OpenApiRestCall_578339
proc url_YoutubeAnalyticsGroupItemsInsert_578886(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsInsert_578885(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a group item.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
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
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578887 = query.getOrDefault("key")
  valid_578887 = validateParameter(valid_578887, JString, required = false,
                                 default = nil)
  if valid_578887 != nil:
    section.add "key", valid_578887
  var valid_578888 = query.getOrDefault("prettyPrint")
  valid_578888 = validateParameter(valid_578888, JBool, required = false,
                                 default = newJBool(true))
  if valid_578888 != nil:
    section.add "prettyPrint", valid_578888
  var valid_578889 = query.getOrDefault("oauth_token")
  valid_578889 = validateParameter(valid_578889, JString, required = false,
                                 default = nil)
  if valid_578889 != nil:
    section.add "oauth_token", valid_578889
  var valid_578890 = query.getOrDefault("$.xgafv")
  valid_578890 = validateParameter(valid_578890, JString, required = false,
                                 default = newJString("1"))
  if valid_578890 != nil:
    section.add "$.xgafv", valid_578890
  var valid_578891 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578891 = validateParameter(valid_578891, JString, required = false,
                                 default = nil)
  if valid_578891 != nil:
    section.add "onBehalfOfContentOwner", valid_578891
  var valid_578892 = query.getOrDefault("alt")
  valid_578892 = validateParameter(valid_578892, JString, required = false,
                                 default = newJString("json"))
  if valid_578892 != nil:
    section.add "alt", valid_578892
  var valid_578893 = query.getOrDefault("uploadType")
  valid_578893 = validateParameter(valid_578893, JString, required = false,
                                 default = nil)
  if valid_578893 != nil:
    section.add "uploadType", valid_578893
  var valid_578894 = query.getOrDefault("quotaUser")
  valid_578894 = validateParameter(valid_578894, JString, required = false,
                                 default = nil)
  if valid_578894 != nil:
    section.add "quotaUser", valid_578894
  var valid_578895 = query.getOrDefault("callback")
  valid_578895 = validateParameter(valid_578895, JString, required = false,
                                 default = nil)
  if valid_578895 != nil:
    section.add "callback", valid_578895
  var valid_578896 = query.getOrDefault("fields")
  valid_578896 = validateParameter(valid_578896, JString, required = false,
                                 default = nil)
  if valid_578896 != nil:
    section.add "fields", valid_578896
  var valid_578897 = query.getOrDefault("access_token")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "access_token", valid_578897
  var valid_578898 = query.getOrDefault("upload_protocol")
  valid_578898 = validateParameter(valid_578898, JString, required = false,
                                 default = nil)
  if valid_578898 != nil:
    section.add "upload_protocol", valid_578898
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

proc call*(call_578900: Call_YoutubeAnalyticsGroupItemsInsert_578884;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a group item.
  ## 
  let valid = call_578900.validator(path, query, header, formData, body)
  let scheme = call_578900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578900.url(scheme.get, call_578900.host, call_578900.base,
                         call_578900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578900, url, valid)

proc call*(call_578901: Call_YoutubeAnalyticsGroupItemsInsert_578884;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; onBehalfOfContentOwner: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## youtubeAnalyticsGroupItemsInsert
  ## Creates a group item.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578902 = newJObject()
  var body_578903 = newJObject()
  add(query_578902, "key", newJString(key))
  add(query_578902, "prettyPrint", newJBool(prettyPrint))
  add(query_578902, "oauth_token", newJString(oauthToken))
  add(query_578902, "$.xgafv", newJString(Xgafv))
  add(query_578902, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578902, "alt", newJString(alt))
  add(query_578902, "uploadType", newJString(uploadType))
  add(query_578902, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578903 = body
  add(query_578902, "callback", newJString(callback))
  add(query_578902, "fields", newJString(fields))
  add(query_578902, "access_token", newJString(accessToken))
  add(query_578902, "upload_protocol", newJString(uploadProtocol))
  result = call_578901.call(nil, query_578902, nil, nil, body_578903)

var youtubeAnalyticsGroupItemsInsert* = Call_YoutubeAnalyticsGroupItemsInsert_578884(
    name: "youtubeAnalyticsGroupItemsInsert", meth: HttpMethod.HttpPost,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsInsert_578885, base: "/",
    url: url_YoutubeAnalyticsGroupItemsInsert_578886, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupItemsList_578610 = ref object of OpenApiRestCall_578339
proc url_YoutubeAnalyticsGroupItemsList_578612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsList_578611(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a collection of group items that match the API request parameters.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
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
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   groupId: JString
  ##          : The `groupId` parameter specifies the unique ID of the group for which you
  ## want to retrieve group items.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578724 = query.getOrDefault("key")
  valid_578724 = validateParameter(valid_578724, JString, required = false,
                                 default = nil)
  if valid_578724 != nil:
    section.add "key", valid_578724
  var valid_578738 = query.getOrDefault("prettyPrint")
  valid_578738 = validateParameter(valid_578738, JBool, required = false,
                                 default = newJBool(true))
  if valid_578738 != nil:
    section.add "prettyPrint", valid_578738
  var valid_578739 = query.getOrDefault("oauth_token")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "oauth_token", valid_578739
  var valid_578740 = query.getOrDefault("$.xgafv")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = newJString("1"))
  if valid_578740 != nil:
    section.add "$.xgafv", valid_578740
  var valid_578741 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = nil)
  if valid_578741 != nil:
    section.add "onBehalfOfContentOwner", valid_578741
  var valid_578742 = query.getOrDefault("alt")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = newJString("json"))
  if valid_578742 != nil:
    section.add "alt", valid_578742
  var valid_578743 = query.getOrDefault("uploadType")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "uploadType", valid_578743
  var valid_578744 = query.getOrDefault("quotaUser")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "quotaUser", valid_578744
  var valid_578745 = query.getOrDefault("groupId")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "groupId", valid_578745
  var valid_578746 = query.getOrDefault("callback")
  valid_578746 = validateParameter(valid_578746, JString, required = false,
                                 default = nil)
  if valid_578746 != nil:
    section.add "callback", valid_578746
  var valid_578747 = query.getOrDefault("fields")
  valid_578747 = validateParameter(valid_578747, JString, required = false,
                                 default = nil)
  if valid_578747 != nil:
    section.add "fields", valid_578747
  var valid_578748 = query.getOrDefault("access_token")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "access_token", valid_578748
  var valid_578749 = query.getOrDefault("upload_protocol")
  valid_578749 = validateParameter(valid_578749, JString, required = false,
                                 default = nil)
  if valid_578749 != nil:
    section.add "upload_protocol", valid_578749
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578772: Call_YoutubeAnalyticsGroupItemsList_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of group items that match the API request parameters.
  ## 
  let valid = call_578772.validator(path, query, header, formData, body)
  let scheme = call_578772.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578772.url(scheme.get, call_578772.host, call_578772.base,
                         call_578772.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578772, url, valid)

proc call*(call_578843: Call_YoutubeAnalyticsGroupItemsList_578610;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; onBehalfOfContentOwner: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          groupId: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## youtubeAnalyticsGroupItemsList
  ## Returns a collection of group items that match the API request parameters.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   groupId: string
  ##          : The `groupId` parameter specifies the unique ID of the group for which you
  ## want to retrieve group items.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578844 = newJObject()
  add(query_578844, "key", newJString(key))
  add(query_578844, "prettyPrint", newJBool(prettyPrint))
  add(query_578844, "oauth_token", newJString(oauthToken))
  add(query_578844, "$.xgafv", newJString(Xgafv))
  add(query_578844, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578844, "alt", newJString(alt))
  add(query_578844, "uploadType", newJString(uploadType))
  add(query_578844, "quotaUser", newJString(quotaUser))
  add(query_578844, "groupId", newJString(groupId))
  add(query_578844, "callback", newJString(callback))
  add(query_578844, "fields", newJString(fields))
  add(query_578844, "access_token", newJString(accessToken))
  add(query_578844, "upload_protocol", newJString(uploadProtocol))
  result = call_578843.call(nil, query_578844, nil, nil, nil)

var youtubeAnalyticsGroupItemsList* = Call_YoutubeAnalyticsGroupItemsList_578610(
    name: "youtubeAnalyticsGroupItemsList", meth: HttpMethod.HttpGet,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsList_578611, base: "/",
    url: url_YoutubeAnalyticsGroupItemsList_578612, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupItemsDelete_578904 = ref object of OpenApiRestCall_578339
proc url_YoutubeAnalyticsGroupItemsDelete_578906(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupItemsDelete_578905(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes an item from a group.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
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
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: JString
  ##     : The `id` parameter specifies the YouTube group item ID of the group item
  ## that is being deleted.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578907 = query.getOrDefault("key")
  valid_578907 = validateParameter(valid_578907, JString, required = false,
                                 default = nil)
  if valid_578907 != nil:
    section.add "key", valid_578907
  var valid_578908 = query.getOrDefault("prettyPrint")
  valid_578908 = validateParameter(valid_578908, JBool, required = false,
                                 default = newJBool(true))
  if valid_578908 != nil:
    section.add "prettyPrint", valid_578908
  var valid_578909 = query.getOrDefault("oauth_token")
  valid_578909 = validateParameter(valid_578909, JString, required = false,
                                 default = nil)
  if valid_578909 != nil:
    section.add "oauth_token", valid_578909
  var valid_578910 = query.getOrDefault("$.xgafv")
  valid_578910 = validateParameter(valid_578910, JString, required = false,
                                 default = newJString("1"))
  if valid_578910 != nil:
    section.add "$.xgafv", valid_578910
  var valid_578911 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "onBehalfOfContentOwner", valid_578911
  var valid_578912 = query.getOrDefault("alt")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = newJString("json"))
  if valid_578912 != nil:
    section.add "alt", valid_578912
  var valid_578913 = query.getOrDefault("uploadType")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "uploadType", valid_578913
  var valid_578914 = query.getOrDefault("quotaUser")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "quotaUser", valid_578914
  var valid_578915 = query.getOrDefault("id")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "id", valid_578915
  var valid_578916 = query.getOrDefault("callback")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "callback", valid_578916
  var valid_578917 = query.getOrDefault("fields")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "fields", valid_578917
  var valid_578918 = query.getOrDefault("access_token")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "access_token", valid_578918
  var valid_578919 = query.getOrDefault("upload_protocol")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "upload_protocol", valid_578919
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578920: Call_YoutubeAnalyticsGroupItemsDelete_578904;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes an item from a group.
  ## 
  let valid = call_578920.validator(path, query, header, formData, body)
  let scheme = call_578920.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578920.url(scheme.get, call_578920.host, call_578920.base,
                         call_578920.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578920, url, valid)

proc call*(call_578921: Call_YoutubeAnalyticsGroupItemsDelete_578904;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; onBehalfOfContentOwner: string = "";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          id: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## youtubeAnalyticsGroupItemsDelete
  ## Removes an item from a group.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: string
  ##     : The `id` parameter specifies the YouTube group item ID of the group item
  ## that is being deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578922 = newJObject()
  add(query_578922, "key", newJString(key))
  add(query_578922, "prettyPrint", newJBool(prettyPrint))
  add(query_578922, "oauth_token", newJString(oauthToken))
  add(query_578922, "$.xgafv", newJString(Xgafv))
  add(query_578922, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578922, "alt", newJString(alt))
  add(query_578922, "uploadType", newJString(uploadType))
  add(query_578922, "quotaUser", newJString(quotaUser))
  add(query_578922, "id", newJString(id))
  add(query_578922, "callback", newJString(callback))
  add(query_578922, "fields", newJString(fields))
  add(query_578922, "access_token", newJString(accessToken))
  add(query_578922, "upload_protocol", newJString(uploadProtocol))
  result = call_578921.call(nil, query_578922, nil, nil, nil)

var youtubeAnalyticsGroupItemsDelete* = Call_YoutubeAnalyticsGroupItemsDelete_578904(
    name: "youtubeAnalyticsGroupItemsDelete", meth: HttpMethod.HttpDelete,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groupItems",
    validator: validate_YoutubeAnalyticsGroupItemsDelete_578905, base: "/",
    url: url_YoutubeAnalyticsGroupItemsDelete_578906, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsUpdate_578944 = ref object of OpenApiRestCall_578339
proc url_YoutubeAnalyticsGroupsUpdate_578946(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsUpdate_578945(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies a group. For example, you could change a group's title.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
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
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578947 = query.getOrDefault("key")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "key", valid_578947
  var valid_578948 = query.getOrDefault("prettyPrint")
  valid_578948 = validateParameter(valid_578948, JBool, required = false,
                                 default = newJBool(true))
  if valid_578948 != nil:
    section.add "prettyPrint", valid_578948
  var valid_578949 = query.getOrDefault("oauth_token")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = nil)
  if valid_578949 != nil:
    section.add "oauth_token", valid_578949
  var valid_578950 = query.getOrDefault("$.xgafv")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = newJString("1"))
  if valid_578950 != nil:
    section.add "$.xgafv", valid_578950
  var valid_578951 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "onBehalfOfContentOwner", valid_578951
  var valid_578952 = query.getOrDefault("alt")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = newJString("json"))
  if valid_578952 != nil:
    section.add "alt", valid_578952
  var valid_578953 = query.getOrDefault("uploadType")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "uploadType", valid_578953
  var valid_578954 = query.getOrDefault("quotaUser")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "quotaUser", valid_578954
  var valid_578955 = query.getOrDefault("callback")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "callback", valid_578955
  var valid_578956 = query.getOrDefault("fields")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = nil)
  if valid_578956 != nil:
    section.add "fields", valid_578956
  var valid_578957 = query.getOrDefault("access_token")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "access_token", valid_578957
  var valid_578958 = query.getOrDefault("upload_protocol")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "upload_protocol", valid_578958
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

proc call*(call_578960: Call_YoutubeAnalyticsGroupsUpdate_578944; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Modifies a group. For example, you could change a group's title.
  ## 
  let valid = call_578960.validator(path, query, header, formData, body)
  let scheme = call_578960.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578960.url(scheme.get, call_578960.host, call_578960.base,
                         call_578960.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578960, url, valid)

proc call*(call_578961: Call_YoutubeAnalyticsGroupsUpdate_578944; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## youtubeAnalyticsGroupsUpdate
  ## Modifies a group. For example, you could change a group's title.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578962 = newJObject()
  var body_578963 = newJObject()
  add(query_578962, "key", newJString(key))
  add(query_578962, "prettyPrint", newJBool(prettyPrint))
  add(query_578962, "oauth_token", newJString(oauthToken))
  add(query_578962, "$.xgafv", newJString(Xgafv))
  add(query_578962, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578962, "alt", newJString(alt))
  add(query_578962, "uploadType", newJString(uploadType))
  add(query_578962, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578963 = body
  add(query_578962, "callback", newJString(callback))
  add(query_578962, "fields", newJString(fields))
  add(query_578962, "access_token", newJString(accessToken))
  add(query_578962, "upload_protocol", newJString(uploadProtocol))
  result = call_578961.call(nil, query_578962, nil, nil, body_578963)

var youtubeAnalyticsGroupsUpdate* = Call_YoutubeAnalyticsGroupsUpdate_578944(
    name: "youtubeAnalyticsGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsUpdate_578945, base: "/",
    url: url_YoutubeAnalyticsGroupsUpdate_578946, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsInsert_578964 = ref object of OpenApiRestCall_578339
proc url_YoutubeAnalyticsGroupsInsert_578966(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsInsert_578965(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a group.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
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
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578967 = query.getOrDefault("key")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = nil)
  if valid_578967 != nil:
    section.add "key", valid_578967
  var valid_578968 = query.getOrDefault("prettyPrint")
  valid_578968 = validateParameter(valid_578968, JBool, required = false,
                                 default = newJBool(true))
  if valid_578968 != nil:
    section.add "prettyPrint", valid_578968
  var valid_578969 = query.getOrDefault("oauth_token")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "oauth_token", valid_578969
  var valid_578970 = query.getOrDefault("$.xgafv")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = newJString("1"))
  if valid_578970 != nil:
    section.add "$.xgafv", valid_578970
  var valid_578971 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "onBehalfOfContentOwner", valid_578971
  var valid_578972 = query.getOrDefault("alt")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = newJString("json"))
  if valid_578972 != nil:
    section.add "alt", valid_578972
  var valid_578973 = query.getOrDefault("uploadType")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "uploadType", valid_578973
  var valid_578974 = query.getOrDefault("quotaUser")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "quotaUser", valid_578974
  var valid_578975 = query.getOrDefault("callback")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "callback", valid_578975
  var valid_578976 = query.getOrDefault("fields")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "fields", valid_578976
  var valid_578977 = query.getOrDefault("access_token")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = nil)
  if valid_578977 != nil:
    section.add "access_token", valid_578977
  var valid_578978 = query.getOrDefault("upload_protocol")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "upload_protocol", valid_578978
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

proc call*(call_578980: Call_YoutubeAnalyticsGroupsInsert_578964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a group.
  ## 
  let valid = call_578980.validator(path, query, header, formData, body)
  let scheme = call_578980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578980.url(scheme.get, call_578980.host, call_578980.base,
                         call_578980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578980, url, valid)

proc call*(call_578981: Call_YoutubeAnalyticsGroupsInsert_578964; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## youtubeAnalyticsGroupsInsert
  ## Creates a group.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_578982 = newJObject()
  var body_578983 = newJObject()
  add(query_578982, "key", newJString(key))
  add(query_578982, "prettyPrint", newJBool(prettyPrint))
  add(query_578982, "oauth_token", newJString(oauthToken))
  add(query_578982, "$.xgafv", newJString(Xgafv))
  add(query_578982, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578982, "alt", newJString(alt))
  add(query_578982, "uploadType", newJString(uploadType))
  add(query_578982, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578983 = body
  add(query_578982, "callback", newJString(callback))
  add(query_578982, "fields", newJString(fields))
  add(query_578982, "access_token", newJString(accessToken))
  add(query_578982, "upload_protocol", newJString(uploadProtocol))
  result = call_578981.call(nil, query_578982, nil, nil, body_578983)

var youtubeAnalyticsGroupsInsert* = Call_YoutubeAnalyticsGroupsInsert_578964(
    name: "youtubeAnalyticsGroupsInsert", meth: HttpMethod.HttpPost,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsInsert_578965, base: "/",
    url: url_YoutubeAnalyticsGroupsInsert_578966, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsList_578923 = ref object of OpenApiRestCall_578339
proc url_YoutubeAnalyticsGroupsList_578925(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsList_578924(path: JsonNode; query: JsonNode;
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
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
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
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The `pageToken` parameter identifies a specific page in the result set that
  ## should be returned. In an API response, the `nextPageToken` property
  ## identifies the next page that can be retrieved.
  ##   id: JString
  ##     : The `id` parameter specifies a comma-separated list of the YouTube group
  ## ID(s) for the resource(s) that are being retrieved. Each group must be
  ## owned by the authenticated user. In a `group` resource, the `id` property
  ## specifies the group's YouTube group ID.
  ## 
  ## Note that if you do not specify a value for the `id` parameter, then you
  ## must set the `mine` parameter to `true`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   mine: JBool
  ##       : This parameter can only be used in a properly authorized request. Set this
  ## parameter's value to true to retrieve all groups owned by the authenticated
  ## user.
  section = newJObject()
  var valid_578926 = query.getOrDefault("key")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = nil)
  if valid_578926 != nil:
    section.add "key", valid_578926
  var valid_578927 = query.getOrDefault("prettyPrint")
  valid_578927 = validateParameter(valid_578927, JBool, required = false,
                                 default = newJBool(true))
  if valid_578927 != nil:
    section.add "prettyPrint", valid_578927
  var valid_578928 = query.getOrDefault("oauth_token")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "oauth_token", valid_578928
  var valid_578929 = query.getOrDefault("$.xgafv")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = newJString("1"))
  if valid_578929 != nil:
    section.add "$.xgafv", valid_578929
  var valid_578930 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "onBehalfOfContentOwner", valid_578930
  var valid_578931 = query.getOrDefault("alt")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = newJString("json"))
  if valid_578931 != nil:
    section.add "alt", valid_578931
  var valid_578932 = query.getOrDefault("uploadType")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "uploadType", valid_578932
  var valid_578933 = query.getOrDefault("quotaUser")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "quotaUser", valid_578933
  var valid_578934 = query.getOrDefault("pageToken")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "pageToken", valid_578934
  var valid_578935 = query.getOrDefault("id")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "id", valid_578935
  var valid_578936 = query.getOrDefault("callback")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "callback", valid_578936
  var valid_578937 = query.getOrDefault("fields")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "fields", valid_578937
  var valid_578938 = query.getOrDefault("access_token")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "access_token", valid_578938
  var valid_578939 = query.getOrDefault("upload_protocol")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "upload_protocol", valid_578939
  var valid_578940 = query.getOrDefault("mine")
  valid_578940 = validateParameter(valid_578940, JBool, required = false, default = nil)
  if valid_578940 != nil:
    section.add "mine", valid_578940
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578941: Call_YoutubeAnalyticsGroupsList_578923; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns a collection of groups that match the API request parameters. For
  ## example, you can retrieve all groups that the authenticated user owns,
  ## or you can retrieve one or more groups by their unique IDs.
  ## 
  let valid = call_578941.validator(path, query, header, formData, body)
  let scheme = call_578941.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578941.url(scheme.get, call_578941.host, call_578941.base,
                         call_578941.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578941, url, valid)

proc call*(call_578942: Call_YoutubeAnalyticsGroupsList_578923; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          id: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; mine: bool = false): Recallable =
  ## youtubeAnalyticsGroupsList
  ## Returns a collection of groups that match the API request parameters. For
  ## example, you can retrieve all groups that the authenticated user owns,
  ## or you can retrieve one or more groups by their unique IDs.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The `pageToken` parameter identifies a specific page in the result set that
  ## should be returned. In an API response, the `nextPageToken` property
  ## identifies the next page that can be retrieved.
  ##   id: string
  ##     : The `id` parameter specifies a comma-separated list of the YouTube group
  ## ID(s) for the resource(s) that are being retrieved. Each group must be
  ## owned by the authenticated user. In a `group` resource, the `id` property
  ## specifies the group's YouTube group ID.
  ## 
  ## Note that if you do not specify a value for the `id` parameter, then you
  ## must set the `mine` parameter to `true`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   mine: bool
  ##       : This parameter can only be used in a properly authorized request. Set this
  ## parameter's value to true to retrieve all groups owned by the authenticated
  ## user.
  var query_578943 = newJObject()
  add(query_578943, "key", newJString(key))
  add(query_578943, "prettyPrint", newJBool(prettyPrint))
  add(query_578943, "oauth_token", newJString(oauthToken))
  add(query_578943, "$.xgafv", newJString(Xgafv))
  add(query_578943, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_578943, "alt", newJString(alt))
  add(query_578943, "uploadType", newJString(uploadType))
  add(query_578943, "quotaUser", newJString(quotaUser))
  add(query_578943, "pageToken", newJString(pageToken))
  add(query_578943, "id", newJString(id))
  add(query_578943, "callback", newJString(callback))
  add(query_578943, "fields", newJString(fields))
  add(query_578943, "access_token", newJString(accessToken))
  add(query_578943, "upload_protocol", newJString(uploadProtocol))
  add(query_578943, "mine", newJBool(mine))
  result = call_578942.call(nil, query_578943, nil, nil, nil)

var youtubeAnalyticsGroupsList* = Call_YoutubeAnalyticsGroupsList_578923(
    name: "youtubeAnalyticsGroupsList", meth: HttpMethod.HttpGet,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsList_578924, base: "/",
    url: url_YoutubeAnalyticsGroupsList_578925, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsGroupsDelete_578984 = ref object of OpenApiRestCall_578339
proc url_YoutubeAnalyticsGroupsDelete_578986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsGroupsDelete_578985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a group.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
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
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: JString
  ##     : The `id` parameter specifies the YouTube group ID of the group that is
  ## being deleted.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578987 = query.getOrDefault("key")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "key", valid_578987
  var valid_578988 = query.getOrDefault("prettyPrint")
  valid_578988 = validateParameter(valid_578988, JBool, required = false,
                                 default = newJBool(true))
  if valid_578988 != nil:
    section.add "prettyPrint", valid_578988
  var valid_578989 = query.getOrDefault("oauth_token")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "oauth_token", valid_578989
  var valid_578990 = query.getOrDefault("$.xgafv")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = newJString("1"))
  if valid_578990 != nil:
    section.add "$.xgafv", valid_578990
  var valid_578991 = query.getOrDefault("onBehalfOfContentOwner")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "onBehalfOfContentOwner", valid_578991
  var valid_578992 = query.getOrDefault("alt")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = newJString("json"))
  if valid_578992 != nil:
    section.add "alt", valid_578992
  var valid_578993 = query.getOrDefault("uploadType")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "uploadType", valid_578993
  var valid_578994 = query.getOrDefault("quotaUser")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "quotaUser", valid_578994
  var valid_578995 = query.getOrDefault("id")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "id", valid_578995
  var valid_578996 = query.getOrDefault("callback")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "callback", valid_578996
  var valid_578997 = query.getOrDefault("fields")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = nil)
  if valid_578997 != nil:
    section.add "fields", valid_578997
  var valid_578998 = query.getOrDefault("access_token")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "access_token", valid_578998
  var valid_578999 = query.getOrDefault("upload_protocol")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "upload_protocol", valid_578999
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579000: Call_YoutubeAnalyticsGroupsDelete_578984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a group.
  ## 
  let valid = call_579000.validator(path, query, header, formData, body)
  let scheme = call_579000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579000.url(scheme.get, call_579000.host, call_579000.base,
                         call_579000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579000, url, valid)

proc call*(call_579001: Call_YoutubeAnalyticsGroupsDelete_578984; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          onBehalfOfContentOwner: string = ""; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; id: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## youtubeAnalyticsGroupsDelete
  ## Deletes a group.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   id: string
  ##     : The `id` parameter specifies the YouTube group ID of the group that is
  ## being deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var query_579002 = newJObject()
  add(query_579002, "key", newJString(key))
  add(query_579002, "prettyPrint", newJBool(prettyPrint))
  add(query_579002, "oauth_token", newJString(oauthToken))
  add(query_579002, "$.xgafv", newJString(Xgafv))
  add(query_579002, "onBehalfOfContentOwner", newJString(onBehalfOfContentOwner))
  add(query_579002, "alt", newJString(alt))
  add(query_579002, "uploadType", newJString(uploadType))
  add(query_579002, "quotaUser", newJString(quotaUser))
  add(query_579002, "id", newJString(id))
  add(query_579002, "callback", newJString(callback))
  add(query_579002, "fields", newJString(fields))
  add(query_579002, "access_token", newJString(accessToken))
  add(query_579002, "upload_protocol", newJString(uploadProtocol))
  result = call_579001.call(nil, query_579002, nil, nil, nil)

var youtubeAnalyticsGroupsDelete* = Call_YoutubeAnalyticsGroupsDelete_578984(
    name: "youtubeAnalyticsGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "youtubeanalytics.googleapis.com", route: "/v2/groups",
    validator: validate_YoutubeAnalyticsGroupsDelete_578985, base: "/",
    url: url_YoutubeAnalyticsGroupsDelete_578986, schemes: {Scheme.Https})
type
  Call_YoutubeAnalyticsReportsQuery_579003 = ref object of OpenApiRestCall_578339
proc url_YoutubeAnalyticsReportsQuery_579005(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_YoutubeAnalyticsReportsQuery_579004(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve your YouTube Analytics reports.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeHistoricalChannelData: JBool
  ##                               : If set to true historical data (i.e. channel data from before the linking
  ## of the channel to the content owner) will be retrieved.",
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   currency: JString
  ##           : The currency to which financial metrics should be converted. The default is
  ## US Dollar (USD). If the result contains no financial metrics, this flag
  ## will be ignored. Responds with an error if the specified currency is not
  ## recognized.",
  ## pattern: [A-Z]{3}
  ##   metrics: JString
  ##          : A comma-separated list of YouTube Analytics metrics, such as `views` or
  ## `likes,dislikes`. See the
  ## [Available Reports](/youtube/analytics/v2/available_reports)  document for
  ## a list of the reports that you can retrieve and the metrics
  ## available in each report, and see the
  ## [Metrics](/youtube/analytics/v2/dimsmets/mets) document for definitions of
  ## those metrics.
  ## required: true, pattern: [0-9a-zA-Z,]+
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   endDate: JString
  ##          : The end date for fetching YouTube Analytics data. The value should be in
  ## `YYYY-MM-DD` format.
  ## required: true, pattern: [0-9]{4}-[0-9]{2}-[0-9]{2}
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dimensions: JString
  ##             : A comma-separated list of YouTube Analytics dimensions, such as `views` or
  ## `ageGroup,gender`. See the [Available
  ## Reports](/youtube/analytics/v2/available_reports) document for a list of
  ## the reports that you can retrieve and the dimensions used for those
  ## reports. Also see the [Dimensions](/youtube/analytics/v2/dimsmets/dims)
  ## document for definitions of those dimensions."
  ## pattern: [0-9a-zA-Z,]+
  ##   startIndex: JInt
  ##             : An index of the first entity to retrieve. Use this parameter as a
  ## pagination mechanism along with the max-results parameter (one-based,
  ## inclusive).",
  ## minValue: 1
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
  ##   callback: JString
  ##           : JSONP
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   startDate: JString
  ##            : The start date for fetching YouTube Analytics data. The value should be in
  ## `YYYY-MM-DD` format.
  ## required: true, pattern: "[0-9]{4}-[0-9]{2}-[0-9]{2}
  ##   maxResults: JInt
  ##             : The maximum number of rows to include in the response.",
  ## minValue: 1
  ##   sort: JString
  ##       : A comma-separated list of dimensions or metrics that determine the sort
  ## order for YouTube Analytics data. By default the sort order is ascending.
  ## The '`-`' prefix causes descending sort order.",
  ## pattern: [-0-9a-zA-Z,]+
  section = newJObject()
  var valid_579006 = query.getOrDefault("key")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "key", valid_579006
  var valid_579007 = query.getOrDefault("prettyPrint")
  valid_579007 = validateParameter(valid_579007, JBool, required = false,
                                 default = newJBool(true))
  if valid_579007 != nil:
    section.add "prettyPrint", valid_579007
  var valid_579008 = query.getOrDefault("oauth_token")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "oauth_token", valid_579008
  var valid_579009 = query.getOrDefault("includeHistoricalChannelData")
  valid_579009 = validateParameter(valid_579009, JBool, required = false, default = nil)
  if valid_579009 != nil:
    section.add "includeHistoricalChannelData", valid_579009
  var valid_579010 = query.getOrDefault("$.xgafv")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = newJString("1"))
  if valid_579010 != nil:
    section.add "$.xgafv", valid_579010
  var valid_579011 = query.getOrDefault("currency")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "currency", valid_579011
  var valid_579012 = query.getOrDefault("metrics")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = nil)
  if valid_579012 != nil:
    section.add "metrics", valid_579012
  var valid_579013 = query.getOrDefault("alt")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = newJString("json"))
  if valid_579013 != nil:
    section.add "alt", valid_579013
  var valid_579014 = query.getOrDefault("uploadType")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "uploadType", valid_579014
  var valid_579015 = query.getOrDefault("endDate")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "endDate", valid_579015
  var valid_579016 = query.getOrDefault("quotaUser")
  valid_579016 = validateParameter(valid_579016, JString, required = false,
                                 default = nil)
  if valid_579016 != nil:
    section.add "quotaUser", valid_579016
  var valid_579017 = query.getOrDefault("dimensions")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "dimensions", valid_579017
  var valid_579018 = query.getOrDefault("startIndex")
  valid_579018 = validateParameter(valid_579018, JInt, required = false, default = nil)
  if valid_579018 != nil:
    section.add "startIndex", valid_579018
  var valid_579019 = query.getOrDefault("filters")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "filters", valid_579019
  var valid_579020 = query.getOrDefault("callback")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "callback", valid_579020
  var valid_579021 = query.getOrDefault("ids")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "ids", valid_579021
  var valid_579022 = query.getOrDefault("fields")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "fields", valid_579022
  var valid_579023 = query.getOrDefault("access_token")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "access_token", valid_579023
  var valid_579024 = query.getOrDefault("upload_protocol")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "upload_protocol", valid_579024
  var valid_579025 = query.getOrDefault("startDate")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "startDate", valid_579025
  var valid_579026 = query.getOrDefault("maxResults")
  valid_579026 = validateParameter(valid_579026, JInt, required = false, default = nil)
  if valid_579026 != nil:
    section.add "maxResults", valid_579026
  var valid_579027 = query.getOrDefault("sort")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "sort", valid_579027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579028: Call_YoutubeAnalyticsReportsQuery_579003; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve your YouTube Analytics reports.
  ## 
  let valid = call_579028.validator(path, query, header, formData, body)
  let scheme = call_579028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579028.url(scheme.get, call_579028.host, call_579028.base,
                         call_579028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579028, url, valid)

proc call*(call_579029: Call_YoutubeAnalyticsReportsQuery_579003; key: string = "";
          prettyPrint: bool = true; oauthToken: string = "";
          includeHistoricalChannelData: bool = false; Xgafv: string = "1";
          currency: string = ""; metrics: string = ""; alt: string = "json";
          uploadType: string = ""; endDate: string = ""; quotaUser: string = "";
          dimensions: string = ""; startIndex: int = 0; filters: string = "";
          callback: string = ""; ids: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""; startDate: string = "";
          maxResults: int = 0; sort: string = ""): Recallable =
  ## youtubeAnalyticsReportsQuery
  ## Retrieve your YouTube Analytics reports.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeHistoricalChannelData: bool
  ##                               : If set to true historical data (i.e. channel data from before the linking
  ## of the channel to the content owner) will be retrieved.",
  ##   Xgafv: string
  ##        : V1 error format.
  ##   currency: string
  ##           : The currency to which financial metrics should be converted. The default is
  ## US Dollar (USD). If the result contains no financial metrics, this flag
  ## will be ignored. Responds with an error if the specified currency is not
  ## recognized.",
  ## pattern: [A-Z]{3}
  ##   metrics: string
  ##          : A comma-separated list of YouTube Analytics metrics, such as `views` or
  ## `likes,dislikes`. See the
  ## [Available Reports](/youtube/analytics/v2/available_reports)  document for
  ## a list of the reports that you can retrieve and the metrics
  ## available in each report, and see the
  ## [Metrics](/youtube/analytics/v2/dimsmets/mets) document for definitions of
  ## those metrics.
  ## required: true, pattern: [0-9a-zA-Z,]+
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   endDate: string
  ##          : The end date for fetching YouTube Analytics data. The value should be in
  ## `YYYY-MM-DD` format.
  ## required: true, pattern: [0-9]{4}-[0-9]{2}-[0-9]{2}
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   dimensions: string
  ##             : A comma-separated list of YouTube Analytics dimensions, such as `views` or
  ## `ageGroup,gender`. See the [Available
  ## Reports](/youtube/analytics/v2/available_reports) document for a list of
  ## the reports that you can retrieve and the dimensions used for those
  ## reports. Also see the [Dimensions](/youtube/analytics/v2/dimsmets/dims)
  ## document for definitions of those dimensions."
  ## pattern: [0-9a-zA-Z,]+
  ##   startIndex: int
  ##             : An index of the first entity to retrieve. Use this parameter as a
  ## pagination mechanism along with the max-results parameter (one-based,
  ## inclusive).",
  ## minValue: 1
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
  ##   callback: string
  ##           : JSONP
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   startDate: string
  ##            : The start date for fetching YouTube Analytics data. The value should be in
  ## `YYYY-MM-DD` format.
  ## required: true, pattern: "[0-9]{4}-[0-9]{2}-[0-9]{2}
  ##   maxResults: int
  ##             : The maximum number of rows to include in the response.",
  ## minValue: 1
  ##   sort: string
  ##       : A comma-separated list of dimensions or metrics that determine the sort
  ## order for YouTube Analytics data. By default the sort order is ascending.
  ## The '`-`' prefix causes descending sort order.",
  ## pattern: [-0-9a-zA-Z,]+
  var query_579030 = newJObject()
  add(query_579030, "key", newJString(key))
  add(query_579030, "prettyPrint", newJBool(prettyPrint))
  add(query_579030, "oauth_token", newJString(oauthToken))
  add(query_579030, "includeHistoricalChannelData",
      newJBool(includeHistoricalChannelData))
  add(query_579030, "$.xgafv", newJString(Xgafv))
  add(query_579030, "currency", newJString(currency))
  add(query_579030, "metrics", newJString(metrics))
  add(query_579030, "alt", newJString(alt))
  add(query_579030, "uploadType", newJString(uploadType))
  add(query_579030, "endDate", newJString(endDate))
  add(query_579030, "quotaUser", newJString(quotaUser))
  add(query_579030, "dimensions", newJString(dimensions))
  add(query_579030, "startIndex", newJInt(startIndex))
  add(query_579030, "filters", newJString(filters))
  add(query_579030, "callback", newJString(callback))
  add(query_579030, "ids", newJString(ids))
  add(query_579030, "fields", newJString(fields))
  add(query_579030, "access_token", newJString(accessToken))
  add(query_579030, "upload_protocol", newJString(uploadProtocol))
  add(query_579030, "startDate", newJString(startDate))
  add(query_579030, "maxResults", newJInt(maxResults))
  add(query_579030, "sort", newJString(sort))
  result = call_579029.call(nil, query_579030, nil, nil, nil)

var youtubeAnalyticsReportsQuery* = Call_YoutubeAnalyticsReportsQuery_579003(
    name: "youtubeAnalyticsReportsQuery", meth: HttpMethod.HttpGet,
    host: "youtubeanalytics.googleapis.com", route: "/v2/reports",
    validator: validate_YoutubeAnalyticsReportsQuery_579004, base: "/",
    url: url_YoutubeAnalyticsReportsQuery_579005, schemes: {Scheme.Https})
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
