
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "pubsub"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_PubsubSubscriptionsCreate_588985 = ref object of OpenApiRestCall_588441
proc url_PubsubSubscriptionsCreate_588987(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsCreate_588986(path: JsonNode; query: JsonNode;
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
  var valid_588988 = query.getOrDefault("upload_protocol")
  valid_588988 = validateParameter(valid_588988, JString, required = false,
                                 default = nil)
  if valid_588988 != nil:
    section.add "upload_protocol", valid_588988
  var valid_588989 = query.getOrDefault("fields")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "fields", valid_588989
  var valid_588990 = query.getOrDefault("quotaUser")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = nil)
  if valid_588990 != nil:
    section.add "quotaUser", valid_588990
  var valid_588991 = query.getOrDefault("alt")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = newJString("json"))
  if valid_588991 != nil:
    section.add "alt", valid_588991
  var valid_588992 = query.getOrDefault("oauth_token")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = nil)
  if valid_588992 != nil:
    section.add "oauth_token", valid_588992
  var valid_588993 = query.getOrDefault("callback")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "callback", valid_588993
  var valid_588994 = query.getOrDefault("access_token")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "access_token", valid_588994
  var valid_588995 = query.getOrDefault("uploadType")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "uploadType", valid_588995
  var valid_588996 = query.getOrDefault("key")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "key", valid_588996
  var valid_588997 = query.getOrDefault("$.xgafv")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = newJString("1"))
  if valid_588997 != nil:
    section.add "$.xgafv", valid_588997
  var valid_588998 = query.getOrDefault("prettyPrint")
  valid_588998 = validateParameter(valid_588998, JBool, required = false,
                                 default = newJBool(true))
  if valid_588998 != nil:
    section.add "prettyPrint", valid_588998
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

