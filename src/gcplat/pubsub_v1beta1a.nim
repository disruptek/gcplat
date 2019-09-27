
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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
  gcpServiceName = "pubsub"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PubsubSubscriptionsCreate_593952 = ref object of OpenApiRestCall_593408
proc url_PubsubSubscriptionsCreate_593954(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsCreate_593953(path: JsonNode; query: JsonNode;
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

proc call*(call_593967: Call_PubsubSubscriptionsCreate_593952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a subscription on a given topic for a given subscriber.
  ## If the subscription already exists, returns ALREADY_EXISTS.
  ## If the corresponding topic doesn't exist, returns NOT_FOUND.
  ## 
  ## If the name is not provided in the request, the server will assign a random
  ## name for this subscription on the same project as the topic.
  ## 
  let valid = call_593967.validator(path, query, header, formData, body)
  let scheme = call_593967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593967.url(scheme.get, call_593967.host, call_593967.base,
                         call_593967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593967, url, valid)

proc call*(call_593968: Call_PubsubSubscriptionsCreate_593952;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## pubsubSubscriptionsCreate
  ## Creates a subscription on a given topic for a given subscriber.
  ## If the subscription already exists, returns ALREADY_EXISTS.
  ## If the corresponding topic doesn't exist, returns NOT_FOUND.
  ## 
  ## If the name is not provided in the request, the server will assign a random
  ## name for this subscription on the same project as the topic.
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

var pubsubSubscriptionsCreate* = Call_PubsubSubscriptionsCreate_593952(
    name: "pubsubSubscriptionsCreate", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions",
    validator: validate_PubsubSubscriptionsCreate_593953, base: "/",
    url: url_PubsubSubscriptionsCreate_593954, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsList_593677 = ref object of OpenApiRestCall_593408
proc url_PubsubSubscriptionsList_593679(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsList_593678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists matching subscriptions.
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
  ##            : The value obtained in the last <code>ListSubscriptionsResponse</code>
  ## for continuation.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : A valid label query expression.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   maxResults: JInt
  ##             : Maximum number of subscriptions to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593791 = query.getOrDefault("upload_protocol")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "upload_protocol", valid_593791
  var valid_593792 = query.getOrDefault("fields")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "fields", valid_593792
  var valid_593793 = query.getOrDefault("pageToken")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "pageToken", valid_593793
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
  var valid_593809 = query.getOrDefault("query")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "query", valid_593809
  var valid_593810 = query.getOrDefault("oauth_token")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "oauth_token", valid_593810
  var valid_593811 = query.getOrDefault("callback")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "callback", valid_593811
  var valid_593812 = query.getOrDefault("access_token")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "access_token", valid_593812
  var valid_593813 = query.getOrDefault("uploadType")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "uploadType", valid_593813
  var valid_593814 = query.getOrDefault("maxResults")
  valid_593814 = validateParameter(valid_593814, JInt, required = false, default = nil)
  if valid_593814 != nil:
    section.add "maxResults", valid_593814
  var valid_593815 = query.getOrDefault("key")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = nil)
  if valid_593815 != nil:
    section.add "key", valid_593815
  var valid_593816 = query.getOrDefault("$.xgafv")
  valid_593816 = validateParameter(valid_593816, JString, required = false,
                                 default = newJString("1"))
  if valid_593816 != nil:
    section.add "$.xgafv", valid_593816
  var valid_593817 = query.getOrDefault("prettyPrint")
  valid_593817 = validateParameter(valid_593817, JBool, required = false,
                                 default = newJBool(true))
  if valid_593817 != nil:
    section.add "prettyPrint", valid_593817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593840: Call_PubsubSubscriptionsList_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matching subscriptions.
  ## 
  let valid = call_593840.validator(path, query, header, formData, body)
  let scheme = call_593840.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593840.url(scheme.get, call_593840.host, call_593840.base,
                         call_593840.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593840, url, valid)

proc call*(call_593911: Call_PubsubSubscriptionsList_593677;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; query: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; maxResults: int = 0; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## pubsubSubscriptionsList
  ## Lists matching subscriptions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value obtained in the last <code>ListSubscriptionsResponse</code>
  ## for continuation.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : A valid label query expression.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   maxResults: int
  ##             : Maximum number of subscriptions to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593912 = newJObject()
  add(query_593912, "upload_protocol", newJString(uploadProtocol))
  add(query_593912, "fields", newJString(fields))
  add(query_593912, "pageToken", newJString(pageToken))
  add(query_593912, "quotaUser", newJString(quotaUser))
  add(query_593912, "alt", newJString(alt))
  add(query_593912, "query", newJString(query))
  add(query_593912, "oauth_token", newJString(oauthToken))
  add(query_593912, "callback", newJString(callback))
  add(query_593912, "access_token", newJString(accessToken))
  add(query_593912, "uploadType", newJString(uploadType))
  add(query_593912, "maxResults", newJInt(maxResults))
  add(query_593912, "key", newJString(key))
  add(query_593912, "$.xgafv", newJString(Xgafv))
  add(query_593912, "prettyPrint", newJBool(prettyPrint))
  result = call_593911.call(nil, query_593912, nil, nil, nil)

var pubsubSubscriptionsList* = Call_PubsubSubscriptionsList_593677(
    name: "pubsubSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions",
    validator: validate_PubsubSubscriptionsList_593678, base: "/",
    url: url_PubsubSubscriptionsList_593679, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsAcknowledge_593971 = ref object of OpenApiRestCall_593408
proc url_PubsubSubscriptionsAcknowledge_593973(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsAcknowledge_593972(path: JsonNode;
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
  var valid_593974 = query.getOrDefault("upload_protocol")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "upload_protocol", valid_593974
  var valid_593975 = query.getOrDefault("fields")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "fields", valid_593975
  var valid_593976 = query.getOrDefault("quotaUser")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "quotaUser", valid_593976
  var valid_593977 = query.getOrDefault("alt")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = newJString("json"))
  if valid_593977 != nil:
    section.add "alt", valid_593977
  var valid_593978 = query.getOrDefault("oauth_token")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "oauth_token", valid_593978
  var valid_593979 = query.getOrDefault("callback")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = nil)
  if valid_593979 != nil:
    section.add "callback", valid_593979
  var valid_593980 = query.getOrDefault("access_token")
  valid_593980 = validateParameter(valid_593980, JString, required = false,
                                 default = nil)
  if valid_593980 != nil:
    section.add "access_token", valid_593980
  var valid_593981 = query.getOrDefault("uploadType")
  valid_593981 = validateParameter(valid_593981, JString, required = false,
                                 default = nil)
  if valid_593981 != nil:
    section.add "uploadType", valid_593981
  var valid_593982 = query.getOrDefault("key")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "key", valid_593982
  var valid_593983 = query.getOrDefault("$.xgafv")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = newJString("1"))
  if valid_593983 != nil:
    section.add "$.xgafv", valid_593983
  var valid_593984 = query.getOrDefault("prettyPrint")
  valid_593984 = validateParameter(valid_593984, JBool, required = false,
                                 default = newJBool(true))
  if valid_593984 != nil:
    section.add "prettyPrint", valid_593984
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

proc call*(call_593986: Call_PubsubSubscriptionsAcknowledge_593971; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Acknowledges a particular received message: the Pub/Sub system can remove
  ## the given message from the subscription. Acknowledging a message whose
  ## Ack deadline has expired may succeed, but the message could have been
  ## already redelivered. Acknowledging a message more than once will not
  ## result in an error. This is only used for messages received via pull.
  ## 
  let valid = call_593986.validator(path, query, header, formData, body)
  let scheme = call_593986.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593986.url(scheme.get, call_593986.host, call_593986.base,
                         call_593986.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593986, url, valid)

proc call*(call_593987: Call_PubsubSubscriptionsAcknowledge_593971;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## pubsubSubscriptionsAcknowledge
  ## Acknowledges a particular received message: the Pub/Sub system can remove
  ## the given message from the subscription. Acknowledging a message whose
  ## Ack deadline has expired may succeed, but the message could have been
  ## already redelivered. Acknowledging a message more than once will not
  ## result in an error. This is only used for messages received via pull.
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
  var query_593988 = newJObject()
  var body_593989 = newJObject()
  add(query_593988, "upload_protocol", newJString(uploadProtocol))
  add(query_593988, "fields", newJString(fields))
  add(query_593988, "quotaUser", newJString(quotaUser))
  add(query_593988, "alt", newJString(alt))
  add(query_593988, "oauth_token", newJString(oauthToken))
  add(query_593988, "callback", newJString(callback))
  add(query_593988, "access_token", newJString(accessToken))
  add(query_593988, "uploadType", newJString(uploadType))
  add(query_593988, "key", newJString(key))
  add(query_593988, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593989 = body
  add(query_593988, "prettyPrint", newJBool(prettyPrint))
  result = call_593987.call(nil, query_593988, nil, nil, body_593989)

var pubsubSubscriptionsAcknowledge* = Call_PubsubSubscriptionsAcknowledge_593971(
    name: "pubsubSubscriptionsAcknowledge", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions/acknowledge",
    validator: validate_PubsubSubscriptionsAcknowledge_593972, base: "/",
    url: url_PubsubSubscriptionsAcknowledge_593973, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsModifyAckDeadline_593990 = ref object of OpenApiRestCall_593408
proc url_PubsubSubscriptionsModifyAckDeadline_593992(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsModifyAckDeadline_593991(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the Ack deadline for a message received from a pull request.
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
  var valid_593993 = query.getOrDefault("upload_protocol")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "upload_protocol", valid_593993
  var valid_593994 = query.getOrDefault("fields")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "fields", valid_593994
  var valid_593995 = query.getOrDefault("quotaUser")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "quotaUser", valid_593995
  var valid_593996 = query.getOrDefault("alt")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = newJString("json"))
  if valid_593996 != nil:
    section.add "alt", valid_593996
  var valid_593997 = query.getOrDefault("oauth_token")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "oauth_token", valid_593997
  var valid_593998 = query.getOrDefault("callback")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "callback", valid_593998
  var valid_593999 = query.getOrDefault("access_token")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "access_token", valid_593999
  var valid_594000 = query.getOrDefault("uploadType")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "uploadType", valid_594000
  var valid_594001 = query.getOrDefault("key")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "key", valid_594001
  var valid_594002 = query.getOrDefault("$.xgafv")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = newJString("1"))
  if valid_594002 != nil:
    section.add "$.xgafv", valid_594002
  var valid_594003 = query.getOrDefault("prettyPrint")
  valid_594003 = validateParameter(valid_594003, JBool, required = false,
                                 default = newJBool(true))
  if valid_594003 != nil:
    section.add "prettyPrint", valid_594003
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

proc call*(call_594005: Call_PubsubSubscriptionsModifyAckDeadline_593990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the Ack deadline for a message received from a pull request.
  ## 
  let valid = call_594005.validator(path, query, header, formData, body)
  let scheme = call_594005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594005.url(scheme.get, call_594005.host, call_594005.base,
                         call_594005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594005, url, valid)

proc call*(call_594006: Call_PubsubSubscriptionsModifyAckDeadline_593990;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## pubsubSubscriptionsModifyAckDeadline
  ## Modifies the Ack deadline for a message received from a pull request.
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
  var query_594007 = newJObject()
  var body_594008 = newJObject()
  add(query_594007, "upload_protocol", newJString(uploadProtocol))
  add(query_594007, "fields", newJString(fields))
  add(query_594007, "quotaUser", newJString(quotaUser))
  add(query_594007, "alt", newJString(alt))
  add(query_594007, "oauth_token", newJString(oauthToken))
  add(query_594007, "callback", newJString(callback))
  add(query_594007, "access_token", newJString(accessToken))
  add(query_594007, "uploadType", newJString(uploadType))
  add(query_594007, "key", newJString(key))
  add(query_594007, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594008 = body
  add(query_594007, "prettyPrint", newJBool(prettyPrint))
  result = call_594006.call(nil, query_594007, nil, nil, body_594008)

var pubsubSubscriptionsModifyAckDeadline* = Call_PubsubSubscriptionsModifyAckDeadline_593990(
    name: "pubsubSubscriptionsModifyAckDeadline", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com",
    route: "/v1beta1a/subscriptions/modifyAckDeadline",
    validator: validate_PubsubSubscriptionsModifyAckDeadline_593991, base: "/",
    url: url_PubsubSubscriptionsModifyAckDeadline_593992, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsModifyPushConfig_594009 = ref object of OpenApiRestCall_593408
proc url_PubsubSubscriptionsModifyPushConfig_594011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsModifyPushConfig_594010(path: JsonNode;
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
  var valid_594012 = query.getOrDefault("upload_protocol")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "upload_protocol", valid_594012
  var valid_594013 = query.getOrDefault("fields")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "fields", valid_594013
  var valid_594014 = query.getOrDefault("quotaUser")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "quotaUser", valid_594014
  var valid_594015 = query.getOrDefault("alt")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = newJString("json"))
  if valid_594015 != nil:
    section.add "alt", valid_594015
  var valid_594016 = query.getOrDefault("oauth_token")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "oauth_token", valid_594016
  var valid_594017 = query.getOrDefault("callback")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "callback", valid_594017
  var valid_594018 = query.getOrDefault("access_token")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "access_token", valid_594018
  var valid_594019 = query.getOrDefault("uploadType")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "uploadType", valid_594019
  var valid_594020 = query.getOrDefault("key")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "key", valid_594020
  var valid_594021 = query.getOrDefault("$.xgafv")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = newJString("1"))
  if valid_594021 != nil:
    section.add "$.xgafv", valid_594021
  var valid_594022 = query.getOrDefault("prettyPrint")
  valid_594022 = validateParameter(valid_594022, JBool, required = false,
                                 default = newJBool(true))
  if valid_594022 != nil:
    section.add "prettyPrint", valid_594022
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

proc call*(call_594024: Call_PubsubSubscriptionsModifyPushConfig_594009;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the <code>PushConfig</code> for a specified subscription.
  ## This method can be used to suspend the flow of messages to an endpoint
  ## by clearing the <code>PushConfig</code> field in the request. Messages
  ## will be accumulated for delivery even if no push configuration is
  ## defined or while the configuration is modified.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_PubsubSubscriptionsModifyPushConfig_594009;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## pubsubSubscriptionsModifyPushConfig
  ## Modifies the <code>PushConfig</code> for a specified subscription.
  ## This method can be used to suspend the flow of messages to an endpoint
  ## by clearing the <code>PushConfig</code> field in the request. Messages
  ## will be accumulated for delivery even if no push configuration is
  ## defined or while the configuration is modified.
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
  var query_594026 = newJObject()
  var body_594027 = newJObject()
  add(query_594026, "upload_protocol", newJString(uploadProtocol))
  add(query_594026, "fields", newJString(fields))
  add(query_594026, "quotaUser", newJString(quotaUser))
  add(query_594026, "alt", newJString(alt))
  add(query_594026, "oauth_token", newJString(oauthToken))
  add(query_594026, "callback", newJString(callback))
  add(query_594026, "access_token", newJString(accessToken))
  add(query_594026, "uploadType", newJString(uploadType))
  add(query_594026, "key", newJString(key))
  add(query_594026, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594027 = body
  add(query_594026, "prettyPrint", newJBool(prettyPrint))
  result = call_594025.call(nil, query_594026, nil, nil, body_594027)

var pubsubSubscriptionsModifyPushConfig* = Call_PubsubSubscriptionsModifyPushConfig_594009(
    name: "pubsubSubscriptionsModifyPushConfig", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com",
    route: "/v1beta1a/subscriptions/modifyPushConfig",
    validator: validate_PubsubSubscriptionsModifyPushConfig_594010, base: "/",
    url: url_PubsubSubscriptionsModifyPushConfig_594011, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsPull_594028 = ref object of OpenApiRestCall_593408
proc url_PubsubSubscriptionsPull_594030(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsPull_594029(path: JsonNode; query: JsonNode;
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
  var valid_594031 = query.getOrDefault("upload_protocol")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "upload_protocol", valid_594031
  var valid_594032 = query.getOrDefault("fields")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "fields", valid_594032
  var valid_594033 = query.getOrDefault("quotaUser")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "quotaUser", valid_594033
  var valid_594034 = query.getOrDefault("alt")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = newJString("json"))
  if valid_594034 != nil:
    section.add "alt", valid_594034
  var valid_594035 = query.getOrDefault("oauth_token")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "oauth_token", valid_594035
  var valid_594036 = query.getOrDefault("callback")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "callback", valid_594036
  var valid_594037 = query.getOrDefault("access_token")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "access_token", valid_594037
  var valid_594038 = query.getOrDefault("uploadType")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "uploadType", valid_594038
  var valid_594039 = query.getOrDefault("key")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "key", valid_594039
  var valid_594040 = query.getOrDefault("$.xgafv")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = newJString("1"))
  if valid_594040 != nil:
    section.add "$.xgafv", valid_594040
  var valid_594041 = query.getOrDefault("prettyPrint")
  valid_594041 = validateParameter(valid_594041, JBool, required = false,
                                 default = newJBool(true))
  if valid_594041 != nil:
    section.add "prettyPrint", valid_594041
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

proc call*(call_594043: Call_PubsubSubscriptionsPull_594028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pulls a single message from the server.
  ## If return_immediately is true, and no messages are available in the
  ## subscription, this method returns FAILED_PRECONDITION. The system is free
  ## to return an UNAVAILABLE error if no messages are available in a
  ## reasonable amount of time (to reduce system load).
  ## 
  let valid = call_594043.validator(path, query, header, formData, body)
  let scheme = call_594043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594043.url(scheme.get, call_594043.host, call_594043.base,
                         call_594043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594043, url, valid)

proc call*(call_594044: Call_PubsubSubscriptionsPull_594028;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## pubsubSubscriptionsPull
  ## Pulls a single message from the server.
  ## If return_immediately is true, and no messages are available in the
  ## subscription, this method returns FAILED_PRECONDITION. The system is free
  ## to return an UNAVAILABLE error if no messages are available in a
  ## reasonable amount of time (to reduce system load).
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
  var query_594045 = newJObject()
  var body_594046 = newJObject()
  add(query_594045, "upload_protocol", newJString(uploadProtocol))
  add(query_594045, "fields", newJString(fields))
  add(query_594045, "quotaUser", newJString(quotaUser))
  add(query_594045, "alt", newJString(alt))
  add(query_594045, "oauth_token", newJString(oauthToken))
  add(query_594045, "callback", newJString(callback))
  add(query_594045, "access_token", newJString(accessToken))
  add(query_594045, "uploadType", newJString(uploadType))
  add(query_594045, "key", newJString(key))
  add(query_594045, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594046 = body
  add(query_594045, "prettyPrint", newJBool(prettyPrint))
  result = call_594044.call(nil, query_594045, nil, nil, body_594046)

var pubsubSubscriptionsPull* = Call_PubsubSubscriptionsPull_594028(
    name: "pubsubSubscriptionsPull", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions/pull",
    validator: validate_PubsubSubscriptionsPull_594029, base: "/",
    url: url_PubsubSubscriptionsPull_594030, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsPullBatch_594047 = ref object of OpenApiRestCall_593408
proc url_PubsubSubscriptionsPullBatch_594049(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsPullBatch_594048(path: JsonNode; query: JsonNode;
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
  var valid_594050 = query.getOrDefault("upload_protocol")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "upload_protocol", valid_594050
  var valid_594051 = query.getOrDefault("fields")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "fields", valid_594051
  var valid_594052 = query.getOrDefault("quotaUser")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "quotaUser", valid_594052
  var valid_594053 = query.getOrDefault("alt")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = newJString("json"))
  if valid_594053 != nil:
    section.add "alt", valid_594053
  var valid_594054 = query.getOrDefault("oauth_token")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "oauth_token", valid_594054
  var valid_594055 = query.getOrDefault("callback")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "callback", valid_594055
  var valid_594056 = query.getOrDefault("access_token")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "access_token", valid_594056
  var valid_594057 = query.getOrDefault("uploadType")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "uploadType", valid_594057
  var valid_594058 = query.getOrDefault("key")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "key", valid_594058
  var valid_594059 = query.getOrDefault("$.xgafv")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = newJString("1"))
  if valid_594059 != nil:
    section.add "$.xgafv", valid_594059
  var valid_594060 = query.getOrDefault("prettyPrint")
  valid_594060 = validateParameter(valid_594060, JBool, required = false,
                                 default = newJBool(true))
  if valid_594060 != nil:
    section.add "prettyPrint", valid_594060
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

proc call*(call_594062: Call_PubsubSubscriptionsPullBatch_594047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pulls messages from the server. Returns an empty list if there are no
  ## messages available in the backlog. The system is free to return UNAVAILABLE
  ## if there are too many pull requests outstanding for the given subscription.
  ## 
  let valid = call_594062.validator(path, query, header, formData, body)
  let scheme = call_594062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594062.url(scheme.get, call_594062.host, call_594062.base,
                         call_594062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594062, url, valid)

proc call*(call_594063: Call_PubsubSubscriptionsPullBatch_594047;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## pubsubSubscriptionsPullBatch
  ## Pulls messages from the server. Returns an empty list if there are no
  ## messages available in the backlog. The system is free to return UNAVAILABLE
  ## if there are too many pull requests outstanding for the given subscription.
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
  var query_594064 = newJObject()
  var body_594065 = newJObject()
  add(query_594064, "upload_protocol", newJString(uploadProtocol))
  add(query_594064, "fields", newJString(fields))
  add(query_594064, "quotaUser", newJString(quotaUser))
  add(query_594064, "alt", newJString(alt))
  add(query_594064, "oauth_token", newJString(oauthToken))
  add(query_594064, "callback", newJString(callback))
  add(query_594064, "access_token", newJString(accessToken))
  add(query_594064, "uploadType", newJString(uploadType))
  add(query_594064, "key", newJString(key))
  add(query_594064, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594065 = body
  add(query_594064, "prettyPrint", newJBool(prettyPrint))
  result = call_594063.call(nil, query_594064, nil, nil, body_594065)

var pubsubSubscriptionsPullBatch* = Call_PubsubSubscriptionsPullBatch_594047(
    name: "pubsubSubscriptionsPullBatch", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions/pullBatch",
    validator: validate_PubsubSubscriptionsPullBatch_594048, base: "/",
    url: url_PubsubSubscriptionsPullBatch_594049, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsGet_594066 = ref object of OpenApiRestCall_593408
proc url_PubsubSubscriptionsGet_594068(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1a/subscriptions/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubSubscriptionsGet_594067(path: JsonNode; query: JsonNode;
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
  var valid_594083 = path.getOrDefault("subscription")
  valid_594083 = validateParameter(valid_594083, JString, required = true,
                                 default = nil)
  if valid_594083 != nil:
    section.add "subscription", valid_594083
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
  var valid_594084 = query.getOrDefault("upload_protocol")
  valid_594084 = validateParameter(valid_594084, JString, required = false,
                                 default = nil)
  if valid_594084 != nil:
    section.add "upload_protocol", valid_594084
  var valid_594085 = query.getOrDefault("fields")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "fields", valid_594085
  var valid_594086 = query.getOrDefault("quotaUser")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "quotaUser", valid_594086
  var valid_594087 = query.getOrDefault("alt")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = newJString("json"))
  if valid_594087 != nil:
    section.add "alt", valid_594087
  var valid_594088 = query.getOrDefault("oauth_token")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "oauth_token", valid_594088
  var valid_594089 = query.getOrDefault("callback")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "callback", valid_594089
  var valid_594090 = query.getOrDefault("access_token")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "access_token", valid_594090
  var valid_594091 = query.getOrDefault("uploadType")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "uploadType", valid_594091
  var valid_594092 = query.getOrDefault("key")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "key", valid_594092
  var valid_594093 = query.getOrDefault("$.xgafv")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = newJString("1"))
  if valid_594093 != nil:
    section.add "$.xgafv", valid_594093
  var valid_594094 = query.getOrDefault("prettyPrint")
  valid_594094 = validateParameter(valid_594094, JBool, required = false,
                                 default = newJBool(true))
  if valid_594094 != nil:
    section.add "prettyPrint", valid_594094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594095: Call_PubsubSubscriptionsGet_594066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of a subscription.
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_PubsubSubscriptionsGet_594066; subscription: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## pubsubSubscriptionsGet
  ## Gets the configuration details of a subscription.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   subscription: string (required)
  ##               : The name of the subscription to get.
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
  var path_594097 = newJObject()
  var query_594098 = newJObject()
  add(query_594098, "upload_protocol", newJString(uploadProtocol))
  add(query_594098, "fields", newJString(fields))
  add(query_594098, "quotaUser", newJString(quotaUser))
  add(path_594097, "subscription", newJString(subscription))
  add(query_594098, "alt", newJString(alt))
  add(query_594098, "oauth_token", newJString(oauthToken))
  add(query_594098, "callback", newJString(callback))
  add(query_594098, "access_token", newJString(accessToken))
  add(query_594098, "uploadType", newJString(uploadType))
  add(query_594098, "key", newJString(key))
  add(query_594098, "$.xgafv", newJString(Xgafv))
  add(query_594098, "prettyPrint", newJBool(prettyPrint))
  result = call_594096.call(path_594097, query_594098, nil, nil, nil)

var pubsubSubscriptionsGet* = Call_PubsubSubscriptionsGet_594066(
    name: "pubsubSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com",
    route: "/v1beta1a/subscriptions/{subscription}",
    validator: validate_PubsubSubscriptionsGet_594067, base: "/",
    url: url_PubsubSubscriptionsGet_594068, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsDelete_594099 = ref object of OpenApiRestCall_593408
proc url_PubsubSubscriptionsDelete_594101(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "subscription" in path, "`subscription` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1a/subscriptions/"),
               (kind: VariableSegment, value: "subscription")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubSubscriptionsDelete_594100(path: JsonNode; query: JsonNode;
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
  var valid_594102 = path.getOrDefault("subscription")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "subscription", valid_594102
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
  var valid_594103 = query.getOrDefault("upload_protocol")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "upload_protocol", valid_594103
  var valid_594104 = query.getOrDefault("fields")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "fields", valid_594104
  var valid_594105 = query.getOrDefault("quotaUser")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "quotaUser", valid_594105
  var valid_594106 = query.getOrDefault("alt")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = newJString("json"))
  if valid_594106 != nil:
    section.add "alt", valid_594106
  var valid_594107 = query.getOrDefault("oauth_token")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "oauth_token", valid_594107
  var valid_594108 = query.getOrDefault("callback")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "callback", valid_594108
  var valid_594109 = query.getOrDefault("access_token")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "access_token", valid_594109
  var valid_594110 = query.getOrDefault("uploadType")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "uploadType", valid_594110
  var valid_594111 = query.getOrDefault("key")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "key", valid_594111
  var valid_594112 = query.getOrDefault("$.xgafv")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = newJString("1"))
  if valid_594112 != nil:
    section.add "$.xgafv", valid_594112
  var valid_594113 = query.getOrDefault("prettyPrint")
  valid_594113 = validateParameter(valid_594113, JBool, required = false,
                                 default = newJBool(true))
  if valid_594113 != nil:
    section.add "prettyPrint", valid_594113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594114: Call_PubsubSubscriptionsDelete_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing subscription. All pending messages in the subscription
  ## are immediately dropped. Calls to Pull after deletion will return
  ## NOT_FOUND.
  ## 
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_PubsubSubscriptionsDelete_594099;
          subscription: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## pubsubSubscriptionsDelete
  ## Deletes an existing subscription. All pending messages in the subscription
  ## are immediately dropped. Calls to Pull after deletion will return
  ## NOT_FOUND.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   subscription: string (required)
  ##               : The subscription to delete.
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
  var path_594116 = newJObject()
  var query_594117 = newJObject()
  add(query_594117, "upload_protocol", newJString(uploadProtocol))
  add(query_594117, "fields", newJString(fields))
  add(query_594117, "quotaUser", newJString(quotaUser))
  add(path_594116, "subscription", newJString(subscription))
  add(query_594117, "alt", newJString(alt))
  add(query_594117, "oauth_token", newJString(oauthToken))
  add(query_594117, "callback", newJString(callback))
  add(query_594117, "access_token", newJString(accessToken))
  add(query_594117, "uploadType", newJString(uploadType))
  add(query_594117, "key", newJString(key))
  add(query_594117, "$.xgafv", newJString(Xgafv))
  add(query_594117, "prettyPrint", newJBool(prettyPrint))
  result = call_594115.call(path_594116, query_594117, nil, nil, nil)

var pubsubSubscriptionsDelete* = Call_PubsubSubscriptionsDelete_594099(
    name: "pubsubSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com",
    route: "/v1beta1a/subscriptions/{subscription}",
    validator: validate_PubsubSubscriptionsDelete_594100, base: "/",
    url: url_PubsubSubscriptionsDelete_594101, schemes: {Scheme.Https})
type
  Call_PubsubTopicsCreate_594138 = ref object of OpenApiRestCall_593408
proc url_PubsubTopicsCreate_594140(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PubsubTopicsCreate_594139(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Creates the given topic with the given name.
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
  var valid_594141 = query.getOrDefault("upload_protocol")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "upload_protocol", valid_594141
  var valid_594142 = query.getOrDefault("fields")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "fields", valid_594142
  var valid_594143 = query.getOrDefault("quotaUser")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "quotaUser", valid_594143
  var valid_594144 = query.getOrDefault("alt")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = newJString("json"))
  if valid_594144 != nil:
    section.add "alt", valid_594144
  var valid_594145 = query.getOrDefault("oauth_token")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "oauth_token", valid_594145
  var valid_594146 = query.getOrDefault("callback")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "callback", valid_594146
  var valid_594147 = query.getOrDefault("access_token")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "access_token", valid_594147
  var valid_594148 = query.getOrDefault("uploadType")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "uploadType", valid_594148
  var valid_594149 = query.getOrDefault("key")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "key", valid_594149
  var valid_594150 = query.getOrDefault("$.xgafv")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = newJString("1"))
  if valid_594150 != nil:
    section.add "$.xgafv", valid_594150
  var valid_594151 = query.getOrDefault("prettyPrint")
  valid_594151 = validateParameter(valid_594151, JBool, required = false,
                                 default = newJBool(true))
  if valid_594151 != nil:
    section.add "prettyPrint", valid_594151
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

proc call*(call_594153: Call_PubsubTopicsCreate_594138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the given topic with the given name.
  ## 
  let valid = call_594153.validator(path, query, header, formData, body)
  let scheme = call_594153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594153.url(scheme.get, call_594153.host, call_594153.base,
                         call_594153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594153, url, valid)

proc call*(call_594154: Call_PubsubTopicsCreate_594138;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## pubsubTopicsCreate
  ## Creates the given topic with the given name.
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
  var query_594155 = newJObject()
  var body_594156 = newJObject()
  add(query_594155, "upload_protocol", newJString(uploadProtocol))
  add(query_594155, "fields", newJString(fields))
  add(query_594155, "quotaUser", newJString(quotaUser))
  add(query_594155, "alt", newJString(alt))
  add(query_594155, "oauth_token", newJString(oauthToken))
  add(query_594155, "callback", newJString(callback))
  add(query_594155, "access_token", newJString(accessToken))
  add(query_594155, "uploadType", newJString(uploadType))
  add(query_594155, "key", newJString(key))
  add(query_594155, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594156 = body
  add(query_594155, "prettyPrint", newJBool(prettyPrint))
  result = call_594154.call(nil, query_594155, nil, nil, body_594156)

var pubsubTopicsCreate* = Call_PubsubTopicsCreate_594138(
    name: "pubsubTopicsCreate", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/topics",
    validator: validate_PubsubTopicsCreate_594139, base: "/",
    url: url_PubsubTopicsCreate_594140, schemes: {Scheme.Https})
type
  Call_PubsubTopicsList_594118 = ref object of OpenApiRestCall_593408
proc url_PubsubTopicsList_594120(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PubsubTopicsList_594119(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Lists matching topics.
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
  ##            : The value obtained in the last <code>ListTopicsResponse</code>
  ## for continuation.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   query: JString
  ##        : A valid label query expression.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   maxResults: JInt
  ##             : Maximum number of topics to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594121 = query.getOrDefault("upload_protocol")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "upload_protocol", valid_594121
  var valid_594122 = query.getOrDefault("fields")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "fields", valid_594122
  var valid_594123 = query.getOrDefault("pageToken")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "pageToken", valid_594123
  var valid_594124 = query.getOrDefault("quotaUser")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "quotaUser", valid_594124
  var valid_594125 = query.getOrDefault("alt")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = newJString("json"))
  if valid_594125 != nil:
    section.add "alt", valid_594125
  var valid_594126 = query.getOrDefault("query")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "query", valid_594126
  var valid_594127 = query.getOrDefault("oauth_token")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "oauth_token", valid_594127
  var valid_594128 = query.getOrDefault("callback")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "callback", valid_594128
  var valid_594129 = query.getOrDefault("access_token")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "access_token", valid_594129
  var valid_594130 = query.getOrDefault("uploadType")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "uploadType", valid_594130
  var valid_594131 = query.getOrDefault("maxResults")
  valid_594131 = validateParameter(valid_594131, JInt, required = false, default = nil)
  if valid_594131 != nil:
    section.add "maxResults", valid_594131
  var valid_594132 = query.getOrDefault("key")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "key", valid_594132
  var valid_594133 = query.getOrDefault("$.xgafv")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = newJString("1"))
  if valid_594133 != nil:
    section.add "$.xgafv", valid_594133
  var valid_594134 = query.getOrDefault("prettyPrint")
  valid_594134 = validateParameter(valid_594134, JBool, required = false,
                                 default = newJBool(true))
  if valid_594134 != nil:
    section.add "prettyPrint", valid_594134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594135: Call_PubsubTopicsList_594118; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matching topics.
  ## 
  let valid = call_594135.validator(path, query, header, formData, body)
  let scheme = call_594135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594135.url(scheme.get, call_594135.host, call_594135.base,
                         call_594135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594135, url, valid)

proc call*(call_594136: Call_PubsubTopicsList_594118; uploadProtocol: string = "";
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; query: string = ""; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          maxResults: int = 0; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## pubsubTopicsList
  ## Lists matching topics.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The value obtained in the last <code>ListTopicsResponse</code>
  ## for continuation.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   query: string
  ##        : A valid label query expression.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   maxResults: int
  ##             : Maximum number of topics to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594137 = newJObject()
  add(query_594137, "upload_protocol", newJString(uploadProtocol))
  add(query_594137, "fields", newJString(fields))
  add(query_594137, "pageToken", newJString(pageToken))
  add(query_594137, "quotaUser", newJString(quotaUser))
  add(query_594137, "alt", newJString(alt))
  add(query_594137, "query", newJString(query))
  add(query_594137, "oauth_token", newJString(oauthToken))
  add(query_594137, "callback", newJString(callback))
  add(query_594137, "access_token", newJString(accessToken))
  add(query_594137, "uploadType", newJString(uploadType))
  add(query_594137, "maxResults", newJInt(maxResults))
  add(query_594137, "key", newJString(key))
  add(query_594137, "$.xgafv", newJString(Xgafv))
  add(query_594137, "prettyPrint", newJBool(prettyPrint))
  result = call_594136.call(nil, query_594137, nil, nil, nil)

var pubsubTopicsList* = Call_PubsubTopicsList_594118(name: "pubsubTopicsList",
    meth: HttpMethod.HttpGet, host: "pubsub.googleapis.com",
    route: "/v1beta1a/topics", validator: validate_PubsubTopicsList_594119,
    base: "/", url: url_PubsubTopicsList_594120, schemes: {Scheme.Https})
type
  Call_PubsubTopicsPublish_594157 = ref object of OpenApiRestCall_593408
proc url_PubsubTopicsPublish_594159(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PubsubTopicsPublish_594158(path: JsonNode; query: JsonNode;
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
  var valid_594160 = query.getOrDefault("upload_protocol")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "upload_protocol", valid_594160
  var valid_594161 = query.getOrDefault("fields")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "fields", valid_594161
  var valid_594162 = query.getOrDefault("quotaUser")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "quotaUser", valid_594162
  var valid_594163 = query.getOrDefault("alt")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = newJString("json"))
  if valid_594163 != nil:
    section.add "alt", valid_594163
  var valid_594164 = query.getOrDefault("oauth_token")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "oauth_token", valid_594164
  var valid_594165 = query.getOrDefault("callback")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "callback", valid_594165
  var valid_594166 = query.getOrDefault("access_token")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "access_token", valid_594166
  var valid_594167 = query.getOrDefault("uploadType")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "uploadType", valid_594167
  var valid_594168 = query.getOrDefault("key")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = nil)
  if valid_594168 != nil:
    section.add "key", valid_594168
  var valid_594169 = query.getOrDefault("$.xgafv")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = newJString("1"))
  if valid_594169 != nil:
    section.add "$.xgafv", valid_594169
  var valid_594170 = query.getOrDefault("prettyPrint")
  valid_594170 = validateParameter(valid_594170, JBool, required = false,
                                 default = newJBool(true))
  if valid_594170 != nil:
    section.add "prettyPrint", valid_594170
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

proc call*(call_594172: Call_PubsubTopicsPublish_594157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a message to the topic.  Returns NOT_FOUND if the topic does not
  ## exist.
  ## 
  let valid = call_594172.validator(path, query, header, formData, body)
  let scheme = call_594172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594172.url(scheme.get, call_594172.host, call_594172.base,
                         call_594172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594172, url, valid)

proc call*(call_594173: Call_PubsubTopicsPublish_594157;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## pubsubTopicsPublish
  ## Adds a message to the topic.  Returns NOT_FOUND if the topic does not
  ## exist.
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
  var query_594174 = newJObject()
  var body_594175 = newJObject()
  add(query_594174, "upload_protocol", newJString(uploadProtocol))
  add(query_594174, "fields", newJString(fields))
  add(query_594174, "quotaUser", newJString(quotaUser))
  add(query_594174, "alt", newJString(alt))
  add(query_594174, "oauth_token", newJString(oauthToken))
  add(query_594174, "callback", newJString(callback))
  add(query_594174, "access_token", newJString(accessToken))
  add(query_594174, "uploadType", newJString(uploadType))
  add(query_594174, "key", newJString(key))
  add(query_594174, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594175 = body
  add(query_594174, "prettyPrint", newJBool(prettyPrint))
  result = call_594173.call(nil, query_594174, nil, nil, body_594175)

var pubsubTopicsPublish* = Call_PubsubTopicsPublish_594157(
    name: "pubsubTopicsPublish", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/topics/publish",
    validator: validate_PubsubTopicsPublish_594158, base: "/",
    url: url_PubsubTopicsPublish_594159, schemes: {Scheme.Https})
type
  Call_PubsubTopicsPublishBatch_594176 = ref object of OpenApiRestCall_593408
proc url_PubsubTopicsPublishBatch_594178(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_PubsubTopicsPublishBatch_594177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds one or more messages to the topic. Returns NOT_FOUND if the topic does
  ## not exist.
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
  var valid_594179 = query.getOrDefault("upload_protocol")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "upload_protocol", valid_594179
  var valid_594180 = query.getOrDefault("fields")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "fields", valid_594180
  var valid_594181 = query.getOrDefault("quotaUser")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "quotaUser", valid_594181
  var valid_594182 = query.getOrDefault("alt")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = newJString("json"))
  if valid_594182 != nil:
    section.add "alt", valid_594182
  var valid_594183 = query.getOrDefault("oauth_token")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "oauth_token", valid_594183
  var valid_594184 = query.getOrDefault("callback")
  valid_594184 = validateParameter(valid_594184, JString, required = false,
                                 default = nil)
  if valid_594184 != nil:
    section.add "callback", valid_594184
  var valid_594185 = query.getOrDefault("access_token")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "access_token", valid_594185
  var valid_594186 = query.getOrDefault("uploadType")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "uploadType", valid_594186
  var valid_594187 = query.getOrDefault("key")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "key", valid_594187
  var valid_594188 = query.getOrDefault("$.xgafv")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = newJString("1"))
  if valid_594188 != nil:
    section.add "$.xgafv", valid_594188
  var valid_594189 = query.getOrDefault("prettyPrint")
  valid_594189 = validateParameter(valid_594189, JBool, required = false,
                                 default = newJBool(true))
  if valid_594189 != nil:
    section.add "prettyPrint", valid_594189
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

proc call*(call_594191: Call_PubsubTopicsPublishBatch_594176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds one or more messages to the topic. Returns NOT_FOUND if the topic does
  ## not exist.
  ## 
  let valid = call_594191.validator(path, query, header, formData, body)
  let scheme = call_594191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594191.url(scheme.get, call_594191.host, call_594191.base,
                         call_594191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594191, url, valid)

proc call*(call_594192: Call_PubsubTopicsPublishBatch_594176;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## pubsubTopicsPublishBatch
  ## Adds one or more messages to the topic. Returns NOT_FOUND if the topic does
  ## not exist.
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
  var query_594193 = newJObject()
  var body_594194 = newJObject()
  add(query_594193, "upload_protocol", newJString(uploadProtocol))
  add(query_594193, "fields", newJString(fields))
  add(query_594193, "quotaUser", newJString(quotaUser))
  add(query_594193, "alt", newJString(alt))
  add(query_594193, "oauth_token", newJString(oauthToken))
  add(query_594193, "callback", newJString(callback))
  add(query_594193, "access_token", newJString(accessToken))
  add(query_594193, "uploadType", newJString(uploadType))
  add(query_594193, "key", newJString(key))
  add(query_594193, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594194 = body
  add(query_594193, "prettyPrint", newJBool(prettyPrint))
  result = call_594192.call(nil, query_594193, nil, nil, body_594194)

var pubsubTopicsPublishBatch* = Call_PubsubTopicsPublishBatch_594176(
    name: "pubsubTopicsPublishBatch", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/topics/publishBatch",
    validator: validate_PubsubTopicsPublishBatch_594177, base: "/",
    url: url_PubsubTopicsPublishBatch_594178, schemes: {Scheme.Https})
type
  Call_PubsubTopicsGet_594195 = ref object of OpenApiRestCall_593408
proc url_PubsubTopicsGet_594197(protocol: Scheme; host: string; base: string;
                               route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1a/topics/"),
               (kind: VariableSegment, value: "topic")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubTopicsGet_594196(path: JsonNode; query: JsonNode;
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
  var valid_594198 = path.getOrDefault("topic")
  valid_594198 = validateParameter(valid_594198, JString, required = true,
                                 default = nil)
  if valid_594198 != nil:
    section.add "topic", valid_594198
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
  var valid_594199 = query.getOrDefault("upload_protocol")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "upload_protocol", valid_594199
  var valid_594200 = query.getOrDefault("fields")
  valid_594200 = validateParameter(valid_594200, JString, required = false,
                                 default = nil)
  if valid_594200 != nil:
    section.add "fields", valid_594200
  var valid_594201 = query.getOrDefault("quotaUser")
  valid_594201 = validateParameter(valid_594201, JString, required = false,
                                 default = nil)
  if valid_594201 != nil:
    section.add "quotaUser", valid_594201
  var valid_594202 = query.getOrDefault("alt")
  valid_594202 = validateParameter(valid_594202, JString, required = false,
                                 default = newJString("json"))
  if valid_594202 != nil:
    section.add "alt", valid_594202
  var valid_594203 = query.getOrDefault("oauth_token")
  valid_594203 = validateParameter(valid_594203, JString, required = false,
                                 default = nil)
  if valid_594203 != nil:
    section.add "oauth_token", valid_594203
  var valid_594204 = query.getOrDefault("callback")
  valid_594204 = validateParameter(valid_594204, JString, required = false,
                                 default = nil)
  if valid_594204 != nil:
    section.add "callback", valid_594204
  var valid_594205 = query.getOrDefault("access_token")
  valid_594205 = validateParameter(valid_594205, JString, required = false,
                                 default = nil)
  if valid_594205 != nil:
    section.add "access_token", valid_594205
  var valid_594206 = query.getOrDefault("uploadType")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "uploadType", valid_594206
  var valid_594207 = query.getOrDefault("key")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "key", valid_594207
  var valid_594208 = query.getOrDefault("$.xgafv")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = newJString("1"))
  if valid_594208 != nil:
    section.add "$.xgafv", valid_594208
  var valid_594209 = query.getOrDefault("prettyPrint")
  valid_594209 = validateParameter(valid_594209, JBool, required = false,
                                 default = newJBool(true))
  if valid_594209 != nil:
    section.add "prettyPrint", valid_594209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594210: Call_PubsubTopicsGet_594195; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration of a topic. Since the topic only has the name
  ## attribute, this method is only useful to check the existence of a topic.
  ## If other attributes are added in the future, they will be returned here.
  ## 
  let valid = call_594210.validator(path, query, header, formData, body)
  let scheme = call_594210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594210.url(scheme.get, call_594210.host, call_594210.base,
                         call_594210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594210, url, valid)

proc call*(call_594211: Call_PubsubTopicsGet_594195; topic: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## pubsubTopicsGet
  ## Gets the configuration of a topic. Since the topic only has the name
  ## attribute, this method is only useful to check the existence of a topic.
  ## If other attributes are added in the future, they will be returned here.
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
  ##   topic: string (required)
  ##        : The name of the topic to get.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594212 = newJObject()
  var query_594213 = newJObject()
  add(query_594213, "upload_protocol", newJString(uploadProtocol))
  add(query_594213, "fields", newJString(fields))
  add(query_594213, "quotaUser", newJString(quotaUser))
  add(query_594213, "alt", newJString(alt))
  add(query_594213, "oauth_token", newJString(oauthToken))
  add(query_594213, "callback", newJString(callback))
  add(query_594213, "access_token", newJString(accessToken))
  add(query_594213, "uploadType", newJString(uploadType))
  add(query_594213, "key", newJString(key))
  add(path_594212, "topic", newJString(topic))
  add(query_594213, "$.xgafv", newJString(Xgafv))
  add(query_594213, "prettyPrint", newJBool(prettyPrint))
  result = call_594211.call(path_594212, query_594213, nil, nil, nil)

var pubsubTopicsGet* = Call_PubsubTopicsGet_594195(name: "pubsubTopicsGet",
    meth: HttpMethod.HttpGet, host: "pubsub.googleapis.com",
    route: "/v1beta1a/topics/{topic}", validator: validate_PubsubTopicsGet_594196,
    base: "/", url: url_PubsubTopicsGet_594197, schemes: {Scheme.Https})
type
  Call_PubsubTopicsDelete_594214 = ref object of OpenApiRestCall_593408
proc url_PubsubTopicsDelete_594216(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "topic" in path, "`topic` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1a/topics/"),
               (kind: VariableSegment, value: "topic")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_PubsubTopicsDelete_594215(path: JsonNode; query: JsonNode;
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
  var valid_594217 = path.getOrDefault("topic")
  valid_594217 = validateParameter(valid_594217, JString, required = true,
                                 default = nil)
  if valid_594217 != nil:
    section.add "topic", valid_594217
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
  var valid_594218 = query.getOrDefault("upload_protocol")
  valid_594218 = validateParameter(valid_594218, JString, required = false,
                                 default = nil)
  if valid_594218 != nil:
    section.add "upload_protocol", valid_594218
  var valid_594219 = query.getOrDefault("fields")
  valid_594219 = validateParameter(valid_594219, JString, required = false,
                                 default = nil)
  if valid_594219 != nil:
    section.add "fields", valid_594219
  var valid_594220 = query.getOrDefault("quotaUser")
  valid_594220 = validateParameter(valid_594220, JString, required = false,
                                 default = nil)
  if valid_594220 != nil:
    section.add "quotaUser", valid_594220
  var valid_594221 = query.getOrDefault("alt")
  valid_594221 = validateParameter(valid_594221, JString, required = false,
                                 default = newJString("json"))
  if valid_594221 != nil:
    section.add "alt", valid_594221
  var valid_594222 = query.getOrDefault("oauth_token")
  valid_594222 = validateParameter(valid_594222, JString, required = false,
                                 default = nil)
  if valid_594222 != nil:
    section.add "oauth_token", valid_594222
  var valid_594223 = query.getOrDefault("callback")
  valid_594223 = validateParameter(valid_594223, JString, required = false,
                                 default = nil)
  if valid_594223 != nil:
    section.add "callback", valid_594223
  var valid_594224 = query.getOrDefault("access_token")
  valid_594224 = validateParameter(valid_594224, JString, required = false,
                                 default = nil)
  if valid_594224 != nil:
    section.add "access_token", valid_594224
  var valid_594225 = query.getOrDefault("uploadType")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = nil)
  if valid_594225 != nil:
    section.add "uploadType", valid_594225
  var valid_594226 = query.getOrDefault("key")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "key", valid_594226
  var valid_594227 = query.getOrDefault("$.xgafv")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = newJString("1"))
  if valid_594227 != nil:
    section.add "$.xgafv", valid_594227
  var valid_594228 = query.getOrDefault("prettyPrint")
  valid_594228 = validateParameter(valid_594228, JBool, required = false,
                                 default = newJBool(true))
  if valid_594228 != nil:
    section.add "prettyPrint", valid_594228
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594229: Call_PubsubTopicsDelete_594214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the topic with the given name. Returns NOT_FOUND if the topic does
  ## not exist. After a topic is deleted, a new topic may be created with the
  ## same name.
  ## 
  let valid = call_594229.validator(path, query, header, formData, body)
  let scheme = call_594229.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594229.url(scheme.get, call_594229.host, call_594229.base,
                         call_594229.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594229, url, valid)

proc call*(call_594230: Call_PubsubTopicsDelete_594214; topic: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## pubsubTopicsDelete
  ## Deletes the topic with the given name. Returns NOT_FOUND if the topic does
  ## not exist. After a topic is deleted, a new topic may be created with the
  ## same name.
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
  ##   topic: string (required)
  ##        : Name of the topic to delete.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594231 = newJObject()
  var query_594232 = newJObject()
  add(query_594232, "upload_protocol", newJString(uploadProtocol))
  add(query_594232, "fields", newJString(fields))
  add(query_594232, "quotaUser", newJString(quotaUser))
  add(query_594232, "alt", newJString(alt))
  add(query_594232, "oauth_token", newJString(oauthToken))
  add(query_594232, "callback", newJString(callback))
  add(query_594232, "access_token", newJString(accessToken))
  add(query_594232, "uploadType", newJString(uploadType))
  add(query_594232, "key", newJString(key))
  add(path_594231, "topic", newJString(topic))
  add(query_594232, "$.xgafv", newJString(Xgafv))
  add(query_594232, "prettyPrint", newJBool(prettyPrint))
  result = call_594230.call(path_594231, query_594232, nil, nil, nil)

var pubsubTopicsDelete* = Call_PubsubTopicsDelete_594214(
    name: "pubsubTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1beta1a/topics/{topic}",
    validator: validate_PubsubTopicsDelete_594215, base: "/",
    url: url_PubsubTopicsDelete_594216, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
