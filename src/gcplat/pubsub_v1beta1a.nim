
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Pub/Sub
## version: v1beta1a
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Provides reliable, many-to-many, asynchronous messaging between applications.
## 
## 
## https://cloud.google.com/pubsub/docs
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
  gcpServiceName = "pubsub"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PubsubSubscriptionsCreate_578885 = ref object of OpenApiRestCall_578339
proc url_PubsubSubscriptionsCreate_578887(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsCreate_578886(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a subscription on a given topic for a given subscriber.
  ## If the subscription already exists, returns ALREADY_EXISTS.
  ## If the corresponding topic doesn't exist, returns NOT_FOUND.
  ## 
  ## If the name is not provided in the request, the server will assign a random
  ## name for this subscription on the same project as the topic.
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
  var valid_578888 = query.getOrDefault("key")
  valid_578888 = validateParameter(valid_578888, JString, required = false,
                                 default = nil)
  if valid_578888 != nil:
    section.add "key", valid_578888
  var valid_578889 = query.getOrDefault("prettyPrint")
  valid_578889 = validateParameter(valid_578889, JBool, required = false,
                                 default = newJBool(true))
  if valid_578889 != nil:
    section.add "prettyPrint", valid_578889
  var valid_578890 = query.getOrDefault("oauth_token")
  valid_578890 = validateParameter(valid_578890, JString, required = false,
                                 default = nil)
  if valid_578890 != nil:
    section.add "oauth_token", valid_578890
  var valid_578891 = query.getOrDefault("$.xgafv")
  valid_578891 = validateParameter(valid_578891, JString, required = false,
                                 default = newJString("1"))
  if valid_578891 != nil:
    section.add "$.xgafv", valid_578891
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

proc call*(call_578900: Call_PubsubSubscriptionsCreate_578885; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a subscription on a given topic for a given subscriber.
  ## If the subscription already exists, returns ALREADY_EXISTS.
  ## If the corresponding topic doesn't exist, returns NOT_FOUND.
  ## 
  ## If the name is not provided in the request, the server will assign a random
  ## name for this subscription on the same project as the topic.
  ## 
  let valid = call_578900.validator(path, query, header, formData, body)
  let scheme = call_578900.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578900.url(scheme.get, call_578900.host, call_578900.base,
                         call_578900.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578900, url, valid)

proc call*(call_578901: Call_PubsubSubscriptionsCreate_578885; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubSubscriptionsCreate
  ## Creates a subscription on a given topic for a given subscriber.
  ## If the subscription already exists, returns ALREADY_EXISTS.
  ## If the corresponding topic doesn't exist, returns NOT_FOUND.
  ## 
  ## If the name is not provided in the request, the server will assign a random
  ## name for this subscription on the same project as the topic.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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

var pubsubSubscriptionsCreate* = Call_PubsubSubscriptionsCreate_578885(
    name: "pubsubSubscriptionsCreate", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions",
    validator: validate_PubsubSubscriptionsCreate_578886, base: "/",
    url: url_PubsubSubscriptionsCreate_578887, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsList_578610 = ref object of OpenApiRestCall_578339
proc url_PubsubSubscriptionsList_578612(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsList_578611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists matching subscriptions.
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
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value obtained in the last <code>ListSubscriptionsResponse</code>
  ## for continuation.
  ##   query: JString
  ##        : A valid label query expression.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxResults: JInt
  ##             : Maximum number of subscriptions to return.
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
  var valid_578741 = query.getOrDefault("alt")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = newJString("json"))
  if valid_578741 != nil:
    section.add "alt", valid_578741
  var valid_578742 = query.getOrDefault("uploadType")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = nil)
  if valid_578742 != nil:
    section.add "uploadType", valid_578742
  var valid_578743 = query.getOrDefault("quotaUser")
  valid_578743 = validateParameter(valid_578743, JString, required = false,
                                 default = nil)
  if valid_578743 != nil:
    section.add "quotaUser", valid_578743
  var valid_578744 = query.getOrDefault("pageToken")
  valid_578744 = validateParameter(valid_578744, JString, required = false,
                                 default = nil)
  if valid_578744 != nil:
    section.add "pageToken", valid_578744
  var valid_578745 = query.getOrDefault("query")
  valid_578745 = validateParameter(valid_578745, JString, required = false,
                                 default = nil)
  if valid_578745 != nil:
    section.add "query", valid_578745
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
  var valid_578750 = query.getOrDefault("maxResults")
  valid_578750 = validateParameter(valid_578750, JInt, required = false, default = nil)
  if valid_578750 != nil:
    section.add "maxResults", valid_578750
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578773: Call_PubsubSubscriptionsList_578610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matching subscriptions.
  ## 
  let valid = call_578773.validator(path, query, header, formData, body)
  let scheme = call_578773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578773.url(scheme.get, call_578773.host, call_578773.base,
                         call_578773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578773, url, valid)

proc call*(call_578844: Call_PubsubSubscriptionsList_578610; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; query: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          maxResults: int = 0): Recallable =
  ## pubsubSubscriptionsList
  ## Lists matching subscriptions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value obtained in the last <code>ListSubscriptionsResponse</code>
  ## for continuation.
  ##   query: string
  ##        : A valid label query expression.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxResults: int
  ##             : Maximum number of subscriptions to return.
  var query_578845 = newJObject()
  add(query_578845, "key", newJString(key))
  add(query_578845, "prettyPrint", newJBool(prettyPrint))
  add(query_578845, "oauth_token", newJString(oauthToken))
  add(query_578845, "$.xgafv", newJString(Xgafv))
  add(query_578845, "alt", newJString(alt))
  add(query_578845, "uploadType", newJString(uploadType))
  add(query_578845, "quotaUser", newJString(quotaUser))
  add(query_578845, "pageToken", newJString(pageToken))
  add(query_578845, "query", newJString(query))
  add(query_578845, "callback", newJString(callback))
  add(query_578845, "fields", newJString(fields))
  add(query_578845, "access_token", newJString(accessToken))
  add(query_578845, "upload_protocol", newJString(uploadProtocol))
  add(query_578845, "maxResults", newJInt(maxResults))
  result = call_578844.call(nil, query_578845, nil, nil, nil)

var pubsubSubscriptionsList* = Call_PubsubSubscriptionsList_578610(
    name: "pubsubSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions",
    validator: validate_PubsubSubscriptionsList_578611, base: "/",
    url: url_PubsubSubscriptionsList_578612, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsAcknowledge_578904 = ref object of OpenApiRestCall_578339
proc url_PubsubSubscriptionsAcknowledge_578906(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsAcknowledge_578905(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Acknowledges a particular received message: the Pub/Sub system can remove
  ## the given message from the subscription. Acknowledging a message whose
  ## Ack deadline has expired may succeed, but the message could have been
  ## already redelivered. Acknowledging a message more than once will not
  ## result in an error. This is only used for messages received via pull.
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
  var valid_578911 = query.getOrDefault("alt")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = newJString("json"))
  if valid_578911 != nil:
    section.add "alt", valid_578911
  var valid_578912 = query.getOrDefault("uploadType")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "uploadType", valid_578912
  var valid_578913 = query.getOrDefault("quotaUser")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "quotaUser", valid_578913
  var valid_578914 = query.getOrDefault("callback")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "callback", valid_578914
  var valid_578915 = query.getOrDefault("fields")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "fields", valid_578915
  var valid_578916 = query.getOrDefault("access_token")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "access_token", valid_578916
  var valid_578917 = query.getOrDefault("upload_protocol")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "upload_protocol", valid_578917
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

proc call*(call_578919: Call_PubsubSubscriptionsAcknowledge_578904; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Acknowledges a particular received message: the Pub/Sub system can remove
  ## the given message from the subscription. Acknowledging a message whose
  ## Ack deadline has expired may succeed, but the message could have been
  ## already redelivered. Acknowledging a message more than once will not
  ## result in an error. This is only used for messages received via pull.
  ## 
  let valid = call_578919.validator(path, query, header, formData, body)
  let scheme = call_578919.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578919.url(scheme.get, call_578919.host, call_578919.base,
                         call_578919.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578919, url, valid)

proc call*(call_578920: Call_PubsubSubscriptionsAcknowledge_578904;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubSubscriptionsAcknowledge
  ## Acknowledges a particular received message: the Pub/Sub system can remove
  ## the given message from the subscription. Acknowledging a message whose
  ## Ack deadline has expired may succeed, but the message could have been
  ## already redelivered. Acknowledging a message more than once will not
  ## result in an error. This is only used for messages received via pull.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  var query_578921 = newJObject()
  var body_578922 = newJObject()
  add(query_578921, "key", newJString(key))
  add(query_578921, "prettyPrint", newJBool(prettyPrint))
  add(query_578921, "oauth_token", newJString(oauthToken))
  add(query_578921, "$.xgafv", newJString(Xgafv))
  add(query_578921, "alt", newJString(alt))
  add(query_578921, "uploadType", newJString(uploadType))
  add(query_578921, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578922 = body
  add(query_578921, "callback", newJString(callback))
  add(query_578921, "fields", newJString(fields))
  add(query_578921, "access_token", newJString(accessToken))
  add(query_578921, "upload_protocol", newJString(uploadProtocol))
  result = call_578920.call(nil, query_578921, nil, nil, body_578922)

var pubsubSubscriptionsAcknowledge* = Call_PubsubSubscriptionsAcknowledge_578904(
    name: "pubsubSubscriptionsAcknowledge", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions/acknowledge",
    validator: validate_PubsubSubscriptionsAcknowledge_578905, base: "/",
    url: url_PubsubSubscriptionsAcknowledge_578906, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsModifyAckDeadline_578923 = ref object of OpenApiRestCall_578339
proc url_PubsubSubscriptionsModifyAckDeadline_578925(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsModifyAckDeadline_578924(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the Ack deadline for a message received from a pull request.
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
  var valid_578930 = query.getOrDefault("alt")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = newJString("json"))
  if valid_578930 != nil:
    section.add "alt", valid_578930
  var valid_578931 = query.getOrDefault("uploadType")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "uploadType", valid_578931
  var valid_578932 = query.getOrDefault("quotaUser")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "quotaUser", valid_578932
  var valid_578933 = query.getOrDefault("callback")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "callback", valid_578933
  var valid_578934 = query.getOrDefault("fields")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "fields", valid_578934
  var valid_578935 = query.getOrDefault("access_token")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "access_token", valid_578935
  var valid_578936 = query.getOrDefault("upload_protocol")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "upload_protocol", valid_578936
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

proc call*(call_578938: Call_PubsubSubscriptionsModifyAckDeadline_578923;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the Ack deadline for a message received from a pull request.
  ## 
  let valid = call_578938.validator(path, query, header, formData, body)
  let scheme = call_578938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578938.url(scheme.get, call_578938.host, call_578938.base,
                         call_578938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578938, url, valid)

proc call*(call_578939: Call_PubsubSubscriptionsModifyAckDeadline_578923;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubSubscriptionsModifyAckDeadline
  ## Modifies the Ack deadline for a message received from a pull request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  var query_578940 = newJObject()
  var body_578941 = newJObject()
  add(query_578940, "key", newJString(key))
  add(query_578940, "prettyPrint", newJBool(prettyPrint))
  add(query_578940, "oauth_token", newJString(oauthToken))
  add(query_578940, "$.xgafv", newJString(Xgafv))
  add(query_578940, "alt", newJString(alt))
  add(query_578940, "uploadType", newJString(uploadType))
  add(query_578940, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578941 = body
  add(query_578940, "callback", newJString(callback))
  add(query_578940, "fields", newJString(fields))
  add(query_578940, "access_token", newJString(accessToken))
  add(query_578940, "upload_protocol", newJString(uploadProtocol))
  result = call_578939.call(nil, query_578940, nil, nil, body_578941)

var pubsubSubscriptionsModifyAckDeadline* = Call_PubsubSubscriptionsModifyAckDeadline_578923(
    name: "pubsubSubscriptionsModifyAckDeadline", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com",
    route: "/v1beta1a/subscriptions/modifyAckDeadline",
    validator: validate_PubsubSubscriptionsModifyAckDeadline_578924, base: "/",
    url: url_PubsubSubscriptionsModifyAckDeadline_578925, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsModifyPushConfig_578942 = ref object of OpenApiRestCall_578339
proc url_PubsubSubscriptionsModifyPushConfig_578944(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsModifyPushConfig_578943(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the <code>PushConfig</code> for a specified subscription.
  ## This method can be used to suspend the flow of messages to an endpoint
  ## by clearing the <code>PushConfig</code> field in the request. Messages
  ## will be accumulated for delivery even if no push configuration is
  ## defined or while the configuration is modified.
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
  var valid_578945 = query.getOrDefault("key")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "key", valid_578945
  var valid_578946 = query.getOrDefault("prettyPrint")
  valid_578946 = validateParameter(valid_578946, JBool, required = false,
                                 default = newJBool(true))
  if valid_578946 != nil:
    section.add "prettyPrint", valid_578946
  var valid_578947 = query.getOrDefault("oauth_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "oauth_token", valid_578947
  var valid_578948 = query.getOrDefault("$.xgafv")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = newJString("1"))
  if valid_578948 != nil:
    section.add "$.xgafv", valid_578948
  var valid_578949 = query.getOrDefault("alt")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("json"))
  if valid_578949 != nil:
    section.add "alt", valid_578949
  var valid_578950 = query.getOrDefault("uploadType")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "uploadType", valid_578950
  var valid_578951 = query.getOrDefault("quotaUser")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "quotaUser", valid_578951
  var valid_578952 = query.getOrDefault("callback")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "callback", valid_578952
  var valid_578953 = query.getOrDefault("fields")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "fields", valid_578953
  var valid_578954 = query.getOrDefault("access_token")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "access_token", valid_578954
  var valid_578955 = query.getOrDefault("upload_protocol")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "upload_protocol", valid_578955
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

proc call*(call_578957: Call_PubsubSubscriptionsModifyPushConfig_578942;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the <code>PushConfig</code> for a specified subscription.
  ## This method can be used to suspend the flow of messages to an endpoint
  ## by clearing the <code>PushConfig</code> field in the request. Messages
  ## will be accumulated for delivery even if no push configuration is
  ## defined or while the configuration is modified.
  ## 
  let valid = call_578957.validator(path, query, header, formData, body)
  let scheme = call_578957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578957.url(scheme.get, call_578957.host, call_578957.base,
                         call_578957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578957, url, valid)

proc call*(call_578958: Call_PubsubSubscriptionsModifyPushConfig_578942;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubSubscriptionsModifyPushConfig
  ## Modifies the <code>PushConfig</code> for a specified subscription.
  ## This method can be used to suspend the flow of messages to an endpoint
  ## by clearing the <code>PushConfig</code> field in the request. Messages
  ## will be accumulated for delivery even if no push configuration is
  ## defined or while the configuration is modified.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  var query_578959 = newJObject()
  var body_578960 = newJObject()
  add(query_578959, "key", newJString(key))
  add(query_578959, "prettyPrint", newJBool(prettyPrint))
  add(query_578959, "oauth_token", newJString(oauthToken))
  add(query_578959, "$.xgafv", newJString(Xgafv))
  add(query_578959, "alt", newJString(alt))
  add(query_578959, "uploadType", newJString(uploadType))
  add(query_578959, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578960 = body
  add(query_578959, "callback", newJString(callback))
  add(query_578959, "fields", newJString(fields))
  add(query_578959, "access_token", newJString(accessToken))
  add(query_578959, "upload_protocol", newJString(uploadProtocol))
  result = call_578958.call(nil, query_578959, nil, nil, body_578960)

var pubsubSubscriptionsModifyPushConfig* = Call_PubsubSubscriptionsModifyPushConfig_578942(
    name: "pubsubSubscriptionsModifyPushConfig", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com",
    route: "/v1beta1a/subscriptions/modifyPushConfig",
    validator: validate_PubsubSubscriptionsModifyPushConfig_578943, base: "/",
    url: url_PubsubSubscriptionsModifyPushConfig_578944, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsPull_578961 = ref object of OpenApiRestCall_578339
proc url_PubsubSubscriptionsPull_578963(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsPull_578962(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pulls a single message from the server.
  ## If return_immediately is true, and no messages are available in the
  ## subscription, this method returns FAILED_PRECONDITION. The system is free
  ## to return an UNAVAILABLE error if no messages are available in a
  ## reasonable amount of time (to reduce system load).
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
  var valid_578964 = query.getOrDefault("key")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "key", valid_578964
  var valid_578965 = query.getOrDefault("prettyPrint")
  valid_578965 = validateParameter(valid_578965, JBool, required = false,
                                 default = newJBool(true))
  if valid_578965 != nil:
    section.add "prettyPrint", valid_578965
  var valid_578966 = query.getOrDefault("oauth_token")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "oauth_token", valid_578966
  var valid_578967 = query.getOrDefault("$.xgafv")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = newJString("1"))
  if valid_578967 != nil:
    section.add "$.xgafv", valid_578967
  var valid_578968 = query.getOrDefault("alt")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = newJString("json"))
  if valid_578968 != nil:
    section.add "alt", valid_578968
  var valid_578969 = query.getOrDefault("uploadType")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "uploadType", valid_578969
  var valid_578970 = query.getOrDefault("quotaUser")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "quotaUser", valid_578970
  var valid_578971 = query.getOrDefault("callback")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "callback", valid_578971
  var valid_578972 = query.getOrDefault("fields")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "fields", valid_578972
  var valid_578973 = query.getOrDefault("access_token")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "access_token", valid_578973
  var valid_578974 = query.getOrDefault("upload_protocol")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "upload_protocol", valid_578974
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

proc call*(call_578976: Call_PubsubSubscriptionsPull_578961; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pulls a single message from the server.
  ## If return_immediately is true, and no messages are available in the
  ## subscription, this method returns FAILED_PRECONDITION. The system is free
  ## to return an UNAVAILABLE error if no messages are available in a
  ## reasonable amount of time (to reduce system load).
  ## 
  let valid = call_578976.validator(path, query, header, formData, body)
  let scheme = call_578976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578976.url(scheme.get, call_578976.host, call_578976.base,
                         call_578976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578976, url, valid)

proc call*(call_578977: Call_PubsubSubscriptionsPull_578961; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubSubscriptionsPull
  ## Pulls a single message from the server.
  ## If return_immediately is true, and no messages are available in the
  ## subscription, this method returns FAILED_PRECONDITION. The system is free
  ## to return an UNAVAILABLE error if no messages are available in a
  ## reasonable amount of time (to reduce system load).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  var query_578978 = newJObject()
  var body_578979 = newJObject()
  add(query_578978, "key", newJString(key))
  add(query_578978, "prettyPrint", newJBool(prettyPrint))
  add(query_578978, "oauth_token", newJString(oauthToken))
  add(query_578978, "$.xgafv", newJString(Xgafv))
  add(query_578978, "alt", newJString(alt))
  add(query_578978, "uploadType", newJString(uploadType))
  add(query_578978, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578979 = body
  add(query_578978, "callback", newJString(callback))
  add(query_578978, "fields", newJString(fields))
  add(query_578978, "access_token", newJString(accessToken))
  add(query_578978, "upload_protocol", newJString(uploadProtocol))
  result = call_578977.call(nil, query_578978, nil, nil, body_578979)

var pubsubSubscriptionsPull* = Call_PubsubSubscriptionsPull_578961(
    name: "pubsubSubscriptionsPull", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions/pull",
    validator: validate_PubsubSubscriptionsPull_578962, base: "/",
    url: url_PubsubSubscriptionsPull_578963, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsPullBatch_578980 = ref object of OpenApiRestCall_578339
proc url_PubsubSubscriptionsPullBatch_578982(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsPullBatch_578981(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Pulls messages from the server. Returns an empty list if there are no
  ## messages available in the backlog. The system is free to return UNAVAILABLE
  ## if there are too many pull requests outstanding for the given subscription.
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
  var valid_578983 = query.getOrDefault("key")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "key", valid_578983
  var valid_578984 = query.getOrDefault("prettyPrint")
  valid_578984 = validateParameter(valid_578984, JBool, required = false,
                                 default = newJBool(true))
  if valid_578984 != nil:
    section.add "prettyPrint", valid_578984
  var valid_578985 = query.getOrDefault("oauth_token")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "oauth_token", valid_578985
  var valid_578986 = query.getOrDefault("$.xgafv")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = newJString("1"))
  if valid_578986 != nil:
    section.add "$.xgafv", valid_578986
  var valid_578987 = query.getOrDefault("alt")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = newJString("json"))
  if valid_578987 != nil:
    section.add "alt", valid_578987
  var valid_578988 = query.getOrDefault("uploadType")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "uploadType", valid_578988
  var valid_578989 = query.getOrDefault("quotaUser")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "quotaUser", valid_578989
  var valid_578990 = query.getOrDefault("callback")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = nil)
  if valid_578990 != nil:
    section.add "callback", valid_578990
  var valid_578991 = query.getOrDefault("fields")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "fields", valid_578991
  var valid_578992 = query.getOrDefault("access_token")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "access_token", valid_578992
  var valid_578993 = query.getOrDefault("upload_protocol")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "upload_protocol", valid_578993
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

proc call*(call_578995: Call_PubsubSubscriptionsPullBatch_578980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pulls messages from the server. Returns an empty list if there are no
  ## messages available in the backlog. The system is free to return UNAVAILABLE
  ## if there are too many pull requests outstanding for the given subscription.
  ## 
  let valid = call_578995.validator(path, query, header, formData, body)
  let scheme = call_578995.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578995.url(scheme.get, call_578995.host, call_578995.base,
                         call_578995.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578995, url, valid)

proc call*(call_578996: Call_PubsubSubscriptionsPullBatch_578980; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubSubscriptionsPullBatch
  ## Pulls messages from the server. Returns an empty list if there are no
  ## messages available in the backlog. The system is free to return UNAVAILABLE
  ## if there are too many pull requests outstanding for the given subscription.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  var query_578997 = newJObject()
  var body_578998 = newJObject()
  add(query_578997, "key", newJString(key))
  add(query_578997, "prettyPrint", newJBool(prettyPrint))
  add(query_578997, "oauth_token", newJString(oauthToken))
  add(query_578997, "$.xgafv", newJString(Xgafv))
  add(query_578997, "alt", newJString(alt))
  add(query_578997, "uploadType", newJString(uploadType))
  add(query_578997, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578998 = body
  add(query_578997, "callback", newJString(callback))
  add(query_578997, "fields", newJString(fields))
  add(query_578997, "access_token", newJString(accessToken))
  add(query_578997, "upload_protocol", newJString(uploadProtocol))
  result = call_578996.call(nil, query_578997, nil, nil, body_578998)

var pubsubSubscriptionsPullBatch* = Call_PubsubSubscriptionsPullBatch_578980(
    name: "pubsubSubscriptionsPullBatch", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions/pullBatch",
    validator: validate_PubsubSubscriptionsPullBatch_578981, base: "/",
    url: url_PubsubSubscriptionsPullBatch_578982, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsGet_578999 = ref object of OpenApiRestCall_578339
proc url_PubsubSubscriptionsGet_579001(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1a/subscriptions/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubSubscriptionsGet_579000(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the configuration details of a subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The name of the subscription to get.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579016 = path.getOrDefault("subscription")
  valid_579016 = validateParameter(valid_579016, JString, required = true,
                                 default = nil)
  if valid_579016 != nil:
    section.add "subscription", valid_579016
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
  var valid_579017 = query.getOrDefault("key")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "key", valid_579017
  var valid_579018 = query.getOrDefault("prettyPrint")
  valid_579018 = validateParameter(valid_579018, JBool, required = false,
                                 default = newJBool(true))
  if valid_579018 != nil:
    section.add "prettyPrint", valid_579018
  var valid_579019 = query.getOrDefault("oauth_token")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "oauth_token", valid_579019
  var valid_579020 = query.getOrDefault("$.xgafv")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = newJString("1"))
  if valid_579020 != nil:
    section.add "$.xgafv", valid_579020
  var valid_579021 = query.getOrDefault("alt")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = newJString("json"))
  if valid_579021 != nil:
    section.add "alt", valid_579021
  var valid_579022 = query.getOrDefault("uploadType")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "uploadType", valid_579022
  var valid_579023 = query.getOrDefault("quotaUser")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "quotaUser", valid_579023
  var valid_579024 = query.getOrDefault("callback")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "callback", valid_579024
  var valid_579025 = query.getOrDefault("fields")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "fields", valid_579025
  var valid_579026 = query.getOrDefault("access_token")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "access_token", valid_579026
  var valid_579027 = query.getOrDefault("upload_protocol")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "upload_protocol", valid_579027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579028: Call_PubsubSubscriptionsGet_578999; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of a subscription.
  ## 
  let valid = call_579028.validator(path, query, header, formData, body)
  let scheme = call_579028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579028.url(scheme.get, call_579028.host, call_579028.base,
                         call_579028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579028, url, valid)

proc call*(call_579029: Call_PubsubSubscriptionsGet_578999; subscription: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubSubscriptionsGet
  ## Gets the configuration details of a subscription.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   subscription: string (required)
  ##               : The name of the subscription to get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579030 = newJObject()
  var query_579031 = newJObject()
  add(query_579031, "key", newJString(key))
  add(query_579031, "prettyPrint", newJBool(prettyPrint))
  add(query_579031, "oauth_token", newJString(oauthToken))
  add(query_579031, "$.xgafv", newJString(Xgafv))
  add(query_579031, "alt", newJString(alt))
  add(query_579031, "uploadType", newJString(uploadType))
  add(query_579031, "quotaUser", newJString(quotaUser))
  add(path_579030, "subscription", newJString(subscription))
  add(query_579031, "callback", newJString(callback))
  add(query_579031, "fields", newJString(fields))
  add(query_579031, "access_token", newJString(accessToken))
  add(query_579031, "upload_protocol", newJString(uploadProtocol))
  result = call_579029.call(path_579030, query_579031, nil, nil, nil)

var pubsubSubscriptionsGet* = Call_PubsubSubscriptionsGet_578999(
    name: "pubsubSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com",
    route: "/v1beta1a/subscriptions/{subscription}",
    validator: validate_PubsubSubscriptionsGet_579000, base: "/",
    url: url_PubsubSubscriptionsGet_579001, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsDelete_579032 = ref object of OpenApiRestCall_578339
proc url_PubsubSubscriptionsDelete_579034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1a/subscriptions/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubSubscriptionsDelete_579033(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing subscription. All pending messages in the subscription
  ## are immediately dropped. Calls to Pull after deletion will return
  ## NOT_FOUND.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   subscription: JString (required)
  ##               : The subscription to delete.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `subscription` field"
  var valid_579035 = path.getOrDefault("subscription")
  valid_579035 = validateParameter(valid_579035, JString, required = true,
                                 default = nil)
  if valid_579035 != nil:
    section.add "subscription", valid_579035
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
  var valid_579036 = query.getOrDefault("key")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "key", valid_579036
  var valid_579037 = query.getOrDefault("prettyPrint")
  valid_579037 = validateParameter(valid_579037, JBool, required = false,
                                 default = newJBool(true))
  if valid_579037 != nil:
    section.add "prettyPrint", valid_579037
  var valid_579038 = query.getOrDefault("oauth_token")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "oauth_token", valid_579038
  var valid_579039 = query.getOrDefault("$.xgafv")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = newJString("1"))
  if valid_579039 != nil:
    section.add "$.xgafv", valid_579039
  var valid_579040 = query.getOrDefault("alt")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = newJString("json"))
  if valid_579040 != nil:
    section.add "alt", valid_579040
  var valid_579041 = query.getOrDefault("uploadType")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "uploadType", valid_579041
  var valid_579042 = query.getOrDefault("quotaUser")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "quotaUser", valid_579042
  var valid_579043 = query.getOrDefault("callback")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "callback", valid_579043
  var valid_579044 = query.getOrDefault("fields")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "fields", valid_579044
  var valid_579045 = query.getOrDefault("access_token")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "access_token", valid_579045
  var valid_579046 = query.getOrDefault("upload_protocol")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "upload_protocol", valid_579046
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579047: Call_PubsubSubscriptionsDelete_579032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing subscription. All pending messages in the subscription
  ## are immediately dropped. Calls to Pull after deletion will return
  ## NOT_FOUND.
  ## 
  let valid = call_579047.validator(path, query, header, formData, body)
  let scheme = call_579047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579047.url(scheme.get, call_579047.host, call_579047.base,
                         call_579047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579047, url, valid)

proc call*(call_579048: Call_PubsubSubscriptionsDelete_579032;
          subscription: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubSubscriptionsDelete
  ## Deletes an existing subscription. All pending messages in the subscription
  ## are immediately dropped. Calls to Pull after deletion will return
  ## NOT_FOUND.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   subscription: string (required)
  ##               : The subscription to delete.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579049 = newJObject()
  var query_579050 = newJObject()
  add(query_579050, "key", newJString(key))
  add(query_579050, "prettyPrint", newJBool(prettyPrint))
  add(query_579050, "oauth_token", newJString(oauthToken))
  add(query_579050, "$.xgafv", newJString(Xgafv))
  add(query_579050, "alt", newJString(alt))
  add(query_579050, "uploadType", newJString(uploadType))
  add(query_579050, "quotaUser", newJString(quotaUser))
  add(path_579049, "subscription", newJString(subscription))
  add(query_579050, "callback", newJString(callback))
  add(query_579050, "fields", newJString(fields))
  add(query_579050, "access_token", newJString(accessToken))
  add(query_579050, "upload_protocol", newJString(uploadProtocol))
  result = call_579048.call(path_579049, query_579050, nil, nil, nil)

var pubsubSubscriptionsDelete* = Call_PubsubSubscriptionsDelete_579032(
    name: "pubsubSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com",
    route: "/v1beta1a/subscriptions/{subscription}",
    validator: validate_PubsubSubscriptionsDelete_579033, base: "/",
    url: url_PubsubSubscriptionsDelete_579034, schemes: {Scheme.Https})
type
  Call_PubsubTopicsCreate_579071 = ref object of OpenApiRestCall_578339
proc url_PubsubTopicsCreate_579073(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubTopicsCreate_579072(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates the given topic with the given name.
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
  var valid_579074 = query.getOrDefault("key")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "key", valid_579074
  var valid_579075 = query.getOrDefault("prettyPrint")
  valid_579075 = validateParameter(valid_579075, JBool, required = false,
                                 default = newJBool(true))
  if valid_579075 != nil:
    section.add "prettyPrint", valid_579075
  var valid_579076 = query.getOrDefault("oauth_token")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "oauth_token", valid_579076
  var valid_579077 = query.getOrDefault("$.xgafv")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = newJString("1"))
  if valid_579077 != nil:
    section.add "$.xgafv", valid_579077
  var valid_579078 = query.getOrDefault("alt")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = newJString("json"))
  if valid_579078 != nil:
    section.add "alt", valid_579078
  var valid_579079 = query.getOrDefault("uploadType")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "uploadType", valid_579079
  var valid_579080 = query.getOrDefault("quotaUser")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "quotaUser", valid_579080
  var valid_579081 = query.getOrDefault("callback")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "callback", valid_579081
  var valid_579082 = query.getOrDefault("fields")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "fields", valid_579082
  var valid_579083 = query.getOrDefault("access_token")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "access_token", valid_579083
  var valid_579084 = query.getOrDefault("upload_protocol")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "upload_protocol", valid_579084
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

proc call*(call_579086: Call_PubsubTopicsCreate_579071; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the given topic with the given name.
  ## 
  let valid = call_579086.validator(path, query, header, formData, body)
  let scheme = call_579086.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579086.url(scheme.get, call_579086.host, call_579086.base,
                         call_579086.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579086, url, valid)

proc call*(call_579087: Call_PubsubTopicsCreate_579071; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubTopicsCreate
  ## Creates the given topic with the given name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  var query_579088 = newJObject()
  var body_579089 = newJObject()
  add(query_579088, "key", newJString(key))
  add(query_579088, "prettyPrint", newJBool(prettyPrint))
  add(query_579088, "oauth_token", newJString(oauthToken))
  add(query_579088, "$.xgafv", newJString(Xgafv))
  add(query_579088, "alt", newJString(alt))
  add(query_579088, "uploadType", newJString(uploadType))
  add(query_579088, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579089 = body
  add(query_579088, "callback", newJString(callback))
  add(query_579088, "fields", newJString(fields))
  add(query_579088, "access_token", newJString(accessToken))
  add(query_579088, "upload_protocol", newJString(uploadProtocol))
  result = call_579087.call(nil, query_579088, nil, nil, body_579089)

var pubsubTopicsCreate* = Call_PubsubTopicsCreate_579071(
    name: "pubsubTopicsCreate", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/topics",
    validator: validate_PubsubTopicsCreate_579072, base: "/",
    url: url_PubsubTopicsCreate_579073, schemes: {Scheme.Https})
type
  Call_PubsubTopicsList_579051 = ref object of OpenApiRestCall_578339
proc url_PubsubTopicsList_579053(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubTopicsList_579052(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists matching topics.
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
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value obtained in the last <code>ListTopicsResponse</code>
  ## for continuation.
  ##   query: JString
  ##        : A valid label query expression.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxResults: JInt
  ##             : Maximum number of topics to return.
  section = newJObject()
  var valid_579054 = query.getOrDefault("key")
  valid_579054 = validateParameter(valid_579054, JString, required = false,
                                 default = nil)
  if valid_579054 != nil:
    section.add "key", valid_579054
  var valid_579055 = query.getOrDefault("prettyPrint")
  valid_579055 = validateParameter(valid_579055, JBool, required = false,
                                 default = newJBool(true))
  if valid_579055 != nil:
    section.add "prettyPrint", valid_579055
  var valid_579056 = query.getOrDefault("oauth_token")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = nil)
  if valid_579056 != nil:
    section.add "oauth_token", valid_579056
  var valid_579057 = query.getOrDefault("$.xgafv")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = newJString("1"))
  if valid_579057 != nil:
    section.add "$.xgafv", valid_579057
  var valid_579058 = query.getOrDefault("alt")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = newJString("json"))
  if valid_579058 != nil:
    section.add "alt", valid_579058
  var valid_579059 = query.getOrDefault("uploadType")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "uploadType", valid_579059
  var valid_579060 = query.getOrDefault("quotaUser")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "quotaUser", valid_579060
  var valid_579061 = query.getOrDefault("pageToken")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "pageToken", valid_579061
  var valid_579062 = query.getOrDefault("query")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "query", valid_579062
  var valid_579063 = query.getOrDefault("callback")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "callback", valid_579063
  var valid_579064 = query.getOrDefault("fields")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "fields", valid_579064
  var valid_579065 = query.getOrDefault("access_token")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "access_token", valid_579065
  var valid_579066 = query.getOrDefault("upload_protocol")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "upload_protocol", valid_579066
  var valid_579067 = query.getOrDefault("maxResults")
  valid_579067 = validateParameter(valid_579067, JInt, required = false, default = nil)
  if valid_579067 != nil:
    section.add "maxResults", valid_579067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579068: Call_PubsubTopicsList_579051; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matching topics.
  ## 
  let valid = call_579068.validator(path, query, header, formData, body)
  let scheme = call_579068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579068.url(scheme.get, call_579068.host, call_579068.base,
                         call_579068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579068, url, valid)

proc call*(call_579069: Call_PubsubTopicsList_579051; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; query: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          maxResults: int = 0): Recallable =
  ## pubsubTopicsList
  ## Lists matching topics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value obtained in the last <code>ListTopicsResponse</code>
  ## for continuation.
  ##   query: string
  ##        : A valid label query expression.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   maxResults: int
  ##             : Maximum number of topics to return.
  var query_579070 = newJObject()
  add(query_579070, "key", newJString(key))
  add(query_579070, "prettyPrint", newJBool(prettyPrint))
  add(query_579070, "oauth_token", newJString(oauthToken))
  add(query_579070, "$.xgafv", newJString(Xgafv))
  add(query_579070, "alt", newJString(alt))
  add(query_579070, "uploadType", newJString(uploadType))
  add(query_579070, "quotaUser", newJString(quotaUser))
  add(query_579070, "pageToken", newJString(pageToken))
  add(query_579070, "query", newJString(query))
  add(query_579070, "callback", newJString(callback))
  add(query_579070, "fields", newJString(fields))
  add(query_579070, "access_token", newJString(accessToken))
  add(query_579070, "upload_protocol", newJString(uploadProtocol))
  add(query_579070, "maxResults", newJInt(maxResults))
  result = call_579069.call(nil, query_579070, nil, nil, nil)

var pubsubTopicsList* = Call_PubsubTopicsList_579051(name: "pubsubTopicsList",
    meth: HttpMethod.HttpGet, host: "pubsub.googleapis.com",
    route: "/v1beta1a/topics", validator: validate_PubsubTopicsList_579052,
    base: "/", url: url_PubsubTopicsList_579053, schemes: {Scheme.Https})
type
  Call_PubsubTopicsPublish_579090 = ref object of OpenApiRestCall_578339
proc url_PubsubTopicsPublish_579092(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubTopicsPublish_579091(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Adds a message to the topic.  Returns NOT_FOUND if the topic does not
  ## exist.
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
  var valid_579093 = query.getOrDefault("key")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "key", valid_579093
  var valid_579094 = query.getOrDefault("prettyPrint")
  valid_579094 = validateParameter(valid_579094, JBool, required = false,
                                 default = newJBool(true))
  if valid_579094 != nil:
    section.add "prettyPrint", valid_579094
  var valid_579095 = query.getOrDefault("oauth_token")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "oauth_token", valid_579095
  var valid_579096 = query.getOrDefault("$.xgafv")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = newJString("1"))
  if valid_579096 != nil:
    section.add "$.xgafv", valid_579096
  var valid_579097 = query.getOrDefault("alt")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = newJString("json"))
  if valid_579097 != nil:
    section.add "alt", valid_579097
  var valid_579098 = query.getOrDefault("uploadType")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "uploadType", valid_579098
  var valid_579099 = query.getOrDefault("quotaUser")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "quotaUser", valid_579099
  var valid_579100 = query.getOrDefault("callback")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "callback", valid_579100
  var valid_579101 = query.getOrDefault("fields")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "fields", valid_579101
  var valid_579102 = query.getOrDefault("access_token")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "access_token", valid_579102
  var valid_579103 = query.getOrDefault("upload_protocol")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "upload_protocol", valid_579103
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

proc call*(call_579105: Call_PubsubTopicsPublish_579090; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a message to the topic.  Returns NOT_FOUND if the topic does not
  ## exist.
  ## 
  let valid = call_579105.validator(path, query, header, formData, body)
  let scheme = call_579105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579105.url(scheme.get, call_579105.host, call_579105.base,
                         call_579105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579105, url, valid)

proc call*(call_579106: Call_PubsubTopicsPublish_579090; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubTopicsPublish
  ## Adds a message to the topic.  Returns NOT_FOUND if the topic does not
  ## exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  var query_579107 = newJObject()
  var body_579108 = newJObject()
  add(query_579107, "key", newJString(key))
  add(query_579107, "prettyPrint", newJBool(prettyPrint))
  add(query_579107, "oauth_token", newJString(oauthToken))
  add(query_579107, "$.xgafv", newJString(Xgafv))
  add(query_579107, "alt", newJString(alt))
  add(query_579107, "uploadType", newJString(uploadType))
  add(query_579107, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579108 = body
  add(query_579107, "callback", newJString(callback))
  add(query_579107, "fields", newJString(fields))
  add(query_579107, "access_token", newJString(accessToken))
  add(query_579107, "upload_protocol", newJString(uploadProtocol))
  result = call_579106.call(nil, query_579107, nil, nil, body_579108)

var pubsubTopicsPublish* = Call_PubsubTopicsPublish_579090(
    name: "pubsubTopicsPublish", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/topics/publish",
    validator: validate_PubsubTopicsPublish_579091, base: "/",
    url: url_PubsubTopicsPublish_579092, schemes: {Scheme.Https})
type
  Call_PubsubTopicsPublishBatch_579109 = ref object of OpenApiRestCall_578339
proc url_PubsubTopicsPublishBatch_579111(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubTopicsPublishBatch_579110(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds one or more messages to the topic. Returns NOT_FOUND if the topic does
  ## not exist.
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
  var valid_579112 = query.getOrDefault("key")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "key", valid_579112
  var valid_579113 = query.getOrDefault("prettyPrint")
  valid_579113 = validateParameter(valid_579113, JBool, required = false,
                                 default = newJBool(true))
  if valid_579113 != nil:
    section.add "prettyPrint", valid_579113
  var valid_579114 = query.getOrDefault("oauth_token")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "oauth_token", valid_579114
  var valid_579115 = query.getOrDefault("$.xgafv")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = newJString("1"))
  if valid_579115 != nil:
    section.add "$.xgafv", valid_579115
  var valid_579116 = query.getOrDefault("alt")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = newJString("json"))
  if valid_579116 != nil:
    section.add "alt", valid_579116
  var valid_579117 = query.getOrDefault("uploadType")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "uploadType", valid_579117
  var valid_579118 = query.getOrDefault("quotaUser")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = nil)
  if valid_579118 != nil:
    section.add "quotaUser", valid_579118
  var valid_579119 = query.getOrDefault("callback")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "callback", valid_579119
  var valid_579120 = query.getOrDefault("fields")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "fields", valid_579120
  var valid_579121 = query.getOrDefault("access_token")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "access_token", valid_579121
  var valid_579122 = query.getOrDefault("upload_protocol")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "upload_protocol", valid_579122
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

proc call*(call_579124: Call_PubsubTopicsPublishBatch_579109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds one or more messages to the topic. Returns NOT_FOUND if the topic does
  ## not exist.
  ## 
  let valid = call_579124.validator(path, query, header, formData, body)
  let scheme = call_579124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579124.url(scheme.get, call_579124.host, call_579124.base,
                         call_579124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579124, url, valid)

proc call*(call_579125: Call_PubsubTopicsPublishBatch_579109; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubTopicsPublishBatch
  ## Adds one or more messages to the topic. Returns NOT_FOUND if the topic does
  ## not exist.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
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
  var query_579126 = newJObject()
  var body_579127 = newJObject()
  add(query_579126, "key", newJString(key))
  add(query_579126, "prettyPrint", newJBool(prettyPrint))
  add(query_579126, "oauth_token", newJString(oauthToken))
  add(query_579126, "$.xgafv", newJString(Xgafv))
  add(query_579126, "alt", newJString(alt))
  add(query_579126, "uploadType", newJString(uploadType))
  add(query_579126, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579127 = body
  add(query_579126, "callback", newJString(callback))
  add(query_579126, "fields", newJString(fields))
  add(query_579126, "access_token", newJString(accessToken))
  add(query_579126, "upload_protocol", newJString(uploadProtocol))
  result = call_579125.call(nil, query_579126, nil, nil, body_579127)

var pubsubTopicsPublishBatch* = Call_PubsubTopicsPublishBatch_579109(
    name: "pubsubTopicsPublishBatch", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/topics/publishBatch",
    validator: validate_PubsubTopicsPublishBatch_579110, base: "/",
    url: url_PubsubTopicsPublishBatch_579111, schemes: {Scheme.Https})
type
  Call_PubsubTopicsGet_579128 = ref object of OpenApiRestCall_578339
proc url_PubsubTopicsGet_579130(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1a/topics/"),
               (kind: VariableSegment, value: "topic")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubTopicsGet_579129(path: JsonNode; query: JsonNode;
                                    header: JsonNode; formData: JsonNode;
                                    body: JsonNode): JsonNode =
  ## Gets the configuration of a topic. Since the topic only has the name
  ## attribute, this method is only useful to check the existence of a topic.
  ## If other attributes are added in the future, they will be returned here.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : The name of the topic to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_579131 = path.getOrDefault("topic")
  valid_579131 = validateParameter(valid_579131, JString, required = true,
                                 default = nil)
  if valid_579131 != nil:
    section.add "topic", valid_579131
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
  var valid_579132 = query.getOrDefault("key")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "key", valid_579132
  var valid_579133 = query.getOrDefault("prettyPrint")
  valid_579133 = validateParameter(valid_579133, JBool, required = false,
                                 default = newJBool(true))
  if valid_579133 != nil:
    section.add "prettyPrint", valid_579133
  var valid_579134 = query.getOrDefault("oauth_token")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "oauth_token", valid_579134
  var valid_579135 = query.getOrDefault("$.xgafv")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = newJString("1"))
  if valid_579135 != nil:
    section.add "$.xgafv", valid_579135
  var valid_579136 = query.getOrDefault("alt")
  valid_579136 = validateParameter(valid_579136, JString, required = false,
                                 default = newJString("json"))
  if valid_579136 != nil:
    section.add "alt", valid_579136
  var valid_579137 = query.getOrDefault("uploadType")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "uploadType", valid_579137
  var valid_579138 = query.getOrDefault("quotaUser")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = nil)
  if valid_579138 != nil:
    section.add "quotaUser", valid_579138
  var valid_579139 = query.getOrDefault("callback")
  valid_579139 = validateParameter(valid_579139, JString, required = false,
                                 default = nil)
  if valid_579139 != nil:
    section.add "callback", valid_579139
  var valid_579140 = query.getOrDefault("fields")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = nil)
  if valid_579140 != nil:
    section.add "fields", valid_579140
  var valid_579141 = query.getOrDefault("access_token")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "access_token", valid_579141
  var valid_579142 = query.getOrDefault("upload_protocol")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "upload_protocol", valid_579142
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579143: Call_PubsubTopicsGet_579128; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration of a topic. Since the topic only has the name
  ## attribute, this method is only useful to check the existence of a topic.
  ## If other attributes are added in the future, they will be returned here.
  ## 
  let valid = call_579143.validator(path, query, header, formData, body)
  let scheme = call_579143.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579143.url(scheme.get, call_579143.host, call_579143.base,
                         call_579143.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579143, url, valid)

proc call*(call_579144: Call_PubsubTopicsGet_579128; topic: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; Xgafv: string = "1";
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## pubsubTopicsGet
  ## Gets the configuration of a topic. Since the topic only has the name
  ## attribute, this method is only useful to check the existence of a topic.
  ## If other attributes are added in the future, they will be returned here.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   topic: string (required)
  ##        : The name of the topic to get.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579145 = newJObject()
  var query_579146 = newJObject()
  add(query_579146, "key", newJString(key))
  add(query_579146, "prettyPrint", newJBool(prettyPrint))
  add(query_579146, "oauth_token", newJString(oauthToken))
  add(query_579146, "$.xgafv", newJString(Xgafv))
  add(query_579146, "alt", newJString(alt))
  add(query_579146, "uploadType", newJString(uploadType))
  add(query_579146, "quotaUser", newJString(quotaUser))
  add(path_579145, "topic", newJString(topic))
  add(query_579146, "callback", newJString(callback))
  add(query_579146, "fields", newJString(fields))
  add(query_579146, "access_token", newJString(accessToken))
  add(query_579146, "upload_protocol", newJString(uploadProtocol))
  result = call_579144.call(path_579145, query_579146, nil, nil, nil)

var pubsubTopicsGet* = Call_PubsubTopicsGet_579128(name: "pubsubTopicsGet",
    meth: HttpMethod.HttpGet, host: "pubsub.googleapis.com",
    route: "/v1beta1a/topics/{topic}", validator: validate_PubsubTopicsGet_579129,
    base: "/", url: url_PubsubTopicsGet_579130, schemes: {Scheme.Https})
type
  Call_PubsubTopicsDelete_579147 = ref object of OpenApiRestCall_578339
proc url_PubsubTopicsDelete_579149(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1a/topics/"),
               (kind: VariableSegment, value: "topic")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubTopicsDelete_579148(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Deletes the topic with the given name. Returns NOT_FOUND if the topic does
  ## not exist. After a topic is deleted, a new topic may be created with the
  ## same name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   topic: JString (required)
  ##        : Name of the topic to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `topic` field"
  var valid_579150 = path.getOrDefault("topic")
  valid_579150 = validateParameter(valid_579150, JString, required = true,
                                 default = nil)
  if valid_579150 != nil:
    section.add "topic", valid_579150
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
  var valid_579151 = query.getOrDefault("key")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "key", valid_579151
  var valid_579152 = query.getOrDefault("prettyPrint")
  valid_579152 = validateParameter(valid_579152, JBool, required = false,
                                 default = newJBool(true))
  if valid_579152 != nil:
    section.add "prettyPrint", valid_579152
  var valid_579153 = query.getOrDefault("oauth_token")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "oauth_token", valid_579153
  var valid_579154 = query.getOrDefault("$.xgafv")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = newJString("1"))
  if valid_579154 != nil:
    section.add "$.xgafv", valid_579154
  var valid_579155 = query.getOrDefault("alt")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = newJString("json"))
  if valid_579155 != nil:
    section.add "alt", valid_579155
  var valid_579156 = query.getOrDefault("uploadType")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "uploadType", valid_579156
  var valid_579157 = query.getOrDefault("quotaUser")
  valid_579157 = validateParameter(valid_579157, JString, required = false,
                                 default = nil)
  if valid_579157 != nil:
    section.add "quotaUser", valid_579157
  var valid_579158 = query.getOrDefault("callback")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "callback", valid_579158
  var valid_579159 = query.getOrDefault("fields")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "fields", valid_579159
  var valid_579160 = query.getOrDefault("access_token")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "access_token", valid_579160
  var valid_579161 = query.getOrDefault("upload_protocol")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "upload_protocol", valid_579161
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579162: Call_PubsubTopicsDelete_579147; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the topic with the given name. Returns NOT_FOUND if the topic does
  ## not exist. After a topic is deleted, a new topic may be created with the
  ## same name.
  ## 
  let valid = call_579162.validator(path, query, header, formData, body)
  let scheme = call_579162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579162.url(scheme.get, call_579162.host, call_579162.base,
                         call_579162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579162, url, valid)

proc call*(call_579163: Call_PubsubTopicsDelete_579147; topic: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## pubsubTopicsDelete
  ## Deletes the topic with the given name. Returns NOT_FOUND if the topic does
  ## not exist. After a topic is deleted, a new topic may be created with the
  ## same name.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   topic: string (required)
  ##        : Name of the topic to delete.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579164 = newJObject()
  var query_579165 = newJObject()
  add(query_579165, "key", newJString(key))
  add(query_579165, "prettyPrint", newJBool(prettyPrint))
  add(query_579165, "oauth_token", newJString(oauthToken))
  add(query_579165, "$.xgafv", newJString(Xgafv))
  add(query_579165, "alt", newJString(alt))
  add(query_579165, "uploadType", newJString(uploadType))
  add(query_579165, "quotaUser", newJString(quotaUser))
  add(path_579164, "topic", newJString(topic))
  add(query_579165, "callback", newJString(callback))
  add(query_579165, "fields", newJString(fields))
  add(query_579165, "access_token", newJString(accessToken))
  add(query_579165, "upload_protocol", newJString(uploadProtocol))
  result = call_579163.call(path_579164, query_579165, nil, nil, nil)

var pubsubTopicsDelete* = Call_PubsubTopicsDelete_579147(
    name: "pubsubTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1beta1a/topics/{topic}",
    validator: validate_PubsubTopicsDelete_579148, base: "/",
    url: url_PubsubTopicsDelete_579149, schemes: {Scheme.Https})
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