proc call*(call_589000: Call_PubsubSubscriptionsCreate_588985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a subscription on a given topic for a given subscriber.
  ## If the subscription already exists, returns ALREADY_EXISTS.
  ## If the corresponding topic doesn't exist, returns NOT_FOUND.
  ## 
  ## If the name is not provided in the request, the server will assign a random
  ## name for this subscription on the same project as the topic.
  ## 
  let valid = call_589000.validator(path, query, header, formData, body)
  let scheme = call_589000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589000.url(scheme.get, call_589000.host, call_589000.base,
                         call_589000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589000, url, valid)

proc call*(call_589001: Call_PubsubSubscriptionsCreate_588985;
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
  var query_589002 = newJObject()
  var body_589003 = newJObject()
  add(query_589002, "upload_protocol", newJString(uploadProtocol))
  add(query_589002, "fields", newJString(fields))
  add(query_589002, "quotaUser", newJString(quotaUser))
  add(query_589002, "alt", newJString(alt))
  add(query_589002, "oauth_token", newJString(oauthToken))
  add(query_589002, "callback", newJString(callback))
  add(query_589002, "access_token", newJString(accessToken))
  add(query_589002, "uploadType", newJString(uploadType))
  add(query_589002, "key", newJString(key))
  add(query_589002, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589003 = body
  add(query_589002, "prettyPrint", newJBool(prettyPrint))
  result = call_589001.call(nil, query_589002, nil, nil, body_589003)

var pubsubSubscriptionsCreate* = Call_PubsubSubscriptionsCreate_588985(
    name: "pubsubSubscriptionsCreate", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions",
    validator: validate_PubsubSubscriptionsCreate_588986, base: "/",
    url: url_PubsubSubscriptionsCreate_588987, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsList_588710 = ref object of OpenApiRestCall_588441
proc url_PubsubSubscriptionsList_588712(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsList_588711(path: JsonNode; query: JsonNode;
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
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("pageToken")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "pageToken", valid_588826
  var valid_588827 = query.getOrDefault("quotaUser")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "quotaUser", valid_588827
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("query")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "query", valid_588842
  var valid_588843 = query.getOrDefault("oauth_token")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "oauth_token", valid_588843
  var valid_588844 = query.getOrDefault("callback")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "callback", valid_588844
  var valid_588845 = query.getOrDefault("access_token")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "access_token", valid_588845
  var valid_588846 = query.getOrDefault("uploadType")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "uploadType", valid_588846
  var valid_588847 = query.getOrDefault("maxResults")
  valid_588847 = validateParameter(valid_588847, JInt, required = false, default = nil)
  if valid_588847 != nil:
    section.add "maxResults", valid_588847
  var valid_588848 = query.getOrDefault("key")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "key", valid_588848
  var valid_588849 = query.getOrDefault("$.xgafv")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = newJString("1"))
  if valid_588849 != nil:
    section.add "$.xgafv", valid_588849
  var valid_588850 = query.getOrDefault("prettyPrint")
  valid_588850 = validateParameter(valid_588850, JBool, required = false,
                                 default = newJBool(true))
  if valid_588850 != nil:
    section.add "prettyPrint", valid_588850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588873: Call_PubsubSubscriptionsList_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matching subscriptions.
  ## 
  let valid = call_588873.validator(path, query, header, formData, body)
  let scheme = call_588873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588873.url(scheme.get, call_588873.host, call_588873.base,
                         call_588873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588873, url, valid)

proc call*(call_588944: Call_PubsubSubscriptionsList_588710;
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
  var query_588945 = newJObject()
  add(query_588945, "upload_protocol", newJString(uploadProtocol))
  add(query_588945, "fields", newJString(fields))
  add(query_588945, "pageToken", newJString(pageToken))
  add(query_588945, "quotaUser", newJString(quotaUser))
  add(query_588945, "alt", newJString(alt))
  add(query_588945, "query", newJString(query))
  add(query_588945, "oauth_token", newJString(oauthToken))
  add(query_588945, "callback", newJString(callback))
  add(query_588945, "access_token", newJString(accessToken))
  add(query_588945, "uploadType", newJString(uploadType))
  add(query_588945, "maxResults", newJInt(maxResults))
  add(query_588945, "key", newJString(key))
  add(query_588945, "$.xgafv", newJString(Xgafv))
  add(query_588945, "prettyPrint", newJBool(prettyPrint))
  result = call_588944.call(nil, query_588945, nil, nil, nil)

var pubsubSubscriptionsList* = Call_PubsubSubscriptionsList_588710(
    name: "pubsubSubscriptionsList", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions",
    validator: validate_PubsubSubscriptionsList_588711, base: "/",
    url: url_PubsubSubscriptionsList_588712, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsAcknowledge_589004 = ref object of OpenApiRestCall_588441
proc url_PubsubSubscriptionsAcknowledge_589006(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsAcknowledge_589005(path: JsonNode;
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
  var valid_589007 = query.getOrDefault("upload_protocol")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "upload_protocol", valid_589007
  var valid_589008 = query.getOrDefault("fields")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "fields", valid_589008
  var valid_589009 = query.getOrDefault("quotaUser")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "quotaUser", valid_589009
  var valid_589010 = query.getOrDefault("alt")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = newJString("json"))
  if valid_589010 != nil:
    section.add "alt", valid_589010
  var valid_589011 = query.getOrDefault("oauth_token")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "oauth_token", valid_589011
  var valid_589012 = query.getOrDefault("callback")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "callback", valid_589012
  var valid_589013 = query.getOrDefault("access_token")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "access_token", valid_589013
  var valid_589014 = query.getOrDefault("uploadType")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "uploadType", valid_589014
  var valid_589015 = query.getOrDefault("key")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "key", valid_589015
  var valid_589016 = query.getOrDefault("$.xgafv")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("1"))
  if valid_589016 != nil:
    section.add "$.xgafv", valid_589016
  var valid_589017 = query.getOrDefault("prettyPrint")
  valid_589017 = validateParameter(valid_589017, JBool, required = false,
                                 default = newJBool(true))
  if valid_589017 != nil:
    section.add "prettyPrint", valid_589017
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

proc call*(call_589019: Call_PubsubSubscriptionsAcknowledge_589004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Acknowledges a particular received message: the Pub/Sub system can remove
  ## the given message from the subscription. Acknowledging a message whose
  ## Ack deadline has expired may succeed, but the message could have been
  ## already redelivered. Acknowledging a message more than once will not
  ## result in an error. This is only used for messages received via pull.
  ## 
  let valid = call_589019.validator(path, query, header, formData, body)
  let scheme = call_589019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589019.url(scheme.get, call_589019.host, call_589019.base,
                         call_589019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589019, url, valid)

proc call*(call_589020: Call_PubsubSubscriptionsAcknowledge_589004;
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
  var query_589021 = newJObject()
  var body_589022 = newJObject()
  add(query_589021, "upload_protocol", newJString(uploadProtocol))
  add(query_589021, "fields", newJString(fields))
  add(query_589021, "quotaUser", newJString(quotaUser))
  add(query_589021, "alt", newJString(alt))
  add(query_589021, "oauth_token", newJString(oauthToken))
  add(query_589021, "callback", newJString(callback))
  add(query_589021, "access_token", newJString(accessToken))
  add(query_589021, "uploadType", newJString(uploadType))
  add(query_589021, "key", newJString(key))
  add(query_589021, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589022 = body
  add(query_589021, "prettyPrint", newJBool(prettyPrint))
  result = call_589020.call(nil, query_589021, nil, nil, body_589022)

var pubsubSubscriptionsAcknowledge* = Call_PubsubSubscriptionsAcknowledge_589004(
    name: "pubsubSubscriptionsAcknowledge", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions/acknowledge",
    validator: validate_PubsubSubscriptionsAcknowledge_589005, base: "/",
    url: url_PubsubSubscriptionsAcknowledge_589006, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsModifyAckDeadline_589023 = ref object of OpenApiRestCall_588441
proc url_PubsubSubscriptionsModifyAckDeadline_589025(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsModifyAckDeadline_589024(path: JsonNode;
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
  var valid_589026 = query.getOrDefault("upload_protocol")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "upload_protocol", valid_589026
  var valid_589027 = query.getOrDefault("fields")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "fields", valid_589027
  var valid_589028 = query.getOrDefault("quotaUser")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "quotaUser", valid_589028
  var valid_589029 = query.getOrDefault("alt")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = newJString("json"))
  if valid_589029 != nil:
    section.add "alt", valid_589029
  var valid_589030 = query.getOrDefault("oauth_token")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "oauth_token", valid_589030
  var valid_589031 = query.getOrDefault("callback")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "callback", valid_589031
  var valid_589032 = query.getOrDefault("access_token")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "access_token", valid_589032
  var valid_589033 = query.getOrDefault("uploadType")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "uploadType", valid_589033
  var valid_589034 = query.getOrDefault("key")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "key", valid_589034
  var valid_589035 = query.getOrDefault("$.xgafv")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = newJString("1"))
  if valid_589035 != nil:
    section.add "$.xgafv", valid_589035
  var valid_589036 = query.getOrDefault("prettyPrint")
  valid_589036 = validateParameter(valid_589036, JBool, required = false,
                                 default = newJBool(true))
  if valid_589036 != nil:
    section.add "prettyPrint", valid_589036
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

proc call*(call_589038: Call_PubsubSubscriptionsModifyAckDeadline_589023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the Ack deadline for a message received from a pull request.
  ## 
  let valid = call_589038.validator(path, query, header, formData, body)
  let scheme = call_589038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589038.url(scheme.get, call_589038.host, call_589038.base,
                         call_589038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589038, url, valid)

proc call*(call_589039: Call_PubsubSubscriptionsModifyAckDeadline_589023;
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
  var query_589040 = newJObject()
  var body_589041 = newJObject()
  add(query_589040, "upload_protocol", newJString(uploadProtocol))
  add(query_589040, "fields", newJString(fields))
  add(query_589040, "quotaUser", newJString(quotaUser))
  add(query_589040, "alt", newJString(alt))
  add(query_589040, "oauth_token", newJString(oauthToken))
  add(query_589040, "callback", newJString(callback))
  add(query_589040, "access_token", newJString(accessToken))
  add(query_589040, "uploadType", newJString(uploadType))
  add(query_589040, "key", newJString(key))
  add(query_589040, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589041 = body
  add(query_589040, "prettyPrint", newJBool(prettyPrint))
  result = call_589039.call(nil, query_589040, nil, nil, body_589041)

var pubsubSubscriptionsModifyAckDeadline* = Call_PubsubSubscriptionsModifyAckDeadline_589023(
    name: "pubsubSubscriptionsModifyAckDeadline", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com",
    route: "/v1beta1a/subscriptions/modifyAckDeadline",
    validator: validate_PubsubSubscriptionsModifyAckDeadline_589024, base: "/",
    url: url_PubsubSubscriptionsModifyAckDeadline_589025, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsModifyPushConfig_589042 = ref object of OpenApiRestCall_588441
proc url_PubsubSubscriptionsModifyPushConfig_589044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsModifyPushConfig_589043(path: JsonNode;
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
  var valid_589045 = query.getOrDefault("upload_protocol")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "upload_protocol", valid_589045
  var valid_589046 = query.getOrDefault("fields")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "fields", valid_589046
  var valid_589047 = query.getOrDefault("quotaUser")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "quotaUser", valid_589047
  var valid_589048 = query.getOrDefault("alt")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = newJString("json"))
  if valid_589048 != nil:
    section.add "alt", valid_589048
  var valid_589049 = query.getOrDefault("oauth_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "oauth_token", valid_589049
  var valid_589050 = query.getOrDefault("callback")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "callback", valid_589050
  var valid_589051 = query.getOrDefault("access_token")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "access_token", valid_589051
  var valid_589052 = query.getOrDefault("uploadType")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "uploadType", valid_589052
  var valid_589053 = query.getOrDefault("key")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "key", valid_589053
  var valid_589054 = query.getOrDefault("$.xgafv")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = newJString("1"))
  if valid_589054 != nil:
    section.add "$.xgafv", valid_589054
  var valid_589055 = query.getOrDefault("prettyPrint")
  valid_589055 = validateParameter(valid_589055, JBool, required = false,
                                 default = newJBool(true))
  if valid_589055 != nil:
    section.add "prettyPrint", valid_589055
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

proc call*(call_589057: Call_PubsubSubscriptionsModifyPushConfig_589042;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the <code>PushConfig</code> for a specified subscription.
  ## This method can be used to suspend the flow of messages to an endpoint
  ## by clearing the <code>PushConfig</code> field in the request. Messages
  ## will be accumulated for delivery even if no push configuration is
  ## defined or while the configuration is modified.
  ## 
  let valid = call_589057.validator(path, query, header, formData, body)
  let scheme = call_589057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589057.url(scheme.get, call_589057.host, call_589057.base,
                         call_589057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589057, url, valid)

proc call*(call_589058: Call_PubsubSubscriptionsModifyPushConfig_589042;
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
  var query_589059 = newJObject()
  var body_589060 = newJObject()
  add(query_589059, "upload_protocol", newJString(uploadProtocol))
  add(query_589059, "fields", newJString(fields))
  add(query_589059, "quotaUser", newJString(quotaUser))
  add(query_589059, "alt", newJString(alt))
  add(query_589059, "oauth_token", newJString(oauthToken))
  add(query_589059, "callback", newJString(callback))
  add(query_589059, "access_token", newJString(accessToken))
  add(query_589059, "uploadType", newJString(uploadType))
  add(query_589059, "key", newJString(key))
  add(query_589059, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589060 = body
  add(query_589059, "prettyPrint", newJBool(prettyPrint))
  result = call_589058.call(nil, query_589059, nil, nil, body_589060)

var pubsubSubscriptionsModifyPushConfig* = Call_PubsubSubscriptionsModifyPushConfig_589042(
    name: "pubsubSubscriptionsModifyPushConfig", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com",
    route: "/v1beta1a/subscriptions/modifyPushConfig",
    validator: validate_PubsubSubscriptionsModifyPushConfig_589043, base: "/",
    url: url_PubsubSubscriptionsModifyPushConfig_589044, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsPull_589061 = ref object of OpenApiRestCall_588441
proc url_PubsubSubscriptionsPull_589063(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsPull_589062(path: JsonNode; query: JsonNode;
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
  var valid_589064 = query.getOrDefault("upload_protocol")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "upload_protocol", valid_589064
  var valid_589065 = query.getOrDefault("fields")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "fields", valid_589065
  var valid_589066 = query.getOrDefault("quotaUser")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "quotaUser", valid_589066
  var valid_589067 = query.getOrDefault("alt")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = newJString("json"))
  if valid_589067 != nil:
    section.add "alt", valid_589067
  var valid_589068 = query.getOrDefault("oauth_token")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "oauth_token", valid_589068
  var valid_589069 = query.getOrDefault("callback")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "callback", valid_589069
  var valid_589070 = query.getOrDefault("access_token")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "access_token", valid_589070
  var valid_589071 = query.getOrDefault("uploadType")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "uploadType", valid_589071
  var valid_589072 = query.getOrDefault("key")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = nil)
  if valid_589072 != nil:
    section.add "key", valid_589072
  var valid_589073 = query.getOrDefault("$.xgafv")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = newJString("1"))
  if valid_589073 != nil:
    section.add "$.xgafv", valid_589073
  var valid_589074 = query.getOrDefault("prettyPrint")
  valid_589074 = validateParameter(valid_589074, JBool, required = false,
                                 default = newJBool(true))
  if valid_589074 != nil:
    section.add "prettyPrint", valid_589074
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

proc call*(call_589076: Call_PubsubSubscriptionsPull_589061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pulls a single message from the server.
  ## If return_immediately is true, and no messages are available in the
  ## subscription, this method returns FAILED_PRECONDITION. The system is free
  ## to return an UNAVAILABLE error if no messages are available in a
  ## reasonable amount of time (to reduce system load).
  ## 
  let valid = call_589076.validator(path, query, header, formData, body)
  let scheme = call_589076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589076.url(scheme.get, call_589076.host, call_589076.base,
                         call_589076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589076, url, valid)

proc call*(call_589077: Call_PubsubSubscriptionsPull_589061;
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
  var query_589078 = newJObject()
  var body_589079 = newJObject()
  add(query_589078, "upload_protocol", newJString(uploadProtocol))
  add(query_589078, "fields", newJString(fields))
  add(query_589078, "quotaUser", newJString(quotaUser))
  add(query_589078, "alt", newJString(alt))
  add(query_589078, "oauth_token", newJString(oauthToken))
  add(query_589078, "callback", newJString(callback))
  add(query_589078, "access_token", newJString(accessToken))
  add(query_589078, "uploadType", newJString(uploadType))
  add(query_589078, "key", newJString(key))
  add(query_589078, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589079 = body
  add(query_589078, "prettyPrint", newJBool(prettyPrint))
  result = call_589077.call(nil, query_589078, nil, nil, body_589079)

var pubsubSubscriptionsPull* = Call_PubsubSubscriptionsPull_589061(
    name: "pubsubSubscriptionsPull", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions/pull",
    validator: validate_PubsubSubscriptionsPull_589062, base: "/",
    url: url_PubsubSubscriptionsPull_589063, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsPullBatch_589080 = ref object of OpenApiRestCall_588441
proc url_PubsubSubscriptionsPullBatch_589082(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubSubscriptionsPullBatch_589081(path: JsonNode; query: JsonNode;
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
  var valid_589083 = query.getOrDefault("upload_protocol")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "upload_protocol", valid_589083
  var valid_589084 = query.getOrDefault("fields")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "fields", valid_589084
  var valid_589085 = query.getOrDefault("quotaUser")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "quotaUser", valid_589085
  var valid_589086 = query.getOrDefault("alt")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = newJString("json"))
  if valid_589086 != nil:
    section.add "alt", valid_589086
  var valid_589087 = query.getOrDefault("oauth_token")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "oauth_token", valid_589087
  var valid_589088 = query.getOrDefault("callback")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "callback", valid_589088
  var valid_589089 = query.getOrDefault("access_token")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "access_token", valid_589089
  var valid_589090 = query.getOrDefault("uploadType")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "uploadType", valid_589090
  var valid_589091 = query.getOrDefault("key")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "key", valid_589091
  var valid_589092 = query.getOrDefault("$.xgafv")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = newJString("1"))
  if valid_589092 != nil:
    section.add "$.xgafv", valid_589092
  var valid_589093 = query.getOrDefault("prettyPrint")
  valid_589093 = validateParameter(valid_589093, JBool, required = false,
                                 default = newJBool(true))
  if valid_589093 != nil:
    section.add "prettyPrint", valid_589093
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

proc call*(call_589095: Call_PubsubSubscriptionsPullBatch_589080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Pulls messages from the server. Returns an empty list if there are no
  ## messages available in the backlog. The system is free to return UNAVAILABLE
  ## if there are too many pull requests outstanding for the given subscription.
  ## 
  let valid = call_589095.validator(path, query, header, formData, body)
  let scheme = call_589095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589095.url(scheme.get, call_589095.host, call_589095.base,
                         call_589095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589095, url, valid)

proc call*(call_589096: Call_PubsubSubscriptionsPullBatch_589080;
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
  var query_589097 = newJObject()
  var body_589098 = newJObject()
  add(query_589097, "upload_protocol", newJString(uploadProtocol))
  add(query_589097, "fields", newJString(fields))
  add(query_589097, "quotaUser", newJString(quotaUser))
  add(query_589097, "alt", newJString(alt))
  add(query_589097, "oauth_token", newJString(oauthToken))
  add(query_589097, "callback", newJString(callback))
  add(query_589097, "access_token", newJString(accessToken))
  add(query_589097, "uploadType", newJString(uploadType))
  add(query_589097, "key", newJString(key))
  add(query_589097, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589098 = body
  add(query_589097, "prettyPrint", newJBool(prettyPrint))
  result = call_589096.call(nil, query_589097, nil, nil, body_589098)

var pubsubSubscriptionsPullBatch* = Call_PubsubSubscriptionsPullBatch_589080(
    name: "pubsubSubscriptionsPullBatch", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/subscriptions/pullBatch",
    validator: validate_PubsubSubscriptionsPullBatch_589081, base: "/",
    url: url_PubsubSubscriptionsPullBatch_589082, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsGet_589099 = ref object of OpenApiRestCall_588441
proc url_PubsubSubscriptionsGet_589101(protocol: Scheme; host: string; base: string;
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

proc validate_PubsubSubscriptionsGet_589100(path: JsonNode; query: JsonNode;
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
  var valid_589116 = path.getOrDefault("subscription")
  valid_589116 = validateParameter(valid_589116, JString, required = true,
                                 default = nil)
  if valid_589116 != nil:
    section.add "subscription", valid_589116
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
  var valid_589117 = query.getOrDefault("upload_protocol")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "upload_protocol", valid_589117
  var valid_589118 = query.getOrDefault("fields")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "fields", valid_589118
  var valid_589119 = query.getOrDefault("quotaUser")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "quotaUser", valid_589119
  var valid_589120 = query.getOrDefault("alt")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = newJString("json"))
  if valid_589120 != nil:
    section.add "alt", valid_589120
  var valid_589121 = query.getOrDefault("oauth_token")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = nil)
  if valid_589121 != nil:
    section.add "oauth_token", valid_589121
  var valid_589122 = query.getOrDefault("callback")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "callback", valid_589122
  var valid_589123 = query.getOrDefault("access_token")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "access_token", valid_589123
  var valid_589124 = query.getOrDefault("uploadType")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "uploadType", valid_589124
  var valid_589125 = query.getOrDefault("key")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "key", valid_589125
  var valid_589126 = query.getOrDefault("$.xgafv")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = newJString("1"))
  if valid_589126 != nil:
    section.add "$.xgafv", valid_589126
  var valid_589127 = query.getOrDefault("prettyPrint")
  valid_589127 = validateParameter(valid_589127, JBool, required = false,
                                 default = newJBool(true))
  if valid_589127 != nil:
    section.add "prettyPrint", valid_589127
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589128: Call_PubsubSubscriptionsGet_589099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration details of a subscription.
  ## 
  let valid = call_589128.validator(path, query, header, formData, body)
  let scheme = call_589128.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589128.url(scheme.get, call_589128.host, call_589128.base,
                         call_589128.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589128, url, valid)

proc call*(call_589129: Call_PubsubSubscriptionsGet_589099; subscription: string;
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
  var path_589130 = newJObject()
  var query_589131 = newJObject()
  add(query_589131, "upload_protocol", newJString(uploadProtocol))
  add(query_589131, "fields", newJString(fields))
  add(query_589131, "quotaUser", newJString(quotaUser))
  add(path_589130, "subscription", newJString(subscription))
  add(query_589131, "alt", newJString(alt))
  add(query_589131, "oauth_token", newJString(oauthToken))
  add(query_589131, "callback", newJString(callback))
  add(query_589131, "access_token", newJString(accessToken))
  add(query_589131, "uploadType", newJString(uploadType))
  add(query_589131, "key", newJString(key))
  add(query_589131, "$.xgafv", newJString(Xgafv))
  add(query_589131, "prettyPrint", newJBool(prettyPrint))
  result = call_589129.call(path_589130, query_589131, nil, nil, nil)

var pubsubSubscriptionsGet* = Call_PubsubSubscriptionsGet_589099(
    name: "pubsubSubscriptionsGet", meth: HttpMethod.HttpGet,
    host: "pubsub.googleapis.com",
    route: "/v1beta1a/subscriptions/{subscription}",
    validator: validate_PubsubSubscriptionsGet_589100, base: "/",
    url: url_PubsubSubscriptionsGet_589101, schemes: {Scheme.Https})
type
  Call_PubsubSubscriptionsDelete_589132 = ref object of OpenApiRestCall_588441
proc url_PubsubSubscriptionsDelete_589134(protocol: Scheme; host: string;
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

proc validate_PubsubSubscriptionsDelete_589133(path: JsonNode; query: JsonNode;
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
  var valid_589135 = path.getOrDefault("subscription")
  valid_589135 = validateParameter(valid_589135, JString, required = true,
                                 default = nil)
  if valid_589135 != nil:
    section.add "subscription", valid_589135
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
  var valid_589136 = query.getOrDefault("upload_protocol")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "upload_protocol", valid_589136
  var valid_589137 = query.getOrDefault("fields")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "fields", valid_589137
  var valid_589138 = query.getOrDefault("quotaUser")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "quotaUser", valid_589138
  var valid_589139 = query.getOrDefault("alt")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = newJString("json"))
  if valid_589139 != nil:
    section.add "alt", valid_589139
  var valid_589140 = query.getOrDefault("oauth_token")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "oauth_token", valid_589140
  var valid_589141 = query.getOrDefault("callback")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "callback", valid_589141
  var valid_589142 = query.getOrDefault("access_token")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "access_token", valid_589142
  var valid_589143 = query.getOrDefault("uploadType")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "uploadType", valid_589143
  var valid_589144 = query.getOrDefault("key")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "key", valid_589144
  var valid_589145 = query.getOrDefault("$.xgafv")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = newJString("1"))
  if valid_589145 != nil:
    section.add "$.xgafv", valid_589145
  var valid_589146 = query.getOrDefault("prettyPrint")
  valid_589146 = validateParameter(valid_589146, JBool, required = false,
                                 default = newJBool(true))
  if valid_589146 != nil:
    section.add "prettyPrint", valid_589146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589147: Call_PubsubSubscriptionsDelete_589132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing subscription. All pending messages in the subscription
  ## are immediately dropped. Calls to Pull after deletion will return
  ## NOT_FOUND.
  ## 
  let valid = call_589147.validator(path, query, header, formData, body)
  let scheme = call_589147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589147.url(scheme.get, call_589147.host, call_589147.base,
                         call_589147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589147, url, valid)

proc call*(call_589148: Call_PubsubSubscriptionsDelete_589132;
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
  var path_589149 = newJObject()
  var query_589150 = newJObject()
  add(query_589150, "upload_protocol", newJString(uploadProtocol))
  add(query_589150, "fields", newJString(fields))
  add(query_589150, "quotaUser", newJString(quotaUser))
  add(path_589149, "subscription", newJString(subscription))
  add(query_589150, "alt", newJString(alt))
  add(query_589150, "oauth_token", newJString(oauthToken))
  add(query_589150, "callback", newJString(callback))
  add(query_589150, "access_token", newJString(accessToken))
  add(query_589150, "uploadType", newJString(uploadType))
  add(query_589150, "key", newJString(key))
  add(query_589150, "$.xgafv", newJString(Xgafv))
  add(query_589150, "prettyPrint", newJBool(prettyPrint))
  result = call_589148.call(path_589149, query_589150, nil, nil, nil)

var pubsubSubscriptionsDelete* = Call_PubsubSubscriptionsDelete_589132(
    name: "pubsubSubscriptionsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com",
    route: "/v1beta1a/subscriptions/{subscription}",
    validator: validate_PubsubSubscriptionsDelete_589133, base: "/",
    url: url_PubsubSubscriptionsDelete_589134, schemes: {Scheme.Https})
type
  Call_PubsubTopicsCreate_589171 = ref object of OpenApiRestCall_588441
proc url_PubsubTopicsCreate_589173(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubTopicsCreate_589172(path: JsonNode; query: JsonNode;
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
  var valid_589174 = query.getOrDefault("upload_protocol")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "upload_protocol", valid_589174
  var valid_589175 = query.getOrDefault("fields")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "fields", valid_589175
  var valid_589176 = query.getOrDefault("quotaUser")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "quotaUser", valid_589176
  var valid_589177 = query.getOrDefault("alt")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = newJString("json"))
  if valid_589177 != nil:
    section.add "alt", valid_589177
  var valid_589178 = query.getOrDefault("oauth_token")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "oauth_token", valid_589178
  var valid_589179 = query.getOrDefault("callback")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "callback", valid_589179
  var valid_589180 = query.getOrDefault("access_token")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "access_token", valid_589180
  var valid_589181 = query.getOrDefault("uploadType")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "uploadType", valid_589181
  var valid_589182 = query.getOrDefault("key")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "key", valid_589182
  var valid_589183 = query.getOrDefault("$.xgafv")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = newJString("1"))
  if valid_589183 != nil:
    section.add "$.xgafv", valid_589183
  var valid_589184 = query.getOrDefault("prettyPrint")
  valid_589184 = validateParameter(valid_589184, JBool, required = false,
                                 default = newJBool(true))
  if valid_589184 != nil:
    section.add "prettyPrint", valid_589184
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

proc call*(call_589186: Call_PubsubTopicsCreate_589171; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates the given topic with the given name.
  ## 
  let valid = call_589186.validator(path, query, header, formData, body)
  let scheme = call_589186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589186.url(scheme.get, call_589186.host, call_589186.base,
                         call_589186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589186, url, valid)

proc call*(call_589187: Call_PubsubTopicsCreate_589171;
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
  var query_589188 = newJObject()
  var body_589189 = newJObject()
  add(query_589188, "upload_protocol", newJString(uploadProtocol))
  add(query_589188, "fields", newJString(fields))
  add(query_589188, "quotaUser", newJString(quotaUser))
  add(query_589188, "alt", newJString(alt))
  add(query_589188, "oauth_token", newJString(oauthToken))
  add(query_589188, "callback", newJString(callback))
  add(query_589188, "access_token", newJString(accessToken))
  add(query_589188, "uploadType", newJString(uploadType))
  add(query_589188, "key", newJString(key))
  add(query_589188, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589189 = body
  add(query_589188, "prettyPrint", newJBool(prettyPrint))
  result = call_589187.call(nil, query_589188, nil, nil, body_589189)

var pubsubTopicsCreate* = Call_PubsubTopicsCreate_589171(
    name: "pubsubTopicsCreate", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/topics",
    validator: validate_PubsubTopicsCreate_589172, base: "/",
    url: url_PubsubTopicsCreate_589173, schemes: {Scheme.Https})
type
  Call_PubsubTopicsList_589151 = ref object of OpenApiRestCall_588441
proc url_PubsubTopicsList_589153(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubTopicsList_589152(path: JsonNode; query: JsonNode;
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
  var valid_589154 = query.getOrDefault("upload_protocol")
  valid_589154 = validateParameter(valid_589154, JString, required = false,
                                 default = nil)
  if valid_589154 != nil:
    section.add "upload_protocol", valid_589154
  var valid_589155 = query.getOrDefault("fields")
  valid_589155 = validateParameter(valid_589155, JString, required = false,
                                 default = nil)
  if valid_589155 != nil:
    section.add "fields", valid_589155
  var valid_589156 = query.getOrDefault("pageToken")
  valid_589156 = validateParameter(valid_589156, JString, required = false,
                                 default = nil)
  if valid_589156 != nil:
    section.add "pageToken", valid_589156
  var valid_589157 = query.getOrDefault("quotaUser")
  valid_589157 = validateParameter(valid_589157, JString, required = false,
                                 default = nil)
  if valid_589157 != nil:
    section.add "quotaUser", valid_589157
  var valid_589158 = query.getOrDefault("alt")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = newJString("json"))
  if valid_589158 != nil:
    section.add "alt", valid_589158
  var valid_589159 = query.getOrDefault("query")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "query", valid_589159
  var valid_589160 = query.getOrDefault("oauth_token")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "oauth_token", valid_589160
  var valid_589161 = query.getOrDefault("callback")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "callback", valid_589161
  var valid_589162 = query.getOrDefault("access_token")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "access_token", valid_589162
  var valid_589163 = query.getOrDefault("uploadType")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "uploadType", valid_589163
  var valid_589164 = query.getOrDefault("maxResults")
  valid_589164 = validateParameter(valid_589164, JInt, required = false, default = nil)
  if valid_589164 != nil:
    section.add "maxResults", valid_589164
  var valid_589165 = query.getOrDefault("key")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "key", valid_589165
  var valid_589166 = query.getOrDefault("$.xgafv")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = newJString("1"))
  if valid_589166 != nil:
    section.add "$.xgafv", valid_589166
  var valid_589167 = query.getOrDefault("prettyPrint")
  valid_589167 = validateParameter(valid_589167, JBool, required = false,
                                 default = newJBool(true))
  if valid_589167 != nil:
    section.add "prettyPrint", valid_589167
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589168: Call_PubsubTopicsList_589151; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists matching topics.
  ## 
  let valid = call_589168.validator(path, query, header, formData, body)
  let scheme = call_589168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589168.url(scheme.get, call_589168.host, call_589168.base,
                         call_589168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589168, url, valid)

proc call*(call_589169: Call_PubsubTopicsList_589151; uploadProtocol: string = "";
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
  var query_589170 = newJObject()
  add(query_589170, "upload_protocol", newJString(uploadProtocol))
  add(query_589170, "fields", newJString(fields))
  add(query_589170, "pageToken", newJString(pageToken))
  add(query_589170, "quotaUser", newJString(quotaUser))
  add(query_589170, "alt", newJString(alt))
  add(query_589170, "query", newJString(query))
  add(query_589170, "oauth_token", newJString(oauthToken))
  add(query_589170, "callback", newJString(callback))
  add(query_589170, "access_token", newJString(accessToken))
  add(query_589170, "uploadType", newJString(uploadType))
  add(query_589170, "maxResults", newJInt(maxResults))
  add(query_589170, "key", newJString(key))
  add(query_589170, "$.xgafv", newJString(Xgafv))
  add(query_589170, "prettyPrint", newJBool(prettyPrint))
  result = call_589169.call(nil, query_589170, nil, nil, nil)

var pubsubTopicsList* = Call_PubsubTopicsList_589151(name: "pubsubTopicsList",
    meth: HttpMethod.HttpGet, host: "pubsub.googleapis.com",
    route: "/v1beta1a/topics", validator: validate_PubsubTopicsList_589152,
    base: "/", url: url_PubsubTopicsList_589153, schemes: {Scheme.Https})
type
  Call_PubsubTopicsPublish_589190 = ref object of OpenApiRestCall_588441
proc url_PubsubTopicsPublish_589192(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubTopicsPublish_589191(path: JsonNode; query: JsonNode;
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
  var valid_589193 = query.getOrDefault("upload_protocol")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "upload_protocol", valid_589193
  var valid_589194 = query.getOrDefault("fields")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "fields", valid_589194
  var valid_589195 = query.getOrDefault("quotaUser")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "quotaUser", valid_589195
  var valid_589196 = query.getOrDefault("alt")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = newJString("json"))
  if valid_589196 != nil:
    section.add "alt", valid_589196
  var valid_589197 = query.getOrDefault("oauth_token")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "oauth_token", valid_589197
  var valid_589198 = query.getOrDefault("callback")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "callback", valid_589198
  var valid_589199 = query.getOrDefault("access_token")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "access_token", valid_589199
  var valid_589200 = query.getOrDefault("uploadType")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "uploadType", valid_589200
  var valid_589201 = query.getOrDefault("key")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "key", valid_589201
  var valid_589202 = query.getOrDefault("$.xgafv")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = newJString("1"))
  if valid_589202 != nil:
    section.add "$.xgafv", valid_589202
  var valid_589203 = query.getOrDefault("prettyPrint")
  valid_589203 = validateParameter(valid_589203, JBool, required = false,
                                 default = newJBool(true))
  if valid_589203 != nil:
    section.add "prettyPrint", valid_589203
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

proc call*(call_589205: Call_PubsubTopicsPublish_589190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a message to the topic.  Returns NOT_FOUND if the topic does not
  ## exist.
  ## 
  let valid = call_589205.validator(path, query, header, formData, body)
  let scheme = call_589205.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589205.url(scheme.get, call_589205.host, call_589205.base,
                         call_589205.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589205, url, valid)

proc call*(call_589206: Call_PubsubTopicsPublish_589190;
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
  var query_589207 = newJObject()
  var body_589208 = newJObject()
  add(query_589207, "upload_protocol", newJString(uploadProtocol))
  add(query_589207, "fields", newJString(fields))
  add(query_589207, "quotaUser", newJString(quotaUser))
  add(query_589207, "alt", newJString(alt))
  add(query_589207, "oauth_token", newJString(oauthToken))
  add(query_589207, "callback", newJString(callback))
  add(query_589207, "access_token", newJString(accessToken))
  add(query_589207, "uploadType", newJString(uploadType))
  add(query_589207, "key", newJString(key))
  add(query_589207, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589208 = body
  add(query_589207, "prettyPrint", newJBool(prettyPrint))
  result = call_589206.call(nil, query_589207, nil, nil, body_589208)

var pubsubTopicsPublish* = Call_PubsubTopicsPublish_589190(
    name: "pubsubTopicsPublish", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/topics/publish",
    validator: validate_PubsubTopicsPublish_589191, base: "/",
    url: url_PubsubTopicsPublish_589192, schemes: {Scheme.Https})
type
  Call_PubsubTopicsPublishBatch_589209 = ref object of OpenApiRestCall_588441
proc url_PubsubTopicsPublishBatch_589211(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_PubsubTopicsPublishBatch_589210(path: JsonNode; query: JsonNode;
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
  var valid_589212 = query.getOrDefault("upload_protocol")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "upload_protocol", valid_589212
  var valid_589213 = query.getOrDefault("fields")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "fields", valid_589213
  var valid_589214 = query.getOrDefault("quotaUser")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "quotaUser", valid_589214
  var valid_589215 = query.getOrDefault("alt")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = newJString("json"))
  if valid_589215 != nil:
    section.add "alt", valid_589215
  var valid_589216 = query.getOrDefault("oauth_token")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "oauth_token", valid_589216
  var valid_589217 = query.getOrDefault("callback")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "callback", valid_589217
  var valid_589218 = query.getOrDefault("access_token")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "access_token", valid_589218
  var valid_589219 = query.getOrDefault("uploadType")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "uploadType", valid_589219
  var valid_589220 = query.getOrDefault("key")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "key", valid_589220
  var valid_589221 = query.getOrDefault("$.xgafv")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = newJString("1"))
  if valid_589221 != nil:
    section.add "$.xgafv", valid_589221
  var valid_589222 = query.getOrDefault("prettyPrint")
  valid_589222 = validateParameter(valid_589222, JBool, required = false,
                                 default = newJBool(true))
  if valid_589222 != nil:
    section.add "prettyPrint", valid_589222
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

proc call*(call_589224: Call_PubsubTopicsPublishBatch_589209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds one or more messages to the topic. Returns NOT_FOUND if the topic does
  ## not exist.
  ## 
  let valid = call_589224.validator(path, query, header, formData, body)
  let scheme = call_589224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589224.url(scheme.get, call_589224.host, call_589224.base,
                         call_589224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589224, url, valid)

proc call*(call_589225: Call_PubsubTopicsPublishBatch_589209;
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
  var query_589226 = newJObject()
  var body_589227 = newJObject()
  add(query_589226, "upload_protocol", newJString(uploadProtocol))
  add(query_589226, "fields", newJString(fields))
  add(query_589226, "quotaUser", newJString(quotaUser))
  add(query_589226, "alt", newJString(alt))
  add(query_589226, "oauth_token", newJString(oauthToken))
  add(query_589226, "callback", newJString(callback))
  add(query_589226, "access_token", newJString(accessToken))
  add(query_589226, "uploadType", newJString(uploadType))
  add(query_589226, "key", newJString(key))
  add(query_589226, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589227 = body
  add(query_589226, "prettyPrint", newJBool(prettyPrint))
  result = call_589225.call(nil, query_589226, nil, nil, body_589227)

var pubsubTopicsPublishBatch* = Call_PubsubTopicsPublishBatch_589209(
    name: "pubsubTopicsPublishBatch", meth: HttpMethod.HttpPost,
    host: "pubsub.googleapis.com", route: "/v1beta1a/topics/publishBatch",
    validator: validate_PubsubTopicsPublishBatch_589210, base: "/",
    url: url_PubsubTopicsPublishBatch_589211, schemes: {Scheme.Https})
type
  Call_PubsubTopicsGet_589228 = ref object of OpenApiRestCall_588441
proc url_PubsubTopicsGet_589230(protocol: Scheme; host: string; base: string;
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

proc validate_PubsubTopicsGet_589229(path: JsonNode; query: JsonNode;
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
  var valid_589231 = path.getOrDefault("topic")
  valid_589231 = validateParameter(valid_589231, JString, required = true,
                                 default = nil)
  if valid_589231 != nil:
    section.add "topic", valid_589231
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
  var valid_589232 = query.getOrDefault("upload_protocol")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "upload_protocol", valid_589232
  var valid_589233 = query.getOrDefault("fields")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "fields", valid_589233
  var valid_589234 = query.getOrDefault("quotaUser")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "quotaUser", valid_589234
  var valid_589235 = query.getOrDefault("alt")
  valid_589235 = validateParameter(valid_589235, JString, required = false,
                                 default = newJString("json"))
  if valid_589235 != nil:
    section.add "alt", valid_589235
  var valid_589236 = query.getOrDefault("oauth_token")
  valid_589236 = validateParameter(valid_589236, JString, required = false,
                                 default = nil)
  if valid_589236 != nil:
    section.add "oauth_token", valid_589236
  var valid_589237 = query.getOrDefault("callback")
  valid_589237 = validateParameter(valid_589237, JString, required = false,
                                 default = nil)
  if valid_589237 != nil:
    section.add "callback", valid_589237
  var valid_589238 = query.getOrDefault("access_token")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "access_token", valid_589238
  var valid_589239 = query.getOrDefault("uploadType")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "uploadType", valid_589239
  var valid_589240 = query.getOrDefault("key")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "key", valid_589240
  var valid_589241 = query.getOrDefault("$.xgafv")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = newJString("1"))
  if valid_589241 != nil:
    section.add "$.xgafv", valid_589241
  var valid_589242 = query.getOrDefault("prettyPrint")
  valid_589242 = validateParameter(valid_589242, JBool, required = false,
                                 default = newJBool(true))
  if valid_589242 != nil:
    section.add "prettyPrint", valid_589242
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589243: Call_PubsubTopicsGet_589228; path: JsonNode; query: JsonNode;
          header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the configuration of a topic. Since the topic only has the name
  ## attribute, this method is only useful to check the existence of a topic.
  ## If other attributes are added in the future, they will be returned here.
  ## 
  let valid = call_589243.validator(path, query, header, formData, body)
  let scheme = call_589243.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589243.url(scheme.get, call_589243.host, call_589243.base,
                         call_589243.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589243, url, valid)

proc call*(call_589244: Call_PubsubTopicsGet_589228; topic: string;
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
  var path_589245 = newJObject()
  var query_589246 = newJObject()
  add(query_589246, "upload_protocol", newJString(uploadProtocol))
  add(query_589246, "fields", newJString(fields))
  add(query_589246, "quotaUser", newJString(quotaUser))
  add(query_589246, "alt", newJString(alt))
  add(query_589246, "oauth_token", newJString(oauthToken))
  add(query_589246, "callback", newJString(callback))
  add(query_589246, "access_token", newJString(accessToken))
  add(query_589246, "uploadType", newJString(uploadType))
  add(query_589246, "key", newJString(key))
  add(path_589245, "topic", newJString(topic))
  add(query_589246, "$.xgafv", newJString(Xgafv))
  add(query_589246, "prettyPrint", newJBool(prettyPrint))
  result = call_589244.call(path_589245, query_589246, nil, nil, nil)

var pubsubTopicsGet* = Call_PubsubTopicsGet_589228(name: "pubsubTopicsGet",
    meth: HttpMethod.HttpGet, host: "pubsub.googleapis.com",
    route: "/v1beta1a/topics/{topic}", validator: validate_PubsubTopicsGet_589229,
    base: "/", url: url_PubsubTopicsGet_589230, schemes: {Scheme.Https})
type
  Call_PubsubTopicsDelete_589247 = ref object of OpenApiRestCall_588441
proc url_PubsubTopicsDelete_589249(protocol: Scheme; host: string; base: string;
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

proc validate_PubsubTopicsDelete_589248(path: JsonNode; query: JsonNode;
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
  var valid_589250 = path.getOrDefault("topic")
  valid_589250 = validateParameter(valid_589250, JString, required = true,
                                 default = nil)
  if valid_589250 != nil:
    section.add "topic", valid_589250
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
  var valid_589251 = query.getOrDefault("upload_protocol")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "upload_protocol", valid_589251
  var valid_589252 = query.getOrDefault("fields")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "fields", valid_589252
  var valid_589253 = query.getOrDefault("quotaUser")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "quotaUser", valid_589253
  var valid_589254 = query.getOrDefault("alt")
  valid_589254 = validateParameter(valid_589254, JString, required = false,
                                 default = newJString("json"))
  if valid_589254 != nil:
    section.add "alt", valid_589254
  var valid_589255 = query.getOrDefault("oauth_token")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "oauth_token", valid_589255
  var valid_589256 = query.getOrDefault("callback")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "callback", valid_589256
  var valid_589257 = query.getOrDefault("access_token")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = nil)
  if valid_589257 != nil:
    section.add "access_token", valid_589257
  var valid_589258 = query.getOrDefault("uploadType")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "uploadType", valid_589258
  var valid_589259 = query.getOrDefault("key")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "key", valid_589259
  var valid_589260 = query.getOrDefault("$.xgafv")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = newJString("1"))
  if valid_589260 != nil:
    section.add "$.xgafv", valid_589260
  var valid_589261 = query.getOrDefault("prettyPrint")
  valid_589261 = validateParameter(valid_589261, JBool, required = false,
                                 default = newJBool(true))
  if valid_589261 != nil:
    section.add "prettyPrint", valid_589261
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589262: Call_PubsubTopicsDelete_589247; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the topic with the given name. Returns NOT_FOUND if the topic does
  ## not exist. After a topic is deleted, a new topic may be created with the
  ## same name.
  ## 
  let valid = call_589262.validator(path, query, header, formData, body)
  let scheme = call_589262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589262.url(scheme.get, call_589262.host, call_589262.base,
                         call_589262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589262, url, valid)

proc call*(call_589263: Call_PubsubTopicsDelete_589247; topic: string;
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
  var path_589264 = newJObject()
  var query_589265 = newJObject()
  add(query_589265, "upload_protocol", newJString(uploadProtocol))
  add(query_589265, "fields", newJString(fields))
  add(query_589265, "quotaUser", newJString(quotaUser))
  add(query_589265, "alt", newJString(alt))
  add(query_589265, "oauth_token", newJString(oauthToken))
  add(query_589265, "callback", newJString(callback))
  add(query_589265, "access_token", newJString(accessToken))
  add(query_589265, "uploadType", newJString(uploadType))
  add(query_589265, "key", newJString(key))
  add(path_589264, "topic", newJString(topic))
  add(query_589265, "$.xgafv", newJString(Xgafv))
  add(query_589265, "prettyPrint", newJBool(prettyPrint))
  result = call_589263.call(path_589264, query_589265, nil, nil, nil)

var pubsubTopicsDelete* = Call_PubsubTopicsDelete_589247(
    name: "pubsubTopicsDelete", meth: HttpMethod.HttpDelete,
    host: "pubsub.googleapis.com", route: "/v1beta1a/topics/{topic}",
    validator: validate_PubsubTopicsDelete_589248, base: "/",
    url: url_PubsubTopicsDelete_589249, schemes: {Scheme.Https})
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
