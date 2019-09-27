
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Google Play EMM
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages the deployment of apps to Android for Work users.
## 
## https://developers.google.com/android/work/play/emm-api
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

  OpenApiRestCall_597421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597421): Option[Scheme] {.used.} =
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
  gcpServiceName = "androidenterprise"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidenterpriseEnterprisesList_597689 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesList_597691(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesList_597690(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Looks up an enterprise by domain name. This is only supported for enterprises created via the Google-initiated creation flow. Lookup of the id is not needed for enterprises created via the EMM-initiated flow since the EMM learns the enterprise ID in the callback specified in the Enterprises.generateSignupUrl call.
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   domain: JString (required)
  ##         : The exact primary domain name of the enterprise to look up.
  section = newJObject()
  var valid_597803 = query.getOrDefault("fields")
  valid_597803 = validateParameter(valid_597803, JString, required = false,
                                 default = nil)
  if valid_597803 != nil:
    section.add "fields", valid_597803
  var valid_597804 = query.getOrDefault("quotaUser")
  valid_597804 = validateParameter(valid_597804, JString, required = false,
                                 default = nil)
  if valid_597804 != nil:
    section.add "quotaUser", valid_597804
  var valid_597818 = query.getOrDefault("alt")
  valid_597818 = validateParameter(valid_597818, JString, required = false,
                                 default = newJString("json"))
  if valid_597818 != nil:
    section.add "alt", valid_597818
  var valid_597819 = query.getOrDefault("oauth_token")
  valid_597819 = validateParameter(valid_597819, JString, required = false,
                                 default = nil)
  if valid_597819 != nil:
    section.add "oauth_token", valid_597819
  var valid_597820 = query.getOrDefault("userIp")
  valid_597820 = validateParameter(valid_597820, JString, required = false,
                                 default = nil)
  if valid_597820 != nil:
    section.add "userIp", valid_597820
  var valid_597821 = query.getOrDefault("key")
  valid_597821 = validateParameter(valid_597821, JString, required = false,
                                 default = nil)
  if valid_597821 != nil:
    section.add "key", valid_597821
  var valid_597822 = query.getOrDefault("prettyPrint")
  valid_597822 = validateParameter(valid_597822, JBool, required = false,
                                 default = newJBool(true))
  if valid_597822 != nil:
    section.add "prettyPrint", valid_597822
  assert query != nil, "query argument is necessary due to required `domain` field"
  var valid_597823 = query.getOrDefault("domain")
  valid_597823 = validateParameter(valid_597823, JString, required = true,
                                 default = nil)
  if valid_597823 != nil:
    section.add "domain", valid_597823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597846: Call_AndroidenterpriseEnterprisesList_597689;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up an enterprise by domain name. This is only supported for enterprises created via the Google-initiated creation flow. Lookup of the id is not needed for enterprises created via the EMM-initiated flow since the EMM learns the enterprise ID in the callback specified in the Enterprises.generateSignupUrl call.
  ## 
  let valid = call_597846.validator(path, query, header, formData, body)
  let scheme = call_597846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597846.url(scheme.get, call_597846.host, call_597846.base,
                         call_597846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597846, url, valid)

proc call*(call_597917: Call_AndroidenterpriseEnterprisesList_597689;
          domain: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEnterprisesList
  ## Looks up an enterprise by domain name. This is only supported for enterprises created via the Google-initiated creation flow. Lookup of the id is not needed for enterprises created via the EMM-initiated flow since the EMM learns the enterprise ID in the callback specified in the Enterprises.generateSignupUrl call.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   domain: string (required)
  ##         : The exact primary domain name of the enterprise to look up.
  var query_597918 = newJObject()
  add(query_597918, "fields", newJString(fields))
  add(query_597918, "quotaUser", newJString(quotaUser))
  add(query_597918, "alt", newJString(alt))
  add(query_597918, "oauth_token", newJString(oauthToken))
  add(query_597918, "userIp", newJString(userIp))
  add(query_597918, "key", newJString(key))
  add(query_597918, "prettyPrint", newJBool(prettyPrint))
  add(query_597918, "domain", newJString(domain))
  result = call_597917.call(nil, query_597918, nil, nil, nil)

var androidenterpriseEnterprisesList* = Call_AndroidenterpriseEnterprisesList_597689(
    name: "androidenterpriseEnterprisesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises",
    validator: validate_AndroidenterpriseEnterprisesList_597690,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesList_597691,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_597958 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_597960(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_597959(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Acknowledges notifications that were received from Enterprises.PullNotificationSet to prevent subsequent calls from returning the same notifications.
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
  ##   notificationSetId: JString
  ##                    : The notification set ID as returned by Enterprises.PullNotificationSet. This must be provided.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597961 = query.getOrDefault("fields")
  valid_597961 = validateParameter(valid_597961, JString, required = false,
                                 default = nil)
  if valid_597961 != nil:
    section.add "fields", valid_597961
  var valid_597962 = query.getOrDefault("quotaUser")
  valid_597962 = validateParameter(valid_597962, JString, required = false,
                                 default = nil)
  if valid_597962 != nil:
    section.add "quotaUser", valid_597962
  var valid_597963 = query.getOrDefault("alt")
  valid_597963 = validateParameter(valid_597963, JString, required = false,
                                 default = newJString("json"))
  if valid_597963 != nil:
    section.add "alt", valid_597963
  var valid_597964 = query.getOrDefault("oauth_token")
  valid_597964 = validateParameter(valid_597964, JString, required = false,
                                 default = nil)
  if valid_597964 != nil:
    section.add "oauth_token", valid_597964
  var valid_597965 = query.getOrDefault("userIp")
  valid_597965 = validateParameter(valid_597965, JString, required = false,
                                 default = nil)
  if valid_597965 != nil:
    section.add "userIp", valid_597965
  var valid_597966 = query.getOrDefault("notificationSetId")
  valid_597966 = validateParameter(valid_597966, JString, required = false,
                                 default = nil)
  if valid_597966 != nil:
    section.add "notificationSetId", valid_597966
  var valid_597967 = query.getOrDefault("key")
  valid_597967 = validateParameter(valid_597967, JString, required = false,
                                 default = nil)
  if valid_597967 != nil:
    section.add "key", valid_597967
  var valid_597968 = query.getOrDefault("prettyPrint")
  valid_597968 = validateParameter(valid_597968, JBool, required = false,
                                 default = newJBool(true))
  if valid_597968 != nil:
    section.add "prettyPrint", valid_597968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597969: Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_597958;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges notifications that were received from Enterprises.PullNotificationSet to prevent subsequent calls from returning the same notifications.
  ## 
  let valid = call_597969.validator(path, query, header, formData, body)
  let scheme = call_597969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597969.url(scheme.get, call_597969.host, call_597969.base,
                         call_597969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597969, url, valid)

proc call*(call_597970: Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_597958;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; notificationSetId: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEnterprisesAcknowledgeNotificationSet
  ## Acknowledges notifications that were received from Enterprises.PullNotificationSet to prevent subsequent calls from returning the same notifications.
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
  ##   notificationSetId: string
  ##                    : The notification set ID as returned by Enterprises.PullNotificationSet. This must be provided.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_597971 = newJObject()
  add(query_597971, "fields", newJString(fields))
  add(query_597971, "quotaUser", newJString(quotaUser))
  add(query_597971, "alt", newJString(alt))
  add(query_597971, "oauth_token", newJString(oauthToken))
  add(query_597971, "userIp", newJString(userIp))
  add(query_597971, "notificationSetId", newJString(notificationSetId))
  add(query_597971, "key", newJString(key))
  add(query_597971, "prettyPrint", newJBool(prettyPrint))
  result = call_597970.call(nil, query_597971, nil, nil, nil)

var androidenterpriseEnterprisesAcknowledgeNotificationSet* = Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_597958(
    name: "androidenterpriseEnterprisesAcknowledgeNotificationSet",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/acknowledgeNotificationSet",
    validator: validate_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_597959,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_597960,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesCompleteSignup_597972 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesCompleteSignup_597974(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesCompleteSignup_597973(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Completes the signup flow, by specifying the Completion token and Enterprise token. This request must not be called multiple times for a given Enterprise Token.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   completionToken: JString
  ##                  : The Completion token initially returned by GenerateSignupUrl.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   enterpriseToken: JString
  ##                  : The Enterprise token appended to the Callback URL.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_597975 = query.getOrDefault("fields")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "fields", valid_597975
  var valid_597976 = query.getOrDefault("completionToken")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "completionToken", valid_597976
  var valid_597977 = query.getOrDefault("quotaUser")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "quotaUser", valid_597977
  var valid_597978 = query.getOrDefault("alt")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = newJString("json"))
  if valid_597978 != nil:
    section.add "alt", valid_597978
  var valid_597979 = query.getOrDefault("oauth_token")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "oauth_token", valid_597979
  var valid_597980 = query.getOrDefault("userIp")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = nil)
  if valid_597980 != nil:
    section.add "userIp", valid_597980
  var valid_597981 = query.getOrDefault("enterpriseToken")
  valid_597981 = validateParameter(valid_597981, JString, required = false,
                                 default = nil)
  if valid_597981 != nil:
    section.add "enterpriseToken", valid_597981
  var valid_597982 = query.getOrDefault("key")
  valid_597982 = validateParameter(valid_597982, JString, required = false,
                                 default = nil)
  if valid_597982 != nil:
    section.add "key", valid_597982
  var valid_597983 = query.getOrDefault("prettyPrint")
  valid_597983 = validateParameter(valid_597983, JBool, required = false,
                                 default = newJBool(true))
  if valid_597983 != nil:
    section.add "prettyPrint", valid_597983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597984: Call_AndroidenterpriseEnterprisesCompleteSignup_597972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes the signup flow, by specifying the Completion token and Enterprise token. This request must not be called multiple times for a given Enterprise Token.
  ## 
  let valid = call_597984.validator(path, query, header, formData, body)
  let scheme = call_597984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597984.url(scheme.get, call_597984.host, call_597984.base,
                         call_597984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597984, url, valid)

proc call*(call_597985: Call_AndroidenterpriseEnterprisesCompleteSignup_597972;
          fields: string = ""; completionToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          enterpriseToken: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEnterprisesCompleteSignup
  ## Completes the signup flow, by specifying the Completion token and Enterprise token. This request must not be called multiple times for a given Enterprise Token.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   completionToken: string
  ##                  : The Completion token initially returned by GenerateSignupUrl.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   enterpriseToken: string
  ##                  : The Enterprise token appended to the Callback URL.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_597986 = newJObject()
  add(query_597986, "fields", newJString(fields))
  add(query_597986, "completionToken", newJString(completionToken))
  add(query_597986, "quotaUser", newJString(quotaUser))
  add(query_597986, "alt", newJString(alt))
  add(query_597986, "oauth_token", newJString(oauthToken))
  add(query_597986, "userIp", newJString(userIp))
  add(query_597986, "enterpriseToken", newJString(enterpriseToken))
  add(query_597986, "key", newJString(key))
  add(query_597986, "prettyPrint", newJBool(prettyPrint))
  result = call_597985.call(nil, query_597986, nil, nil, nil)

var androidenterpriseEnterprisesCompleteSignup* = Call_AndroidenterpriseEnterprisesCompleteSignup_597972(
    name: "androidenterpriseEnterprisesCompleteSignup", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/completeSignup",
    validator: validate_AndroidenterpriseEnterprisesCompleteSignup_597973,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesCompleteSignup_597974,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesEnroll_597987 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesEnroll_597989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesEnroll_597988(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Enrolls an enterprise with the calling EMM.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   token: JString (required)
  ##        : The token provided by the enterprise to register the EMM.
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  assert query != nil, "query argument is necessary due to required `token` field"
  var valid_597990 = query.getOrDefault("token")
  valid_597990 = validateParameter(valid_597990, JString, required = true,
                                 default = nil)
  if valid_597990 != nil:
    section.add "token", valid_597990
  var valid_597991 = query.getOrDefault("fields")
  valid_597991 = validateParameter(valid_597991, JString, required = false,
                                 default = nil)
  if valid_597991 != nil:
    section.add "fields", valid_597991
  var valid_597992 = query.getOrDefault("quotaUser")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "quotaUser", valid_597992
  var valid_597993 = query.getOrDefault("alt")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = newJString("json"))
  if valid_597993 != nil:
    section.add "alt", valid_597993
  var valid_597994 = query.getOrDefault("oauth_token")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "oauth_token", valid_597994
  var valid_597995 = query.getOrDefault("userIp")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = nil)
  if valid_597995 != nil:
    section.add "userIp", valid_597995
  var valid_597996 = query.getOrDefault("key")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "key", valid_597996
  var valid_597997 = query.getOrDefault("prettyPrint")
  valid_597997 = validateParameter(valid_597997, JBool, required = false,
                                 default = newJBool(true))
  if valid_597997 != nil:
    section.add "prettyPrint", valid_597997
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

proc call*(call_597999: Call_AndroidenterpriseEnterprisesEnroll_597987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enrolls an enterprise with the calling EMM.
  ## 
  let valid = call_597999.validator(path, query, header, formData, body)
  let scheme = call_597999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597999.url(scheme.get, call_597999.host, call_597999.base,
                         call_597999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597999, url, valid)

proc call*(call_598000: Call_AndroidenterpriseEnterprisesEnroll_597987;
          token: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEnterprisesEnroll
  ## Enrolls an enterprise with the calling EMM.
  ##   token: string (required)
  ##        : The token provided by the enterprise to register the EMM.
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
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598001 = newJObject()
  var body_598002 = newJObject()
  add(query_598001, "token", newJString(token))
  add(query_598001, "fields", newJString(fields))
  add(query_598001, "quotaUser", newJString(quotaUser))
  add(query_598001, "alt", newJString(alt))
  add(query_598001, "oauth_token", newJString(oauthToken))
  add(query_598001, "userIp", newJString(userIp))
  add(query_598001, "key", newJString(key))
  if body != nil:
    body_598002 = body
  add(query_598001, "prettyPrint", newJBool(prettyPrint))
  result = call_598000.call(nil, query_598001, nil, nil, body_598002)

var androidenterpriseEnterprisesEnroll* = Call_AndroidenterpriseEnterprisesEnroll_597987(
    name: "androidenterpriseEnterprisesEnroll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/enroll",
    validator: validate_AndroidenterpriseEnterprisesEnroll_597988,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesEnroll_597989,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesPullNotificationSet_598003 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesPullNotificationSet_598005(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesPullNotificationSet_598004(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Pulls and returns a notification set for the enterprises associated with the service account authenticated for the request. The notification set may be empty if no notification are pending.
  ## A notification set returned needs to be acknowledged within 20 seconds by calling Enterprises.AcknowledgeNotificationSet, unless the notification set is empty.
  ## Notifications that are not acknowledged within the 20 seconds will eventually be included again in the response to another PullNotificationSet request, and those that are never acknowledged will ultimately be deleted according to the Google Cloud Platform Pub/Sub system policy.
  ## Multiple requests might be performed concurrently to retrieve notifications, in which case the pending notifications (if any) will be split among each caller, if any are pending.
  ## If no notifications are present, an empty notification list is returned. Subsequent requests may return more notifications once they become available.
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   requestMode: JString
  ##              : The request mode for pulling notifications.
  ## Specifying waitForNotifications will cause the request to block and wait until one or more notifications are present, or return an empty notification list if no notifications are present after some time.
  ## Speciying returnImmediately will cause the request to immediately return the pending notifications, or an empty list if no notifications are present.
  ## If omitted, defaults to waitForNotifications.
  section = newJObject()
  var valid_598006 = query.getOrDefault("fields")
  valid_598006 = validateParameter(valid_598006, JString, required = false,
                                 default = nil)
  if valid_598006 != nil:
    section.add "fields", valid_598006
  var valid_598007 = query.getOrDefault("quotaUser")
  valid_598007 = validateParameter(valid_598007, JString, required = false,
                                 default = nil)
  if valid_598007 != nil:
    section.add "quotaUser", valid_598007
  var valid_598008 = query.getOrDefault("alt")
  valid_598008 = validateParameter(valid_598008, JString, required = false,
                                 default = newJString("json"))
  if valid_598008 != nil:
    section.add "alt", valid_598008
  var valid_598009 = query.getOrDefault("oauth_token")
  valid_598009 = validateParameter(valid_598009, JString, required = false,
                                 default = nil)
  if valid_598009 != nil:
    section.add "oauth_token", valid_598009
  var valid_598010 = query.getOrDefault("userIp")
  valid_598010 = validateParameter(valid_598010, JString, required = false,
                                 default = nil)
  if valid_598010 != nil:
    section.add "userIp", valid_598010
  var valid_598011 = query.getOrDefault("key")
  valid_598011 = validateParameter(valid_598011, JString, required = false,
                                 default = nil)
  if valid_598011 != nil:
    section.add "key", valid_598011
  var valid_598012 = query.getOrDefault("prettyPrint")
  valid_598012 = validateParameter(valid_598012, JBool, required = false,
                                 default = newJBool(true))
  if valid_598012 != nil:
    section.add "prettyPrint", valid_598012
  var valid_598013 = query.getOrDefault("requestMode")
  valid_598013 = validateParameter(valid_598013, JString, required = false,
                                 default = newJString("returnImmediately"))
  if valid_598013 != nil:
    section.add "requestMode", valid_598013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598014: Call_AndroidenterpriseEnterprisesPullNotificationSet_598003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pulls and returns a notification set for the enterprises associated with the service account authenticated for the request. The notification set may be empty if no notification are pending.
  ## A notification set returned needs to be acknowledged within 20 seconds by calling Enterprises.AcknowledgeNotificationSet, unless the notification set is empty.
  ## Notifications that are not acknowledged within the 20 seconds will eventually be included again in the response to another PullNotificationSet request, and those that are never acknowledged will ultimately be deleted according to the Google Cloud Platform Pub/Sub system policy.
  ## Multiple requests might be performed concurrently to retrieve notifications, in which case the pending notifications (if any) will be split among each caller, if any are pending.
  ## If no notifications are present, an empty notification list is returned. Subsequent requests may return more notifications once they become available.
  ## 
  let valid = call_598014.validator(path, query, header, formData, body)
  let scheme = call_598014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598014.url(scheme.get, call_598014.host, call_598014.base,
                         call_598014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598014, url, valid)

proc call*(call_598015: Call_AndroidenterpriseEnterprisesPullNotificationSet_598003;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true; requestMode: string = "returnImmediately"): Recallable =
  ## androidenterpriseEnterprisesPullNotificationSet
  ## Pulls and returns a notification set for the enterprises associated with the service account authenticated for the request. The notification set may be empty if no notification are pending.
  ## A notification set returned needs to be acknowledged within 20 seconds by calling Enterprises.AcknowledgeNotificationSet, unless the notification set is empty.
  ## Notifications that are not acknowledged within the 20 seconds will eventually be included again in the response to another PullNotificationSet request, and those that are never acknowledged will ultimately be deleted according to the Google Cloud Platform Pub/Sub system policy.
  ## Multiple requests might be performed concurrently to retrieve notifications, in which case the pending notifications (if any) will be split among each caller, if any are pending.
  ## If no notifications are present, an empty notification list is returned. Subsequent requests may return more notifications once they become available.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   requestMode: string
  ##              : The request mode for pulling notifications.
  ## Specifying waitForNotifications will cause the request to block and wait until one or more notifications are present, or return an empty notification list if no notifications are present after some time.
  ## Speciying returnImmediately will cause the request to immediately return the pending notifications, or an empty list if no notifications are present.
  ## If omitted, defaults to waitForNotifications.
  var query_598016 = newJObject()
  add(query_598016, "fields", newJString(fields))
  add(query_598016, "quotaUser", newJString(quotaUser))
  add(query_598016, "alt", newJString(alt))
  add(query_598016, "oauth_token", newJString(oauthToken))
  add(query_598016, "userIp", newJString(userIp))
  add(query_598016, "key", newJString(key))
  add(query_598016, "prettyPrint", newJBool(prettyPrint))
  add(query_598016, "requestMode", newJString(requestMode))
  result = call_598015.call(nil, query_598016, nil, nil, nil)

var androidenterpriseEnterprisesPullNotificationSet* = Call_AndroidenterpriseEnterprisesPullNotificationSet_598003(
    name: "androidenterpriseEnterprisesPullNotificationSet",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/pullNotificationSet",
    validator: validate_AndroidenterpriseEnterprisesPullNotificationSet_598004,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesPullNotificationSet_598005,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGenerateSignupUrl_598017 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesGenerateSignupUrl_598019(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesGenerateSignupUrl_598018(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Generates a sign-up URL.
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
  ##   callbackUrl: JString
  ##              : The callback URL to which the Admin will be redirected after successfully creating an enterprise. Before redirecting there the system will add a single query parameter to this URL named "enterpriseToken" which will contain an opaque token to be used for the CompleteSignup request.
  ## Beware that this means that the URL will be parsed, the parameter added and then a new URL formatted, i.e. there may be some minor formatting changes and, more importantly, the URL must be well-formed so that it can be parsed.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598020 = query.getOrDefault("fields")
  valid_598020 = validateParameter(valid_598020, JString, required = false,
                                 default = nil)
  if valid_598020 != nil:
    section.add "fields", valid_598020
  var valid_598021 = query.getOrDefault("quotaUser")
  valid_598021 = validateParameter(valid_598021, JString, required = false,
                                 default = nil)
  if valid_598021 != nil:
    section.add "quotaUser", valid_598021
  var valid_598022 = query.getOrDefault("callbackUrl")
  valid_598022 = validateParameter(valid_598022, JString, required = false,
                                 default = nil)
  if valid_598022 != nil:
    section.add "callbackUrl", valid_598022
  var valid_598023 = query.getOrDefault("alt")
  valid_598023 = validateParameter(valid_598023, JString, required = false,
                                 default = newJString("json"))
  if valid_598023 != nil:
    section.add "alt", valid_598023
  var valid_598024 = query.getOrDefault("oauth_token")
  valid_598024 = validateParameter(valid_598024, JString, required = false,
                                 default = nil)
  if valid_598024 != nil:
    section.add "oauth_token", valid_598024
  var valid_598025 = query.getOrDefault("userIp")
  valid_598025 = validateParameter(valid_598025, JString, required = false,
                                 default = nil)
  if valid_598025 != nil:
    section.add "userIp", valid_598025
  var valid_598026 = query.getOrDefault("key")
  valid_598026 = validateParameter(valid_598026, JString, required = false,
                                 default = nil)
  if valid_598026 != nil:
    section.add "key", valid_598026
  var valid_598027 = query.getOrDefault("prettyPrint")
  valid_598027 = validateParameter(valid_598027, JBool, required = false,
                                 default = newJBool(true))
  if valid_598027 != nil:
    section.add "prettyPrint", valid_598027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598028: Call_AndroidenterpriseEnterprisesGenerateSignupUrl_598017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a sign-up URL.
  ## 
  let valid = call_598028.validator(path, query, header, formData, body)
  let scheme = call_598028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598028.url(scheme.get, call_598028.host, call_598028.base,
                         call_598028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598028, url, valid)

proc call*(call_598029: Call_AndroidenterpriseEnterprisesGenerateSignupUrl_598017;
          fields: string = ""; quotaUser: string = ""; callbackUrl: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEnterprisesGenerateSignupUrl
  ## Generates a sign-up URL.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   callbackUrl: string
  ##              : The callback URL to which the Admin will be redirected after successfully creating an enterprise. Before redirecting there the system will add a single query parameter to this URL named "enterpriseToken" which will contain an opaque token to be used for the CompleteSignup request.
  ## Beware that this means that the URL will be parsed, the parameter added and then a new URL formatted, i.e. there may be some minor formatting changes and, more importantly, the URL must be well-formed so that it can be parsed.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_598030 = newJObject()
  add(query_598030, "fields", newJString(fields))
  add(query_598030, "quotaUser", newJString(quotaUser))
  add(query_598030, "callbackUrl", newJString(callbackUrl))
  add(query_598030, "alt", newJString(alt))
  add(query_598030, "oauth_token", newJString(oauthToken))
  add(query_598030, "userIp", newJString(userIp))
  add(query_598030, "key", newJString(key))
  add(query_598030, "prettyPrint", newJBool(prettyPrint))
  result = call_598029.call(nil, query_598030, nil, nil, nil)

var androidenterpriseEnterprisesGenerateSignupUrl* = Call_AndroidenterpriseEnterprisesGenerateSignupUrl_598017(
    name: "androidenterpriseEnterprisesGenerateSignupUrl",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/signupUrl",
    validator: validate_AndroidenterpriseEnterprisesGenerateSignupUrl_598018,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesGenerateSignupUrl_598019,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGet_598031 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesGet_598033(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesGet_598032(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the name and domain of an enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598048 = path.getOrDefault("enterpriseId")
  valid_598048 = validateParameter(valid_598048, JString, required = true,
                                 default = nil)
  if valid_598048 != nil:
    section.add "enterpriseId", valid_598048
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598049 = query.getOrDefault("fields")
  valid_598049 = validateParameter(valid_598049, JString, required = false,
                                 default = nil)
  if valid_598049 != nil:
    section.add "fields", valid_598049
  var valid_598050 = query.getOrDefault("quotaUser")
  valid_598050 = validateParameter(valid_598050, JString, required = false,
                                 default = nil)
  if valid_598050 != nil:
    section.add "quotaUser", valid_598050
  var valid_598051 = query.getOrDefault("alt")
  valid_598051 = validateParameter(valid_598051, JString, required = false,
                                 default = newJString("json"))
  if valid_598051 != nil:
    section.add "alt", valid_598051
  var valid_598052 = query.getOrDefault("oauth_token")
  valid_598052 = validateParameter(valid_598052, JString, required = false,
                                 default = nil)
  if valid_598052 != nil:
    section.add "oauth_token", valid_598052
  var valid_598053 = query.getOrDefault("userIp")
  valid_598053 = validateParameter(valid_598053, JString, required = false,
                                 default = nil)
  if valid_598053 != nil:
    section.add "userIp", valid_598053
  var valid_598054 = query.getOrDefault("key")
  valid_598054 = validateParameter(valid_598054, JString, required = false,
                                 default = nil)
  if valid_598054 != nil:
    section.add "key", valid_598054
  var valid_598055 = query.getOrDefault("prettyPrint")
  valid_598055 = validateParameter(valid_598055, JBool, required = false,
                                 default = newJBool(true))
  if valid_598055 != nil:
    section.add "prettyPrint", valid_598055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598056: Call_AndroidenterpriseEnterprisesGet_598031;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the name and domain of an enterprise.
  ## 
  let valid = call_598056.validator(path, query, header, formData, body)
  let scheme = call_598056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598056.url(scheme.get, call_598056.host, call_598056.base,
                         call_598056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598056, url, valid)

proc call*(call_598057: Call_AndroidenterpriseEnterprisesGet_598031;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEnterprisesGet
  ## Retrieves the name and domain of an enterprise.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598058 = newJObject()
  var query_598059 = newJObject()
  add(query_598059, "fields", newJString(fields))
  add(query_598059, "quotaUser", newJString(quotaUser))
  add(query_598059, "alt", newJString(alt))
  add(query_598059, "oauth_token", newJString(oauthToken))
  add(query_598059, "userIp", newJString(userIp))
  add(query_598059, "key", newJString(key))
  add(path_598058, "enterpriseId", newJString(enterpriseId))
  add(query_598059, "prettyPrint", newJBool(prettyPrint))
  result = call_598057.call(path_598058, query_598059, nil, nil, nil)

var androidenterpriseEnterprisesGet* = Call_AndroidenterpriseEnterprisesGet_598031(
    name: "androidenterpriseEnterprisesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}",
    validator: validate_AndroidenterpriseEnterprisesGet_598032,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesGet_598033,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesSetAccount_598060 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesSetAccount_598062(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/account")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesSetAccount_598061(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the account that will be used to authenticate to the API as the enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598063 = path.getOrDefault("enterpriseId")
  valid_598063 = validateParameter(valid_598063, JString, required = true,
                                 default = nil)
  if valid_598063 != nil:
    section.add "enterpriseId", valid_598063
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598064 = query.getOrDefault("fields")
  valid_598064 = validateParameter(valid_598064, JString, required = false,
                                 default = nil)
  if valid_598064 != nil:
    section.add "fields", valid_598064
  var valid_598065 = query.getOrDefault("quotaUser")
  valid_598065 = validateParameter(valid_598065, JString, required = false,
                                 default = nil)
  if valid_598065 != nil:
    section.add "quotaUser", valid_598065
  var valid_598066 = query.getOrDefault("alt")
  valid_598066 = validateParameter(valid_598066, JString, required = false,
                                 default = newJString("json"))
  if valid_598066 != nil:
    section.add "alt", valid_598066
  var valid_598067 = query.getOrDefault("oauth_token")
  valid_598067 = validateParameter(valid_598067, JString, required = false,
                                 default = nil)
  if valid_598067 != nil:
    section.add "oauth_token", valid_598067
  var valid_598068 = query.getOrDefault("userIp")
  valid_598068 = validateParameter(valid_598068, JString, required = false,
                                 default = nil)
  if valid_598068 != nil:
    section.add "userIp", valid_598068
  var valid_598069 = query.getOrDefault("key")
  valid_598069 = validateParameter(valid_598069, JString, required = false,
                                 default = nil)
  if valid_598069 != nil:
    section.add "key", valid_598069
  var valid_598070 = query.getOrDefault("prettyPrint")
  valid_598070 = validateParameter(valid_598070, JBool, required = false,
                                 default = newJBool(true))
  if valid_598070 != nil:
    section.add "prettyPrint", valid_598070
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

proc call*(call_598072: Call_AndroidenterpriseEnterprisesSetAccount_598060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the account that will be used to authenticate to the API as the enterprise.
  ## 
  let valid = call_598072.validator(path, query, header, formData, body)
  let scheme = call_598072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598072.url(scheme.get, call_598072.host, call_598072.base,
                         call_598072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598072, url, valid)

proc call*(call_598073: Call_AndroidenterpriseEnterprisesSetAccount_598060;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEnterprisesSetAccount
  ## Sets the account that will be used to authenticate to the API as the enterprise.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598074 = newJObject()
  var query_598075 = newJObject()
  var body_598076 = newJObject()
  add(query_598075, "fields", newJString(fields))
  add(query_598075, "quotaUser", newJString(quotaUser))
  add(query_598075, "alt", newJString(alt))
  add(query_598075, "oauth_token", newJString(oauthToken))
  add(query_598075, "userIp", newJString(userIp))
  add(query_598075, "key", newJString(key))
  add(path_598074, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598076 = body
  add(query_598075, "prettyPrint", newJBool(prettyPrint))
  result = call_598073.call(path_598074, query_598075, nil, nil, body_598076)

var androidenterpriseEnterprisesSetAccount* = Call_AndroidenterpriseEnterprisesSetAccount_598060(
    name: "androidenterpriseEnterprisesSetAccount", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/account",
    validator: validate_AndroidenterpriseEnterprisesSetAccount_598061,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesSetAccount_598062,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesCreateWebToken_598077 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesCreateWebToken_598079(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/createWebToken")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesCreateWebToken_598078(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a unique token to access an embeddable UI. To generate a web UI, pass the generated token into the managed Google Play javascript API. Each token may only be used to start one UI session. See the javascript API documentation for further information.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598080 = path.getOrDefault("enterpriseId")
  valid_598080 = validateParameter(valid_598080, JString, required = true,
                                 default = nil)
  if valid_598080 != nil:
    section.add "enterpriseId", valid_598080
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598081 = query.getOrDefault("fields")
  valid_598081 = validateParameter(valid_598081, JString, required = false,
                                 default = nil)
  if valid_598081 != nil:
    section.add "fields", valid_598081
  var valid_598082 = query.getOrDefault("quotaUser")
  valid_598082 = validateParameter(valid_598082, JString, required = false,
                                 default = nil)
  if valid_598082 != nil:
    section.add "quotaUser", valid_598082
  var valid_598083 = query.getOrDefault("alt")
  valid_598083 = validateParameter(valid_598083, JString, required = false,
                                 default = newJString("json"))
  if valid_598083 != nil:
    section.add "alt", valid_598083
  var valid_598084 = query.getOrDefault("oauth_token")
  valid_598084 = validateParameter(valid_598084, JString, required = false,
                                 default = nil)
  if valid_598084 != nil:
    section.add "oauth_token", valid_598084
  var valid_598085 = query.getOrDefault("userIp")
  valid_598085 = validateParameter(valid_598085, JString, required = false,
                                 default = nil)
  if valid_598085 != nil:
    section.add "userIp", valid_598085
  var valid_598086 = query.getOrDefault("key")
  valid_598086 = validateParameter(valid_598086, JString, required = false,
                                 default = nil)
  if valid_598086 != nil:
    section.add "key", valid_598086
  var valid_598087 = query.getOrDefault("prettyPrint")
  valid_598087 = validateParameter(valid_598087, JBool, required = false,
                                 default = newJBool(true))
  if valid_598087 != nil:
    section.add "prettyPrint", valid_598087
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

proc call*(call_598089: Call_AndroidenterpriseEnterprisesCreateWebToken_598077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a unique token to access an embeddable UI. To generate a web UI, pass the generated token into the managed Google Play javascript API. Each token may only be used to start one UI session. See the javascript API documentation for further information.
  ## 
  let valid = call_598089.validator(path, query, header, formData, body)
  let scheme = call_598089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598089.url(scheme.get, call_598089.host, call_598089.base,
                         call_598089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598089, url, valid)

proc call*(call_598090: Call_AndroidenterpriseEnterprisesCreateWebToken_598077;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEnterprisesCreateWebToken
  ## Returns a unique token to access an embeddable UI. To generate a web UI, pass the generated token into the managed Google Play javascript API. Each token may only be used to start one UI session. See the javascript API documentation for further information.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598091 = newJObject()
  var query_598092 = newJObject()
  var body_598093 = newJObject()
  add(query_598092, "fields", newJString(fields))
  add(query_598092, "quotaUser", newJString(quotaUser))
  add(query_598092, "alt", newJString(alt))
  add(query_598092, "oauth_token", newJString(oauthToken))
  add(query_598092, "userIp", newJString(userIp))
  add(query_598092, "key", newJString(key))
  add(path_598091, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598093 = body
  add(query_598092, "prettyPrint", newJBool(prettyPrint))
  result = call_598090.call(path_598091, query_598092, nil, nil, body_598093)

var androidenterpriseEnterprisesCreateWebToken* = Call_AndroidenterpriseEnterprisesCreateWebToken_598077(
    name: "androidenterpriseEnterprisesCreateWebToken", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/createWebToken",
    validator: validate_AndroidenterpriseEnterprisesCreateWebToken_598078,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesCreateWebToken_598079,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseGrouplicensesList_598094 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseGrouplicensesList_598096(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/groupLicenses")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseGrouplicensesList_598095(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves IDs of all products for which the enterprise has a group license.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598097 = path.getOrDefault("enterpriseId")
  valid_598097 = validateParameter(valid_598097, JString, required = true,
                                 default = nil)
  if valid_598097 != nil:
    section.add "enterpriseId", valid_598097
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598098 = query.getOrDefault("fields")
  valid_598098 = validateParameter(valid_598098, JString, required = false,
                                 default = nil)
  if valid_598098 != nil:
    section.add "fields", valid_598098
  var valid_598099 = query.getOrDefault("quotaUser")
  valid_598099 = validateParameter(valid_598099, JString, required = false,
                                 default = nil)
  if valid_598099 != nil:
    section.add "quotaUser", valid_598099
  var valid_598100 = query.getOrDefault("alt")
  valid_598100 = validateParameter(valid_598100, JString, required = false,
                                 default = newJString("json"))
  if valid_598100 != nil:
    section.add "alt", valid_598100
  var valid_598101 = query.getOrDefault("oauth_token")
  valid_598101 = validateParameter(valid_598101, JString, required = false,
                                 default = nil)
  if valid_598101 != nil:
    section.add "oauth_token", valid_598101
  var valid_598102 = query.getOrDefault("userIp")
  valid_598102 = validateParameter(valid_598102, JString, required = false,
                                 default = nil)
  if valid_598102 != nil:
    section.add "userIp", valid_598102
  var valid_598103 = query.getOrDefault("key")
  valid_598103 = validateParameter(valid_598103, JString, required = false,
                                 default = nil)
  if valid_598103 != nil:
    section.add "key", valid_598103
  var valid_598104 = query.getOrDefault("prettyPrint")
  valid_598104 = validateParameter(valid_598104, JBool, required = false,
                                 default = newJBool(true))
  if valid_598104 != nil:
    section.add "prettyPrint", valid_598104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598105: Call_AndroidenterpriseGrouplicensesList_598094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves IDs of all products for which the enterprise has a group license.
  ## 
  let valid = call_598105.validator(path, query, header, formData, body)
  let scheme = call_598105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598105.url(scheme.get, call_598105.host, call_598105.base,
                         call_598105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598105, url, valid)

proc call*(call_598106: Call_AndroidenterpriseGrouplicensesList_598094;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseGrouplicensesList
  ## Retrieves IDs of all products for which the enterprise has a group license.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598107 = newJObject()
  var query_598108 = newJObject()
  add(query_598108, "fields", newJString(fields))
  add(query_598108, "quotaUser", newJString(quotaUser))
  add(query_598108, "alt", newJString(alt))
  add(query_598108, "oauth_token", newJString(oauthToken))
  add(query_598108, "userIp", newJString(userIp))
  add(query_598108, "key", newJString(key))
  add(path_598107, "enterpriseId", newJString(enterpriseId))
  add(query_598108, "prettyPrint", newJBool(prettyPrint))
  result = call_598106.call(path_598107, query_598108, nil, nil, nil)

var androidenterpriseGrouplicensesList* = Call_AndroidenterpriseGrouplicensesList_598094(
    name: "androidenterpriseGrouplicensesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/groupLicenses",
    validator: validate_AndroidenterpriseGrouplicensesList_598095,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseGrouplicensesList_598096,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseGrouplicensesGet_598109 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseGrouplicensesGet_598111(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "groupLicenseId" in path, "`groupLicenseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/groupLicenses/"),
               (kind: VariableSegment, value: "groupLicenseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseGrouplicensesGet_598110(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of an enterprise's group license for a product.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupLicenseId: JString (required)
  ##                 : The ID of the product the group license is for, e.g. "app:com.google.android.gm".
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `groupLicenseId` field"
  var valid_598112 = path.getOrDefault("groupLicenseId")
  valid_598112 = validateParameter(valid_598112, JString, required = true,
                                 default = nil)
  if valid_598112 != nil:
    section.add "groupLicenseId", valid_598112
  var valid_598113 = path.getOrDefault("enterpriseId")
  valid_598113 = validateParameter(valid_598113, JString, required = true,
                                 default = nil)
  if valid_598113 != nil:
    section.add "enterpriseId", valid_598113
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598114 = query.getOrDefault("fields")
  valid_598114 = validateParameter(valid_598114, JString, required = false,
                                 default = nil)
  if valid_598114 != nil:
    section.add "fields", valid_598114
  var valid_598115 = query.getOrDefault("quotaUser")
  valid_598115 = validateParameter(valid_598115, JString, required = false,
                                 default = nil)
  if valid_598115 != nil:
    section.add "quotaUser", valid_598115
  var valid_598116 = query.getOrDefault("alt")
  valid_598116 = validateParameter(valid_598116, JString, required = false,
                                 default = newJString("json"))
  if valid_598116 != nil:
    section.add "alt", valid_598116
  var valid_598117 = query.getOrDefault("oauth_token")
  valid_598117 = validateParameter(valid_598117, JString, required = false,
                                 default = nil)
  if valid_598117 != nil:
    section.add "oauth_token", valid_598117
  var valid_598118 = query.getOrDefault("userIp")
  valid_598118 = validateParameter(valid_598118, JString, required = false,
                                 default = nil)
  if valid_598118 != nil:
    section.add "userIp", valid_598118
  var valid_598119 = query.getOrDefault("key")
  valid_598119 = validateParameter(valid_598119, JString, required = false,
                                 default = nil)
  if valid_598119 != nil:
    section.add "key", valid_598119
  var valid_598120 = query.getOrDefault("prettyPrint")
  valid_598120 = validateParameter(valid_598120, JBool, required = false,
                                 default = newJBool(true))
  if valid_598120 != nil:
    section.add "prettyPrint", valid_598120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598121: Call_AndroidenterpriseGrouplicensesGet_598109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of an enterprise's group license for a product.
  ## 
  let valid = call_598121.validator(path, query, header, formData, body)
  let scheme = call_598121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598121.url(scheme.get, call_598121.host, call_598121.base,
                         call_598121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598121, url, valid)

proc call*(call_598122: Call_AndroidenterpriseGrouplicensesGet_598109;
          groupLicenseId: string; enterpriseId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseGrouplicensesGet
  ## Retrieves details of an enterprise's group license for a product.
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
  ##   groupLicenseId: string (required)
  ##                 : The ID of the product the group license is for, e.g. "app:com.google.android.gm".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598123 = newJObject()
  var query_598124 = newJObject()
  add(query_598124, "fields", newJString(fields))
  add(query_598124, "quotaUser", newJString(quotaUser))
  add(query_598124, "alt", newJString(alt))
  add(query_598124, "oauth_token", newJString(oauthToken))
  add(query_598124, "userIp", newJString(userIp))
  add(path_598123, "groupLicenseId", newJString(groupLicenseId))
  add(query_598124, "key", newJString(key))
  add(path_598123, "enterpriseId", newJString(enterpriseId))
  add(query_598124, "prettyPrint", newJBool(prettyPrint))
  result = call_598122.call(path_598123, query_598124, nil, nil, nil)

var androidenterpriseGrouplicensesGet* = Call_AndroidenterpriseGrouplicensesGet_598109(
    name: "androidenterpriseGrouplicensesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/groupLicenses/{groupLicenseId}",
    validator: validate_AndroidenterpriseGrouplicensesGet_598110,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseGrouplicensesGet_598111,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseGrouplicenseusersList_598125 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseGrouplicenseusersList_598127(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "groupLicenseId" in path, "`groupLicenseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/groupLicenses/"),
               (kind: VariableSegment, value: "groupLicenseId"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseGrouplicenseusersList_598126(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the IDs of the users who have been granted entitlements under the license.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupLicenseId: JString (required)
  ##                 : The ID of the product the group license is for, e.g. "app:com.google.android.gm".
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `groupLicenseId` field"
  var valid_598128 = path.getOrDefault("groupLicenseId")
  valid_598128 = validateParameter(valid_598128, JString, required = true,
                                 default = nil)
  if valid_598128 != nil:
    section.add "groupLicenseId", valid_598128
  var valid_598129 = path.getOrDefault("enterpriseId")
  valid_598129 = validateParameter(valid_598129, JString, required = true,
                                 default = nil)
  if valid_598129 != nil:
    section.add "enterpriseId", valid_598129
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598130 = query.getOrDefault("fields")
  valid_598130 = validateParameter(valid_598130, JString, required = false,
                                 default = nil)
  if valid_598130 != nil:
    section.add "fields", valid_598130
  var valid_598131 = query.getOrDefault("quotaUser")
  valid_598131 = validateParameter(valid_598131, JString, required = false,
                                 default = nil)
  if valid_598131 != nil:
    section.add "quotaUser", valid_598131
  var valid_598132 = query.getOrDefault("alt")
  valid_598132 = validateParameter(valid_598132, JString, required = false,
                                 default = newJString("json"))
  if valid_598132 != nil:
    section.add "alt", valid_598132
  var valid_598133 = query.getOrDefault("oauth_token")
  valid_598133 = validateParameter(valid_598133, JString, required = false,
                                 default = nil)
  if valid_598133 != nil:
    section.add "oauth_token", valid_598133
  var valid_598134 = query.getOrDefault("userIp")
  valid_598134 = validateParameter(valid_598134, JString, required = false,
                                 default = nil)
  if valid_598134 != nil:
    section.add "userIp", valid_598134
  var valid_598135 = query.getOrDefault("key")
  valid_598135 = validateParameter(valid_598135, JString, required = false,
                                 default = nil)
  if valid_598135 != nil:
    section.add "key", valid_598135
  var valid_598136 = query.getOrDefault("prettyPrint")
  valid_598136 = validateParameter(valid_598136, JBool, required = false,
                                 default = newJBool(true))
  if valid_598136 != nil:
    section.add "prettyPrint", valid_598136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598137: Call_AndroidenterpriseGrouplicenseusersList_598125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the IDs of the users who have been granted entitlements under the license.
  ## 
  let valid = call_598137.validator(path, query, header, formData, body)
  let scheme = call_598137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598137.url(scheme.get, call_598137.host, call_598137.base,
                         call_598137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598137, url, valid)

proc call*(call_598138: Call_AndroidenterpriseGrouplicenseusersList_598125;
          groupLicenseId: string; enterpriseId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseGrouplicenseusersList
  ## Retrieves the IDs of the users who have been granted entitlements under the license.
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
  ##   groupLicenseId: string (required)
  ##                 : The ID of the product the group license is for, e.g. "app:com.google.android.gm".
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598139 = newJObject()
  var query_598140 = newJObject()
  add(query_598140, "fields", newJString(fields))
  add(query_598140, "quotaUser", newJString(quotaUser))
  add(query_598140, "alt", newJString(alt))
  add(query_598140, "oauth_token", newJString(oauthToken))
  add(query_598140, "userIp", newJString(userIp))
  add(path_598139, "groupLicenseId", newJString(groupLicenseId))
  add(query_598140, "key", newJString(key))
  add(path_598139, "enterpriseId", newJString(enterpriseId))
  add(query_598140, "prettyPrint", newJBool(prettyPrint))
  result = call_598138.call(path_598139, query_598140, nil, nil, nil)

var androidenterpriseGrouplicenseusersList* = Call_AndroidenterpriseGrouplicenseusersList_598125(
    name: "androidenterpriseGrouplicenseusersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/groupLicenses/{groupLicenseId}/users",
    validator: validate_AndroidenterpriseGrouplicenseusersList_598126,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseGrouplicenseusersList_598127,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsList_598141 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseProductsList_598143(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsList_598142(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Finds approved products that match a query, or all approved products if there is no query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598144 = path.getOrDefault("enterpriseId")
  valid_598144 = validateParameter(valid_598144, JString, required = true,
                                 default = nil)
  if valid_598144 != nil:
    section.add "enterpriseId", valid_598144
  result.add "path", section
  ## parameters in `query` object:
  ##   token: JString
  ##        : A pagination token is contained in a request's response when there are more products. The token can be used in a subsequent request to obtain more products, and so forth. This parameter cannot be used in the initial request.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de"). Results are returned in the language best matching the preferred language.
  ##   query: JString
  ##        : The search query as typed in the Google Play store search box. If omitted, all approved apps will be returned (using the pagination parameters), including apps that are not available in the store (e.g. unpublished apps).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Specifies the maximum number of products that can be returned per request. If not specified, uses a default value of 100, which is also the maximum retrievable within a single response.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   approved: JBool
  ##           : Specifies whether to search among all products (false) or among only products that have been approved (true). Only "true" is supported, and should be specified.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598145 = query.getOrDefault("token")
  valid_598145 = validateParameter(valid_598145, JString, required = false,
                                 default = nil)
  if valid_598145 != nil:
    section.add "token", valid_598145
  var valid_598146 = query.getOrDefault("fields")
  valid_598146 = validateParameter(valid_598146, JString, required = false,
                                 default = nil)
  if valid_598146 != nil:
    section.add "fields", valid_598146
  var valid_598147 = query.getOrDefault("quotaUser")
  valid_598147 = validateParameter(valid_598147, JString, required = false,
                                 default = nil)
  if valid_598147 != nil:
    section.add "quotaUser", valid_598147
  var valid_598148 = query.getOrDefault("alt")
  valid_598148 = validateParameter(valid_598148, JString, required = false,
                                 default = newJString("json"))
  if valid_598148 != nil:
    section.add "alt", valid_598148
  var valid_598149 = query.getOrDefault("language")
  valid_598149 = validateParameter(valid_598149, JString, required = false,
                                 default = nil)
  if valid_598149 != nil:
    section.add "language", valid_598149
  var valid_598150 = query.getOrDefault("query")
  valid_598150 = validateParameter(valid_598150, JString, required = false,
                                 default = nil)
  if valid_598150 != nil:
    section.add "query", valid_598150
  var valid_598151 = query.getOrDefault("oauth_token")
  valid_598151 = validateParameter(valid_598151, JString, required = false,
                                 default = nil)
  if valid_598151 != nil:
    section.add "oauth_token", valid_598151
  var valid_598152 = query.getOrDefault("userIp")
  valid_598152 = validateParameter(valid_598152, JString, required = false,
                                 default = nil)
  if valid_598152 != nil:
    section.add "userIp", valid_598152
  var valid_598153 = query.getOrDefault("maxResults")
  valid_598153 = validateParameter(valid_598153, JInt, required = false, default = nil)
  if valid_598153 != nil:
    section.add "maxResults", valid_598153
  var valid_598154 = query.getOrDefault("key")
  valid_598154 = validateParameter(valid_598154, JString, required = false,
                                 default = nil)
  if valid_598154 != nil:
    section.add "key", valid_598154
  var valid_598155 = query.getOrDefault("approved")
  valid_598155 = validateParameter(valid_598155, JBool, required = false, default = nil)
  if valid_598155 != nil:
    section.add "approved", valid_598155
  var valid_598156 = query.getOrDefault("prettyPrint")
  valid_598156 = validateParameter(valid_598156, JBool, required = false,
                                 default = newJBool(true))
  if valid_598156 != nil:
    section.add "prettyPrint", valid_598156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598157: Call_AndroidenterpriseProductsList_598141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finds approved products that match a query, or all approved products if there is no query.
  ## 
  let valid = call_598157.validator(path, query, header, formData, body)
  let scheme = call_598157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598157.url(scheme.get, call_598157.host, call_598157.base,
                         call_598157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598157, url, valid)

proc call*(call_598158: Call_AndroidenterpriseProductsList_598141;
          enterpriseId: string; token: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; language: string = "";
          query: string = ""; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; approved: bool = false;
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseProductsList
  ## Finds approved products that match a query, or all approved products if there is no query.
  ##   token: string
  ##        : A pagination token is contained in a request's response when there are more products. The token can be used in a subsequent request to obtain more products, and so forth. This parameter cannot be used in the initial request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de"). Results are returned in the language best matching the preferred language.
  ##   query: string
  ##        : The search query as typed in the Google Play store search box. If omitted, all approved apps will be returned (using the pagination parameters), including apps that are not available in the store (e.g. unpublished apps).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Specifies the maximum number of products that can be returned per request. If not specified, uses a default value of 100, which is also the maximum retrievable within a single response.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   approved: bool
  ##           : Specifies whether to search among all products (false) or among only products that have been approved (true). Only "true" is supported, and should be specified.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598159 = newJObject()
  var query_598160 = newJObject()
  add(query_598160, "token", newJString(token))
  add(query_598160, "fields", newJString(fields))
  add(query_598160, "quotaUser", newJString(quotaUser))
  add(query_598160, "alt", newJString(alt))
  add(query_598160, "language", newJString(language))
  add(query_598160, "query", newJString(query))
  add(query_598160, "oauth_token", newJString(oauthToken))
  add(query_598160, "userIp", newJString(userIp))
  add(query_598160, "maxResults", newJInt(maxResults))
  add(query_598160, "key", newJString(key))
  add(path_598159, "enterpriseId", newJString(enterpriseId))
  add(query_598160, "approved", newJBool(approved))
  add(query_598160, "prettyPrint", newJBool(prettyPrint))
  result = call_598158.call(path_598159, query_598160, nil, nil, nil)

var androidenterpriseProductsList* = Call_AndroidenterpriseProductsList_598141(
    name: "androidenterpriseProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products",
    validator: validate_AndroidenterpriseProductsList_598142,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsList_598143,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGet_598161 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseProductsGet_598163(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsGet_598162(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of a product for display to an enterprise admin.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product, e.g. "app:com.google.android.gm".
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598164 = path.getOrDefault("enterpriseId")
  valid_598164 = validateParameter(valid_598164, JString, required = true,
                                 default = nil)
  if valid_598164 != nil:
    section.add "enterpriseId", valid_598164
  var valid_598165 = path.getOrDefault("productId")
  valid_598165 = validateParameter(valid_598165, JString, required = true,
                                 default = nil)
  if valid_598165 != nil:
    section.add "productId", valid_598165
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de").
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598166 = query.getOrDefault("fields")
  valid_598166 = validateParameter(valid_598166, JString, required = false,
                                 default = nil)
  if valid_598166 != nil:
    section.add "fields", valid_598166
  var valid_598167 = query.getOrDefault("quotaUser")
  valid_598167 = validateParameter(valid_598167, JString, required = false,
                                 default = nil)
  if valid_598167 != nil:
    section.add "quotaUser", valid_598167
  var valid_598168 = query.getOrDefault("alt")
  valid_598168 = validateParameter(valid_598168, JString, required = false,
                                 default = newJString("json"))
  if valid_598168 != nil:
    section.add "alt", valid_598168
  var valid_598169 = query.getOrDefault("language")
  valid_598169 = validateParameter(valid_598169, JString, required = false,
                                 default = nil)
  if valid_598169 != nil:
    section.add "language", valid_598169
  var valid_598170 = query.getOrDefault("oauth_token")
  valid_598170 = validateParameter(valid_598170, JString, required = false,
                                 default = nil)
  if valid_598170 != nil:
    section.add "oauth_token", valid_598170
  var valid_598171 = query.getOrDefault("userIp")
  valid_598171 = validateParameter(valid_598171, JString, required = false,
                                 default = nil)
  if valid_598171 != nil:
    section.add "userIp", valid_598171
  var valid_598172 = query.getOrDefault("key")
  valid_598172 = validateParameter(valid_598172, JString, required = false,
                                 default = nil)
  if valid_598172 != nil:
    section.add "key", valid_598172
  var valid_598173 = query.getOrDefault("prettyPrint")
  valid_598173 = validateParameter(valid_598173, JBool, required = false,
                                 default = newJBool(true))
  if valid_598173 != nil:
    section.add "prettyPrint", valid_598173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598174: Call_AndroidenterpriseProductsGet_598161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves details of a product for display to an enterprise admin.
  ## 
  let valid = call_598174.validator(path, query, header, formData, body)
  let scheme = call_598174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598174.url(scheme.get, call_598174.host, call_598174.base,
                         call_598174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598174, url, valid)

proc call*(call_598175: Call_AndroidenterpriseProductsGet_598161;
          enterpriseId: string; productId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; language: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseProductsGet
  ## Retrieves details of a product for display to an enterprise admin.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de").
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   productId: string (required)
  ##            : The ID of the product, e.g. "app:com.google.android.gm".
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598176 = newJObject()
  var query_598177 = newJObject()
  add(query_598177, "fields", newJString(fields))
  add(query_598177, "quotaUser", newJString(quotaUser))
  add(query_598177, "alt", newJString(alt))
  add(query_598177, "language", newJString(language))
  add(query_598177, "oauth_token", newJString(oauthToken))
  add(query_598177, "userIp", newJString(userIp))
  add(query_598177, "key", newJString(key))
  add(path_598176, "enterpriseId", newJString(enterpriseId))
  add(path_598176, "productId", newJString(productId))
  add(query_598177, "prettyPrint", newJBool(prettyPrint))
  result = call_598175.call(path_598176, query_598177, nil, nil, nil)

var androidenterpriseProductsGet* = Call_AndroidenterpriseProductsGet_598161(
    name: "androidenterpriseProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}",
    validator: validate_AndroidenterpriseProductsGet_598162,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsGet_598163,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGetAppRestrictionsSchema_598178 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseProductsGetAppRestrictionsSchema_598180(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/appRestrictionsSchema")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsGetAppRestrictionsSchema_598179(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the schema that defines the configurable properties for this product. All products have a schema, but this schema may be empty if no managed configurations have been defined. This schema can be used to populate a UI that allows an admin to configure the product. To apply a managed configuration based on the schema obtained using this API, see Managed Configurations through Play.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598181 = path.getOrDefault("enterpriseId")
  valid_598181 = validateParameter(valid_598181, JString, required = true,
                                 default = nil)
  if valid_598181 != nil:
    section.add "enterpriseId", valid_598181
  var valid_598182 = path.getOrDefault("productId")
  valid_598182 = validateParameter(valid_598182, JString, required = true,
                                 default = nil)
  if valid_598182 != nil:
    section.add "productId", valid_598182
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de").
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598183 = query.getOrDefault("fields")
  valid_598183 = validateParameter(valid_598183, JString, required = false,
                                 default = nil)
  if valid_598183 != nil:
    section.add "fields", valid_598183
  var valid_598184 = query.getOrDefault("quotaUser")
  valid_598184 = validateParameter(valid_598184, JString, required = false,
                                 default = nil)
  if valid_598184 != nil:
    section.add "quotaUser", valid_598184
  var valid_598185 = query.getOrDefault("alt")
  valid_598185 = validateParameter(valid_598185, JString, required = false,
                                 default = newJString("json"))
  if valid_598185 != nil:
    section.add "alt", valid_598185
  var valid_598186 = query.getOrDefault("language")
  valid_598186 = validateParameter(valid_598186, JString, required = false,
                                 default = nil)
  if valid_598186 != nil:
    section.add "language", valid_598186
  var valid_598187 = query.getOrDefault("oauth_token")
  valid_598187 = validateParameter(valid_598187, JString, required = false,
                                 default = nil)
  if valid_598187 != nil:
    section.add "oauth_token", valid_598187
  var valid_598188 = query.getOrDefault("userIp")
  valid_598188 = validateParameter(valid_598188, JString, required = false,
                                 default = nil)
  if valid_598188 != nil:
    section.add "userIp", valid_598188
  var valid_598189 = query.getOrDefault("key")
  valid_598189 = validateParameter(valid_598189, JString, required = false,
                                 default = nil)
  if valid_598189 != nil:
    section.add "key", valid_598189
  var valid_598190 = query.getOrDefault("prettyPrint")
  valid_598190 = validateParameter(valid_598190, JBool, required = false,
                                 default = newJBool(true))
  if valid_598190 != nil:
    section.add "prettyPrint", valid_598190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598191: Call_AndroidenterpriseProductsGetAppRestrictionsSchema_598178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the schema that defines the configurable properties for this product. All products have a schema, but this schema may be empty if no managed configurations have been defined. This schema can be used to populate a UI that allows an admin to configure the product. To apply a managed configuration based on the schema obtained using this API, see Managed Configurations through Play.
  ## 
  let valid = call_598191.validator(path, query, header, formData, body)
  let scheme = call_598191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598191.url(scheme.get, call_598191.host, call_598191.base,
                         call_598191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598191, url, valid)

proc call*(call_598192: Call_AndroidenterpriseProductsGetAppRestrictionsSchema_598178;
          enterpriseId: string; productId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; language: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseProductsGetAppRestrictionsSchema
  ## Retrieves the schema that defines the configurable properties for this product. All products have a schema, but this schema may be empty if no managed configurations have been defined. This schema can be used to populate a UI that allows an admin to configure the product. To apply a managed configuration based on the schema obtained using this API, see Managed Configurations through Play.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de").
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   productId: string (required)
  ##            : The ID of the product.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598193 = newJObject()
  var query_598194 = newJObject()
  add(query_598194, "fields", newJString(fields))
  add(query_598194, "quotaUser", newJString(quotaUser))
  add(query_598194, "alt", newJString(alt))
  add(query_598194, "language", newJString(language))
  add(query_598194, "oauth_token", newJString(oauthToken))
  add(query_598194, "userIp", newJString(userIp))
  add(query_598194, "key", newJString(key))
  add(path_598193, "enterpriseId", newJString(enterpriseId))
  add(path_598193, "productId", newJString(productId))
  add(query_598194, "prettyPrint", newJBool(prettyPrint))
  result = call_598192.call(path_598193, query_598194, nil, nil, nil)

var androidenterpriseProductsGetAppRestrictionsSchema* = Call_AndroidenterpriseProductsGetAppRestrictionsSchema_598178(
    name: "androidenterpriseProductsGetAppRestrictionsSchema",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products/{productId}/appRestrictionsSchema",
    validator: validate_AndroidenterpriseProductsGetAppRestrictionsSchema_598179,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseProductsGetAppRestrictionsSchema_598180,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsApprove_598195 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseProductsApprove_598197(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/approve")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsApprove_598196(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Approves the specified product and the relevant app permissions, if any. The maximum number of products that you can approve per enterprise customer is 1,000.
  ## 
  ## To learn how to use managed Google Play to design and create a store layout to display approved products to your users, see Store Layout Design.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598198 = path.getOrDefault("enterpriseId")
  valid_598198 = validateParameter(valid_598198, JString, required = true,
                                 default = nil)
  if valid_598198 != nil:
    section.add "enterpriseId", valid_598198
  var valid_598199 = path.getOrDefault("productId")
  valid_598199 = validateParameter(valid_598199, JString, required = true,
                                 default = nil)
  if valid_598199 != nil:
    section.add "productId", valid_598199
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598200 = query.getOrDefault("fields")
  valid_598200 = validateParameter(valid_598200, JString, required = false,
                                 default = nil)
  if valid_598200 != nil:
    section.add "fields", valid_598200
  var valid_598201 = query.getOrDefault("quotaUser")
  valid_598201 = validateParameter(valid_598201, JString, required = false,
                                 default = nil)
  if valid_598201 != nil:
    section.add "quotaUser", valid_598201
  var valid_598202 = query.getOrDefault("alt")
  valid_598202 = validateParameter(valid_598202, JString, required = false,
                                 default = newJString("json"))
  if valid_598202 != nil:
    section.add "alt", valid_598202
  var valid_598203 = query.getOrDefault("oauth_token")
  valid_598203 = validateParameter(valid_598203, JString, required = false,
                                 default = nil)
  if valid_598203 != nil:
    section.add "oauth_token", valid_598203
  var valid_598204 = query.getOrDefault("userIp")
  valid_598204 = validateParameter(valid_598204, JString, required = false,
                                 default = nil)
  if valid_598204 != nil:
    section.add "userIp", valid_598204
  var valid_598205 = query.getOrDefault("key")
  valid_598205 = validateParameter(valid_598205, JString, required = false,
                                 default = nil)
  if valid_598205 != nil:
    section.add "key", valid_598205
  var valid_598206 = query.getOrDefault("prettyPrint")
  valid_598206 = validateParameter(valid_598206, JBool, required = false,
                                 default = newJBool(true))
  if valid_598206 != nil:
    section.add "prettyPrint", valid_598206
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

proc call*(call_598208: Call_AndroidenterpriseProductsApprove_598195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Approves the specified product and the relevant app permissions, if any. The maximum number of products that you can approve per enterprise customer is 1,000.
  ## 
  ## To learn how to use managed Google Play to design and create a store layout to display approved products to your users, see Store Layout Design.
  ## 
  let valid = call_598208.validator(path, query, header, formData, body)
  let scheme = call_598208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598208.url(scheme.get, call_598208.host, call_598208.base,
                         call_598208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598208, url, valid)

proc call*(call_598209: Call_AndroidenterpriseProductsApprove_598195;
          enterpriseId: string; productId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseProductsApprove
  ## Approves the specified product and the relevant app permissions, if any. The maximum number of products that you can approve per enterprise customer is 1,000.
  ## 
  ## To learn how to use managed Google Play to design and create a store layout to display approved products to your users, see Store Layout Design.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   productId: string (required)
  ##            : The ID of the product.
  var path_598210 = newJObject()
  var query_598211 = newJObject()
  var body_598212 = newJObject()
  add(query_598211, "fields", newJString(fields))
  add(query_598211, "quotaUser", newJString(quotaUser))
  add(query_598211, "alt", newJString(alt))
  add(query_598211, "oauth_token", newJString(oauthToken))
  add(query_598211, "userIp", newJString(userIp))
  add(query_598211, "key", newJString(key))
  add(path_598210, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598212 = body
  add(query_598211, "prettyPrint", newJBool(prettyPrint))
  add(path_598210, "productId", newJString(productId))
  result = call_598209.call(path_598210, query_598211, nil, nil, body_598212)

var androidenterpriseProductsApprove* = Call_AndroidenterpriseProductsApprove_598195(
    name: "androidenterpriseProductsApprove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}/approve",
    validator: validate_AndroidenterpriseProductsApprove_598196,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsApprove_598197,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGenerateApprovalUrl_598213 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseProductsGenerateApprovalUrl_598215(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/generateApprovalUrl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsGenerateApprovalUrl_598214(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a URL that can be rendered in an iframe to display the permissions (if any) of a product. An enterprise admin must view these permissions and accept them on behalf of their organization in order to approve that product.
  ## 
  ## Admins should accept the displayed permissions by interacting with a separate UI element in the EMM console, which in turn should trigger the use of this URL as the approvalUrlInfo.approvalUrl property in a Products.approve call to approve the product. This URL can only be used to display permissions for up to 1 day.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598216 = path.getOrDefault("enterpriseId")
  valid_598216 = validateParameter(valid_598216, JString, required = true,
                                 default = nil)
  if valid_598216 != nil:
    section.add "enterpriseId", valid_598216
  var valid_598217 = path.getOrDefault("productId")
  valid_598217 = validateParameter(valid_598217, JString, required = true,
                                 default = nil)
  if valid_598217 != nil:
    section.add "productId", valid_598217
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
  ##   languageCode: JString
  ##               : The BCP 47 language code used for permission names and descriptions in the returned iframe, for instance "en-US".
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598218 = query.getOrDefault("fields")
  valid_598218 = validateParameter(valid_598218, JString, required = false,
                                 default = nil)
  if valid_598218 != nil:
    section.add "fields", valid_598218
  var valid_598219 = query.getOrDefault("quotaUser")
  valid_598219 = validateParameter(valid_598219, JString, required = false,
                                 default = nil)
  if valid_598219 != nil:
    section.add "quotaUser", valid_598219
  var valid_598220 = query.getOrDefault("alt")
  valid_598220 = validateParameter(valid_598220, JString, required = false,
                                 default = newJString("json"))
  if valid_598220 != nil:
    section.add "alt", valid_598220
  var valid_598221 = query.getOrDefault("oauth_token")
  valid_598221 = validateParameter(valid_598221, JString, required = false,
                                 default = nil)
  if valid_598221 != nil:
    section.add "oauth_token", valid_598221
  var valid_598222 = query.getOrDefault("userIp")
  valid_598222 = validateParameter(valid_598222, JString, required = false,
                                 default = nil)
  if valid_598222 != nil:
    section.add "userIp", valid_598222
  var valid_598223 = query.getOrDefault("key")
  valid_598223 = validateParameter(valid_598223, JString, required = false,
                                 default = nil)
  if valid_598223 != nil:
    section.add "key", valid_598223
  var valid_598224 = query.getOrDefault("languageCode")
  valid_598224 = validateParameter(valid_598224, JString, required = false,
                                 default = nil)
  if valid_598224 != nil:
    section.add "languageCode", valid_598224
  var valid_598225 = query.getOrDefault("prettyPrint")
  valid_598225 = validateParameter(valid_598225, JBool, required = false,
                                 default = newJBool(true))
  if valid_598225 != nil:
    section.add "prettyPrint", valid_598225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598226: Call_AndroidenterpriseProductsGenerateApprovalUrl_598213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a URL that can be rendered in an iframe to display the permissions (if any) of a product. An enterprise admin must view these permissions and accept them on behalf of their organization in order to approve that product.
  ## 
  ## Admins should accept the displayed permissions by interacting with a separate UI element in the EMM console, which in turn should trigger the use of this URL as the approvalUrlInfo.approvalUrl property in a Products.approve call to approve the product. This URL can only be used to display permissions for up to 1 day.
  ## 
  let valid = call_598226.validator(path, query, header, formData, body)
  let scheme = call_598226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598226.url(scheme.get, call_598226.host, call_598226.base,
                         call_598226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598226, url, valid)

proc call*(call_598227: Call_AndroidenterpriseProductsGenerateApprovalUrl_598213;
          enterpriseId: string; productId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; languageCode: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseProductsGenerateApprovalUrl
  ## Generates a URL that can be rendered in an iframe to display the permissions (if any) of a product. An enterprise admin must view these permissions and accept them on behalf of their organization in order to approve that product.
  ## 
  ## Admins should accept the displayed permissions by interacting with a separate UI element in the EMM console, which in turn should trigger the use of this URL as the approvalUrlInfo.approvalUrl property in a Products.approve call to approve the product. This URL can only be used to display permissions for up to 1 day.
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
  ##   languageCode: string
  ##               : The BCP 47 language code used for permission names and descriptions in the returned iframe, for instance "en-US".
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   productId: string (required)
  ##            : The ID of the product.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598228 = newJObject()
  var query_598229 = newJObject()
  add(query_598229, "fields", newJString(fields))
  add(query_598229, "quotaUser", newJString(quotaUser))
  add(query_598229, "alt", newJString(alt))
  add(query_598229, "oauth_token", newJString(oauthToken))
  add(query_598229, "userIp", newJString(userIp))
  add(query_598229, "key", newJString(key))
  add(query_598229, "languageCode", newJString(languageCode))
  add(path_598228, "enterpriseId", newJString(enterpriseId))
  add(path_598228, "productId", newJString(productId))
  add(query_598229, "prettyPrint", newJBool(prettyPrint))
  result = call_598227.call(path_598228, query_598229, nil, nil, nil)

var androidenterpriseProductsGenerateApprovalUrl* = Call_AndroidenterpriseProductsGenerateApprovalUrl_598213(
    name: "androidenterpriseProductsGenerateApprovalUrl",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products/{productId}/generateApprovalUrl",
    validator: validate_AndroidenterpriseProductsGenerateApprovalUrl_598214,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseProductsGenerateApprovalUrl_598215,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationssettingsList_598230 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseManagedconfigurationssettingsList_598232(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/managedConfigurationsSettings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationssettingsList_598231(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the managed configurations settings for the specified app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product for which the managed configurations settings applies to.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598233 = path.getOrDefault("enterpriseId")
  valid_598233 = validateParameter(valid_598233, JString, required = true,
                                 default = nil)
  if valid_598233 != nil:
    section.add "enterpriseId", valid_598233
  var valid_598234 = path.getOrDefault("productId")
  valid_598234 = validateParameter(valid_598234, JString, required = true,
                                 default = nil)
  if valid_598234 != nil:
    section.add "productId", valid_598234
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598235 = query.getOrDefault("fields")
  valid_598235 = validateParameter(valid_598235, JString, required = false,
                                 default = nil)
  if valid_598235 != nil:
    section.add "fields", valid_598235
  var valid_598236 = query.getOrDefault("quotaUser")
  valid_598236 = validateParameter(valid_598236, JString, required = false,
                                 default = nil)
  if valid_598236 != nil:
    section.add "quotaUser", valid_598236
  var valid_598237 = query.getOrDefault("alt")
  valid_598237 = validateParameter(valid_598237, JString, required = false,
                                 default = newJString("json"))
  if valid_598237 != nil:
    section.add "alt", valid_598237
  var valid_598238 = query.getOrDefault("oauth_token")
  valid_598238 = validateParameter(valid_598238, JString, required = false,
                                 default = nil)
  if valid_598238 != nil:
    section.add "oauth_token", valid_598238
  var valid_598239 = query.getOrDefault("userIp")
  valid_598239 = validateParameter(valid_598239, JString, required = false,
                                 default = nil)
  if valid_598239 != nil:
    section.add "userIp", valid_598239
  var valid_598240 = query.getOrDefault("key")
  valid_598240 = validateParameter(valid_598240, JString, required = false,
                                 default = nil)
  if valid_598240 != nil:
    section.add "key", valid_598240
  var valid_598241 = query.getOrDefault("prettyPrint")
  valid_598241 = validateParameter(valid_598241, JBool, required = false,
                                 default = newJBool(true))
  if valid_598241 != nil:
    section.add "prettyPrint", valid_598241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598242: Call_AndroidenterpriseManagedconfigurationssettingsList_598230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the managed configurations settings for the specified app.
  ## 
  let valid = call_598242.validator(path, query, header, formData, body)
  let scheme = call_598242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598242.url(scheme.get, call_598242.host, call_598242.base,
                         call_598242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598242, url, valid)

proc call*(call_598243: Call_AndroidenterpriseManagedconfigurationssettingsList_598230;
          enterpriseId: string; productId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseManagedconfigurationssettingsList
  ## Lists all the managed configurations settings for the specified app.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   productId: string (required)
  ##            : The ID of the product for which the managed configurations settings applies to.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598244 = newJObject()
  var query_598245 = newJObject()
  add(query_598245, "fields", newJString(fields))
  add(query_598245, "quotaUser", newJString(quotaUser))
  add(query_598245, "alt", newJString(alt))
  add(query_598245, "oauth_token", newJString(oauthToken))
  add(query_598245, "userIp", newJString(userIp))
  add(query_598245, "key", newJString(key))
  add(path_598244, "enterpriseId", newJString(enterpriseId))
  add(path_598244, "productId", newJString(productId))
  add(query_598245, "prettyPrint", newJBool(prettyPrint))
  result = call_598243.call(path_598244, query_598245, nil, nil, nil)

var androidenterpriseManagedconfigurationssettingsList* = Call_AndroidenterpriseManagedconfigurationssettingsList_598230(
    name: "androidenterpriseManagedconfigurationssettingsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products/{productId}/managedConfigurationsSettings",
    validator: validate_AndroidenterpriseManagedconfigurationssettingsList_598231,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationssettingsList_598232,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGetPermissions_598246 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseProductsGetPermissions_598248(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/permissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsGetPermissions_598247(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the Android app permissions required by this app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598249 = path.getOrDefault("enterpriseId")
  valid_598249 = validateParameter(valid_598249, JString, required = true,
                                 default = nil)
  if valid_598249 != nil:
    section.add "enterpriseId", valid_598249
  var valid_598250 = path.getOrDefault("productId")
  valid_598250 = validateParameter(valid_598250, JString, required = true,
                                 default = nil)
  if valid_598250 != nil:
    section.add "productId", valid_598250
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598251 = query.getOrDefault("fields")
  valid_598251 = validateParameter(valid_598251, JString, required = false,
                                 default = nil)
  if valid_598251 != nil:
    section.add "fields", valid_598251
  var valid_598252 = query.getOrDefault("quotaUser")
  valid_598252 = validateParameter(valid_598252, JString, required = false,
                                 default = nil)
  if valid_598252 != nil:
    section.add "quotaUser", valid_598252
  var valid_598253 = query.getOrDefault("alt")
  valid_598253 = validateParameter(valid_598253, JString, required = false,
                                 default = newJString("json"))
  if valid_598253 != nil:
    section.add "alt", valid_598253
  var valid_598254 = query.getOrDefault("oauth_token")
  valid_598254 = validateParameter(valid_598254, JString, required = false,
                                 default = nil)
  if valid_598254 != nil:
    section.add "oauth_token", valid_598254
  var valid_598255 = query.getOrDefault("userIp")
  valid_598255 = validateParameter(valid_598255, JString, required = false,
                                 default = nil)
  if valid_598255 != nil:
    section.add "userIp", valid_598255
  var valid_598256 = query.getOrDefault("key")
  valid_598256 = validateParameter(valid_598256, JString, required = false,
                                 default = nil)
  if valid_598256 != nil:
    section.add "key", valid_598256
  var valid_598257 = query.getOrDefault("prettyPrint")
  valid_598257 = validateParameter(valid_598257, JBool, required = false,
                                 default = newJBool(true))
  if valid_598257 != nil:
    section.add "prettyPrint", valid_598257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598258: Call_AndroidenterpriseProductsGetPermissions_598246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the Android app permissions required by this app.
  ## 
  let valid = call_598258.validator(path, query, header, formData, body)
  let scheme = call_598258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598258.url(scheme.get, call_598258.host, call_598258.base,
                         call_598258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598258, url, valid)

proc call*(call_598259: Call_AndroidenterpriseProductsGetPermissions_598246;
          enterpriseId: string; productId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseProductsGetPermissions
  ## Retrieves the Android app permissions required by this app.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   productId: string (required)
  ##            : The ID of the product.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598260 = newJObject()
  var query_598261 = newJObject()
  add(query_598261, "fields", newJString(fields))
  add(query_598261, "quotaUser", newJString(quotaUser))
  add(query_598261, "alt", newJString(alt))
  add(query_598261, "oauth_token", newJString(oauthToken))
  add(query_598261, "userIp", newJString(userIp))
  add(query_598261, "key", newJString(key))
  add(path_598260, "enterpriseId", newJString(enterpriseId))
  add(path_598260, "productId", newJString(productId))
  add(query_598261, "prettyPrint", newJBool(prettyPrint))
  result = call_598259.call(path_598260, query_598261, nil, nil, nil)

var androidenterpriseProductsGetPermissions* = Call_AndroidenterpriseProductsGetPermissions_598246(
    name: "androidenterpriseProductsGetPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}/permissions",
    validator: validate_AndroidenterpriseProductsGetPermissions_598247,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseProductsGetPermissions_598248,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsUnapprove_598262 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseProductsUnapprove_598264(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "productId" in path, "`productId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/products/"),
               (kind: VariableSegment, value: "productId"),
               (kind: ConstantSegment, value: "/unapprove")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseProductsUnapprove_598263(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unapproves the specified product (and the relevant app permissions, if any)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   productId: JString (required)
  ##            : The ID of the product.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598265 = path.getOrDefault("enterpriseId")
  valid_598265 = validateParameter(valid_598265, JString, required = true,
                                 default = nil)
  if valid_598265 != nil:
    section.add "enterpriseId", valid_598265
  var valid_598266 = path.getOrDefault("productId")
  valid_598266 = validateParameter(valid_598266, JString, required = true,
                                 default = nil)
  if valid_598266 != nil:
    section.add "productId", valid_598266
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598267 = query.getOrDefault("fields")
  valid_598267 = validateParameter(valid_598267, JString, required = false,
                                 default = nil)
  if valid_598267 != nil:
    section.add "fields", valid_598267
  var valid_598268 = query.getOrDefault("quotaUser")
  valid_598268 = validateParameter(valid_598268, JString, required = false,
                                 default = nil)
  if valid_598268 != nil:
    section.add "quotaUser", valid_598268
  var valid_598269 = query.getOrDefault("alt")
  valid_598269 = validateParameter(valid_598269, JString, required = false,
                                 default = newJString("json"))
  if valid_598269 != nil:
    section.add "alt", valid_598269
  var valid_598270 = query.getOrDefault("oauth_token")
  valid_598270 = validateParameter(valid_598270, JString, required = false,
                                 default = nil)
  if valid_598270 != nil:
    section.add "oauth_token", valid_598270
  var valid_598271 = query.getOrDefault("userIp")
  valid_598271 = validateParameter(valid_598271, JString, required = false,
                                 default = nil)
  if valid_598271 != nil:
    section.add "userIp", valid_598271
  var valid_598272 = query.getOrDefault("key")
  valid_598272 = validateParameter(valid_598272, JString, required = false,
                                 default = nil)
  if valid_598272 != nil:
    section.add "key", valid_598272
  var valid_598273 = query.getOrDefault("prettyPrint")
  valid_598273 = validateParameter(valid_598273, JBool, required = false,
                                 default = newJBool(true))
  if valid_598273 != nil:
    section.add "prettyPrint", valid_598273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598274: Call_AndroidenterpriseProductsUnapprove_598262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unapproves the specified product (and the relevant app permissions, if any)
  ## 
  let valid = call_598274.validator(path, query, header, formData, body)
  let scheme = call_598274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598274.url(scheme.get, call_598274.host, call_598274.base,
                         call_598274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598274, url, valid)

proc call*(call_598275: Call_AndroidenterpriseProductsUnapprove_598262;
          enterpriseId: string; productId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseProductsUnapprove
  ## Unapproves the specified product (and the relevant app permissions, if any)
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   productId: string (required)
  ##            : The ID of the product.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598276 = newJObject()
  var query_598277 = newJObject()
  add(query_598277, "fields", newJString(fields))
  add(query_598277, "quotaUser", newJString(quotaUser))
  add(query_598277, "alt", newJString(alt))
  add(query_598277, "oauth_token", newJString(oauthToken))
  add(query_598277, "userIp", newJString(userIp))
  add(query_598277, "key", newJString(key))
  add(path_598276, "enterpriseId", newJString(enterpriseId))
  add(path_598276, "productId", newJString(productId))
  add(query_598277, "prettyPrint", newJBool(prettyPrint))
  result = call_598275.call(path_598276, query_598277, nil, nil, nil)

var androidenterpriseProductsUnapprove* = Call_AndroidenterpriseProductsUnapprove_598262(
    name: "androidenterpriseProductsUnapprove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}/unapprove",
    validator: validate_AndroidenterpriseProductsUnapprove_598263,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsUnapprove_598264,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesSendTestPushNotification_598278 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesSendTestPushNotification_598280(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/sendTestPushNotification")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesSendTestPushNotification_598279(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sends a test notification to validate the EMM integration with the Google Cloud Pub/Sub service for this enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598281 = path.getOrDefault("enterpriseId")
  valid_598281 = validateParameter(valid_598281, JString, required = true,
                                 default = nil)
  if valid_598281 != nil:
    section.add "enterpriseId", valid_598281
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598282 = query.getOrDefault("fields")
  valid_598282 = validateParameter(valid_598282, JString, required = false,
                                 default = nil)
  if valid_598282 != nil:
    section.add "fields", valid_598282
  var valid_598283 = query.getOrDefault("quotaUser")
  valid_598283 = validateParameter(valid_598283, JString, required = false,
                                 default = nil)
  if valid_598283 != nil:
    section.add "quotaUser", valid_598283
  var valid_598284 = query.getOrDefault("alt")
  valid_598284 = validateParameter(valid_598284, JString, required = false,
                                 default = newJString("json"))
  if valid_598284 != nil:
    section.add "alt", valid_598284
  var valid_598285 = query.getOrDefault("oauth_token")
  valid_598285 = validateParameter(valid_598285, JString, required = false,
                                 default = nil)
  if valid_598285 != nil:
    section.add "oauth_token", valid_598285
  var valid_598286 = query.getOrDefault("userIp")
  valid_598286 = validateParameter(valid_598286, JString, required = false,
                                 default = nil)
  if valid_598286 != nil:
    section.add "userIp", valid_598286
  var valid_598287 = query.getOrDefault("key")
  valid_598287 = validateParameter(valid_598287, JString, required = false,
                                 default = nil)
  if valid_598287 != nil:
    section.add "key", valid_598287
  var valid_598288 = query.getOrDefault("prettyPrint")
  valid_598288 = validateParameter(valid_598288, JBool, required = false,
                                 default = newJBool(true))
  if valid_598288 != nil:
    section.add "prettyPrint", valid_598288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598289: Call_AndroidenterpriseEnterprisesSendTestPushNotification_598278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sends a test notification to validate the EMM integration with the Google Cloud Pub/Sub service for this enterprise.
  ## 
  let valid = call_598289.validator(path, query, header, formData, body)
  let scheme = call_598289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598289.url(scheme.get, call_598289.host, call_598289.base,
                         call_598289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598289, url, valid)

proc call*(call_598290: Call_AndroidenterpriseEnterprisesSendTestPushNotification_598278;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEnterprisesSendTestPushNotification
  ## Sends a test notification to validate the EMM integration with the Google Cloud Pub/Sub service for this enterprise.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598291 = newJObject()
  var query_598292 = newJObject()
  add(query_598292, "fields", newJString(fields))
  add(query_598292, "quotaUser", newJString(quotaUser))
  add(query_598292, "alt", newJString(alt))
  add(query_598292, "oauth_token", newJString(oauthToken))
  add(query_598292, "userIp", newJString(userIp))
  add(query_598292, "key", newJString(key))
  add(path_598291, "enterpriseId", newJString(enterpriseId))
  add(query_598292, "prettyPrint", newJBool(prettyPrint))
  result = call_598290.call(path_598291, query_598292, nil, nil, nil)

var androidenterpriseEnterprisesSendTestPushNotification* = Call_AndroidenterpriseEnterprisesSendTestPushNotification_598278(
    name: "androidenterpriseEnterprisesSendTestPushNotification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/sendTestPushNotification",
    validator: validate_AndroidenterpriseEnterprisesSendTestPushNotification_598279,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesSendTestPushNotification_598280,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGetServiceAccount_598293 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesGetServiceAccount_598295(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/serviceAccount")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesGetServiceAccount_598294(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns a service account and credentials. The service account can be bound to the enterprise by calling setAccount. The service account is unique to this enterprise and EMM, and will be deleted if the enterprise is unbound. The credentials contain private key data and are not stored server-side.
  ## 
  ## This method can only be called after calling Enterprises.Enroll or Enterprises.CompleteSignup, and before Enterprises.SetAccount; at other times it will return an error.
  ## 
  ## Subsequent calls after the first will generate a new, unique set of credentials, and invalidate the previously generated credentials.
  ## 
  ## Once the service account is bound to the enterprise, it can be managed using the serviceAccountKeys resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598296 = path.getOrDefault("enterpriseId")
  valid_598296 = validateParameter(valid_598296, JString, required = true,
                                 default = nil)
  if valid_598296 != nil:
    section.add "enterpriseId", valid_598296
  result.add "path", section
  ## parameters in `query` object:
  ##   keyType: JString
  ##          : The type of credential to return with the service account. Required.
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598297 = query.getOrDefault("keyType")
  valid_598297 = validateParameter(valid_598297, JString, required = false,
                                 default = newJString("googleCredentials"))
  if valid_598297 != nil:
    section.add "keyType", valid_598297
  var valid_598298 = query.getOrDefault("fields")
  valid_598298 = validateParameter(valid_598298, JString, required = false,
                                 default = nil)
  if valid_598298 != nil:
    section.add "fields", valid_598298
  var valid_598299 = query.getOrDefault("quotaUser")
  valid_598299 = validateParameter(valid_598299, JString, required = false,
                                 default = nil)
  if valid_598299 != nil:
    section.add "quotaUser", valid_598299
  var valid_598300 = query.getOrDefault("alt")
  valid_598300 = validateParameter(valid_598300, JString, required = false,
                                 default = newJString("json"))
  if valid_598300 != nil:
    section.add "alt", valid_598300
  var valid_598301 = query.getOrDefault("oauth_token")
  valid_598301 = validateParameter(valid_598301, JString, required = false,
                                 default = nil)
  if valid_598301 != nil:
    section.add "oauth_token", valid_598301
  var valid_598302 = query.getOrDefault("userIp")
  valid_598302 = validateParameter(valid_598302, JString, required = false,
                                 default = nil)
  if valid_598302 != nil:
    section.add "userIp", valid_598302
  var valid_598303 = query.getOrDefault("key")
  valid_598303 = validateParameter(valid_598303, JString, required = false,
                                 default = nil)
  if valid_598303 != nil:
    section.add "key", valid_598303
  var valid_598304 = query.getOrDefault("prettyPrint")
  valid_598304 = validateParameter(valid_598304, JBool, required = false,
                                 default = newJBool(true))
  if valid_598304 != nil:
    section.add "prettyPrint", valid_598304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598305: Call_AndroidenterpriseEnterprisesGetServiceAccount_598293;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a service account and credentials. The service account can be bound to the enterprise by calling setAccount. The service account is unique to this enterprise and EMM, and will be deleted if the enterprise is unbound. The credentials contain private key data and are not stored server-side.
  ## 
  ## This method can only be called after calling Enterprises.Enroll or Enterprises.CompleteSignup, and before Enterprises.SetAccount; at other times it will return an error.
  ## 
  ## Subsequent calls after the first will generate a new, unique set of credentials, and invalidate the previously generated credentials.
  ## 
  ## Once the service account is bound to the enterprise, it can be managed using the serviceAccountKeys resource.
  ## 
  let valid = call_598305.validator(path, query, header, formData, body)
  let scheme = call_598305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598305.url(scheme.get, call_598305.host, call_598305.base,
                         call_598305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598305, url, valid)

proc call*(call_598306: Call_AndroidenterpriseEnterprisesGetServiceAccount_598293;
          enterpriseId: string; keyType: string = "googleCredentials";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseEnterprisesGetServiceAccount
  ## Returns a service account and credentials. The service account can be bound to the enterprise by calling setAccount. The service account is unique to this enterprise and EMM, and will be deleted if the enterprise is unbound. The credentials contain private key data and are not stored server-side.
  ## 
  ## This method can only be called after calling Enterprises.Enroll or Enterprises.CompleteSignup, and before Enterprises.SetAccount; at other times it will return an error.
  ## 
  ## Subsequent calls after the first will generate a new, unique set of credentials, and invalidate the previously generated credentials.
  ## 
  ## Once the service account is bound to the enterprise, it can be managed using the serviceAccountKeys resource.
  ##   keyType: string
  ##          : The type of credential to return with the service account. Required.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598307 = newJObject()
  var query_598308 = newJObject()
  add(query_598308, "keyType", newJString(keyType))
  add(query_598308, "fields", newJString(fields))
  add(query_598308, "quotaUser", newJString(quotaUser))
  add(query_598308, "alt", newJString(alt))
  add(query_598308, "oauth_token", newJString(oauthToken))
  add(query_598308, "userIp", newJString(userIp))
  add(query_598308, "key", newJString(key))
  add(path_598307, "enterpriseId", newJString(enterpriseId))
  add(query_598308, "prettyPrint", newJBool(prettyPrint))
  result = call_598306.call(path_598307, query_598308, nil, nil, nil)

var androidenterpriseEnterprisesGetServiceAccount* = Call_AndroidenterpriseEnterprisesGetServiceAccount_598293(
    name: "androidenterpriseEnterprisesGetServiceAccount",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccount",
    validator: validate_AndroidenterpriseEnterprisesGetServiceAccount_598294,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesGetServiceAccount_598295,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseServiceaccountkeysInsert_598324 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseServiceaccountkeysInsert_598326(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/serviceAccountKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseServiceaccountkeysInsert_598325(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates new credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  ## Only the type of the key should be populated in the resource to be inserted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598327 = path.getOrDefault("enterpriseId")
  valid_598327 = validateParameter(valid_598327, JString, required = true,
                                 default = nil)
  if valid_598327 != nil:
    section.add "enterpriseId", valid_598327
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598328 = query.getOrDefault("fields")
  valid_598328 = validateParameter(valid_598328, JString, required = false,
                                 default = nil)
  if valid_598328 != nil:
    section.add "fields", valid_598328
  var valid_598329 = query.getOrDefault("quotaUser")
  valid_598329 = validateParameter(valid_598329, JString, required = false,
                                 default = nil)
  if valid_598329 != nil:
    section.add "quotaUser", valid_598329
  var valid_598330 = query.getOrDefault("alt")
  valid_598330 = validateParameter(valid_598330, JString, required = false,
                                 default = newJString("json"))
  if valid_598330 != nil:
    section.add "alt", valid_598330
  var valid_598331 = query.getOrDefault("oauth_token")
  valid_598331 = validateParameter(valid_598331, JString, required = false,
                                 default = nil)
  if valid_598331 != nil:
    section.add "oauth_token", valid_598331
  var valid_598332 = query.getOrDefault("userIp")
  valid_598332 = validateParameter(valid_598332, JString, required = false,
                                 default = nil)
  if valid_598332 != nil:
    section.add "userIp", valid_598332
  var valid_598333 = query.getOrDefault("key")
  valid_598333 = validateParameter(valid_598333, JString, required = false,
                                 default = nil)
  if valid_598333 != nil:
    section.add "key", valid_598333
  var valid_598334 = query.getOrDefault("prettyPrint")
  valid_598334 = validateParameter(valid_598334, JBool, required = false,
                                 default = newJBool(true))
  if valid_598334 != nil:
    section.add "prettyPrint", valid_598334
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

proc call*(call_598336: Call_AndroidenterpriseServiceaccountkeysInsert_598324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates new credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  ## Only the type of the key should be populated in the resource to be inserted.
  ## 
  let valid = call_598336.validator(path, query, header, formData, body)
  let scheme = call_598336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598336.url(scheme.get, call_598336.host, call_598336.base,
                         call_598336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598336, url, valid)

proc call*(call_598337: Call_AndroidenterpriseServiceaccountkeysInsert_598324;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseServiceaccountkeysInsert
  ## Generates new credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  ## Only the type of the key should be populated in the resource to be inserted.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598338 = newJObject()
  var query_598339 = newJObject()
  var body_598340 = newJObject()
  add(query_598339, "fields", newJString(fields))
  add(query_598339, "quotaUser", newJString(quotaUser))
  add(query_598339, "alt", newJString(alt))
  add(query_598339, "oauth_token", newJString(oauthToken))
  add(query_598339, "userIp", newJString(userIp))
  add(query_598339, "key", newJString(key))
  add(path_598338, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598340 = body
  add(query_598339, "prettyPrint", newJBool(prettyPrint))
  result = call_598337.call(path_598338, query_598339, nil, nil, body_598340)

var androidenterpriseServiceaccountkeysInsert* = Call_AndroidenterpriseServiceaccountkeysInsert_598324(
    name: "androidenterpriseServiceaccountkeysInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccountKeys",
    validator: validate_AndroidenterpriseServiceaccountkeysInsert_598325,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseServiceaccountkeysInsert_598326,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseServiceaccountkeysList_598309 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseServiceaccountkeysList_598311(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/serviceAccountKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseServiceaccountkeysList_598310(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all active credentials for the service account associated with this enterprise. Only the ID and key type are returned. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598312 = path.getOrDefault("enterpriseId")
  valid_598312 = validateParameter(valid_598312, JString, required = true,
                                 default = nil)
  if valid_598312 != nil:
    section.add "enterpriseId", valid_598312
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598313 = query.getOrDefault("fields")
  valid_598313 = validateParameter(valid_598313, JString, required = false,
                                 default = nil)
  if valid_598313 != nil:
    section.add "fields", valid_598313
  var valid_598314 = query.getOrDefault("quotaUser")
  valid_598314 = validateParameter(valid_598314, JString, required = false,
                                 default = nil)
  if valid_598314 != nil:
    section.add "quotaUser", valid_598314
  var valid_598315 = query.getOrDefault("alt")
  valid_598315 = validateParameter(valid_598315, JString, required = false,
                                 default = newJString("json"))
  if valid_598315 != nil:
    section.add "alt", valid_598315
  var valid_598316 = query.getOrDefault("oauth_token")
  valid_598316 = validateParameter(valid_598316, JString, required = false,
                                 default = nil)
  if valid_598316 != nil:
    section.add "oauth_token", valid_598316
  var valid_598317 = query.getOrDefault("userIp")
  valid_598317 = validateParameter(valid_598317, JString, required = false,
                                 default = nil)
  if valid_598317 != nil:
    section.add "userIp", valid_598317
  var valid_598318 = query.getOrDefault("key")
  valid_598318 = validateParameter(valid_598318, JString, required = false,
                                 default = nil)
  if valid_598318 != nil:
    section.add "key", valid_598318
  var valid_598319 = query.getOrDefault("prettyPrint")
  valid_598319 = validateParameter(valid_598319, JBool, required = false,
                                 default = newJBool(true))
  if valid_598319 != nil:
    section.add "prettyPrint", valid_598319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598320: Call_AndroidenterpriseServiceaccountkeysList_598309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all active credentials for the service account associated with this enterprise. Only the ID and key type are returned. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  let valid = call_598320.validator(path, query, header, formData, body)
  let scheme = call_598320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598320.url(scheme.get, call_598320.host, call_598320.base,
                         call_598320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598320, url, valid)

proc call*(call_598321: Call_AndroidenterpriseServiceaccountkeysList_598309;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseServiceaccountkeysList
  ## Lists all active credentials for the service account associated with this enterprise. Only the ID and key type are returned. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598322 = newJObject()
  var query_598323 = newJObject()
  add(query_598323, "fields", newJString(fields))
  add(query_598323, "quotaUser", newJString(quotaUser))
  add(query_598323, "alt", newJString(alt))
  add(query_598323, "oauth_token", newJString(oauthToken))
  add(query_598323, "userIp", newJString(userIp))
  add(query_598323, "key", newJString(key))
  add(path_598322, "enterpriseId", newJString(enterpriseId))
  add(query_598323, "prettyPrint", newJBool(prettyPrint))
  result = call_598321.call(path_598322, query_598323, nil, nil, nil)

var androidenterpriseServiceaccountkeysList* = Call_AndroidenterpriseServiceaccountkeysList_598309(
    name: "androidenterpriseServiceaccountkeysList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccountKeys",
    validator: validate_AndroidenterpriseServiceaccountkeysList_598310,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseServiceaccountkeysList_598311,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseServiceaccountkeysDelete_598341 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseServiceaccountkeysDelete_598343(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "keyId" in path, "`keyId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/serviceAccountKeys/"),
               (kind: VariableSegment, value: "keyId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseServiceaccountkeysDelete_598342(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes and invalidates the specified credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   keyId: JString (required)
  ##        : The ID of the key.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `keyId` field"
  var valid_598344 = path.getOrDefault("keyId")
  valid_598344 = validateParameter(valid_598344, JString, required = true,
                                 default = nil)
  if valid_598344 != nil:
    section.add "keyId", valid_598344
  var valid_598345 = path.getOrDefault("enterpriseId")
  valid_598345 = validateParameter(valid_598345, JString, required = true,
                                 default = nil)
  if valid_598345 != nil:
    section.add "enterpriseId", valid_598345
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598346 = query.getOrDefault("fields")
  valid_598346 = validateParameter(valid_598346, JString, required = false,
                                 default = nil)
  if valid_598346 != nil:
    section.add "fields", valid_598346
  var valid_598347 = query.getOrDefault("quotaUser")
  valid_598347 = validateParameter(valid_598347, JString, required = false,
                                 default = nil)
  if valid_598347 != nil:
    section.add "quotaUser", valid_598347
  var valid_598348 = query.getOrDefault("alt")
  valid_598348 = validateParameter(valid_598348, JString, required = false,
                                 default = newJString("json"))
  if valid_598348 != nil:
    section.add "alt", valid_598348
  var valid_598349 = query.getOrDefault("oauth_token")
  valid_598349 = validateParameter(valid_598349, JString, required = false,
                                 default = nil)
  if valid_598349 != nil:
    section.add "oauth_token", valid_598349
  var valid_598350 = query.getOrDefault("userIp")
  valid_598350 = validateParameter(valid_598350, JString, required = false,
                                 default = nil)
  if valid_598350 != nil:
    section.add "userIp", valid_598350
  var valid_598351 = query.getOrDefault("key")
  valid_598351 = validateParameter(valid_598351, JString, required = false,
                                 default = nil)
  if valid_598351 != nil:
    section.add "key", valid_598351
  var valid_598352 = query.getOrDefault("prettyPrint")
  valid_598352 = validateParameter(valid_598352, JBool, required = false,
                                 default = newJBool(true))
  if valid_598352 != nil:
    section.add "prettyPrint", valid_598352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598353: Call_AndroidenterpriseServiceaccountkeysDelete_598341;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes and invalidates the specified credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  let valid = call_598353.validator(path, query, header, formData, body)
  let scheme = call_598353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598353.url(scheme.get, call_598353.host, call_598353.base,
                         call_598353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598353, url, valid)

proc call*(call_598354: Call_AndroidenterpriseServiceaccountkeysDelete_598341;
          keyId: string; enterpriseId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseServiceaccountkeysDelete
  ## Removes and invalidates the specified credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ##   keyId: string (required)
  ##        : The ID of the key.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598355 = newJObject()
  var query_598356 = newJObject()
  add(path_598355, "keyId", newJString(keyId))
  add(query_598356, "fields", newJString(fields))
  add(query_598356, "quotaUser", newJString(quotaUser))
  add(query_598356, "alt", newJString(alt))
  add(query_598356, "oauth_token", newJString(oauthToken))
  add(query_598356, "userIp", newJString(userIp))
  add(query_598356, "key", newJString(key))
  add(path_598355, "enterpriseId", newJString(enterpriseId))
  add(query_598356, "prettyPrint", newJBool(prettyPrint))
  result = call_598354.call(path_598355, query_598356, nil, nil, nil)

var androidenterpriseServiceaccountkeysDelete* = Call_AndroidenterpriseServiceaccountkeysDelete_598341(
    name: "androidenterpriseServiceaccountkeysDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccountKeys/{keyId}",
    validator: validate_AndroidenterpriseServiceaccountkeysDelete_598342,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseServiceaccountkeysDelete_598343,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesSetStoreLayout_598372 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesSetStoreLayout_598374(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesSetStoreLayout_598373(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the store layout for the enterprise. By default, storeLayoutType is set to "basic" and the basic store layout is enabled. The basic layout only contains apps approved by the admin, and that have been added to the available product set for a user (using the  setAvailableProductSet call). Apps on the page are sorted in order of their product ID value. If you create a custom store layout (by setting storeLayoutType = "custom" and setting a homepage), the basic store layout is disabled.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598375 = path.getOrDefault("enterpriseId")
  valid_598375 = validateParameter(valid_598375, JString, required = true,
                                 default = nil)
  if valid_598375 != nil:
    section.add "enterpriseId", valid_598375
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598376 = query.getOrDefault("fields")
  valid_598376 = validateParameter(valid_598376, JString, required = false,
                                 default = nil)
  if valid_598376 != nil:
    section.add "fields", valid_598376
  var valid_598377 = query.getOrDefault("quotaUser")
  valid_598377 = validateParameter(valid_598377, JString, required = false,
                                 default = nil)
  if valid_598377 != nil:
    section.add "quotaUser", valid_598377
  var valid_598378 = query.getOrDefault("alt")
  valid_598378 = validateParameter(valid_598378, JString, required = false,
                                 default = newJString("json"))
  if valid_598378 != nil:
    section.add "alt", valid_598378
  var valid_598379 = query.getOrDefault("oauth_token")
  valid_598379 = validateParameter(valid_598379, JString, required = false,
                                 default = nil)
  if valid_598379 != nil:
    section.add "oauth_token", valid_598379
  var valid_598380 = query.getOrDefault("userIp")
  valid_598380 = validateParameter(valid_598380, JString, required = false,
                                 default = nil)
  if valid_598380 != nil:
    section.add "userIp", valid_598380
  var valid_598381 = query.getOrDefault("key")
  valid_598381 = validateParameter(valid_598381, JString, required = false,
                                 default = nil)
  if valid_598381 != nil:
    section.add "key", valid_598381
  var valid_598382 = query.getOrDefault("prettyPrint")
  valid_598382 = validateParameter(valid_598382, JBool, required = false,
                                 default = newJBool(true))
  if valid_598382 != nil:
    section.add "prettyPrint", valid_598382
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

proc call*(call_598384: Call_AndroidenterpriseEnterprisesSetStoreLayout_598372;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the store layout for the enterprise. By default, storeLayoutType is set to "basic" and the basic store layout is enabled. The basic layout only contains apps approved by the admin, and that have been added to the available product set for a user (using the  setAvailableProductSet call). Apps on the page are sorted in order of their product ID value. If you create a custom store layout (by setting storeLayoutType = "custom" and setting a homepage), the basic store layout is disabled.
  ## 
  let valid = call_598384.validator(path, query, header, formData, body)
  let scheme = call_598384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598384.url(scheme.get, call_598384.host, call_598384.base,
                         call_598384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598384, url, valid)

proc call*(call_598385: Call_AndroidenterpriseEnterprisesSetStoreLayout_598372;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEnterprisesSetStoreLayout
  ## Sets the store layout for the enterprise. By default, storeLayoutType is set to "basic" and the basic store layout is enabled. The basic layout only contains apps approved by the admin, and that have been added to the available product set for a user (using the  setAvailableProductSet call). Apps on the page are sorted in order of their product ID value. If you create a custom store layout (by setting storeLayoutType = "custom" and setting a homepage), the basic store layout is disabled.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598386 = newJObject()
  var query_598387 = newJObject()
  var body_598388 = newJObject()
  add(query_598387, "fields", newJString(fields))
  add(query_598387, "quotaUser", newJString(quotaUser))
  add(query_598387, "alt", newJString(alt))
  add(query_598387, "oauth_token", newJString(oauthToken))
  add(query_598387, "userIp", newJString(userIp))
  add(query_598387, "key", newJString(key))
  add(path_598386, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598388 = body
  add(query_598387, "prettyPrint", newJBool(prettyPrint))
  result = call_598385.call(path_598386, query_598387, nil, nil, body_598388)

var androidenterpriseEnterprisesSetStoreLayout* = Call_AndroidenterpriseEnterprisesSetStoreLayout_598372(
    name: "androidenterpriseEnterprisesSetStoreLayout", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout",
    validator: validate_AndroidenterpriseEnterprisesSetStoreLayout_598373,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesSetStoreLayout_598374,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGetStoreLayout_598357 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesGetStoreLayout_598359(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesGetStoreLayout_598358(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the store layout for the enterprise. If the store layout has not been set, returns "basic" as the store layout type and no homepage.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598360 = path.getOrDefault("enterpriseId")
  valid_598360 = validateParameter(valid_598360, JString, required = true,
                                 default = nil)
  if valid_598360 != nil:
    section.add "enterpriseId", valid_598360
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598361 = query.getOrDefault("fields")
  valid_598361 = validateParameter(valid_598361, JString, required = false,
                                 default = nil)
  if valid_598361 != nil:
    section.add "fields", valid_598361
  var valid_598362 = query.getOrDefault("quotaUser")
  valid_598362 = validateParameter(valid_598362, JString, required = false,
                                 default = nil)
  if valid_598362 != nil:
    section.add "quotaUser", valid_598362
  var valid_598363 = query.getOrDefault("alt")
  valid_598363 = validateParameter(valid_598363, JString, required = false,
                                 default = newJString("json"))
  if valid_598363 != nil:
    section.add "alt", valid_598363
  var valid_598364 = query.getOrDefault("oauth_token")
  valid_598364 = validateParameter(valid_598364, JString, required = false,
                                 default = nil)
  if valid_598364 != nil:
    section.add "oauth_token", valid_598364
  var valid_598365 = query.getOrDefault("userIp")
  valid_598365 = validateParameter(valid_598365, JString, required = false,
                                 default = nil)
  if valid_598365 != nil:
    section.add "userIp", valid_598365
  var valid_598366 = query.getOrDefault("key")
  valid_598366 = validateParameter(valid_598366, JString, required = false,
                                 default = nil)
  if valid_598366 != nil:
    section.add "key", valid_598366
  var valid_598367 = query.getOrDefault("prettyPrint")
  valid_598367 = validateParameter(valid_598367, JBool, required = false,
                                 default = newJBool(true))
  if valid_598367 != nil:
    section.add "prettyPrint", valid_598367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598368: Call_AndroidenterpriseEnterprisesGetStoreLayout_598357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the store layout for the enterprise. If the store layout has not been set, returns "basic" as the store layout type and no homepage.
  ## 
  let valid = call_598368.validator(path, query, header, formData, body)
  let scheme = call_598368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598368.url(scheme.get, call_598368.host, call_598368.base,
                         call_598368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598368, url, valid)

proc call*(call_598369: Call_AndroidenterpriseEnterprisesGetStoreLayout_598357;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEnterprisesGetStoreLayout
  ## Returns the store layout for the enterprise. If the store layout has not been set, returns "basic" as the store layout type and no homepage.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598370 = newJObject()
  var query_598371 = newJObject()
  add(query_598371, "fields", newJString(fields))
  add(query_598371, "quotaUser", newJString(quotaUser))
  add(query_598371, "alt", newJString(alt))
  add(query_598371, "oauth_token", newJString(oauthToken))
  add(query_598371, "userIp", newJString(userIp))
  add(query_598371, "key", newJString(key))
  add(path_598370, "enterpriseId", newJString(enterpriseId))
  add(query_598371, "prettyPrint", newJBool(prettyPrint))
  result = call_598369.call(path_598370, query_598371, nil, nil, nil)

var androidenterpriseEnterprisesGetStoreLayout* = Call_AndroidenterpriseEnterprisesGetStoreLayout_598357(
    name: "androidenterpriseEnterprisesGetStoreLayout", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout",
    validator: validate_AndroidenterpriseEnterprisesGetStoreLayout_598358,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesGetStoreLayout_598359,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesInsert_598404 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseStorelayoutpagesInsert_598406(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutpagesInsert_598405(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new store page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598407 = path.getOrDefault("enterpriseId")
  valid_598407 = validateParameter(valid_598407, JString, required = true,
                                 default = nil)
  if valid_598407 != nil:
    section.add "enterpriseId", valid_598407
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598408 = query.getOrDefault("fields")
  valid_598408 = validateParameter(valid_598408, JString, required = false,
                                 default = nil)
  if valid_598408 != nil:
    section.add "fields", valid_598408
  var valid_598409 = query.getOrDefault("quotaUser")
  valid_598409 = validateParameter(valid_598409, JString, required = false,
                                 default = nil)
  if valid_598409 != nil:
    section.add "quotaUser", valid_598409
  var valid_598410 = query.getOrDefault("alt")
  valid_598410 = validateParameter(valid_598410, JString, required = false,
                                 default = newJString("json"))
  if valid_598410 != nil:
    section.add "alt", valid_598410
  var valid_598411 = query.getOrDefault("oauth_token")
  valid_598411 = validateParameter(valid_598411, JString, required = false,
                                 default = nil)
  if valid_598411 != nil:
    section.add "oauth_token", valid_598411
  var valid_598412 = query.getOrDefault("userIp")
  valid_598412 = validateParameter(valid_598412, JString, required = false,
                                 default = nil)
  if valid_598412 != nil:
    section.add "userIp", valid_598412
  var valid_598413 = query.getOrDefault("key")
  valid_598413 = validateParameter(valid_598413, JString, required = false,
                                 default = nil)
  if valid_598413 != nil:
    section.add "key", valid_598413
  var valid_598414 = query.getOrDefault("prettyPrint")
  valid_598414 = validateParameter(valid_598414, JBool, required = false,
                                 default = newJBool(true))
  if valid_598414 != nil:
    section.add "prettyPrint", valid_598414
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

proc call*(call_598416: Call_AndroidenterpriseStorelayoutpagesInsert_598404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new store page.
  ## 
  let valid = call_598416.validator(path, query, header, formData, body)
  let scheme = call_598416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598416.url(scheme.get, call_598416.host, call_598416.base,
                         call_598416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598416, url, valid)

proc call*(call_598417: Call_AndroidenterpriseStorelayoutpagesInsert_598404;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseStorelayoutpagesInsert
  ## Inserts a new store page.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598418 = newJObject()
  var query_598419 = newJObject()
  var body_598420 = newJObject()
  add(query_598419, "fields", newJString(fields))
  add(query_598419, "quotaUser", newJString(quotaUser))
  add(query_598419, "alt", newJString(alt))
  add(query_598419, "oauth_token", newJString(oauthToken))
  add(query_598419, "userIp", newJString(userIp))
  add(query_598419, "key", newJString(key))
  add(path_598418, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598420 = body
  add(query_598419, "prettyPrint", newJBool(prettyPrint))
  result = call_598417.call(path_598418, query_598419, nil, nil, body_598420)

var androidenterpriseStorelayoutpagesInsert* = Call_AndroidenterpriseStorelayoutpagesInsert_598404(
    name: "androidenterpriseStorelayoutpagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages",
    validator: validate_AndroidenterpriseStorelayoutpagesInsert_598405,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesInsert_598406,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesList_598389 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseStorelayoutpagesList_598391(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutpagesList_598390(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of all pages in the store.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598392 = path.getOrDefault("enterpriseId")
  valid_598392 = validateParameter(valid_598392, JString, required = true,
                                 default = nil)
  if valid_598392 != nil:
    section.add "enterpriseId", valid_598392
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598393 = query.getOrDefault("fields")
  valid_598393 = validateParameter(valid_598393, JString, required = false,
                                 default = nil)
  if valid_598393 != nil:
    section.add "fields", valid_598393
  var valid_598394 = query.getOrDefault("quotaUser")
  valid_598394 = validateParameter(valid_598394, JString, required = false,
                                 default = nil)
  if valid_598394 != nil:
    section.add "quotaUser", valid_598394
  var valid_598395 = query.getOrDefault("alt")
  valid_598395 = validateParameter(valid_598395, JString, required = false,
                                 default = newJString("json"))
  if valid_598395 != nil:
    section.add "alt", valid_598395
  var valid_598396 = query.getOrDefault("oauth_token")
  valid_598396 = validateParameter(valid_598396, JString, required = false,
                                 default = nil)
  if valid_598396 != nil:
    section.add "oauth_token", valid_598396
  var valid_598397 = query.getOrDefault("userIp")
  valid_598397 = validateParameter(valid_598397, JString, required = false,
                                 default = nil)
  if valid_598397 != nil:
    section.add "userIp", valid_598397
  var valid_598398 = query.getOrDefault("key")
  valid_598398 = validateParameter(valid_598398, JString, required = false,
                                 default = nil)
  if valid_598398 != nil:
    section.add "key", valid_598398
  var valid_598399 = query.getOrDefault("prettyPrint")
  valid_598399 = validateParameter(valid_598399, JBool, required = false,
                                 default = newJBool(true))
  if valid_598399 != nil:
    section.add "prettyPrint", valid_598399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598400: Call_AndroidenterpriseStorelayoutpagesList_598389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all pages in the store.
  ## 
  let valid = call_598400.validator(path, query, header, formData, body)
  let scheme = call_598400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598400.url(scheme.get, call_598400.host, call_598400.base,
                         call_598400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598400, url, valid)

proc call*(call_598401: Call_AndroidenterpriseStorelayoutpagesList_598389;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseStorelayoutpagesList
  ## Retrieves the details of all pages in the store.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598402 = newJObject()
  var query_598403 = newJObject()
  add(query_598403, "fields", newJString(fields))
  add(query_598403, "quotaUser", newJString(quotaUser))
  add(query_598403, "alt", newJString(alt))
  add(query_598403, "oauth_token", newJString(oauthToken))
  add(query_598403, "userIp", newJString(userIp))
  add(query_598403, "key", newJString(key))
  add(path_598402, "enterpriseId", newJString(enterpriseId))
  add(query_598403, "prettyPrint", newJBool(prettyPrint))
  result = call_598401.call(path_598402, query_598403, nil, nil, nil)

var androidenterpriseStorelayoutpagesList* = Call_AndroidenterpriseStorelayoutpagesList_598389(
    name: "androidenterpriseStorelayoutpagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages",
    validator: validate_AndroidenterpriseStorelayoutpagesList_598390,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseStorelayoutpagesList_598391,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesUpdate_598437 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseStorelayoutpagesUpdate_598439(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutpagesUpdate_598438(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the content of a store page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598440 = path.getOrDefault("enterpriseId")
  valid_598440 = validateParameter(valid_598440, JString, required = true,
                                 default = nil)
  if valid_598440 != nil:
    section.add "enterpriseId", valid_598440
  var valid_598441 = path.getOrDefault("pageId")
  valid_598441 = validateParameter(valid_598441, JString, required = true,
                                 default = nil)
  if valid_598441 != nil:
    section.add "pageId", valid_598441
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598442 = query.getOrDefault("fields")
  valid_598442 = validateParameter(valid_598442, JString, required = false,
                                 default = nil)
  if valid_598442 != nil:
    section.add "fields", valid_598442
  var valid_598443 = query.getOrDefault("quotaUser")
  valid_598443 = validateParameter(valid_598443, JString, required = false,
                                 default = nil)
  if valid_598443 != nil:
    section.add "quotaUser", valid_598443
  var valid_598444 = query.getOrDefault("alt")
  valid_598444 = validateParameter(valid_598444, JString, required = false,
                                 default = newJString("json"))
  if valid_598444 != nil:
    section.add "alt", valid_598444
  var valid_598445 = query.getOrDefault("oauth_token")
  valid_598445 = validateParameter(valid_598445, JString, required = false,
                                 default = nil)
  if valid_598445 != nil:
    section.add "oauth_token", valid_598445
  var valid_598446 = query.getOrDefault("userIp")
  valid_598446 = validateParameter(valid_598446, JString, required = false,
                                 default = nil)
  if valid_598446 != nil:
    section.add "userIp", valid_598446
  var valid_598447 = query.getOrDefault("key")
  valid_598447 = validateParameter(valid_598447, JString, required = false,
                                 default = nil)
  if valid_598447 != nil:
    section.add "key", valid_598447
  var valid_598448 = query.getOrDefault("prettyPrint")
  valid_598448 = validateParameter(valid_598448, JBool, required = false,
                                 default = newJBool(true))
  if valid_598448 != nil:
    section.add "prettyPrint", valid_598448
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

proc call*(call_598450: Call_AndroidenterpriseStorelayoutpagesUpdate_598437;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the content of a store page.
  ## 
  let valid = call_598450.validator(path, query, header, formData, body)
  let scheme = call_598450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598450.url(scheme.get, call_598450.host, call_598450.base,
                         call_598450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598450, url, valid)

proc call*(call_598451: Call_AndroidenterpriseStorelayoutpagesUpdate_598437;
          enterpriseId: string; pageId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseStorelayoutpagesUpdate
  ## Updates the content of a store page.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   pageId: string (required)
  ##         : The ID of the page.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598452 = newJObject()
  var query_598453 = newJObject()
  var body_598454 = newJObject()
  add(query_598453, "fields", newJString(fields))
  add(query_598453, "quotaUser", newJString(quotaUser))
  add(query_598453, "alt", newJString(alt))
  add(query_598453, "oauth_token", newJString(oauthToken))
  add(query_598453, "userIp", newJString(userIp))
  add(query_598453, "key", newJString(key))
  add(path_598452, "enterpriseId", newJString(enterpriseId))
  add(path_598452, "pageId", newJString(pageId))
  if body != nil:
    body_598454 = body
  add(query_598453, "prettyPrint", newJBool(prettyPrint))
  result = call_598451.call(path_598452, query_598453, nil, nil, body_598454)

var androidenterpriseStorelayoutpagesUpdate* = Call_AndroidenterpriseStorelayoutpagesUpdate_598437(
    name: "androidenterpriseStorelayoutpagesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesUpdate_598438,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesUpdate_598439,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesGet_598421 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseStorelayoutpagesGet_598423(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutpagesGet_598422(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of a store page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598424 = path.getOrDefault("enterpriseId")
  valid_598424 = validateParameter(valid_598424, JString, required = true,
                                 default = nil)
  if valid_598424 != nil:
    section.add "enterpriseId", valid_598424
  var valid_598425 = path.getOrDefault("pageId")
  valid_598425 = validateParameter(valid_598425, JString, required = true,
                                 default = nil)
  if valid_598425 != nil:
    section.add "pageId", valid_598425
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598426 = query.getOrDefault("fields")
  valid_598426 = validateParameter(valid_598426, JString, required = false,
                                 default = nil)
  if valid_598426 != nil:
    section.add "fields", valid_598426
  var valid_598427 = query.getOrDefault("quotaUser")
  valid_598427 = validateParameter(valid_598427, JString, required = false,
                                 default = nil)
  if valid_598427 != nil:
    section.add "quotaUser", valid_598427
  var valid_598428 = query.getOrDefault("alt")
  valid_598428 = validateParameter(valid_598428, JString, required = false,
                                 default = newJString("json"))
  if valid_598428 != nil:
    section.add "alt", valid_598428
  var valid_598429 = query.getOrDefault("oauth_token")
  valid_598429 = validateParameter(valid_598429, JString, required = false,
                                 default = nil)
  if valid_598429 != nil:
    section.add "oauth_token", valid_598429
  var valid_598430 = query.getOrDefault("userIp")
  valid_598430 = validateParameter(valid_598430, JString, required = false,
                                 default = nil)
  if valid_598430 != nil:
    section.add "userIp", valid_598430
  var valid_598431 = query.getOrDefault("key")
  valid_598431 = validateParameter(valid_598431, JString, required = false,
                                 default = nil)
  if valid_598431 != nil:
    section.add "key", valid_598431
  var valid_598432 = query.getOrDefault("prettyPrint")
  valid_598432 = validateParameter(valid_598432, JBool, required = false,
                                 default = newJBool(true))
  if valid_598432 != nil:
    section.add "prettyPrint", valid_598432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598433: Call_AndroidenterpriseStorelayoutpagesGet_598421;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a store page.
  ## 
  let valid = call_598433.validator(path, query, header, formData, body)
  let scheme = call_598433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598433.url(scheme.get, call_598433.host, call_598433.base,
                         call_598433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598433, url, valid)

proc call*(call_598434: Call_AndroidenterpriseStorelayoutpagesGet_598421;
          enterpriseId: string; pageId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseStorelayoutpagesGet
  ## Retrieves details of a store page.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   pageId: string (required)
  ##         : The ID of the page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598435 = newJObject()
  var query_598436 = newJObject()
  add(query_598436, "fields", newJString(fields))
  add(query_598436, "quotaUser", newJString(quotaUser))
  add(query_598436, "alt", newJString(alt))
  add(query_598436, "oauth_token", newJString(oauthToken))
  add(query_598436, "userIp", newJString(userIp))
  add(query_598436, "key", newJString(key))
  add(path_598435, "enterpriseId", newJString(enterpriseId))
  add(path_598435, "pageId", newJString(pageId))
  add(query_598436, "prettyPrint", newJBool(prettyPrint))
  result = call_598434.call(path_598435, query_598436, nil, nil, nil)

var androidenterpriseStorelayoutpagesGet* = Call_AndroidenterpriseStorelayoutpagesGet_598421(
    name: "androidenterpriseStorelayoutpagesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesGet_598422,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseStorelayoutpagesGet_598423,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesPatch_598471 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseStorelayoutpagesPatch_598473(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutpagesPatch_598472(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the content of a store page. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598474 = path.getOrDefault("enterpriseId")
  valid_598474 = validateParameter(valid_598474, JString, required = true,
                                 default = nil)
  if valid_598474 != nil:
    section.add "enterpriseId", valid_598474
  var valid_598475 = path.getOrDefault("pageId")
  valid_598475 = validateParameter(valid_598475, JString, required = true,
                                 default = nil)
  if valid_598475 != nil:
    section.add "pageId", valid_598475
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598476 = query.getOrDefault("fields")
  valid_598476 = validateParameter(valid_598476, JString, required = false,
                                 default = nil)
  if valid_598476 != nil:
    section.add "fields", valid_598476
  var valid_598477 = query.getOrDefault("quotaUser")
  valid_598477 = validateParameter(valid_598477, JString, required = false,
                                 default = nil)
  if valid_598477 != nil:
    section.add "quotaUser", valid_598477
  var valid_598478 = query.getOrDefault("alt")
  valid_598478 = validateParameter(valid_598478, JString, required = false,
                                 default = newJString("json"))
  if valid_598478 != nil:
    section.add "alt", valid_598478
  var valid_598479 = query.getOrDefault("oauth_token")
  valid_598479 = validateParameter(valid_598479, JString, required = false,
                                 default = nil)
  if valid_598479 != nil:
    section.add "oauth_token", valid_598479
  var valid_598480 = query.getOrDefault("userIp")
  valid_598480 = validateParameter(valid_598480, JString, required = false,
                                 default = nil)
  if valid_598480 != nil:
    section.add "userIp", valid_598480
  var valid_598481 = query.getOrDefault("key")
  valid_598481 = validateParameter(valid_598481, JString, required = false,
                                 default = nil)
  if valid_598481 != nil:
    section.add "key", valid_598481
  var valid_598482 = query.getOrDefault("prettyPrint")
  valid_598482 = validateParameter(valid_598482, JBool, required = false,
                                 default = newJBool(true))
  if valid_598482 != nil:
    section.add "prettyPrint", valid_598482
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

proc call*(call_598484: Call_AndroidenterpriseStorelayoutpagesPatch_598471;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the content of a store page. This method supports patch semantics.
  ## 
  let valid = call_598484.validator(path, query, header, formData, body)
  let scheme = call_598484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598484.url(scheme.get, call_598484.host, call_598484.base,
                         call_598484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598484, url, valid)

proc call*(call_598485: Call_AndroidenterpriseStorelayoutpagesPatch_598471;
          enterpriseId: string; pageId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseStorelayoutpagesPatch
  ## Updates the content of a store page. This method supports patch semantics.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   pageId: string (required)
  ##         : The ID of the page.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598486 = newJObject()
  var query_598487 = newJObject()
  var body_598488 = newJObject()
  add(query_598487, "fields", newJString(fields))
  add(query_598487, "quotaUser", newJString(quotaUser))
  add(query_598487, "alt", newJString(alt))
  add(query_598487, "oauth_token", newJString(oauthToken))
  add(query_598487, "userIp", newJString(userIp))
  add(query_598487, "key", newJString(key))
  add(path_598486, "enterpriseId", newJString(enterpriseId))
  add(path_598486, "pageId", newJString(pageId))
  if body != nil:
    body_598488 = body
  add(query_598487, "prettyPrint", newJBool(prettyPrint))
  result = call_598485.call(path_598486, query_598487, nil, nil, body_598488)

var androidenterpriseStorelayoutpagesPatch* = Call_AndroidenterpriseStorelayoutpagesPatch_598471(
    name: "androidenterpriseStorelayoutpagesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesPatch_598472,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesPatch_598473,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesDelete_598455 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseStorelayoutpagesDelete_598457(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutpagesDelete_598456(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a store page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598458 = path.getOrDefault("enterpriseId")
  valid_598458 = validateParameter(valid_598458, JString, required = true,
                                 default = nil)
  if valid_598458 != nil:
    section.add "enterpriseId", valid_598458
  var valid_598459 = path.getOrDefault("pageId")
  valid_598459 = validateParameter(valid_598459, JString, required = true,
                                 default = nil)
  if valid_598459 != nil:
    section.add "pageId", valid_598459
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598460 = query.getOrDefault("fields")
  valid_598460 = validateParameter(valid_598460, JString, required = false,
                                 default = nil)
  if valid_598460 != nil:
    section.add "fields", valid_598460
  var valid_598461 = query.getOrDefault("quotaUser")
  valid_598461 = validateParameter(valid_598461, JString, required = false,
                                 default = nil)
  if valid_598461 != nil:
    section.add "quotaUser", valid_598461
  var valid_598462 = query.getOrDefault("alt")
  valid_598462 = validateParameter(valid_598462, JString, required = false,
                                 default = newJString("json"))
  if valid_598462 != nil:
    section.add "alt", valid_598462
  var valid_598463 = query.getOrDefault("oauth_token")
  valid_598463 = validateParameter(valid_598463, JString, required = false,
                                 default = nil)
  if valid_598463 != nil:
    section.add "oauth_token", valid_598463
  var valid_598464 = query.getOrDefault("userIp")
  valid_598464 = validateParameter(valid_598464, JString, required = false,
                                 default = nil)
  if valid_598464 != nil:
    section.add "userIp", valid_598464
  var valid_598465 = query.getOrDefault("key")
  valid_598465 = validateParameter(valid_598465, JString, required = false,
                                 default = nil)
  if valid_598465 != nil:
    section.add "key", valid_598465
  var valid_598466 = query.getOrDefault("prettyPrint")
  valid_598466 = validateParameter(valid_598466, JBool, required = false,
                                 default = newJBool(true))
  if valid_598466 != nil:
    section.add "prettyPrint", valid_598466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598467: Call_AndroidenterpriseStorelayoutpagesDelete_598455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a store page.
  ## 
  let valid = call_598467.validator(path, query, header, formData, body)
  let scheme = call_598467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598467.url(scheme.get, call_598467.host, call_598467.base,
                         call_598467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598467, url, valid)

proc call*(call_598468: Call_AndroidenterpriseStorelayoutpagesDelete_598455;
          enterpriseId: string; pageId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseStorelayoutpagesDelete
  ## Deletes a store page.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   pageId: string (required)
  ##         : The ID of the page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598469 = newJObject()
  var query_598470 = newJObject()
  add(query_598470, "fields", newJString(fields))
  add(query_598470, "quotaUser", newJString(quotaUser))
  add(query_598470, "alt", newJString(alt))
  add(query_598470, "oauth_token", newJString(oauthToken))
  add(query_598470, "userIp", newJString(userIp))
  add(query_598470, "key", newJString(key))
  add(path_598469, "enterpriseId", newJString(enterpriseId))
  add(path_598469, "pageId", newJString(pageId))
  add(query_598470, "prettyPrint", newJBool(prettyPrint))
  result = call_598468.call(path_598469, query_598470, nil, nil, nil)

var androidenterpriseStorelayoutpagesDelete* = Call_AndroidenterpriseStorelayoutpagesDelete_598455(
    name: "androidenterpriseStorelayoutpagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesDelete_598456,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesDelete_598457,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersInsert_598505 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseStorelayoutclustersInsert_598507(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutclustersInsert_598506(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a new cluster in a page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598508 = path.getOrDefault("enterpriseId")
  valid_598508 = validateParameter(valid_598508, JString, required = true,
                                 default = nil)
  if valid_598508 != nil:
    section.add "enterpriseId", valid_598508
  var valid_598509 = path.getOrDefault("pageId")
  valid_598509 = validateParameter(valid_598509, JString, required = true,
                                 default = nil)
  if valid_598509 != nil:
    section.add "pageId", valid_598509
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598510 = query.getOrDefault("fields")
  valid_598510 = validateParameter(valid_598510, JString, required = false,
                                 default = nil)
  if valid_598510 != nil:
    section.add "fields", valid_598510
  var valid_598511 = query.getOrDefault("quotaUser")
  valid_598511 = validateParameter(valid_598511, JString, required = false,
                                 default = nil)
  if valid_598511 != nil:
    section.add "quotaUser", valid_598511
  var valid_598512 = query.getOrDefault("alt")
  valid_598512 = validateParameter(valid_598512, JString, required = false,
                                 default = newJString("json"))
  if valid_598512 != nil:
    section.add "alt", valid_598512
  var valid_598513 = query.getOrDefault("oauth_token")
  valid_598513 = validateParameter(valid_598513, JString, required = false,
                                 default = nil)
  if valid_598513 != nil:
    section.add "oauth_token", valid_598513
  var valid_598514 = query.getOrDefault("userIp")
  valid_598514 = validateParameter(valid_598514, JString, required = false,
                                 default = nil)
  if valid_598514 != nil:
    section.add "userIp", valid_598514
  var valid_598515 = query.getOrDefault("key")
  valid_598515 = validateParameter(valid_598515, JString, required = false,
                                 default = nil)
  if valid_598515 != nil:
    section.add "key", valid_598515
  var valid_598516 = query.getOrDefault("prettyPrint")
  valid_598516 = validateParameter(valid_598516, JBool, required = false,
                                 default = newJBool(true))
  if valid_598516 != nil:
    section.add "prettyPrint", valid_598516
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

proc call*(call_598518: Call_AndroidenterpriseStorelayoutclustersInsert_598505;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new cluster in a page.
  ## 
  let valid = call_598518.validator(path, query, header, formData, body)
  let scheme = call_598518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598518.url(scheme.get, call_598518.host, call_598518.base,
                         call_598518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598518, url, valid)

proc call*(call_598519: Call_AndroidenterpriseStorelayoutclustersInsert_598505;
          enterpriseId: string; pageId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseStorelayoutclustersInsert
  ## Inserts a new cluster in a page.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   pageId: string (required)
  ##         : The ID of the page.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598520 = newJObject()
  var query_598521 = newJObject()
  var body_598522 = newJObject()
  add(query_598521, "fields", newJString(fields))
  add(query_598521, "quotaUser", newJString(quotaUser))
  add(query_598521, "alt", newJString(alt))
  add(query_598521, "oauth_token", newJString(oauthToken))
  add(query_598521, "userIp", newJString(userIp))
  add(query_598521, "key", newJString(key))
  add(path_598520, "enterpriseId", newJString(enterpriseId))
  add(path_598520, "pageId", newJString(pageId))
  if body != nil:
    body_598522 = body
  add(query_598521, "prettyPrint", newJBool(prettyPrint))
  result = call_598519.call(path_598520, query_598521, nil, nil, body_598522)

var androidenterpriseStorelayoutclustersInsert* = Call_AndroidenterpriseStorelayoutclustersInsert_598505(
    name: "androidenterpriseStorelayoutclustersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters",
    validator: validate_AndroidenterpriseStorelayoutclustersInsert_598506,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersInsert_598507,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersList_598489 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseStorelayoutclustersList_598491(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutclustersList_598490(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of all clusters on the specified page.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598492 = path.getOrDefault("enterpriseId")
  valid_598492 = validateParameter(valid_598492, JString, required = true,
                                 default = nil)
  if valid_598492 != nil:
    section.add "enterpriseId", valid_598492
  var valid_598493 = path.getOrDefault("pageId")
  valid_598493 = validateParameter(valid_598493, JString, required = true,
                                 default = nil)
  if valid_598493 != nil:
    section.add "pageId", valid_598493
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598494 = query.getOrDefault("fields")
  valid_598494 = validateParameter(valid_598494, JString, required = false,
                                 default = nil)
  if valid_598494 != nil:
    section.add "fields", valid_598494
  var valid_598495 = query.getOrDefault("quotaUser")
  valid_598495 = validateParameter(valid_598495, JString, required = false,
                                 default = nil)
  if valid_598495 != nil:
    section.add "quotaUser", valid_598495
  var valid_598496 = query.getOrDefault("alt")
  valid_598496 = validateParameter(valid_598496, JString, required = false,
                                 default = newJString("json"))
  if valid_598496 != nil:
    section.add "alt", valid_598496
  var valid_598497 = query.getOrDefault("oauth_token")
  valid_598497 = validateParameter(valid_598497, JString, required = false,
                                 default = nil)
  if valid_598497 != nil:
    section.add "oauth_token", valid_598497
  var valid_598498 = query.getOrDefault("userIp")
  valid_598498 = validateParameter(valid_598498, JString, required = false,
                                 default = nil)
  if valid_598498 != nil:
    section.add "userIp", valid_598498
  var valid_598499 = query.getOrDefault("key")
  valid_598499 = validateParameter(valid_598499, JString, required = false,
                                 default = nil)
  if valid_598499 != nil:
    section.add "key", valid_598499
  var valid_598500 = query.getOrDefault("prettyPrint")
  valid_598500 = validateParameter(valid_598500, JBool, required = false,
                                 default = newJBool(true))
  if valid_598500 != nil:
    section.add "prettyPrint", valid_598500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598501: Call_AndroidenterpriseStorelayoutclustersList_598489;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all clusters on the specified page.
  ## 
  let valid = call_598501.validator(path, query, header, formData, body)
  let scheme = call_598501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598501.url(scheme.get, call_598501.host, call_598501.base,
                         call_598501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598501, url, valid)

proc call*(call_598502: Call_AndroidenterpriseStorelayoutclustersList_598489;
          enterpriseId: string; pageId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseStorelayoutclustersList
  ## Retrieves the details of all clusters on the specified page.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   pageId: string (required)
  ##         : The ID of the page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598503 = newJObject()
  var query_598504 = newJObject()
  add(query_598504, "fields", newJString(fields))
  add(query_598504, "quotaUser", newJString(quotaUser))
  add(query_598504, "alt", newJString(alt))
  add(query_598504, "oauth_token", newJString(oauthToken))
  add(query_598504, "userIp", newJString(userIp))
  add(query_598504, "key", newJString(key))
  add(path_598503, "enterpriseId", newJString(enterpriseId))
  add(path_598503, "pageId", newJString(pageId))
  add(query_598504, "prettyPrint", newJBool(prettyPrint))
  result = call_598502.call(path_598503, query_598504, nil, nil, nil)

var androidenterpriseStorelayoutclustersList* = Call_AndroidenterpriseStorelayoutclustersList_598489(
    name: "androidenterpriseStorelayoutclustersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters",
    validator: validate_AndroidenterpriseStorelayoutclustersList_598490,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersList_598491,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersUpdate_598540 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseStorelayoutclustersUpdate_598542(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutclustersUpdate_598541(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  ##   clusterId: JString (required)
  ##            : The ID of the cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598543 = path.getOrDefault("enterpriseId")
  valid_598543 = validateParameter(valid_598543, JString, required = true,
                                 default = nil)
  if valid_598543 != nil:
    section.add "enterpriseId", valid_598543
  var valid_598544 = path.getOrDefault("pageId")
  valid_598544 = validateParameter(valid_598544, JString, required = true,
                                 default = nil)
  if valid_598544 != nil:
    section.add "pageId", valid_598544
  var valid_598545 = path.getOrDefault("clusterId")
  valid_598545 = validateParameter(valid_598545, JString, required = true,
                                 default = nil)
  if valid_598545 != nil:
    section.add "clusterId", valid_598545
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598546 = query.getOrDefault("fields")
  valid_598546 = validateParameter(valid_598546, JString, required = false,
                                 default = nil)
  if valid_598546 != nil:
    section.add "fields", valid_598546
  var valid_598547 = query.getOrDefault("quotaUser")
  valid_598547 = validateParameter(valid_598547, JString, required = false,
                                 default = nil)
  if valid_598547 != nil:
    section.add "quotaUser", valid_598547
  var valid_598548 = query.getOrDefault("alt")
  valid_598548 = validateParameter(valid_598548, JString, required = false,
                                 default = newJString("json"))
  if valid_598548 != nil:
    section.add "alt", valid_598548
  var valid_598549 = query.getOrDefault("oauth_token")
  valid_598549 = validateParameter(valid_598549, JString, required = false,
                                 default = nil)
  if valid_598549 != nil:
    section.add "oauth_token", valid_598549
  var valid_598550 = query.getOrDefault("userIp")
  valid_598550 = validateParameter(valid_598550, JString, required = false,
                                 default = nil)
  if valid_598550 != nil:
    section.add "userIp", valid_598550
  var valid_598551 = query.getOrDefault("key")
  valid_598551 = validateParameter(valid_598551, JString, required = false,
                                 default = nil)
  if valid_598551 != nil:
    section.add "key", valid_598551
  var valid_598552 = query.getOrDefault("prettyPrint")
  valid_598552 = validateParameter(valid_598552, JBool, required = false,
                                 default = newJBool(true))
  if valid_598552 != nil:
    section.add "prettyPrint", valid_598552
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

proc call*(call_598554: Call_AndroidenterpriseStorelayoutclustersUpdate_598540;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster.
  ## 
  let valid = call_598554.validator(path, query, header, formData, body)
  let scheme = call_598554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598554.url(scheme.get, call_598554.host, call_598554.base,
                         call_598554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598554, url, valid)

proc call*(call_598555: Call_AndroidenterpriseStorelayoutclustersUpdate_598540;
          enterpriseId: string; pageId: string; clusterId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseStorelayoutclustersUpdate
  ## Updates a cluster.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   pageId: string (required)
  ##         : The ID of the page.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The ID of the cluster.
  var path_598556 = newJObject()
  var query_598557 = newJObject()
  var body_598558 = newJObject()
  add(query_598557, "fields", newJString(fields))
  add(query_598557, "quotaUser", newJString(quotaUser))
  add(query_598557, "alt", newJString(alt))
  add(query_598557, "oauth_token", newJString(oauthToken))
  add(query_598557, "userIp", newJString(userIp))
  add(query_598557, "key", newJString(key))
  add(path_598556, "enterpriseId", newJString(enterpriseId))
  add(path_598556, "pageId", newJString(pageId))
  if body != nil:
    body_598558 = body
  add(query_598557, "prettyPrint", newJBool(prettyPrint))
  add(path_598556, "clusterId", newJString(clusterId))
  result = call_598555.call(path_598556, query_598557, nil, nil, body_598558)

var androidenterpriseStorelayoutclustersUpdate* = Call_AndroidenterpriseStorelayoutclustersUpdate_598540(
    name: "androidenterpriseStorelayoutclustersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersUpdate_598541,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersUpdate_598542,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersGet_598523 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseStorelayoutclustersGet_598525(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutclustersGet_598524(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  ##   clusterId: JString (required)
  ##            : The ID of the cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598526 = path.getOrDefault("enterpriseId")
  valid_598526 = validateParameter(valid_598526, JString, required = true,
                                 default = nil)
  if valid_598526 != nil:
    section.add "enterpriseId", valid_598526
  var valid_598527 = path.getOrDefault("pageId")
  valid_598527 = validateParameter(valid_598527, JString, required = true,
                                 default = nil)
  if valid_598527 != nil:
    section.add "pageId", valid_598527
  var valid_598528 = path.getOrDefault("clusterId")
  valid_598528 = validateParameter(valid_598528, JString, required = true,
                                 default = nil)
  if valid_598528 != nil:
    section.add "clusterId", valid_598528
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598529 = query.getOrDefault("fields")
  valid_598529 = validateParameter(valid_598529, JString, required = false,
                                 default = nil)
  if valid_598529 != nil:
    section.add "fields", valid_598529
  var valid_598530 = query.getOrDefault("quotaUser")
  valid_598530 = validateParameter(valid_598530, JString, required = false,
                                 default = nil)
  if valid_598530 != nil:
    section.add "quotaUser", valid_598530
  var valid_598531 = query.getOrDefault("alt")
  valid_598531 = validateParameter(valid_598531, JString, required = false,
                                 default = newJString("json"))
  if valid_598531 != nil:
    section.add "alt", valid_598531
  var valid_598532 = query.getOrDefault("oauth_token")
  valid_598532 = validateParameter(valid_598532, JString, required = false,
                                 default = nil)
  if valid_598532 != nil:
    section.add "oauth_token", valid_598532
  var valid_598533 = query.getOrDefault("userIp")
  valid_598533 = validateParameter(valid_598533, JString, required = false,
                                 default = nil)
  if valid_598533 != nil:
    section.add "userIp", valid_598533
  var valid_598534 = query.getOrDefault("key")
  valid_598534 = validateParameter(valid_598534, JString, required = false,
                                 default = nil)
  if valid_598534 != nil:
    section.add "key", valid_598534
  var valid_598535 = query.getOrDefault("prettyPrint")
  valid_598535 = validateParameter(valid_598535, JBool, required = false,
                                 default = newJBool(true))
  if valid_598535 != nil:
    section.add "prettyPrint", valid_598535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598536: Call_AndroidenterpriseStorelayoutclustersGet_598523;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a cluster.
  ## 
  let valid = call_598536.validator(path, query, header, formData, body)
  let scheme = call_598536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598536.url(scheme.get, call_598536.host, call_598536.base,
                         call_598536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598536, url, valid)

proc call*(call_598537: Call_AndroidenterpriseStorelayoutclustersGet_598523;
          enterpriseId: string; pageId: string; clusterId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseStorelayoutclustersGet
  ## Retrieves details of a cluster.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   pageId: string (required)
  ##         : The ID of the page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The ID of the cluster.
  var path_598538 = newJObject()
  var query_598539 = newJObject()
  add(query_598539, "fields", newJString(fields))
  add(query_598539, "quotaUser", newJString(quotaUser))
  add(query_598539, "alt", newJString(alt))
  add(query_598539, "oauth_token", newJString(oauthToken))
  add(query_598539, "userIp", newJString(userIp))
  add(query_598539, "key", newJString(key))
  add(path_598538, "enterpriseId", newJString(enterpriseId))
  add(path_598538, "pageId", newJString(pageId))
  add(query_598539, "prettyPrint", newJBool(prettyPrint))
  add(path_598538, "clusterId", newJString(clusterId))
  result = call_598537.call(path_598538, query_598539, nil, nil, nil)

var androidenterpriseStorelayoutclustersGet* = Call_AndroidenterpriseStorelayoutclustersGet_598523(
    name: "androidenterpriseStorelayoutclustersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersGet_598524,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersGet_598525,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersPatch_598576 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseStorelayoutclustersPatch_598578(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutclustersPatch_598577(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a cluster. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  ##   clusterId: JString (required)
  ##            : The ID of the cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598579 = path.getOrDefault("enterpriseId")
  valid_598579 = validateParameter(valid_598579, JString, required = true,
                                 default = nil)
  if valid_598579 != nil:
    section.add "enterpriseId", valid_598579
  var valid_598580 = path.getOrDefault("pageId")
  valid_598580 = validateParameter(valid_598580, JString, required = true,
                                 default = nil)
  if valid_598580 != nil:
    section.add "pageId", valid_598580
  var valid_598581 = path.getOrDefault("clusterId")
  valid_598581 = validateParameter(valid_598581, JString, required = true,
                                 default = nil)
  if valid_598581 != nil:
    section.add "clusterId", valid_598581
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598582 = query.getOrDefault("fields")
  valid_598582 = validateParameter(valid_598582, JString, required = false,
                                 default = nil)
  if valid_598582 != nil:
    section.add "fields", valid_598582
  var valid_598583 = query.getOrDefault("quotaUser")
  valid_598583 = validateParameter(valid_598583, JString, required = false,
                                 default = nil)
  if valid_598583 != nil:
    section.add "quotaUser", valid_598583
  var valid_598584 = query.getOrDefault("alt")
  valid_598584 = validateParameter(valid_598584, JString, required = false,
                                 default = newJString("json"))
  if valid_598584 != nil:
    section.add "alt", valid_598584
  var valid_598585 = query.getOrDefault("oauth_token")
  valid_598585 = validateParameter(valid_598585, JString, required = false,
                                 default = nil)
  if valid_598585 != nil:
    section.add "oauth_token", valid_598585
  var valid_598586 = query.getOrDefault("userIp")
  valid_598586 = validateParameter(valid_598586, JString, required = false,
                                 default = nil)
  if valid_598586 != nil:
    section.add "userIp", valid_598586
  var valid_598587 = query.getOrDefault("key")
  valid_598587 = validateParameter(valid_598587, JString, required = false,
                                 default = nil)
  if valid_598587 != nil:
    section.add "key", valid_598587
  var valid_598588 = query.getOrDefault("prettyPrint")
  valid_598588 = validateParameter(valid_598588, JBool, required = false,
                                 default = newJBool(true))
  if valid_598588 != nil:
    section.add "prettyPrint", valid_598588
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

proc call*(call_598590: Call_AndroidenterpriseStorelayoutclustersPatch_598576;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster. This method supports patch semantics.
  ## 
  let valid = call_598590.validator(path, query, header, formData, body)
  let scheme = call_598590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598590.url(scheme.get, call_598590.host, call_598590.base,
                         call_598590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598590, url, valid)

proc call*(call_598591: Call_AndroidenterpriseStorelayoutclustersPatch_598576;
          enterpriseId: string; pageId: string; clusterId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseStorelayoutclustersPatch
  ## Updates a cluster. This method supports patch semantics.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   pageId: string (required)
  ##         : The ID of the page.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The ID of the cluster.
  var path_598592 = newJObject()
  var query_598593 = newJObject()
  var body_598594 = newJObject()
  add(query_598593, "fields", newJString(fields))
  add(query_598593, "quotaUser", newJString(quotaUser))
  add(query_598593, "alt", newJString(alt))
  add(query_598593, "oauth_token", newJString(oauthToken))
  add(query_598593, "userIp", newJString(userIp))
  add(query_598593, "key", newJString(key))
  add(path_598592, "enterpriseId", newJString(enterpriseId))
  add(path_598592, "pageId", newJString(pageId))
  if body != nil:
    body_598594 = body
  add(query_598593, "prettyPrint", newJBool(prettyPrint))
  add(path_598592, "clusterId", newJString(clusterId))
  result = call_598591.call(path_598592, query_598593, nil, nil, body_598594)

var androidenterpriseStorelayoutclustersPatch* = Call_AndroidenterpriseStorelayoutclustersPatch_598576(
    name: "androidenterpriseStorelayoutclustersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersPatch_598577,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersPatch_598578,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersDelete_598559 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseStorelayoutclustersDelete_598561(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "pageId" in path, "`pageId` is a required path parameter"
  assert "clusterId" in path, "`clusterId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/storeLayout/pages/"),
               (kind: VariableSegment, value: "pageId"),
               (kind: ConstantSegment, value: "/clusters/"),
               (kind: VariableSegment, value: "clusterId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseStorelayoutclustersDelete_598560(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a cluster.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   pageId: JString (required)
  ##         : The ID of the page.
  ##   clusterId: JString (required)
  ##            : The ID of the cluster.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598562 = path.getOrDefault("enterpriseId")
  valid_598562 = validateParameter(valid_598562, JString, required = true,
                                 default = nil)
  if valid_598562 != nil:
    section.add "enterpriseId", valid_598562
  var valid_598563 = path.getOrDefault("pageId")
  valid_598563 = validateParameter(valid_598563, JString, required = true,
                                 default = nil)
  if valid_598563 != nil:
    section.add "pageId", valid_598563
  var valid_598564 = path.getOrDefault("clusterId")
  valid_598564 = validateParameter(valid_598564, JString, required = true,
                                 default = nil)
  if valid_598564 != nil:
    section.add "clusterId", valid_598564
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598565 = query.getOrDefault("fields")
  valid_598565 = validateParameter(valid_598565, JString, required = false,
                                 default = nil)
  if valid_598565 != nil:
    section.add "fields", valid_598565
  var valid_598566 = query.getOrDefault("quotaUser")
  valid_598566 = validateParameter(valid_598566, JString, required = false,
                                 default = nil)
  if valid_598566 != nil:
    section.add "quotaUser", valid_598566
  var valid_598567 = query.getOrDefault("alt")
  valid_598567 = validateParameter(valid_598567, JString, required = false,
                                 default = newJString("json"))
  if valid_598567 != nil:
    section.add "alt", valid_598567
  var valid_598568 = query.getOrDefault("oauth_token")
  valid_598568 = validateParameter(valid_598568, JString, required = false,
                                 default = nil)
  if valid_598568 != nil:
    section.add "oauth_token", valid_598568
  var valid_598569 = query.getOrDefault("userIp")
  valid_598569 = validateParameter(valid_598569, JString, required = false,
                                 default = nil)
  if valid_598569 != nil:
    section.add "userIp", valid_598569
  var valid_598570 = query.getOrDefault("key")
  valid_598570 = validateParameter(valid_598570, JString, required = false,
                                 default = nil)
  if valid_598570 != nil:
    section.add "key", valid_598570
  var valid_598571 = query.getOrDefault("prettyPrint")
  valid_598571 = validateParameter(valid_598571, JBool, required = false,
                                 default = newJBool(true))
  if valid_598571 != nil:
    section.add "prettyPrint", valid_598571
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598572: Call_AndroidenterpriseStorelayoutclustersDelete_598559;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a cluster.
  ## 
  let valid = call_598572.validator(path, query, header, formData, body)
  let scheme = call_598572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598572.url(scheme.get, call_598572.host, call_598572.base,
                         call_598572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598572, url, valid)

proc call*(call_598573: Call_AndroidenterpriseStorelayoutclustersDelete_598559;
          enterpriseId: string; pageId: string; clusterId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseStorelayoutclustersDelete
  ## Deletes a cluster.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   pageId: string (required)
  ##         : The ID of the page.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   clusterId: string (required)
  ##            : The ID of the cluster.
  var path_598574 = newJObject()
  var query_598575 = newJObject()
  add(query_598575, "fields", newJString(fields))
  add(query_598575, "quotaUser", newJString(quotaUser))
  add(query_598575, "alt", newJString(alt))
  add(query_598575, "oauth_token", newJString(oauthToken))
  add(query_598575, "userIp", newJString(userIp))
  add(query_598575, "key", newJString(key))
  add(path_598574, "enterpriseId", newJString(enterpriseId))
  add(path_598574, "pageId", newJString(pageId))
  add(query_598575, "prettyPrint", newJBool(prettyPrint))
  add(path_598574, "clusterId", newJString(clusterId))
  result = call_598573.call(path_598574, query_598575, nil, nil, nil)

var androidenterpriseStorelayoutclustersDelete* = Call_AndroidenterpriseStorelayoutclustersDelete_598559(
    name: "androidenterpriseStorelayoutclustersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersDelete_598560,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersDelete_598561,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesUnenroll_598595 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEnterprisesUnenroll_598597(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/unenroll")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesUnenroll_598596(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Unenrolls an enterprise from the calling EMM.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598598 = path.getOrDefault("enterpriseId")
  valid_598598 = validateParameter(valid_598598, JString, required = true,
                                 default = nil)
  if valid_598598 != nil:
    section.add "enterpriseId", valid_598598
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598599 = query.getOrDefault("fields")
  valid_598599 = validateParameter(valid_598599, JString, required = false,
                                 default = nil)
  if valid_598599 != nil:
    section.add "fields", valid_598599
  var valid_598600 = query.getOrDefault("quotaUser")
  valid_598600 = validateParameter(valid_598600, JString, required = false,
                                 default = nil)
  if valid_598600 != nil:
    section.add "quotaUser", valid_598600
  var valid_598601 = query.getOrDefault("alt")
  valid_598601 = validateParameter(valid_598601, JString, required = false,
                                 default = newJString("json"))
  if valid_598601 != nil:
    section.add "alt", valid_598601
  var valid_598602 = query.getOrDefault("oauth_token")
  valid_598602 = validateParameter(valid_598602, JString, required = false,
                                 default = nil)
  if valid_598602 != nil:
    section.add "oauth_token", valid_598602
  var valid_598603 = query.getOrDefault("userIp")
  valid_598603 = validateParameter(valid_598603, JString, required = false,
                                 default = nil)
  if valid_598603 != nil:
    section.add "userIp", valid_598603
  var valid_598604 = query.getOrDefault("key")
  valid_598604 = validateParameter(valid_598604, JString, required = false,
                                 default = nil)
  if valid_598604 != nil:
    section.add "key", valid_598604
  var valid_598605 = query.getOrDefault("prettyPrint")
  valid_598605 = validateParameter(valid_598605, JBool, required = false,
                                 default = newJBool(true))
  if valid_598605 != nil:
    section.add "prettyPrint", valid_598605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598606: Call_AndroidenterpriseEnterprisesUnenroll_598595;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unenrolls an enterprise from the calling EMM.
  ## 
  let valid = call_598606.validator(path, query, header, formData, body)
  let scheme = call_598606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598606.url(scheme.get, call_598606.host, call_598606.base,
                         call_598606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598606, url, valid)

proc call*(call_598607: Call_AndroidenterpriseEnterprisesUnenroll_598595;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEnterprisesUnenroll
  ## Unenrolls an enterprise from the calling EMM.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598608 = newJObject()
  var query_598609 = newJObject()
  add(query_598609, "fields", newJString(fields))
  add(query_598609, "quotaUser", newJString(quotaUser))
  add(query_598609, "alt", newJString(alt))
  add(query_598609, "oauth_token", newJString(oauthToken))
  add(query_598609, "userIp", newJString(userIp))
  add(query_598609, "key", newJString(key))
  add(path_598608, "enterpriseId", newJString(enterpriseId))
  add(query_598609, "prettyPrint", newJBool(prettyPrint))
  result = call_598607.call(path_598608, query_598609, nil, nil, nil)

var androidenterpriseEnterprisesUnenroll* = Call_AndroidenterpriseEnterprisesUnenroll_598595(
    name: "androidenterpriseEnterprisesUnenroll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/unenroll",
    validator: validate_AndroidenterpriseEnterprisesUnenroll_598596,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesUnenroll_598597,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersInsert_598626 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseUsersInsert_598628(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersInsert_598627(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new EMM-managed user.
  ## 
  ## The Users resource passed in the body of the request should include an accountIdentifier and an accountType.
  ## If a corresponding user already exists with the same account identifier, the user will be updated with the resource. In this case only the displayName field can be changed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598629 = path.getOrDefault("enterpriseId")
  valid_598629 = validateParameter(valid_598629, JString, required = true,
                                 default = nil)
  if valid_598629 != nil:
    section.add "enterpriseId", valid_598629
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598630 = query.getOrDefault("fields")
  valid_598630 = validateParameter(valid_598630, JString, required = false,
                                 default = nil)
  if valid_598630 != nil:
    section.add "fields", valid_598630
  var valid_598631 = query.getOrDefault("quotaUser")
  valid_598631 = validateParameter(valid_598631, JString, required = false,
                                 default = nil)
  if valid_598631 != nil:
    section.add "quotaUser", valid_598631
  var valid_598632 = query.getOrDefault("alt")
  valid_598632 = validateParameter(valid_598632, JString, required = false,
                                 default = newJString("json"))
  if valid_598632 != nil:
    section.add "alt", valid_598632
  var valid_598633 = query.getOrDefault("oauth_token")
  valid_598633 = validateParameter(valid_598633, JString, required = false,
                                 default = nil)
  if valid_598633 != nil:
    section.add "oauth_token", valid_598633
  var valid_598634 = query.getOrDefault("userIp")
  valid_598634 = validateParameter(valid_598634, JString, required = false,
                                 default = nil)
  if valid_598634 != nil:
    section.add "userIp", valid_598634
  var valid_598635 = query.getOrDefault("key")
  valid_598635 = validateParameter(valid_598635, JString, required = false,
                                 default = nil)
  if valid_598635 != nil:
    section.add "key", valid_598635
  var valid_598636 = query.getOrDefault("prettyPrint")
  valid_598636 = validateParameter(valid_598636, JBool, required = false,
                                 default = newJBool(true))
  if valid_598636 != nil:
    section.add "prettyPrint", valid_598636
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

proc call*(call_598638: Call_AndroidenterpriseUsersInsert_598626; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new EMM-managed user.
  ## 
  ## The Users resource passed in the body of the request should include an accountIdentifier and an accountType.
  ## If a corresponding user already exists with the same account identifier, the user will be updated with the resource. In this case only the displayName field can be changed.
  ## 
  let valid = call_598638.validator(path, query, header, formData, body)
  let scheme = call_598638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598638.url(scheme.get, call_598638.host, call_598638.base,
                         call_598638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598638, url, valid)

proc call*(call_598639: Call_AndroidenterpriseUsersInsert_598626;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseUsersInsert
  ## Creates a new EMM-managed user.
  ## 
  ## The Users resource passed in the body of the request should include an accountIdentifier and an accountType.
  ## If a corresponding user already exists with the same account identifier, the user will be updated with the resource. In this case only the displayName field can be changed.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598640 = newJObject()
  var query_598641 = newJObject()
  var body_598642 = newJObject()
  add(query_598641, "fields", newJString(fields))
  add(query_598641, "quotaUser", newJString(quotaUser))
  add(query_598641, "alt", newJString(alt))
  add(query_598641, "oauth_token", newJString(oauthToken))
  add(query_598641, "userIp", newJString(userIp))
  add(query_598641, "key", newJString(key))
  add(path_598640, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598642 = body
  add(query_598641, "prettyPrint", newJBool(prettyPrint))
  result = call_598639.call(path_598640, query_598641, nil, nil, body_598642)

var androidenterpriseUsersInsert* = Call_AndroidenterpriseUsersInsert_598626(
    name: "androidenterpriseUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users",
    validator: validate_AndroidenterpriseUsersInsert_598627,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersInsert_598628,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersList_598610 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseUsersList_598612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersList_598611(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Looks up a user by primary email address. This is only supported for Google-managed users. Lookup of the id is not needed for EMM-managed users because the id is already returned in the result of the Users.insert call.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598613 = path.getOrDefault("enterpriseId")
  valid_598613 = validateParameter(valid_598613, JString, required = true,
                                 default = nil)
  if valid_598613 != nil:
    section.add "enterpriseId", valid_598613
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
  ##   email: JString (required)
  ##        : The exact primary email address of the user to look up.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598614 = query.getOrDefault("fields")
  valid_598614 = validateParameter(valid_598614, JString, required = false,
                                 default = nil)
  if valid_598614 != nil:
    section.add "fields", valid_598614
  var valid_598615 = query.getOrDefault("quotaUser")
  valid_598615 = validateParameter(valid_598615, JString, required = false,
                                 default = nil)
  if valid_598615 != nil:
    section.add "quotaUser", valid_598615
  var valid_598616 = query.getOrDefault("alt")
  valid_598616 = validateParameter(valid_598616, JString, required = false,
                                 default = newJString("json"))
  if valid_598616 != nil:
    section.add "alt", valid_598616
  var valid_598617 = query.getOrDefault("oauth_token")
  valid_598617 = validateParameter(valid_598617, JString, required = false,
                                 default = nil)
  if valid_598617 != nil:
    section.add "oauth_token", valid_598617
  var valid_598618 = query.getOrDefault("userIp")
  valid_598618 = validateParameter(valid_598618, JString, required = false,
                                 default = nil)
  if valid_598618 != nil:
    section.add "userIp", valid_598618
  assert query != nil, "query argument is necessary due to required `email` field"
  var valid_598619 = query.getOrDefault("email")
  valid_598619 = validateParameter(valid_598619, JString, required = true,
                                 default = nil)
  if valid_598619 != nil:
    section.add "email", valid_598619
  var valid_598620 = query.getOrDefault("key")
  valid_598620 = validateParameter(valid_598620, JString, required = false,
                                 default = nil)
  if valid_598620 != nil:
    section.add "key", valid_598620
  var valid_598621 = query.getOrDefault("prettyPrint")
  valid_598621 = validateParameter(valid_598621, JBool, required = false,
                                 default = newJBool(true))
  if valid_598621 != nil:
    section.add "prettyPrint", valid_598621
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598622: Call_AndroidenterpriseUsersList_598610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Looks up a user by primary email address. This is only supported for Google-managed users. Lookup of the id is not needed for EMM-managed users because the id is already returned in the result of the Users.insert call.
  ## 
  let valid = call_598622.validator(path, query, header, formData, body)
  let scheme = call_598622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598622.url(scheme.get, call_598622.host, call_598622.base,
                         call_598622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598622, url, valid)

proc call*(call_598623: Call_AndroidenterpriseUsersList_598610; email: string;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseUsersList
  ## Looks up a user by primary email address. This is only supported for Google-managed users. Lookup of the id is not needed for EMM-managed users because the id is already returned in the result of the Users.insert call.
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
  ##   email: string (required)
  ##        : The exact primary email address of the user to look up.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598624 = newJObject()
  var query_598625 = newJObject()
  add(query_598625, "fields", newJString(fields))
  add(query_598625, "quotaUser", newJString(quotaUser))
  add(query_598625, "alt", newJString(alt))
  add(query_598625, "oauth_token", newJString(oauthToken))
  add(query_598625, "userIp", newJString(userIp))
  add(query_598625, "email", newJString(email))
  add(query_598625, "key", newJString(key))
  add(path_598624, "enterpriseId", newJString(enterpriseId))
  add(query_598625, "prettyPrint", newJBool(prettyPrint))
  result = call_598623.call(path_598624, query_598625, nil, nil, nil)

var androidenterpriseUsersList* = Call_AndroidenterpriseUsersList_598610(
    name: "androidenterpriseUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users",
    validator: validate_AndroidenterpriseUsersList_598611,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersList_598612,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersUpdate_598659 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseUsersUpdate_598661(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersUpdate_598660(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598662 = path.getOrDefault("enterpriseId")
  valid_598662 = validateParameter(valid_598662, JString, required = true,
                                 default = nil)
  if valid_598662 != nil:
    section.add "enterpriseId", valid_598662
  var valid_598663 = path.getOrDefault("userId")
  valid_598663 = validateParameter(valid_598663, JString, required = true,
                                 default = nil)
  if valid_598663 != nil:
    section.add "userId", valid_598663
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598664 = query.getOrDefault("fields")
  valid_598664 = validateParameter(valid_598664, JString, required = false,
                                 default = nil)
  if valid_598664 != nil:
    section.add "fields", valid_598664
  var valid_598665 = query.getOrDefault("quotaUser")
  valid_598665 = validateParameter(valid_598665, JString, required = false,
                                 default = nil)
  if valid_598665 != nil:
    section.add "quotaUser", valid_598665
  var valid_598666 = query.getOrDefault("alt")
  valid_598666 = validateParameter(valid_598666, JString, required = false,
                                 default = newJString("json"))
  if valid_598666 != nil:
    section.add "alt", valid_598666
  var valid_598667 = query.getOrDefault("oauth_token")
  valid_598667 = validateParameter(valid_598667, JString, required = false,
                                 default = nil)
  if valid_598667 != nil:
    section.add "oauth_token", valid_598667
  var valid_598668 = query.getOrDefault("userIp")
  valid_598668 = validateParameter(valid_598668, JString, required = false,
                                 default = nil)
  if valid_598668 != nil:
    section.add "userIp", valid_598668
  var valid_598669 = query.getOrDefault("key")
  valid_598669 = validateParameter(valid_598669, JString, required = false,
                                 default = nil)
  if valid_598669 != nil:
    section.add "key", valid_598669
  var valid_598670 = query.getOrDefault("prettyPrint")
  valid_598670 = validateParameter(valid_598670, JBool, required = false,
                                 default = newJBool(true))
  if valid_598670 != nil:
    section.add "prettyPrint", valid_598670
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

proc call*(call_598672: Call_AndroidenterpriseUsersUpdate_598659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value.
  ## 
  let valid = call_598672.validator(path, query, header, formData, body)
  let scheme = call_598672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598672.url(scheme.get, call_598672.host, call_598672.base,
                         call_598672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598672, url, valid)

proc call*(call_598673: Call_AndroidenterpriseUsersUpdate_598659;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseUsersUpdate
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598674 = newJObject()
  var query_598675 = newJObject()
  var body_598676 = newJObject()
  add(query_598675, "fields", newJString(fields))
  add(query_598675, "quotaUser", newJString(quotaUser))
  add(query_598675, "alt", newJString(alt))
  add(query_598675, "oauth_token", newJString(oauthToken))
  add(query_598675, "userIp", newJString(userIp))
  add(query_598675, "key", newJString(key))
  add(path_598674, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598676 = body
  add(query_598675, "prettyPrint", newJBool(prettyPrint))
  add(path_598674, "userId", newJString(userId))
  result = call_598673.call(path_598674, query_598675, nil, nil, body_598676)

var androidenterpriseUsersUpdate* = Call_AndroidenterpriseUsersUpdate_598659(
    name: "androidenterpriseUsersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersUpdate_598660,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersUpdate_598661,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGet_598643 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseUsersGet_598645(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersGet_598644(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a user's details.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598646 = path.getOrDefault("enterpriseId")
  valid_598646 = validateParameter(valid_598646, JString, required = true,
                                 default = nil)
  if valid_598646 != nil:
    section.add "enterpriseId", valid_598646
  var valid_598647 = path.getOrDefault("userId")
  valid_598647 = validateParameter(valid_598647, JString, required = true,
                                 default = nil)
  if valid_598647 != nil:
    section.add "userId", valid_598647
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598648 = query.getOrDefault("fields")
  valid_598648 = validateParameter(valid_598648, JString, required = false,
                                 default = nil)
  if valid_598648 != nil:
    section.add "fields", valid_598648
  var valid_598649 = query.getOrDefault("quotaUser")
  valid_598649 = validateParameter(valid_598649, JString, required = false,
                                 default = nil)
  if valid_598649 != nil:
    section.add "quotaUser", valid_598649
  var valid_598650 = query.getOrDefault("alt")
  valid_598650 = validateParameter(valid_598650, JString, required = false,
                                 default = newJString("json"))
  if valid_598650 != nil:
    section.add "alt", valid_598650
  var valid_598651 = query.getOrDefault("oauth_token")
  valid_598651 = validateParameter(valid_598651, JString, required = false,
                                 default = nil)
  if valid_598651 != nil:
    section.add "oauth_token", valid_598651
  var valid_598652 = query.getOrDefault("userIp")
  valid_598652 = validateParameter(valid_598652, JString, required = false,
                                 default = nil)
  if valid_598652 != nil:
    section.add "userIp", valid_598652
  var valid_598653 = query.getOrDefault("key")
  valid_598653 = validateParameter(valid_598653, JString, required = false,
                                 default = nil)
  if valid_598653 != nil:
    section.add "key", valid_598653
  var valid_598654 = query.getOrDefault("prettyPrint")
  valid_598654 = validateParameter(valid_598654, JBool, required = false,
                                 default = newJBool(true))
  if valid_598654 != nil:
    section.add "prettyPrint", valid_598654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598655: Call_AndroidenterpriseUsersGet_598643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a user's details.
  ## 
  let valid = call_598655.validator(path, query, header, formData, body)
  let scheme = call_598655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598655.url(scheme.get, call_598655.host, call_598655.base,
                         call_598655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598655, url, valid)

proc call*(call_598656: Call_AndroidenterpriseUsersGet_598643;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseUsersGet
  ## Retrieves a user's details.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598657 = newJObject()
  var query_598658 = newJObject()
  add(query_598658, "fields", newJString(fields))
  add(query_598658, "quotaUser", newJString(quotaUser))
  add(query_598658, "alt", newJString(alt))
  add(query_598658, "oauth_token", newJString(oauthToken))
  add(query_598658, "userIp", newJString(userIp))
  add(query_598658, "key", newJString(key))
  add(path_598657, "enterpriseId", newJString(enterpriseId))
  add(query_598658, "prettyPrint", newJBool(prettyPrint))
  add(path_598657, "userId", newJString(userId))
  result = call_598656.call(path_598657, query_598658, nil, nil, nil)

var androidenterpriseUsersGet* = Call_AndroidenterpriseUsersGet_598643(
    name: "androidenterpriseUsersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersGet_598644,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersGet_598645,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersPatch_598693 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseUsersPatch_598695(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersPatch_598694(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598696 = path.getOrDefault("enterpriseId")
  valid_598696 = validateParameter(valid_598696, JString, required = true,
                                 default = nil)
  if valid_598696 != nil:
    section.add "enterpriseId", valid_598696
  var valid_598697 = path.getOrDefault("userId")
  valid_598697 = validateParameter(valid_598697, JString, required = true,
                                 default = nil)
  if valid_598697 != nil:
    section.add "userId", valid_598697
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598698 = query.getOrDefault("fields")
  valid_598698 = validateParameter(valid_598698, JString, required = false,
                                 default = nil)
  if valid_598698 != nil:
    section.add "fields", valid_598698
  var valid_598699 = query.getOrDefault("quotaUser")
  valid_598699 = validateParameter(valid_598699, JString, required = false,
                                 default = nil)
  if valid_598699 != nil:
    section.add "quotaUser", valid_598699
  var valid_598700 = query.getOrDefault("alt")
  valid_598700 = validateParameter(valid_598700, JString, required = false,
                                 default = newJString("json"))
  if valid_598700 != nil:
    section.add "alt", valid_598700
  var valid_598701 = query.getOrDefault("oauth_token")
  valid_598701 = validateParameter(valid_598701, JString, required = false,
                                 default = nil)
  if valid_598701 != nil:
    section.add "oauth_token", valid_598701
  var valid_598702 = query.getOrDefault("userIp")
  valid_598702 = validateParameter(valid_598702, JString, required = false,
                                 default = nil)
  if valid_598702 != nil:
    section.add "userIp", valid_598702
  var valid_598703 = query.getOrDefault("key")
  valid_598703 = validateParameter(valid_598703, JString, required = false,
                                 default = nil)
  if valid_598703 != nil:
    section.add "key", valid_598703
  var valid_598704 = query.getOrDefault("prettyPrint")
  valid_598704 = validateParameter(valid_598704, JBool, required = false,
                                 default = newJBool(true))
  if valid_598704 != nil:
    section.add "prettyPrint", valid_598704
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

proc call*(call_598706: Call_AndroidenterpriseUsersPatch_598693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value. This method supports patch semantics.
  ## 
  let valid = call_598706.validator(path, query, header, formData, body)
  let scheme = call_598706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598706.url(scheme.get, call_598706.host, call_598706.base,
                         call_598706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598706, url, valid)

proc call*(call_598707: Call_AndroidenterpriseUsersPatch_598693;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseUsersPatch
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value. This method supports patch semantics.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598708 = newJObject()
  var query_598709 = newJObject()
  var body_598710 = newJObject()
  add(query_598709, "fields", newJString(fields))
  add(query_598709, "quotaUser", newJString(quotaUser))
  add(query_598709, "alt", newJString(alt))
  add(query_598709, "oauth_token", newJString(oauthToken))
  add(query_598709, "userIp", newJString(userIp))
  add(query_598709, "key", newJString(key))
  add(path_598708, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598710 = body
  add(query_598709, "prettyPrint", newJBool(prettyPrint))
  add(path_598708, "userId", newJString(userId))
  result = call_598707.call(path_598708, query_598709, nil, nil, body_598710)

var androidenterpriseUsersPatch* = Call_AndroidenterpriseUsersPatch_598693(
    name: "androidenterpriseUsersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersPatch_598694,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersPatch_598695,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersDelete_598677 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseUsersDelete_598679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersDelete_598678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deleted an EMM-managed user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598680 = path.getOrDefault("enterpriseId")
  valid_598680 = validateParameter(valid_598680, JString, required = true,
                                 default = nil)
  if valid_598680 != nil:
    section.add "enterpriseId", valid_598680
  var valid_598681 = path.getOrDefault("userId")
  valid_598681 = validateParameter(valid_598681, JString, required = true,
                                 default = nil)
  if valid_598681 != nil:
    section.add "userId", valid_598681
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598682 = query.getOrDefault("fields")
  valid_598682 = validateParameter(valid_598682, JString, required = false,
                                 default = nil)
  if valid_598682 != nil:
    section.add "fields", valid_598682
  var valid_598683 = query.getOrDefault("quotaUser")
  valid_598683 = validateParameter(valid_598683, JString, required = false,
                                 default = nil)
  if valid_598683 != nil:
    section.add "quotaUser", valid_598683
  var valid_598684 = query.getOrDefault("alt")
  valid_598684 = validateParameter(valid_598684, JString, required = false,
                                 default = newJString("json"))
  if valid_598684 != nil:
    section.add "alt", valid_598684
  var valid_598685 = query.getOrDefault("oauth_token")
  valid_598685 = validateParameter(valid_598685, JString, required = false,
                                 default = nil)
  if valid_598685 != nil:
    section.add "oauth_token", valid_598685
  var valid_598686 = query.getOrDefault("userIp")
  valid_598686 = validateParameter(valid_598686, JString, required = false,
                                 default = nil)
  if valid_598686 != nil:
    section.add "userIp", valid_598686
  var valid_598687 = query.getOrDefault("key")
  valid_598687 = validateParameter(valid_598687, JString, required = false,
                                 default = nil)
  if valid_598687 != nil:
    section.add "key", valid_598687
  var valid_598688 = query.getOrDefault("prettyPrint")
  valid_598688 = validateParameter(valid_598688, JBool, required = false,
                                 default = newJBool(true))
  if valid_598688 != nil:
    section.add "prettyPrint", valid_598688
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598689: Call_AndroidenterpriseUsersDelete_598677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deleted an EMM-managed user.
  ## 
  let valid = call_598689.validator(path, query, header, formData, body)
  let scheme = call_598689.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598689.url(scheme.get, call_598689.host, call_598689.base,
                         call_598689.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598689, url, valid)

proc call*(call_598690: Call_AndroidenterpriseUsersDelete_598677;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseUsersDelete
  ## Deleted an EMM-managed user.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598691 = newJObject()
  var query_598692 = newJObject()
  add(query_598692, "fields", newJString(fields))
  add(query_598692, "quotaUser", newJString(quotaUser))
  add(query_598692, "alt", newJString(alt))
  add(query_598692, "oauth_token", newJString(oauthToken))
  add(query_598692, "userIp", newJString(userIp))
  add(query_598692, "key", newJString(key))
  add(path_598691, "enterpriseId", newJString(enterpriseId))
  add(query_598692, "prettyPrint", newJBool(prettyPrint))
  add(path_598691, "userId", newJString(userId))
  result = call_598690.call(path_598691, query_598692, nil, nil, nil)

var androidenterpriseUsersDelete* = Call_AndroidenterpriseUsersDelete_598677(
    name: "androidenterpriseUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersDelete_598678,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersDelete_598679,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGenerateAuthenticationToken_598711 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseUsersGenerateAuthenticationToken_598713(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/authenticationToken")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersGenerateAuthenticationToken_598712(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Generates an authentication token which the device policy client can use to provision the given EMM-managed user account on a device. The generated token is single-use and expires after a few minutes.
  ## 
  ## You can provision a maximum of 10 devices per user.
  ## 
  ## This call only works with EMM-managed accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598714 = path.getOrDefault("enterpriseId")
  valid_598714 = validateParameter(valid_598714, JString, required = true,
                                 default = nil)
  if valid_598714 != nil:
    section.add "enterpriseId", valid_598714
  var valid_598715 = path.getOrDefault("userId")
  valid_598715 = validateParameter(valid_598715, JString, required = true,
                                 default = nil)
  if valid_598715 != nil:
    section.add "userId", valid_598715
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598716 = query.getOrDefault("fields")
  valid_598716 = validateParameter(valid_598716, JString, required = false,
                                 default = nil)
  if valid_598716 != nil:
    section.add "fields", valid_598716
  var valid_598717 = query.getOrDefault("quotaUser")
  valid_598717 = validateParameter(valid_598717, JString, required = false,
                                 default = nil)
  if valid_598717 != nil:
    section.add "quotaUser", valid_598717
  var valid_598718 = query.getOrDefault("alt")
  valid_598718 = validateParameter(valid_598718, JString, required = false,
                                 default = newJString("json"))
  if valid_598718 != nil:
    section.add "alt", valid_598718
  var valid_598719 = query.getOrDefault("oauth_token")
  valid_598719 = validateParameter(valid_598719, JString, required = false,
                                 default = nil)
  if valid_598719 != nil:
    section.add "oauth_token", valid_598719
  var valid_598720 = query.getOrDefault("userIp")
  valid_598720 = validateParameter(valid_598720, JString, required = false,
                                 default = nil)
  if valid_598720 != nil:
    section.add "userIp", valid_598720
  var valid_598721 = query.getOrDefault("key")
  valid_598721 = validateParameter(valid_598721, JString, required = false,
                                 default = nil)
  if valid_598721 != nil:
    section.add "key", valid_598721
  var valid_598722 = query.getOrDefault("prettyPrint")
  valid_598722 = validateParameter(valid_598722, JBool, required = false,
                                 default = newJBool(true))
  if valid_598722 != nil:
    section.add "prettyPrint", valid_598722
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598723: Call_AndroidenterpriseUsersGenerateAuthenticationToken_598711;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates an authentication token which the device policy client can use to provision the given EMM-managed user account on a device. The generated token is single-use and expires after a few minutes.
  ## 
  ## You can provision a maximum of 10 devices per user.
  ## 
  ## This call only works with EMM-managed accounts.
  ## 
  let valid = call_598723.validator(path, query, header, formData, body)
  let scheme = call_598723.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598723.url(scheme.get, call_598723.host, call_598723.base,
                         call_598723.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598723, url, valid)

proc call*(call_598724: Call_AndroidenterpriseUsersGenerateAuthenticationToken_598711;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseUsersGenerateAuthenticationToken
  ## Generates an authentication token which the device policy client can use to provision the given EMM-managed user account on a device. The generated token is single-use and expires after a few minutes.
  ## 
  ## You can provision a maximum of 10 devices per user.
  ## 
  ## This call only works with EMM-managed accounts.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598725 = newJObject()
  var query_598726 = newJObject()
  add(query_598726, "fields", newJString(fields))
  add(query_598726, "quotaUser", newJString(quotaUser))
  add(query_598726, "alt", newJString(alt))
  add(query_598726, "oauth_token", newJString(oauthToken))
  add(query_598726, "userIp", newJString(userIp))
  add(query_598726, "key", newJString(key))
  add(path_598725, "enterpriseId", newJString(enterpriseId))
  add(query_598726, "prettyPrint", newJBool(prettyPrint))
  add(path_598725, "userId", newJString(userId))
  result = call_598724.call(path_598725, query_598726, nil, nil, nil)

var androidenterpriseUsersGenerateAuthenticationToken* = Call_AndroidenterpriseUsersGenerateAuthenticationToken_598711(
    name: "androidenterpriseUsersGenerateAuthenticationToken",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/authenticationToken",
    validator: validate_AndroidenterpriseUsersGenerateAuthenticationToken_598712,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersGenerateAuthenticationToken_598713,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersSetAvailableProductSet_598743 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseUsersSetAvailableProductSet_598745(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/availableProductSet")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersSetAvailableProductSet_598744(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Modifies the set of products that a user is entitled to access (referred to as whitelisted products). Only products that are approved or products that were previously approved (products with revoked approval) can be whitelisted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598746 = path.getOrDefault("enterpriseId")
  valid_598746 = validateParameter(valid_598746, JString, required = true,
                                 default = nil)
  if valid_598746 != nil:
    section.add "enterpriseId", valid_598746
  var valid_598747 = path.getOrDefault("userId")
  valid_598747 = validateParameter(valid_598747, JString, required = true,
                                 default = nil)
  if valid_598747 != nil:
    section.add "userId", valid_598747
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598748 = query.getOrDefault("fields")
  valid_598748 = validateParameter(valid_598748, JString, required = false,
                                 default = nil)
  if valid_598748 != nil:
    section.add "fields", valid_598748
  var valid_598749 = query.getOrDefault("quotaUser")
  valid_598749 = validateParameter(valid_598749, JString, required = false,
                                 default = nil)
  if valid_598749 != nil:
    section.add "quotaUser", valid_598749
  var valid_598750 = query.getOrDefault("alt")
  valid_598750 = validateParameter(valid_598750, JString, required = false,
                                 default = newJString("json"))
  if valid_598750 != nil:
    section.add "alt", valid_598750
  var valid_598751 = query.getOrDefault("oauth_token")
  valid_598751 = validateParameter(valid_598751, JString, required = false,
                                 default = nil)
  if valid_598751 != nil:
    section.add "oauth_token", valid_598751
  var valid_598752 = query.getOrDefault("userIp")
  valid_598752 = validateParameter(valid_598752, JString, required = false,
                                 default = nil)
  if valid_598752 != nil:
    section.add "userIp", valid_598752
  var valid_598753 = query.getOrDefault("key")
  valid_598753 = validateParameter(valid_598753, JString, required = false,
                                 default = nil)
  if valid_598753 != nil:
    section.add "key", valid_598753
  var valid_598754 = query.getOrDefault("prettyPrint")
  valid_598754 = validateParameter(valid_598754, JBool, required = false,
                                 default = newJBool(true))
  if valid_598754 != nil:
    section.add "prettyPrint", valid_598754
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

proc call*(call_598756: Call_AndroidenterpriseUsersSetAvailableProductSet_598743;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the set of products that a user is entitled to access (referred to as whitelisted products). Only products that are approved or products that were previously approved (products with revoked approval) can be whitelisted.
  ## 
  let valid = call_598756.validator(path, query, header, formData, body)
  let scheme = call_598756.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598756.url(scheme.get, call_598756.host, call_598756.base,
                         call_598756.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598756, url, valid)

proc call*(call_598757: Call_AndroidenterpriseUsersSetAvailableProductSet_598743;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseUsersSetAvailableProductSet
  ## Modifies the set of products that a user is entitled to access (referred to as whitelisted products). Only products that are approved or products that were previously approved (products with revoked approval) can be whitelisted.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598758 = newJObject()
  var query_598759 = newJObject()
  var body_598760 = newJObject()
  add(query_598759, "fields", newJString(fields))
  add(query_598759, "quotaUser", newJString(quotaUser))
  add(query_598759, "alt", newJString(alt))
  add(query_598759, "oauth_token", newJString(oauthToken))
  add(query_598759, "userIp", newJString(userIp))
  add(query_598759, "key", newJString(key))
  add(path_598758, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598760 = body
  add(query_598759, "prettyPrint", newJBool(prettyPrint))
  add(path_598758, "userId", newJString(userId))
  result = call_598757.call(path_598758, query_598759, nil, nil, body_598760)

var androidenterpriseUsersSetAvailableProductSet* = Call_AndroidenterpriseUsersSetAvailableProductSet_598743(
    name: "androidenterpriseUsersSetAvailableProductSet",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/availableProductSet",
    validator: validate_AndroidenterpriseUsersSetAvailableProductSet_598744,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersSetAvailableProductSet_598745,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGetAvailableProductSet_598727 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseUsersGetAvailableProductSet_598729(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/availableProductSet")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersGetAvailableProductSet_598728(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the set of products a user is entitled to access.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598730 = path.getOrDefault("enterpriseId")
  valid_598730 = validateParameter(valid_598730, JString, required = true,
                                 default = nil)
  if valid_598730 != nil:
    section.add "enterpriseId", valid_598730
  var valid_598731 = path.getOrDefault("userId")
  valid_598731 = validateParameter(valid_598731, JString, required = true,
                                 default = nil)
  if valid_598731 != nil:
    section.add "userId", valid_598731
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598732 = query.getOrDefault("fields")
  valid_598732 = validateParameter(valid_598732, JString, required = false,
                                 default = nil)
  if valid_598732 != nil:
    section.add "fields", valid_598732
  var valid_598733 = query.getOrDefault("quotaUser")
  valid_598733 = validateParameter(valid_598733, JString, required = false,
                                 default = nil)
  if valid_598733 != nil:
    section.add "quotaUser", valid_598733
  var valid_598734 = query.getOrDefault("alt")
  valid_598734 = validateParameter(valid_598734, JString, required = false,
                                 default = newJString("json"))
  if valid_598734 != nil:
    section.add "alt", valid_598734
  var valid_598735 = query.getOrDefault("oauth_token")
  valid_598735 = validateParameter(valid_598735, JString, required = false,
                                 default = nil)
  if valid_598735 != nil:
    section.add "oauth_token", valid_598735
  var valid_598736 = query.getOrDefault("userIp")
  valid_598736 = validateParameter(valid_598736, JString, required = false,
                                 default = nil)
  if valid_598736 != nil:
    section.add "userIp", valid_598736
  var valid_598737 = query.getOrDefault("key")
  valid_598737 = validateParameter(valid_598737, JString, required = false,
                                 default = nil)
  if valid_598737 != nil:
    section.add "key", valid_598737
  var valid_598738 = query.getOrDefault("prettyPrint")
  valid_598738 = validateParameter(valid_598738, JBool, required = false,
                                 default = newJBool(true))
  if valid_598738 != nil:
    section.add "prettyPrint", valid_598738
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598739: Call_AndroidenterpriseUsersGetAvailableProductSet_598727;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the set of products a user is entitled to access.
  ## 
  let valid = call_598739.validator(path, query, header, formData, body)
  let scheme = call_598739.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598739.url(scheme.get, call_598739.host, call_598739.base,
                         call_598739.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598739, url, valid)

proc call*(call_598740: Call_AndroidenterpriseUsersGetAvailableProductSet_598727;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseUsersGetAvailableProductSet
  ## Retrieves the set of products a user is entitled to access.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598741 = newJObject()
  var query_598742 = newJObject()
  add(query_598742, "fields", newJString(fields))
  add(query_598742, "quotaUser", newJString(quotaUser))
  add(query_598742, "alt", newJString(alt))
  add(query_598742, "oauth_token", newJString(oauthToken))
  add(query_598742, "userIp", newJString(userIp))
  add(query_598742, "key", newJString(key))
  add(path_598741, "enterpriseId", newJString(enterpriseId))
  add(query_598742, "prettyPrint", newJBool(prettyPrint))
  add(path_598741, "userId", newJString(userId))
  result = call_598740.call(path_598741, query_598742, nil, nil, nil)

var androidenterpriseUsersGetAvailableProductSet* = Call_AndroidenterpriseUsersGetAvailableProductSet_598727(
    name: "androidenterpriseUsersGetAvailableProductSet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/availableProductSet",
    validator: validate_AndroidenterpriseUsersGetAvailableProductSet_598728,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersGetAvailableProductSet_598729,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersRevokeDeviceAccess_598761 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseUsersRevokeDeviceAccess_598763(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/deviceAccess")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersRevokeDeviceAccess_598762(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revokes access to all devices currently provisioned to the user. The user will no longer be able to use the managed Play store on any of their managed devices.
  ## 
  ## This call only works with EMM-managed accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598764 = path.getOrDefault("enterpriseId")
  valid_598764 = validateParameter(valid_598764, JString, required = true,
                                 default = nil)
  if valid_598764 != nil:
    section.add "enterpriseId", valid_598764
  var valid_598765 = path.getOrDefault("userId")
  valid_598765 = validateParameter(valid_598765, JString, required = true,
                                 default = nil)
  if valid_598765 != nil:
    section.add "userId", valid_598765
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598766 = query.getOrDefault("fields")
  valid_598766 = validateParameter(valid_598766, JString, required = false,
                                 default = nil)
  if valid_598766 != nil:
    section.add "fields", valid_598766
  var valid_598767 = query.getOrDefault("quotaUser")
  valid_598767 = validateParameter(valid_598767, JString, required = false,
                                 default = nil)
  if valid_598767 != nil:
    section.add "quotaUser", valid_598767
  var valid_598768 = query.getOrDefault("alt")
  valid_598768 = validateParameter(valid_598768, JString, required = false,
                                 default = newJString("json"))
  if valid_598768 != nil:
    section.add "alt", valid_598768
  var valid_598769 = query.getOrDefault("oauth_token")
  valid_598769 = validateParameter(valid_598769, JString, required = false,
                                 default = nil)
  if valid_598769 != nil:
    section.add "oauth_token", valid_598769
  var valid_598770 = query.getOrDefault("userIp")
  valid_598770 = validateParameter(valid_598770, JString, required = false,
                                 default = nil)
  if valid_598770 != nil:
    section.add "userIp", valid_598770
  var valid_598771 = query.getOrDefault("key")
  valid_598771 = validateParameter(valid_598771, JString, required = false,
                                 default = nil)
  if valid_598771 != nil:
    section.add "key", valid_598771
  var valid_598772 = query.getOrDefault("prettyPrint")
  valid_598772 = validateParameter(valid_598772, JBool, required = false,
                                 default = newJBool(true))
  if valid_598772 != nil:
    section.add "prettyPrint", valid_598772
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598773: Call_AndroidenterpriseUsersRevokeDeviceAccess_598761;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes access to all devices currently provisioned to the user. The user will no longer be able to use the managed Play store on any of their managed devices.
  ## 
  ## This call only works with EMM-managed accounts.
  ## 
  let valid = call_598773.validator(path, query, header, formData, body)
  let scheme = call_598773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598773.url(scheme.get, call_598773.host, call_598773.base,
                         call_598773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598773, url, valid)

proc call*(call_598774: Call_AndroidenterpriseUsersRevokeDeviceAccess_598761;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseUsersRevokeDeviceAccess
  ## Revokes access to all devices currently provisioned to the user. The user will no longer be able to use the managed Play store on any of their managed devices.
  ## 
  ## This call only works with EMM-managed accounts.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598775 = newJObject()
  var query_598776 = newJObject()
  add(query_598776, "fields", newJString(fields))
  add(query_598776, "quotaUser", newJString(quotaUser))
  add(query_598776, "alt", newJString(alt))
  add(query_598776, "oauth_token", newJString(oauthToken))
  add(query_598776, "userIp", newJString(userIp))
  add(query_598776, "key", newJString(key))
  add(path_598775, "enterpriseId", newJString(enterpriseId))
  add(query_598776, "prettyPrint", newJBool(prettyPrint))
  add(path_598775, "userId", newJString(userId))
  result = call_598774.call(path_598775, query_598776, nil, nil, nil)

var androidenterpriseUsersRevokeDeviceAccess* = Call_AndroidenterpriseUsersRevokeDeviceAccess_598761(
    name: "androidenterpriseUsersRevokeDeviceAccess", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/deviceAccess",
    validator: validate_AndroidenterpriseUsersRevokeDeviceAccess_598762,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersRevokeDeviceAccess_598763,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesList_598777 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseDevicesList_598779(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesList_598778(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the IDs of all of a user's devices.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_598780 = path.getOrDefault("enterpriseId")
  valid_598780 = validateParameter(valid_598780, JString, required = true,
                                 default = nil)
  if valid_598780 != nil:
    section.add "enterpriseId", valid_598780
  var valid_598781 = path.getOrDefault("userId")
  valid_598781 = validateParameter(valid_598781, JString, required = true,
                                 default = nil)
  if valid_598781 != nil:
    section.add "userId", valid_598781
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598782 = query.getOrDefault("fields")
  valid_598782 = validateParameter(valid_598782, JString, required = false,
                                 default = nil)
  if valid_598782 != nil:
    section.add "fields", valid_598782
  var valid_598783 = query.getOrDefault("quotaUser")
  valid_598783 = validateParameter(valid_598783, JString, required = false,
                                 default = nil)
  if valid_598783 != nil:
    section.add "quotaUser", valid_598783
  var valid_598784 = query.getOrDefault("alt")
  valid_598784 = validateParameter(valid_598784, JString, required = false,
                                 default = newJString("json"))
  if valid_598784 != nil:
    section.add "alt", valid_598784
  var valid_598785 = query.getOrDefault("oauth_token")
  valid_598785 = validateParameter(valid_598785, JString, required = false,
                                 default = nil)
  if valid_598785 != nil:
    section.add "oauth_token", valid_598785
  var valid_598786 = query.getOrDefault("userIp")
  valid_598786 = validateParameter(valid_598786, JString, required = false,
                                 default = nil)
  if valid_598786 != nil:
    section.add "userIp", valid_598786
  var valid_598787 = query.getOrDefault("key")
  valid_598787 = validateParameter(valid_598787, JString, required = false,
                                 default = nil)
  if valid_598787 != nil:
    section.add "key", valid_598787
  var valid_598788 = query.getOrDefault("prettyPrint")
  valid_598788 = validateParameter(valid_598788, JBool, required = false,
                                 default = newJBool(true))
  if valid_598788 != nil:
    section.add "prettyPrint", valid_598788
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598789: Call_AndroidenterpriseDevicesList_598777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the IDs of all of a user's devices.
  ## 
  let valid = call_598789.validator(path, query, header, formData, body)
  let scheme = call_598789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598789.url(scheme.get, call_598789.host, call_598789.base,
                         call_598789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598789, url, valid)

proc call*(call_598790: Call_AndroidenterpriseDevicesList_598777;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseDevicesList
  ## Retrieves the IDs of all of a user's devices.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598791 = newJObject()
  var query_598792 = newJObject()
  add(query_598792, "fields", newJString(fields))
  add(query_598792, "quotaUser", newJString(quotaUser))
  add(query_598792, "alt", newJString(alt))
  add(query_598792, "oauth_token", newJString(oauthToken))
  add(query_598792, "userIp", newJString(userIp))
  add(query_598792, "key", newJString(key))
  add(path_598791, "enterpriseId", newJString(enterpriseId))
  add(query_598792, "prettyPrint", newJBool(prettyPrint))
  add(path_598791, "userId", newJString(userId))
  result = call_598790.call(path_598791, query_598792, nil, nil, nil)

var androidenterpriseDevicesList* = Call_AndroidenterpriseDevicesList_598777(
    name: "androidenterpriseDevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices",
    validator: validate_AndroidenterpriseDevicesList_598778,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesList_598779,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesUpdate_598810 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseDevicesUpdate_598812(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesUpdate_598811(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the device policy
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceId: JString (required)
  ##           : The ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceId` field"
  var valid_598813 = path.getOrDefault("deviceId")
  valid_598813 = validateParameter(valid_598813, JString, required = true,
                                 default = nil)
  if valid_598813 != nil:
    section.add "deviceId", valid_598813
  var valid_598814 = path.getOrDefault("enterpriseId")
  valid_598814 = validateParameter(valid_598814, JString, required = true,
                                 default = nil)
  if valid_598814 != nil:
    section.add "enterpriseId", valid_598814
  var valid_598815 = path.getOrDefault("userId")
  valid_598815 = validateParameter(valid_598815, JString, required = true,
                                 default = nil)
  if valid_598815 != nil:
    section.add "userId", valid_598815
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Mask that identifies which fields to update. If not set, all modifiable fields will be modified.
  ## 
  ## When set in a query parameter, this field should be specified as updateMask=<field1>,<field2>,...
  section = newJObject()
  var valid_598816 = query.getOrDefault("fields")
  valid_598816 = validateParameter(valid_598816, JString, required = false,
                                 default = nil)
  if valid_598816 != nil:
    section.add "fields", valid_598816
  var valid_598817 = query.getOrDefault("quotaUser")
  valid_598817 = validateParameter(valid_598817, JString, required = false,
                                 default = nil)
  if valid_598817 != nil:
    section.add "quotaUser", valid_598817
  var valid_598818 = query.getOrDefault("alt")
  valid_598818 = validateParameter(valid_598818, JString, required = false,
                                 default = newJString("json"))
  if valid_598818 != nil:
    section.add "alt", valid_598818
  var valid_598819 = query.getOrDefault("oauth_token")
  valid_598819 = validateParameter(valid_598819, JString, required = false,
                                 default = nil)
  if valid_598819 != nil:
    section.add "oauth_token", valid_598819
  var valid_598820 = query.getOrDefault("userIp")
  valid_598820 = validateParameter(valid_598820, JString, required = false,
                                 default = nil)
  if valid_598820 != nil:
    section.add "userIp", valid_598820
  var valid_598821 = query.getOrDefault("key")
  valid_598821 = validateParameter(valid_598821, JString, required = false,
                                 default = nil)
  if valid_598821 != nil:
    section.add "key", valid_598821
  var valid_598822 = query.getOrDefault("prettyPrint")
  valid_598822 = validateParameter(valid_598822, JBool, required = false,
                                 default = newJBool(true))
  if valid_598822 != nil:
    section.add "prettyPrint", valid_598822
  var valid_598823 = query.getOrDefault("updateMask")
  valid_598823 = validateParameter(valid_598823, JString, required = false,
                                 default = nil)
  if valid_598823 != nil:
    section.add "updateMask", valid_598823
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

proc call*(call_598825: Call_AndroidenterpriseDevicesUpdate_598810; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the device policy
  ## 
  let valid = call_598825.validator(path, query, header, formData, body)
  let scheme = call_598825.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598825.url(scheme.get, call_598825.host, call_598825.base,
                         call_598825.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598825, url, valid)

proc call*(call_598826: Call_AndroidenterpriseDevicesUpdate_598810;
          deviceId: string; enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## androidenterpriseDevicesUpdate
  ## Updates the device policy
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Mask that identifies which fields to update. If not set, all modifiable fields will be modified.
  ## 
  ## When set in a query parameter, this field should be specified as updateMask=<field1>,<field2>,...
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598827 = newJObject()
  var query_598828 = newJObject()
  var body_598829 = newJObject()
  add(query_598828, "fields", newJString(fields))
  add(query_598828, "quotaUser", newJString(quotaUser))
  add(query_598828, "alt", newJString(alt))
  add(path_598827, "deviceId", newJString(deviceId))
  add(query_598828, "oauth_token", newJString(oauthToken))
  add(query_598828, "userIp", newJString(userIp))
  add(query_598828, "key", newJString(key))
  add(path_598827, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598829 = body
  add(query_598828, "prettyPrint", newJBool(prettyPrint))
  add(query_598828, "updateMask", newJString(updateMask))
  add(path_598827, "userId", newJString(userId))
  result = call_598826.call(path_598827, query_598828, nil, nil, body_598829)

var androidenterpriseDevicesUpdate* = Call_AndroidenterpriseDevicesUpdate_598810(
    name: "androidenterpriseDevicesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}",
    validator: validate_AndroidenterpriseDevicesUpdate_598811,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesUpdate_598812,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesGet_598793 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseDevicesGet_598795(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesGet_598794(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceId: JString (required)
  ##           : The ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceId` field"
  var valid_598796 = path.getOrDefault("deviceId")
  valid_598796 = validateParameter(valid_598796, JString, required = true,
                                 default = nil)
  if valid_598796 != nil:
    section.add "deviceId", valid_598796
  var valid_598797 = path.getOrDefault("enterpriseId")
  valid_598797 = validateParameter(valid_598797, JString, required = true,
                                 default = nil)
  if valid_598797 != nil:
    section.add "enterpriseId", valid_598797
  var valid_598798 = path.getOrDefault("userId")
  valid_598798 = validateParameter(valid_598798, JString, required = true,
                                 default = nil)
  if valid_598798 != nil:
    section.add "userId", valid_598798
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598799 = query.getOrDefault("fields")
  valid_598799 = validateParameter(valid_598799, JString, required = false,
                                 default = nil)
  if valid_598799 != nil:
    section.add "fields", valid_598799
  var valid_598800 = query.getOrDefault("quotaUser")
  valid_598800 = validateParameter(valid_598800, JString, required = false,
                                 default = nil)
  if valid_598800 != nil:
    section.add "quotaUser", valid_598800
  var valid_598801 = query.getOrDefault("alt")
  valid_598801 = validateParameter(valid_598801, JString, required = false,
                                 default = newJString("json"))
  if valid_598801 != nil:
    section.add "alt", valid_598801
  var valid_598802 = query.getOrDefault("oauth_token")
  valid_598802 = validateParameter(valid_598802, JString, required = false,
                                 default = nil)
  if valid_598802 != nil:
    section.add "oauth_token", valid_598802
  var valid_598803 = query.getOrDefault("userIp")
  valid_598803 = validateParameter(valid_598803, JString, required = false,
                                 default = nil)
  if valid_598803 != nil:
    section.add "userIp", valid_598803
  var valid_598804 = query.getOrDefault("key")
  valid_598804 = validateParameter(valid_598804, JString, required = false,
                                 default = nil)
  if valid_598804 != nil:
    section.add "key", valid_598804
  var valid_598805 = query.getOrDefault("prettyPrint")
  valid_598805 = validateParameter(valid_598805, JBool, required = false,
                                 default = newJBool(true))
  if valid_598805 != nil:
    section.add "prettyPrint", valid_598805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598806: Call_AndroidenterpriseDevicesGet_598793; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a device.
  ## 
  let valid = call_598806.validator(path, query, header, formData, body)
  let scheme = call_598806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598806.url(scheme.get, call_598806.host, call_598806.base,
                         call_598806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598806, url, valid)

proc call*(call_598807: Call_AndroidenterpriseDevicesGet_598793; deviceId: string;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseDevicesGet
  ## Retrieves the details of a device.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598808 = newJObject()
  var query_598809 = newJObject()
  add(query_598809, "fields", newJString(fields))
  add(query_598809, "quotaUser", newJString(quotaUser))
  add(query_598809, "alt", newJString(alt))
  add(path_598808, "deviceId", newJString(deviceId))
  add(query_598809, "oauth_token", newJString(oauthToken))
  add(query_598809, "userIp", newJString(userIp))
  add(query_598809, "key", newJString(key))
  add(path_598808, "enterpriseId", newJString(enterpriseId))
  add(query_598809, "prettyPrint", newJBool(prettyPrint))
  add(path_598808, "userId", newJString(userId))
  result = call_598807.call(path_598808, query_598809, nil, nil, nil)

var androidenterpriseDevicesGet* = Call_AndroidenterpriseDevicesGet_598793(
    name: "androidenterpriseDevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}",
    validator: validate_AndroidenterpriseDevicesGet_598794,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesGet_598795,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesPatch_598830 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseDevicesPatch_598832(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesPatch_598831(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the device policy. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceId: JString (required)
  ##           : The ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceId` field"
  var valid_598833 = path.getOrDefault("deviceId")
  valid_598833 = validateParameter(valid_598833, JString, required = true,
                                 default = nil)
  if valid_598833 != nil:
    section.add "deviceId", valid_598833
  var valid_598834 = path.getOrDefault("enterpriseId")
  valid_598834 = validateParameter(valid_598834, JString, required = true,
                                 default = nil)
  if valid_598834 != nil:
    section.add "enterpriseId", valid_598834
  var valid_598835 = path.getOrDefault("userId")
  valid_598835 = validateParameter(valid_598835, JString, required = true,
                                 default = nil)
  if valid_598835 != nil:
    section.add "userId", valid_598835
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: JString
  ##             : Mask that identifies which fields to update. If not set, all modifiable fields will be modified.
  ## 
  ## When set in a query parameter, this field should be specified as updateMask=<field1>,<field2>,...
  section = newJObject()
  var valid_598836 = query.getOrDefault("fields")
  valid_598836 = validateParameter(valid_598836, JString, required = false,
                                 default = nil)
  if valid_598836 != nil:
    section.add "fields", valid_598836
  var valid_598837 = query.getOrDefault("quotaUser")
  valid_598837 = validateParameter(valid_598837, JString, required = false,
                                 default = nil)
  if valid_598837 != nil:
    section.add "quotaUser", valid_598837
  var valid_598838 = query.getOrDefault("alt")
  valid_598838 = validateParameter(valid_598838, JString, required = false,
                                 default = newJString("json"))
  if valid_598838 != nil:
    section.add "alt", valid_598838
  var valid_598839 = query.getOrDefault("oauth_token")
  valid_598839 = validateParameter(valid_598839, JString, required = false,
                                 default = nil)
  if valid_598839 != nil:
    section.add "oauth_token", valid_598839
  var valid_598840 = query.getOrDefault("userIp")
  valid_598840 = validateParameter(valid_598840, JString, required = false,
                                 default = nil)
  if valid_598840 != nil:
    section.add "userIp", valid_598840
  var valid_598841 = query.getOrDefault("key")
  valid_598841 = validateParameter(valid_598841, JString, required = false,
                                 default = nil)
  if valid_598841 != nil:
    section.add "key", valid_598841
  var valid_598842 = query.getOrDefault("prettyPrint")
  valid_598842 = validateParameter(valid_598842, JBool, required = false,
                                 default = newJBool(true))
  if valid_598842 != nil:
    section.add "prettyPrint", valid_598842
  var valid_598843 = query.getOrDefault("updateMask")
  valid_598843 = validateParameter(valid_598843, JString, required = false,
                                 default = nil)
  if valid_598843 != nil:
    section.add "updateMask", valid_598843
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

proc call*(call_598845: Call_AndroidenterpriseDevicesPatch_598830; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the device policy. This method supports patch semantics.
  ## 
  let valid = call_598845.validator(path, query, header, formData, body)
  let scheme = call_598845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598845.url(scheme.get, call_598845.host, call_598845.base,
                         call_598845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598845, url, valid)

proc call*(call_598846: Call_AndroidenterpriseDevicesPatch_598830;
          deviceId: string; enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## androidenterpriseDevicesPatch
  ## Updates the device policy. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   updateMask: string
  ##             : Mask that identifies which fields to update. If not set, all modifiable fields will be modified.
  ## 
  ## When set in a query parameter, this field should be specified as updateMask=<field1>,<field2>,...
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598847 = newJObject()
  var query_598848 = newJObject()
  var body_598849 = newJObject()
  add(query_598848, "fields", newJString(fields))
  add(query_598848, "quotaUser", newJString(quotaUser))
  add(query_598848, "alt", newJString(alt))
  add(path_598847, "deviceId", newJString(deviceId))
  add(query_598848, "oauth_token", newJString(oauthToken))
  add(query_598848, "userIp", newJString(userIp))
  add(query_598848, "key", newJString(key))
  add(path_598847, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598849 = body
  add(query_598848, "prettyPrint", newJBool(prettyPrint))
  add(query_598848, "updateMask", newJString(updateMask))
  add(path_598847, "userId", newJString(userId))
  result = call_598846.call(path_598847, query_598848, nil, nil, body_598849)

var androidenterpriseDevicesPatch* = Call_AndroidenterpriseDevicesPatch_598830(
    name: "androidenterpriseDevicesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}",
    validator: validate_AndroidenterpriseDevicesPatch_598831,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesPatch_598832,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesForceReportUpload_598850 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseDevicesForceReportUpload_598852(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/forceReportUpload")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesForceReportUpload_598851(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Uploads a report containing any changes in app states on the device since the last report was generated. You can call this method up to 3 times every 24 hours for a given device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceId: JString (required)
  ##           : The ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceId` field"
  var valid_598853 = path.getOrDefault("deviceId")
  valid_598853 = validateParameter(valid_598853, JString, required = true,
                                 default = nil)
  if valid_598853 != nil:
    section.add "deviceId", valid_598853
  var valid_598854 = path.getOrDefault("enterpriseId")
  valid_598854 = validateParameter(valid_598854, JString, required = true,
                                 default = nil)
  if valid_598854 != nil:
    section.add "enterpriseId", valid_598854
  var valid_598855 = path.getOrDefault("userId")
  valid_598855 = validateParameter(valid_598855, JString, required = true,
                                 default = nil)
  if valid_598855 != nil:
    section.add "userId", valid_598855
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598856 = query.getOrDefault("fields")
  valid_598856 = validateParameter(valid_598856, JString, required = false,
                                 default = nil)
  if valid_598856 != nil:
    section.add "fields", valid_598856
  var valid_598857 = query.getOrDefault("quotaUser")
  valid_598857 = validateParameter(valid_598857, JString, required = false,
                                 default = nil)
  if valid_598857 != nil:
    section.add "quotaUser", valid_598857
  var valid_598858 = query.getOrDefault("alt")
  valid_598858 = validateParameter(valid_598858, JString, required = false,
                                 default = newJString("json"))
  if valid_598858 != nil:
    section.add "alt", valid_598858
  var valid_598859 = query.getOrDefault("oauth_token")
  valid_598859 = validateParameter(valid_598859, JString, required = false,
                                 default = nil)
  if valid_598859 != nil:
    section.add "oauth_token", valid_598859
  var valid_598860 = query.getOrDefault("userIp")
  valid_598860 = validateParameter(valid_598860, JString, required = false,
                                 default = nil)
  if valid_598860 != nil:
    section.add "userIp", valid_598860
  var valid_598861 = query.getOrDefault("key")
  valid_598861 = validateParameter(valid_598861, JString, required = false,
                                 default = nil)
  if valid_598861 != nil:
    section.add "key", valid_598861
  var valid_598862 = query.getOrDefault("prettyPrint")
  valid_598862 = validateParameter(valid_598862, JBool, required = false,
                                 default = newJBool(true))
  if valid_598862 != nil:
    section.add "prettyPrint", valid_598862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598863: Call_AndroidenterpriseDevicesForceReportUpload_598850;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a report containing any changes in app states on the device since the last report was generated. You can call this method up to 3 times every 24 hours for a given device.
  ## 
  let valid = call_598863.validator(path, query, header, formData, body)
  let scheme = call_598863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598863.url(scheme.get, call_598863.host, call_598863.base,
                         call_598863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598863, url, valid)

proc call*(call_598864: Call_AndroidenterpriseDevicesForceReportUpload_598850;
          deviceId: string; enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseDevicesForceReportUpload
  ## Uploads a report containing any changes in app states on the device since the last report was generated. You can call this method up to 3 times every 24 hours for a given device.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598865 = newJObject()
  var query_598866 = newJObject()
  add(query_598866, "fields", newJString(fields))
  add(query_598866, "quotaUser", newJString(quotaUser))
  add(query_598866, "alt", newJString(alt))
  add(path_598865, "deviceId", newJString(deviceId))
  add(query_598866, "oauth_token", newJString(oauthToken))
  add(query_598866, "userIp", newJString(userIp))
  add(query_598866, "key", newJString(key))
  add(path_598865, "enterpriseId", newJString(enterpriseId))
  add(query_598866, "prettyPrint", newJBool(prettyPrint))
  add(path_598865, "userId", newJString(userId))
  result = call_598864.call(path_598865, query_598866, nil, nil, nil)

var androidenterpriseDevicesForceReportUpload* = Call_AndroidenterpriseDevicesForceReportUpload_598850(
    name: "androidenterpriseDevicesForceReportUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/forceReportUpload",
    validator: validate_AndroidenterpriseDevicesForceReportUpload_598851,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseDevicesForceReportUpload_598852,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsList_598867 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseInstallsList_598869(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/installs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseInstallsList_598868(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of all apps installed on the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceId` field"
  var valid_598870 = path.getOrDefault("deviceId")
  valid_598870 = validateParameter(valid_598870, JString, required = true,
                                 default = nil)
  if valid_598870 != nil:
    section.add "deviceId", valid_598870
  var valid_598871 = path.getOrDefault("enterpriseId")
  valid_598871 = validateParameter(valid_598871, JString, required = true,
                                 default = nil)
  if valid_598871 != nil:
    section.add "enterpriseId", valid_598871
  var valid_598872 = path.getOrDefault("userId")
  valid_598872 = validateParameter(valid_598872, JString, required = true,
                                 default = nil)
  if valid_598872 != nil:
    section.add "userId", valid_598872
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598873 = query.getOrDefault("fields")
  valid_598873 = validateParameter(valid_598873, JString, required = false,
                                 default = nil)
  if valid_598873 != nil:
    section.add "fields", valid_598873
  var valid_598874 = query.getOrDefault("quotaUser")
  valid_598874 = validateParameter(valid_598874, JString, required = false,
                                 default = nil)
  if valid_598874 != nil:
    section.add "quotaUser", valid_598874
  var valid_598875 = query.getOrDefault("alt")
  valid_598875 = validateParameter(valid_598875, JString, required = false,
                                 default = newJString("json"))
  if valid_598875 != nil:
    section.add "alt", valid_598875
  var valid_598876 = query.getOrDefault("oauth_token")
  valid_598876 = validateParameter(valid_598876, JString, required = false,
                                 default = nil)
  if valid_598876 != nil:
    section.add "oauth_token", valid_598876
  var valid_598877 = query.getOrDefault("userIp")
  valid_598877 = validateParameter(valid_598877, JString, required = false,
                                 default = nil)
  if valid_598877 != nil:
    section.add "userIp", valid_598877
  var valid_598878 = query.getOrDefault("key")
  valid_598878 = validateParameter(valid_598878, JString, required = false,
                                 default = nil)
  if valid_598878 != nil:
    section.add "key", valid_598878
  var valid_598879 = query.getOrDefault("prettyPrint")
  valid_598879 = validateParameter(valid_598879, JBool, required = false,
                                 default = newJBool(true))
  if valid_598879 != nil:
    section.add "prettyPrint", valid_598879
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598880: Call_AndroidenterpriseInstallsList_598867; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of all apps installed on the specified device.
  ## 
  let valid = call_598880.validator(path, query, header, formData, body)
  let scheme = call_598880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598880.url(scheme.get, call_598880.host, call_598880.base,
                         call_598880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598880, url, valid)

proc call*(call_598881: Call_AndroidenterpriseInstallsList_598867;
          deviceId: string; enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseInstallsList
  ## Retrieves the details of all apps installed on the specified device.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598882 = newJObject()
  var query_598883 = newJObject()
  add(query_598883, "fields", newJString(fields))
  add(query_598883, "quotaUser", newJString(quotaUser))
  add(query_598883, "alt", newJString(alt))
  add(path_598882, "deviceId", newJString(deviceId))
  add(query_598883, "oauth_token", newJString(oauthToken))
  add(query_598883, "userIp", newJString(userIp))
  add(query_598883, "key", newJString(key))
  add(path_598882, "enterpriseId", newJString(enterpriseId))
  add(query_598883, "prettyPrint", newJBool(prettyPrint))
  add(path_598882, "userId", newJString(userId))
  result = call_598881.call(path_598882, query_598883, nil, nil, nil)

var androidenterpriseInstallsList* = Call_AndroidenterpriseInstallsList_598867(
    name: "androidenterpriseInstallsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs",
    validator: validate_AndroidenterpriseInstallsList_598868,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsList_598869,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsUpdate_598902 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseInstallsUpdate_598904(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "installId" in path, "`installId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/installs/"),
               (kind: VariableSegment, value: "installId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseInstallsUpdate_598903(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   installId: JString (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `installId` field"
  var valid_598905 = path.getOrDefault("installId")
  valid_598905 = validateParameter(valid_598905, JString, required = true,
                                 default = nil)
  if valid_598905 != nil:
    section.add "installId", valid_598905
  var valid_598906 = path.getOrDefault("deviceId")
  valid_598906 = validateParameter(valid_598906, JString, required = true,
                                 default = nil)
  if valid_598906 != nil:
    section.add "deviceId", valid_598906
  var valid_598907 = path.getOrDefault("enterpriseId")
  valid_598907 = validateParameter(valid_598907, JString, required = true,
                                 default = nil)
  if valid_598907 != nil:
    section.add "enterpriseId", valid_598907
  var valid_598908 = path.getOrDefault("userId")
  valid_598908 = validateParameter(valid_598908, JString, required = true,
                                 default = nil)
  if valid_598908 != nil:
    section.add "userId", valid_598908
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598909 = query.getOrDefault("fields")
  valid_598909 = validateParameter(valid_598909, JString, required = false,
                                 default = nil)
  if valid_598909 != nil:
    section.add "fields", valid_598909
  var valid_598910 = query.getOrDefault("quotaUser")
  valid_598910 = validateParameter(valid_598910, JString, required = false,
                                 default = nil)
  if valid_598910 != nil:
    section.add "quotaUser", valid_598910
  var valid_598911 = query.getOrDefault("alt")
  valid_598911 = validateParameter(valid_598911, JString, required = false,
                                 default = newJString("json"))
  if valid_598911 != nil:
    section.add "alt", valid_598911
  var valid_598912 = query.getOrDefault("oauth_token")
  valid_598912 = validateParameter(valid_598912, JString, required = false,
                                 default = nil)
  if valid_598912 != nil:
    section.add "oauth_token", valid_598912
  var valid_598913 = query.getOrDefault("userIp")
  valid_598913 = validateParameter(valid_598913, JString, required = false,
                                 default = nil)
  if valid_598913 != nil:
    section.add "userIp", valid_598913
  var valid_598914 = query.getOrDefault("key")
  valid_598914 = validateParameter(valid_598914, JString, required = false,
                                 default = nil)
  if valid_598914 != nil:
    section.add "key", valid_598914
  var valid_598915 = query.getOrDefault("prettyPrint")
  valid_598915 = validateParameter(valid_598915, JBool, required = false,
                                 default = newJBool(true))
  if valid_598915 != nil:
    section.add "prettyPrint", valid_598915
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

proc call*(call_598917: Call_AndroidenterpriseInstallsUpdate_598902;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary.
  ## 
  let valid = call_598917.validator(path, query, header, formData, body)
  let scheme = call_598917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598917.url(scheme.get, call_598917.host, call_598917.base,
                         call_598917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598917, url, valid)

proc call*(call_598918: Call_AndroidenterpriseInstallsUpdate_598902;
          installId: string; deviceId: string; enterpriseId: string; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseInstallsUpdate
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   installId: string (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598919 = newJObject()
  var query_598920 = newJObject()
  var body_598921 = newJObject()
  add(query_598920, "fields", newJString(fields))
  add(query_598920, "quotaUser", newJString(quotaUser))
  add(path_598919, "installId", newJString(installId))
  add(query_598920, "alt", newJString(alt))
  add(path_598919, "deviceId", newJString(deviceId))
  add(query_598920, "oauth_token", newJString(oauthToken))
  add(query_598920, "userIp", newJString(userIp))
  add(query_598920, "key", newJString(key))
  add(path_598919, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598921 = body
  add(query_598920, "prettyPrint", newJBool(prettyPrint))
  add(path_598919, "userId", newJString(userId))
  result = call_598918.call(path_598919, query_598920, nil, nil, body_598921)

var androidenterpriseInstallsUpdate* = Call_AndroidenterpriseInstallsUpdate_598902(
    name: "androidenterpriseInstallsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsUpdate_598903,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsUpdate_598904,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsGet_598884 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseInstallsGet_598886(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "installId" in path, "`installId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/installs/"),
               (kind: VariableSegment, value: "installId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseInstallsGet_598885(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of an installation of an app on a device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   installId: JString (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `installId` field"
  var valid_598887 = path.getOrDefault("installId")
  valid_598887 = validateParameter(valid_598887, JString, required = true,
                                 default = nil)
  if valid_598887 != nil:
    section.add "installId", valid_598887
  var valid_598888 = path.getOrDefault("deviceId")
  valid_598888 = validateParameter(valid_598888, JString, required = true,
                                 default = nil)
  if valid_598888 != nil:
    section.add "deviceId", valid_598888
  var valid_598889 = path.getOrDefault("enterpriseId")
  valid_598889 = validateParameter(valid_598889, JString, required = true,
                                 default = nil)
  if valid_598889 != nil:
    section.add "enterpriseId", valid_598889
  var valid_598890 = path.getOrDefault("userId")
  valid_598890 = validateParameter(valid_598890, JString, required = true,
                                 default = nil)
  if valid_598890 != nil:
    section.add "userId", valid_598890
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598891 = query.getOrDefault("fields")
  valid_598891 = validateParameter(valid_598891, JString, required = false,
                                 default = nil)
  if valid_598891 != nil:
    section.add "fields", valid_598891
  var valid_598892 = query.getOrDefault("quotaUser")
  valid_598892 = validateParameter(valid_598892, JString, required = false,
                                 default = nil)
  if valid_598892 != nil:
    section.add "quotaUser", valid_598892
  var valid_598893 = query.getOrDefault("alt")
  valid_598893 = validateParameter(valid_598893, JString, required = false,
                                 default = newJString("json"))
  if valid_598893 != nil:
    section.add "alt", valid_598893
  var valid_598894 = query.getOrDefault("oauth_token")
  valid_598894 = validateParameter(valid_598894, JString, required = false,
                                 default = nil)
  if valid_598894 != nil:
    section.add "oauth_token", valid_598894
  var valid_598895 = query.getOrDefault("userIp")
  valid_598895 = validateParameter(valid_598895, JString, required = false,
                                 default = nil)
  if valid_598895 != nil:
    section.add "userIp", valid_598895
  var valid_598896 = query.getOrDefault("key")
  valid_598896 = validateParameter(valid_598896, JString, required = false,
                                 default = nil)
  if valid_598896 != nil:
    section.add "key", valid_598896
  var valid_598897 = query.getOrDefault("prettyPrint")
  valid_598897 = validateParameter(valid_598897, JBool, required = false,
                                 default = newJBool(true))
  if valid_598897 != nil:
    section.add "prettyPrint", valid_598897
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598898: Call_AndroidenterpriseInstallsGet_598884; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves details of an installation of an app on a device.
  ## 
  let valid = call_598898.validator(path, query, header, formData, body)
  let scheme = call_598898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598898.url(scheme.get, call_598898.host, call_598898.base,
                         call_598898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598898, url, valid)

proc call*(call_598899: Call_AndroidenterpriseInstallsGet_598884;
          installId: string; deviceId: string; enterpriseId: string; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseInstallsGet
  ## Retrieves details of an installation of an app on a device.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   installId: string (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598900 = newJObject()
  var query_598901 = newJObject()
  add(query_598901, "fields", newJString(fields))
  add(query_598901, "quotaUser", newJString(quotaUser))
  add(path_598900, "installId", newJString(installId))
  add(query_598901, "alt", newJString(alt))
  add(path_598900, "deviceId", newJString(deviceId))
  add(query_598901, "oauth_token", newJString(oauthToken))
  add(query_598901, "userIp", newJString(userIp))
  add(query_598901, "key", newJString(key))
  add(path_598900, "enterpriseId", newJString(enterpriseId))
  add(query_598901, "prettyPrint", newJBool(prettyPrint))
  add(path_598900, "userId", newJString(userId))
  result = call_598899.call(path_598900, query_598901, nil, nil, nil)

var androidenterpriseInstallsGet* = Call_AndroidenterpriseInstallsGet_598884(
    name: "androidenterpriseInstallsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsGet_598885,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsGet_598886,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsPatch_598940 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseInstallsPatch_598942(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "installId" in path, "`installId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/installs/"),
               (kind: VariableSegment, value: "installId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseInstallsPatch_598941(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   installId: JString (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `installId` field"
  var valid_598943 = path.getOrDefault("installId")
  valid_598943 = validateParameter(valid_598943, JString, required = true,
                                 default = nil)
  if valid_598943 != nil:
    section.add "installId", valid_598943
  var valid_598944 = path.getOrDefault("deviceId")
  valid_598944 = validateParameter(valid_598944, JString, required = true,
                                 default = nil)
  if valid_598944 != nil:
    section.add "deviceId", valid_598944
  var valid_598945 = path.getOrDefault("enterpriseId")
  valid_598945 = validateParameter(valid_598945, JString, required = true,
                                 default = nil)
  if valid_598945 != nil:
    section.add "enterpriseId", valid_598945
  var valid_598946 = path.getOrDefault("userId")
  valid_598946 = validateParameter(valid_598946, JString, required = true,
                                 default = nil)
  if valid_598946 != nil:
    section.add "userId", valid_598946
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598947 = query.getOrDefault("fields")
  valid_598947 = validateParameter(valid_598947, JString, required = false,
                                 default = nil)
  if valid_598947 != nil:
    section.add "fields", valid_598947
  var valid_598948 = query.getOrDefault("quotaUser")
  valid_598948 = validateParameter(valid_598948, JString, required = false,
                                 default = nil)
  if valid_598948 != nil:
    section.add "quotaUser", valid_598948
  var valid_598949 = query.getOrDefault("alt")
  valid_598949 = validateParameter(valid_598949, JString, required = false,
                                 default = newJString("json"))
  if valid_598949 != nil:
    section.add "alt", valid_598949
  var valid_598950 = query.getOrDefault("oauth_token")
  valid_598950 = validateParameter(valid_598950, JString, required = false,
                                 default = nil)
  if valid_598950 != nil:
    section.add "oauth_token", valid_598950
  var valid_598951 = query.getOrDefault("userIp")
  valid_598951 = validateParameter(valid_598951, JString, required = false,
                                 default = nil)
  if valid_598951 != nil:
    section.add "userIp", valid_598951
  var valid_598952 = query.getOrDefault("key")
  valid_598952 = validateParameter(valid_598952, JString, required = false,
                                 default = nil)
  if valid_598952 != nil:
    section.add "key", valid_598952
  var valid_598953 = query.getOrDefault("prettyPrint")
  valid_598953 = validateParameter(valid_598953, JBool, required = false,
                                 default = newJBool(true))
  if valid_598953 != nil:
    section.add "prettyPrint", valid_598953
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

proc call*(call_598955: Call_AndroidenterpriseInstallsPatch_598940; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary. This method supports patch semantics.
  ## 
  let valid = call_598955.validator(path, query, header, formData, body)
  let scheme = call_598955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598955.url(scheme.get, call_598955.host, call_598955.base,
                         call_598955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598955, url, valid)

proc call*(call_598956: Call_AndroidenterpriseInstallsPatch_598940;
          installId: string; deviceId: string; enterpriseId: string; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseInstallsPatch
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   installId: string (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598957 = newJObject()
  var query_598958 = newJObject()
  var body_598959 = newJObject()
  add(query_598958, "fields", newJString(fields))
  add(query_598958, "quotaUser", newJString(quotaUser))
  add(path_598957, "installId", newJString(installId))
  add(query_598958, "alt", newJString(alt))
  add(path_598957, "deviceId", newJString(deviceId))
  add(query_598958, "oauth_token", newJString(oauthToken))
  add(query_598958, "userIp", newJString(userIp))
  add(query_598958, "key", newJString(key))
  add(path_598957, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_598959 = body
  add(query_598958, "prettyPrint", newJBool(prettyPrint))
  add(path_598957, "userId", newJString(userId))
  result = call_598956.call(path_598957, query_598958, nil, nil, body_598959)

var androidenterpriseInstallsPatch* = Call_AndroidenterpriseInstallsPatch_598940(
    name: "androidenterpriseInstallsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsPatch_598941,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsPatch_598942,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsDelete_598922 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseInstallsDelete_598924(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "installId" in path, "`installId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/installs/"),
               (kind: VariableSegment, value: "installId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseInstallsDelete_598923(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Requests to remove an app from a device. A call to get or list will still show the app as installed on the device until it is actually removed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   installId: JString (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `installId` field"
  var valid_598925 = path.getOrDefault("installId")
  valid_598925 = validateParameter(valid_598925, JString, required = true,
                                 default = nil)
  if valid_598925 != nil:
    section.add "installId", valid_598925
  var valid_598926 = path.getOrDefault("deviceId")
  valid_598926 = validateParameter(valid_598926, JString, required = true,
                                 default = nil)
  if valid_598926 != nil:
    section.add "deviceId", valid_598926
  var valid_598927 = path.getOrDefault("enterpriseId")
  valid_598927 = validateParameter(valid_598927, JString, required = true,
                                 default = nil)
  if valid_598927 != nil:
    section.add "enterpriseId", valid_598927
  var valid_598928 = path.getOrDefault("userId")
  valid_598928 = validateParameter(valid_598928, JString, required = true,
                                 default = nil)
  if valid_598928 != nil:
    section.add "userId", valid_598928
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598929 = query.getOrDefault("fields")
  valid_598929 = validateParameter(valid_598929, JString, required = false,
                                 default = nil)
  if valid_598929 != nil:
    section.add "fields", valid_598929
  var valid_598930 = query.getOrDefault("quotaUser")
  valid_598930 = validateParameter(valid_598930, JString, required = false,
                                 default = nil)
  if valid_598930 != nil:
    section.add "quotaUser", valid_598930
  var valid_598931 = query.getOrDefault("alt")
  valid_598931 = validateParameter(valid_598931, JString, required = false,
                                 default = newJString("json"))
  if valid_598931 != nil:
    section.add "alt", valid_598931
  var valid_598932 = query.getOrDefault("oauth_token")
  valid_598932 = validateParameter(valid_598932, JString, required = false,
                                 default = nil)
  if valid_598932 != nil:
    section.add "oauth_token", valid_598932
  var valid_598933 = query.getOrDefault("userIp")
  valid_598933 = validateParameter(valid_598933, JString, required = false,
                                 default = nil)
  if valid_598933 != nil:
    section.add "userIp", valid_598933
  var valid_598934 = query.getOrDefault("key")
  valid_598934 = validateParameter(valid_598934, JString, required = false,
                                 default = nil)
  if valid_598934 != nil:
    section.add "key", valid_598934
  var valid_598935 = query.getOrDefault("prettyPrint")
  valid_598935 = validateParameter(valid_598935, JBool, required = false,
                                 default = newJBool(true))
  if valid_598935 != nil:
    section.add "prettyPrint", valid_598935
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598936: Call_AndroidenterpriseInstallsDelete_598922;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests to remove an app from a device. A call to get or list will still show the app as installed on the device until it is actually removed.
  ## 
  let valid = call_598936.validator(path, query, header, formData, body)
  let scheme = call_598936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598936.url(scheme.get, call_598936.host, call_598936.base,
                         call_598936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598936, url, valid)

proc call*(call_598937: Call_AndroidenterpriseInstallsDelete_598922;
          installId: string; deviceId: string; enterpriseId: string; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseInstallsDelete
  ## Requests to remove an app from a device. A call to get or list will still show the app as installed on the device until it is actually removed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   installId: string (required)
  ##            : The ID of the product represented by the install, e.g. "app:com.google.android.gm".
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598938 = newJObject()
  var query_598939 = newJObject()
  add(query_598939, "fields", newJString(fields))
  add(query_598939, "quotaUser", newJString(quotaUser))
  add(path_598938, "installId", newJString(installId))
  add(query_598939, "alt", newJString(alt))
  add(path_598938, "deviceId", newJString(deviceId))
  add(query_598939, "oauth_token", newJString(oauthToken))
  add(query_598939, "userIp", newJString(userIp))
  add(query_598939, "key", newJString(key))
  add(path_598938, "enterpriseId", newJString(enterpriseId))
  add(query_598939, "prettyPrint", newJBool(prettyPrint))
  add(path_598938, "userId", newJString(userId))
  result = call_598937.call(path_598938, query_598939, nil, nil, nil)

var androidenterpriseInstallsDelete* = Call_AndroidenterpriseInstallsDelete_598922(
    name: "androidenterpriseInstallsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsDelete_598923,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsDelete_598924,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceList_598960 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseManagedconfigurationsfordeviceList_598962(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForDevice")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsfordeviceList_598961(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the per-device managed configurations for the specified device. Only the ID is set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceId` field"
  var valid_598963 = path.getOrDefault("deviceId")
  valid_598963 = validateParameter(valid_598963, JString, required = true,
                                 default = nil)
  if valid_598963 != nil:
    section.add "deviceId", valid_598963
  var valid_598964 = path.getOrDefault("enterpriseId")
  valid_598964 = validateParameter(valid_598964, JString, required = true,
                                 default = nil)
  if valid_598964 != nil:
    section.add "enterpriseId", valid_598964
  var valid_598965 = path.getOrDefault("userId")
  valid_598965 = validateParameter(valid_598965, JString, required = true,
                                 default = nil)
  if valid_598965 != nil:
    section.add "userId", valid_598965
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598966 = query.getOrDefault("fields")
  valid_598966 = validateParameter(valid_598966, JString, required = false,
                                 default = nil)
  if valid_598966 != nil:
    section.add "fields", valid_598966
  var valid_598967 = query.getOrDefault("quotaUser")
  valid_598967 = validateParameter(valid_598967, JString, required = false,
                                 default = nil)
  if valid_598967 != nil:
    section.add "quotaUser", valid_598967
  var valid_598968 = query.getOrDefault("alt")
  valid_598968 = validateParameter(valid_598968, JString, required = false,
                                 default = newJString("json"))
  if valid_598968 != nil:
    section.add "alt", valid_598968
  var valid_598969 = query.getOrDefault("oauth_token")
  valid_598969 = validateParameter(valid_598969, JString, required = false,
                                 default = nil)
  if valid_598969 != nil:
    section.add "oauth_token", valid_598969
  var valid_598970 = query.getOrDefault("userIp")
  valid_598970 = validateParameter(valid_598970, JString, required = false,
                                 default = nil)
  if valid_598970 != nil:
    section.add "userIp", valid_598970
  var valid_598971 = query.getOrDefault("key")
  valid_598971 = validateParameter(valid_598971, JString, required = false,
                                 default = nil)
  if valid_598971 != nil:
    section.add "key", valid_598971
  var valid_598972 = query.getOrDefault("prettyPrint")
  valid_598972 = validateParameter(valid_598972, JBool, required = false,
                                 default = newJBool(true))
  if valid_598972 != nil:
    section.add "prettyPrint", valid_598972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598973: Call_AndroidenterpriseManagedconfigurationsfordeviceList_598960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the per-device managed configurations for the specified device. Only the ID is set.
  ## 
  let valid = call_598973.validator(path, query, header, formData, body)
  let scheme = call_598973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598973.url(scheme.get, call_598973.host, call_598973.base,
                         call_598973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598973, url, valid)

proc call*(call_598974: Call_AndroidenterpriseManagedconfigurationsfordeviceList_598960;
          deviceId: string; enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseManagedconfigurationsfordeviceList
  ## Lists all the per-device managed configurations for the specified device. Only the ID is set.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598975 = newJObject()
  var query_598976 = newJObject()
  add(query_598976, "fields", newJString(fields))
  add(query_598976, "quotaUser", newJString(quotaUser))
  add(query_598976, "alt", newJString(alt))
  add(path_598975, "deviceId", newJString(deviceId))
  add(query_598976, "oauth_token", newJString(oauthToken))
  add(query_598976, "userIp", newJString(userIp))
  add(query_598976, "key", newJString(key))
  add(path_598975, "enterpriseId", newJString(enterpriseId))
  add(query_598976, "prettyPrint", newJBool(prettyPrint))
  add(path_598975, "userId", newJString(userId))
  result = call_598974.call(path_598975, query_598976, nil, nil, nil)

var androidenterpriseManagedconfigurationsfordeviceList* = Call_AndroidenterpriseManagedconfigurationsfordeviceList_598960(
    name: "androidenterpriseManagedconfigurationsfordeviceList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceList_598961,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceList_598962,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_598995 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseManagedconfigurationsfordeviceUpdate_598997(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "managedConfigurationForDeviceId" in path,
        "`managedConfigurationForDeviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForDevice/"), (kind: VariableSegment,
        value: "managedConfigurationForDeviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsfordeviceUpdate_598996(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Adds or updates a per-device managed configuration for an app for the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedConfigurationForDeviceId: JString (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managedConfigurationForDeviceId` field"
  var valid_598998 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_598998 = validateParameter(valid_598998, JString, required = true,
                                 default = nil)
  if valid_598998 != nil:
    section.add "managedConfigurationForDeviceId", valid_598998
  var valid_598999 = path.getOrDefault("deviceId")
  valid_598999 = validateParameter(valid_598999, JString, required = true,
                                 default = nil)
  if valid_598999 != nil:
    section.add "deviceId", valid_598999
  var valid_599000 = path.getOrDefault("enterpriseId")
  valid_599000 = validateParameter(valid_599000, JString, required = true,
                                 default = nil)
  if valid_599000 != nil:
    section.add "enterpriseId", valid_599000
  var valid_599001 = path.getOrDefault("userId")
  valid_599001 = validateParameter(valid_599001, JString, required = true,
                                 default = nil)
  if valid_599001 != nil:
    section.add "userId", valid_599001
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599002 = query.getOrDefault("fields")
  valid_599002 = validateParameter(valid_599002, JString, required = false,
                                 default = nil)
  if valid_599002 != nil:
    section.add "fields", valid_599002
  var valid_599003 = query.getOrDefault("quotaUser")
  valid_599003 = validateParameter(valid_599003, JString, required = false,
                                 default = nil)
  if valid_599003 != nil:
    section.add "quotaUser", valid_599003
  var valid_599004 = query.getOrDefault("alt")
  valid_599004 = validateParameter(valid_599004, JString, required = false,
                                 default = newJString("json"))
  if valid_599004 != nil:
    section.add "alt", valid_599004
  var valid_599005 = query.getOrDefault("oauth_token")
  valid_599005 = validateParameter(valid_599005, JString, required = false,
                                 default = nil)
  if valid_599005 != nil:
    section.add "oauth_token", valid_599005
  var valid_599006 = query.getOrDefault("userIp")
  valid_599006 = validateParameter(valid_599006, JString, required = false,
                                 default = nil)
  if valid_599006 != nil:
    section.add "userIp", valid_599006
  var valid_599007 = query.getOrDefault("key")
  valid_599007 = validateParameter(valid_599007, JString, required = false,
                                 default = nil)
  if valid_599007 != nil:
    section.add "key", valid_599007
  var valid_599008 = query.getOrDefault("prettyPrint")
  valid_599008 = validateParameter(valid_599008, JBool, required = false,
                                 default = newJBool(true))
  if valid_599008 != nil:
    section.add "prettyPrint", valid_599008
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

proc call*(call_599010: Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_598995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates a per-device managed configuration for an app for the specified device.
  ## 
  let valid = call_599010.validator(path, query, header, formData, body)
  let scheme = call_599010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599010.url(scheme.get, call_599010.host, call_599010.base,
                         call_599010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599010, url, valid)

proc call*(call_599011: Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_598995;
          managedConfigurationForDeviceId: string; deviceId: string;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseManagedconfigurationsfordeviceUpdate
  ## Adds or updates a per-device managed configuration for an app for the specified device.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   managedConfigurationForDeviceId: string (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599012 = newJObject()
  var query_599013 = newJObject()
  var body_599014 = newJObject()
  add(query_599013, "fields", newJString(fields))
  add(query_599013, "quotaUser", newJString(quotaUser))
  add(path_599012, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_599013, "alt", newJString(alt))
  add(path_599012, "deviceId", newJString(deviceId))
  add(query_599013, "oauth_token", newJString(oauthToken))
  add(query_599013, "userIp", newJString(userIp))
  add(query_599013, "key", newJString(key))
  add(path_599012, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_599014 = body
  add(query_599013, "prettyPrint", newJBool(prettyPrint))
  add(path_599012, "userId", newJString(userId))
  result = call_599011.call(path_599012, query_599013, nil, nil, body_599014)

var androidenterpriseManagedconfigurationsfordeviceUpdate* = Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_598995(
    name: "androidenterpriseManagedconfigurationsfordeviceUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceUpdate_598996,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceUpdate_598997,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceGet_598977 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseManagedconfigurationsfordeviceGet_598979(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "managedConfigurationForDeviceId" in path,
        "`managedConfigurationForDeviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForDevice/"), (kind: VariableSegment,
        value: "managedConfigurationForDeviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsfordeviceGet_598978(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves details of a per-device managed configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedConfigurationForDeviceId: JString (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managedConfigurationForDeviceId` field"
  var valid_598980 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_598980 = validateParameter(valid_598980, JString, required = true,
                                 default = nil)
  if valid_598980 != nil:
    section.add "managedConfigurationForDeviceId", valid_598980
  var valid_598981 = path.getOrDefault("deviceId")
  valid_598981 = validateParameter(valid_598981, JString, required = true,
                                 default = nil)
  if valid_598981 != nil:
    section.add "deviceId", valid_598981
  var valid_598982 = path.getOrDefault("enterpriseId")
  valid_598982 = validateParameter(valid_598982, JString, required = true,
                                 default = nil)
  if valid_598982 != nil:
    section.add "enterpriseId", valid_598982
  var valid_598983 = path.getOrDefault("userId")
  valid_598983 = validateParameter(valid_598983, JString, required = true,
                                 default = nil)
  if valid_598983 != nil:
    section.add "userId", valid_598983
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_598984 = query.getOrDefault("fields")
  valid_598984 = validateParameter(valid_598984, JString, required = false,
                                 default = nil)
  if valid_598984 != nil:
    section.add "fields", valid_598984
  var valid_598985 = query.getOrDefault("quotaUser")
  valid_598985 = validateParameter(valid_598985, JString, required = false,
                                 default = nil)
  if valid_598985 != nil:
    section.add "quotaUser", valid_598985
  var valid_598986 = query.getOrDefault("alt")
  valid_598986 = validateParameter(valid_598986, JString, required = false,
                                 default = newJString("json"))
  if valid_598986 != nil:
    section.add "alt", valid_598986
  var valid_598987 = query.getOrDefault("oauth_token")
  valid_598987 = validateParameter(valid_598987, JString, required = false,
                                 default = nil)
  if valid_598987 != nil:
    section.add "oauth_token", valid_598987
  var valid_598988 = query.getOrDefault("userIp")
  valid_598988 = validateParameter(valid_598988, JString, required = false,
                                 default = nil)
  if valid_598988 != nil:
    section.add "userIp", valid_598988
  var valid_598989 = query.getOrDefault("key")
  valid_598989 = validateParameter(valid_598989, JString, required = false,
                                 default = nil)
  if valid_598989 != nil:
    section.add "key", valid_598989
  var valid_598990 = query.getOrDefault("prettyPrint")
  valid_598990 = validateParameter(valid_598990, JBool, required = false,
                                 default = newJBool(true))
  if valid_598990 != nil:
    section.add "prettyPrint", valid_598990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_598991: Call_AndroidenterpriseManagedconfigurationsfordeviceGet_598977;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a per-device managed configuration.
  ## 
  let valid = call_598991.validator(path, query, header, formData, body)
  let scheme = call_598991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598991.url(scheme.get, call_598991.host, call_598991.base,
                         call_598991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598991, url, valid)

proc call*(call_598992: Call_AndroidenterpriseManagedconfigurationsfordeviceGet_598977;
          managedConfigurationForDeviceId: string; deviceId: string;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseManagedconfigurationsfordeviceGet
  ## Retrieves details of a per-device managed configuration.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   managedConfigurationForDeviceId: string (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_598993 = newJObject()
  var query_598994 = newJObject()
  add(query_598994, "fields", newJString(fields))
  add(query_598994, "quotaUser", newJString(quotaUser))
  add(path_598993, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_598994, "alt", newJString(alt))
  add(path_598993, "deviceId", newJString(deviceId))
  add(query_598994, "oauth_token", newJString(oauthToken))
  add(query_598994, "userIp", newJString(userIp))
  add(query_598994, "key", newJString(key))
  add(path_598993, "enterpriseId", newJString(enterpriseId))
  add(query_598994, "prettyPrint", newJBool(prettyPrint))
  add(path_598993, "userId", newJString(userId))
  result = call_598992.call(path_598993, query_598994, nil, nil, nil)

var androidenterpriseManagedconfigurationsfordeviceGet* = Call_AndroidenterpriseManagedconfigurationsfordeviceGet_598977(
    name: "androidenterpriseManagedconfigurationsfordeviceGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceGet_598978,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceGet_598979,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordevicePatch_599033 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseManagedconfigurationsfordevicePatch_599035(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "managedConfigurationForDeviceId" in path,
        "`managedConfigurationForDeviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForDevice/"), (kind: VariableSegment,
        value: "managedConfigurationForDeviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsfordevicePatch_599034(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Adds or updates a per-device managed configuration for an app for the specified device. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedConfigurationForDeviceId: JString (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managedConfigurationForDeviceId` field"
  var valid_599036 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_599036 = validateParameter(valid_599036, JString, required = true,
                                 default = nil)
  if valid_599036 != nil:
    section.add "managedConfigurationForDeviceId", valid_599036
  var valid_599037 = path.getOrDefault("deviceId")
  valid_599037 = validateParameter(valid_599037, JString, required = true,
                                 default = nil)
  if valid_599037 != nil:
    section.add "deviceId", valid_599037
  var valid_599038 = path.getOrDefault("enterpriseId")
  valid_599038 = validateParameter(valid_599038, JString, required = true,
                                 default = nil)
  if valid_599038 != nil:
    section.add "enterpriseId", valid_599038
  var valid_599039 = path.getOrDefault("userId")
  valid_599039 = validateParameter(valid_599039, JString, required = true,
                                 default = nil)
  if valid_599039 != nil:
    section.add "userId", valid_599039
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599040 = query.getOrDefault("fields")
  valid_599040 = validateParameter(valid_599040, JString, required = false,
                                 default = nil)
  if valid_599040 != nil:
    section.add "fields", valid_599040
  var valid_599041 = query.getOrDefault("quotaUser")
  valid_599041 = validateParameter(valid_599041, JString, required = false,
                                 default = nil)
  if valid_599041 != nil:
    section.add "quotaUser", valid_599041
  var valid_599042 = query.getOrDefault("alt")
  valid_599042 = validateParameter(valid_599042, JString, required = false,
                                 default = newJString("json"))
  if valid_599042 != nil:
    section.add "alt", valid_599042
  var valid_599043 = query.getOrDefault("oauth_token")
  valid_599043 = validateParameter(valid_599043, JString, required = false,
                                 default = nil)
  if valid_599043 != nil:
    section.add "oauth_token", valid_599043
  var valid_599044 = query.getOrDefault("userIp")
  valid_599044 = validateParameter(valid_599044, JString, required = false,
                                 default = nil)
  if valid_599044 != nil:
    section.add "userIp", valid_599044
  var valid_599045 = query.getOrDefault("key")
  valid_599045 = validateParameter(valid_599045, JString, required = false,
                                 default = nil)
  if valid_599045 != nil:
    section.add "key", valid_599045
  var valid_599046 = query.getOrDefault("prettyPrint")
  valid_599046 = validateParameter(valid_599046, JBool, required = false,
                                 default = newJBool(true))
  if valid_599046 != nil:
    section.add "prettyPrint", valid_599046
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

proc call*(call_599048: Call_AndroidenterpriseManagedconfigurationsfordevicePatch_599033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates a per-device managed configuration for an app for the specified device. This method supports patch semantics.
  ## 
  let valid = call_599048.validator(path, query, header, formData, body)
  let scheme = call_599048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599048.url(scheme.get, call_599048.host, call_599048.base,
                         call_599048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599048, url, valid)

proc call*(call_599049: Call_AndroidenterpriseManagedconfigurationsfordevicePatch_599033;
          managedConfigurationForDeviceId: string; deviceId: string;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseManagedconfigurationsfordevicePatch
  ## Adds or updates a per-device managed configuration for an app for the specified device. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   managedConfigurationForDeviceId: string (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599050 = newJObject()
  var query_599051 = newJObject()
  var body_599052 = newJObject()
  add(query_599051, "fields", newJString(fields))
  add(query_599051, "quotaUser", newJString(quotaUser))
  add(path_599050, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_599051, "alt", newJString(alt))
  add(path_599050, "deviceId", newJString(deviceId))
  add(query_599051, "oauth_token", newJString(oauthToken))
  add(query_599051, "userIp", newJString(userIp))
  add(query_599051, "key", newJString(key))
  add(path_599050, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_599052 = body
  add(query_599051, "prettyPrint", newJBool(prettyPrint))
  add(path_599050, "userId", newJString(userId))
  result = call_599049.call(path_599050, query_599051, nil, nil, body_599052)

var androidenterpriseManagedconfigurationsfordevicePatch* = Call_AndroidenterpriseManagedconfigurationsfordevicePatch_599033(
    name: "androidenterpriseManagedconfigurationsfordevicePatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordevicePatch_599034,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordevicePatch_599035,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_599015 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseManagedconfigurationsfordeviceDelete_599017(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  assert "managedConfigurationForDeviceId" in path,
        "`managedConfigurationForDeviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForDevice/"), (kind: VariableSegment,
        value: "managedConfigurationForDeviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsfordeviceDelete_599016(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Removes a per-device managed configuration for an app for the specified device.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   managedConfigurationForDeviceId: JString (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   deviceId: JString (required)
  ##           : The Android ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `managedConfigurationForDeviceId` field"
  var valid_599018 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_599018 = validateParameter(valid_599018, JString, required = true,
                                 default = nil)
  if valid_599018 != nil:
    section.add "managedConfigurationForDeviceId", valid_599018
  var valid_599019 = path.getOrDefault("deviceId")
  valid_599019 = validateParameter(valid_599019, JString, required = true,
                                 default = nil)
  if valid_599019 != nil:
    section.add "deviceId", valid_599019
  var valid_599020 = path.getOrDefault("enterpriseId")
  valid_599020 = validateParameter(valid_599020, JString, required = true,
                                 default = nil)
  if valid_599020 != nil:
    section.add "enterpriseId", valid_599020
  var valid_599021 = path.getOrDefault("userId")
  valid_599021 = validateParameter(valid_599021, JString, required = true,
                                 default = nil)
  if valid_599021 != nil:
    section.add "userId", valid_599021
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599022 = query.getOrDefault("fields")
  valid_599022 = validateParameter(valid_599022, JString, required = false,
                                 default = nil)
  if valid_599022 != nil:
    section.add "fields", valid_599022
  var valid_599023 = query.getOrDefault("quotaUser")
  valid_599023 = validateParameter(valid_599023, JString, required = false,
                                 default = nil)
  if valid_599023 != nil:
    section.add "quotaUser", valid_599023
  var valid_599024 = query.getOrDefault("alt")
  valid_599024 = validateParameter(valid_599024, JString, required = false,
                                 default = newJString("json"))
  if valid_599024 != nil:
    section.add "alt", valid_599024
  var valid_599025 = query.getOrDefault("oauth_token")
  valid_599025 = validateParameter(valid_599025, JString, required = false,
                                 default = nil)
  if valid_599025 != nil:
    section.add "oauth_token", valid_599025
  var valid_599026 = query.getOrDefault("userIp")
  valid_599026 = validateParameter(valid_599026, JString, required = false,
                                 default = nil)
  if valid_599026 != nil:
    section.add "userIp", valid_599026
  var valid_599027 = query.getOrDefault("key")
  valid_599027 = validateParameter(valid_599027, JString, required = false,
                                 default = nil)
  if valid_599027 != nil:
    section.add "key", valid_599027
  var valid_599028 = query.getOrDefault("prettyPrint")
  valid_599028 = validateParameter(valid_599028, JBool, required = false,
                                 default = newJBool(true))
  if valid_599028 != nil:
    section.add "prettyPrint", valid_599028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599029: Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_599015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a per-device managed configuration for an app for the specified device.
  ## 
  let valid = call_599029.validator(path, query, header, formData, body)
  let scheme = call_599029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599029.url(scheme.get, call_599029.host, call_599029.base,
                         call_599029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599029, url, valid)

proc call*(call_599030: Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_599015;
          managedConfigurationForDeviceId: string; deviceId: string;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseManagedconfigurationsfordeviceDelete
  ## Removes a per-device managed configuration for an app for the specified device.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   managedConfigurationForDeviceId: string (required)
  ##                                  : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The Android ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599031 = newJObject()
  var query_599032 = newJObject()
  add(query_599032, "fields", newJString(fields))
  add(query_599032, "quotaUser", newJString(quotaUser))
  add(path_599031, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_599032, "alt", newJString(alt))
  add(path_599031, "deviceId", newJString(deviceId))
  add(query_599032, "oauth_token", newJString(oauthToken))
  add(query_599032, "userIp", newJString(userIp))
  add(query_599032, "key", newJString(key))
  add(path_599031, "enterpriseId", newJString(enterpriseId))
  add(query_599032, "prettyPrint", newJBool(prettyPrint))
  add(path_599031, "userId", newJString(userId))
  result = call_599030.call(path_599031, query_599032, nil, nil, nil)

var androidenterpriseManagedconfigurationsfordeviceDelete* = Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_599015(
    name: "androidenterpriseManagedconfigurationsfordeviceDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceDelete_599016,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceDelete_599017,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesSetState_599070 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseDevicesSetState_599072(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/state")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesSetState_599071(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceId: JString (required)
  ##           : The ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceId` field"
  var valid_599073 = path.getOrDefault("deviceId")
  valid_599073 = validateParameter(valid_599073, JString, required = true,
                                 default = nil)
  if valid_599073 != nil:
    section.add "deviceId", valid_599073
  var valid_599074 = path.getOrDefault("enterpriseId")
  valid_599074 = validateParameter(valid_599074, JString, required = true,
                                 default = nil)
  if valid_599074 != nil:
    section.add "enterpriseId", valid_599074
  var valid_599075 = path.getOrDefault("userId")
  valid_599075 = validateParameter(valid_599075, JString, required = true,
                                 default = nil)
  if valid_599075 != nil:
    section.add "userId", valid_599075
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599076 = query.getOrDefault("fields")
  valid_599076 = validateParameter(valid_599076, JString, required = false,
                                 default = nil)
  if valid_599076 != nil:
    section.add "fields", valid_599076
  var valid_599077 = query.getOrDefault("quotaUser")
  valid_599077 = validateParameter(valid_599077, JString, required = false,
                                 default = nil)
  if valid_599077 != nil:
    section.add "quotaUser", valid_599077
  var valid_599078 = query.getOrDefault("alt")
  valid_599078 = validateParameter(valid_599078, JString, required = false,
                                 default = newJString("json"))
  if valid_599078 != nil:
    section.add "alt", valid_599078
  var valid_599079 = query.getOrDefault("oauth_token")
  valid_599079 = validateParameter(valid_599079, JString, required = false,
                                 default = nil)
  if valid_599079 != nil:
    section.add "oauth_token", valid_599079
  var valid_599080 = query.getOrDefault("userIp")
  valid_599080 = validateParameter(valid_599080, JString, required = false,
                                 default = nil)
  if valid_599080 != nil:
    section.add "userIp", valid_599080
  var valid_599081 = query.getOrDefault("key")
  valid_599081 = validateParameter(valid_599081, JString, required = false,
                                 default = nil)
  if valid_599081 != nil:
    section.add "key", valid_599081
  var valid_599082 = query.getOrDefault("prettyPrint")
  valid_599082 = validateParameter(valid_599082, JBool, required = false,
                                 default = newJBool(true))
  if valid_599082 != nil:
    section.add "prettyPrint", valid_599082
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

proc call*(call_599084: Call_AndroidenterpriseDevicesSetState_599070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ## 
  let valid = call_599084.validator(path, query, header, formData, body)
  let scheme = call_599084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599084.url(scheme.get, call_599084.host, call_599084.base,
                         call_599084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599084, url, valid)

proc call*(call_599085: Call_AndroidenterpriseDevicesSetState_599070;
          deviceId: string; enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseDevicesSetState
  ## Sets whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599086 = newJObject()
  var query_599087 = newJObject()
  var body_599088 = newJObject()
  add(query_599087, "fields", newJString(fields))
  add(query_599087, "quotaUser", newJString(quotaUser))
  add(query_599087, "alt", newJString(alt))
  add(path_599086, "deviceId", newJString(deviceId))
  add(query_599087, "oauth_token", newJString(oauthToken))
  add(query_599087, "userIp", newJString(userIp))
  add(query_599087, "key", newJString(key))
  add(path_599086, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_599088 = body
  add(query_599087, "prettyPrint", newJBool(prettyPrint))
  add(path_599086, "userId", newJString(userId))
  result = call_599085.call(path_599086, query_599087, nil, nil, body_599088)

var androidenterpriseDevicesSetState* = Call_AndroidenterpriseDevicesSetState_599070(
    name: "androidenterpriseDevicesSetState", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/state",
    validator: validate_AndroidenterpriseDevicesSetState_599071,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesSetState_599072,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesGetState_599053 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseDevicesGetState_599055(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/devices/"),
               (kind: VariableSegment, value: "deviceId"),
               (kind: ConstantSegment, value: "/state")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseDevicesGetState_599054(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceId: JString (required)
  ##           : The ID of the device.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceId` field"
  var valid_599056 = path.getOrDefault("deviceId")
  valid_599056 = validateParameter(valid_599056, JString, required = true,
                                 default = nil)
  if valid_599056 != nil:
    section.add "deviceId", valid_599056
  var valid_599057 = path.getOrDefault("enterpriseId")
  valid_599057 = validateParameter(valid_599057, JString, required = true,
                                 default = nil)
  if valid_599057 != nil:
    section.add "enterpriseId", valid_599057
  var valid_599058 = path.getOrDefault("userId")
  valid_599058 = validateParameter(valid_599058, JString, required = true,
                                 default = nil)
  if valid_599058 != nil:
    section.add "userId", valid_599058
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599059 = query.getOrDefault("fields")
  valid_599059 = validateParameter(valid_599059, JString, required = false,
                                 default = nil)
  if valid_599059 != nil:
    section.add "fields", valid_599059
  var valid_599060 = query.getOrDefault("quotaUser")
  valid_599060 = validateParameter(valid_599060, JString, required = false,
                                 default = nil)
  if valid_599060 != nil:
    section.add "quotaUser", valid_599060
  var valid_599061 = query.getOrDefault("alt")
  valid_599061 = validateParameter(valid_599061, JString, required = false,
                                 default = newJString("json"))
  if valid_599061 != nil:
    section.add "alt", valid_599061
  var valid_599062 = query.getOrDefault("oauth_token")
  valid_599062 = validateParameter(valid_599062, JString, required = false,
                                 default = nil)
  if valid_599062 != nil:
    section.add "oauth_token", valid_599062
  var valid_599063 = query.getOrDefault("userIp")
  valid_599063 = validateParameter(valid_599063, JString, required = false,
                                 default = nil)
  if valid_599063 != nil:
    section.add "userIp", valid_599063
  var valid_599064 = query.getOrDefault("key")
  valid_599064 = validateParameter(valid_599064, JString, required = false,
                                 default = nil)
  if valid_599064 != nil:
    section.add "key", valid_599064
  var valid_599065 = query.getOrDefault("prettyPrint")
  valid_599065 = validateParameter(valid_599065, JBool, required = false,
                                 default = newJBool(true))
  if valid_599065 != nil:
    section.add "prettyPrint", valid_599065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599066: Call_AndroidenterpriseDevicesGetState_599053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ## 
  let valid = call_599066.validator(path, query, header, formData, body)
  let scheme = call_599066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599066.url(scheme.get, call_599066.host, call_599066.base,
                         call_599066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599066, url, valid)

proc call*(call_599067: Call_AndroidenterpriseDevicesGetState_599053;
          deviceId: string; enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseDevicesGetState
  ## Retrieves whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : The ID of the device.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599068 = newJObject()
  var query_599069 = newJObject()
  add(query_599069, "fields", newJString(fields))
  add(query_599069, "quotaUser", newJString(quotaUser))
  add(query_599069, "alt", newJString(alt))
  add(path_599068, "deviceId", newJString(deviceId))
  add(query_599069, "oauth_token", newJString(oauthToken))
  add(query_599069, "userIp", newJString(userIp))
  add(query_599069, "key", newJString(key))
  add(path_599068, "enterpriseId", newJString(enterpriseId))
  add(query_599069, "prettyPrint", newJBool(prettyPrint))
  add(path_599068, "userId", newJString(userId))
  result = call_599067.call(path_599068, query_599069, nil, nil, nil)

var androidenterpriseDevicesGetState* = Call_AndroidenterpriseDevicesGetState_599053(
    name: "androidenterpriseDevicesGetState", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/state",
    validator: validate_AndroidenterpriseDevicesGetState_599054,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesGetState_599055,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsList_599089 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEntitlementsList_599091(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/entitlements")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEntitlementsList_599090(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all entitlements for the specified user. Only the ID is set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599092 = path.getOrDefault("enterpriseId")
  valid_599092 = validateParameter(valid_599092, JString, required = true,
                                 default = nil)
  if valid_599092 != nil:
    section.add "enterpriseId", valid_599092
  var valid_599093 = path.getOrDefault("userId")
  valid_599093 = validateParameter(valid_599093, JString, required = true,
                                 default = nil)
  if valid_599093 != nil:
    section.add "userId", valid_599093
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599094 = query.getOrDefault("fields")
  valid_599094 = validateParameter(valid_599094, JString, required = false,
                                 default = nil)
  if valid_599094 != nil:
    section.add "fields", valid_599094
  var valid_599095 = query.getOrDefault("quotaUser")
  valid_599095 = validateParameter(valid_599095, JString, required = false,
                                 default = nil)
  if valid_599095 != nil:
    section.add "quotaUser", valid_599095
  var valid_599096 = query.getOrDefault("alt")
  valid_599096 = validateParameter(valid_599096, JString, required = false,
                                 default = newJString("json"))
  if valid_599096 != nil:
    section.add "alt", valid_599096
  var valid_599097 = query.getOrDefault("oauth_token")
  valid_599097 = validateParameter(valid_599097, JString, required = false,
                                 default = nil)
  if valid_599097 != nil:
    section.add "oauth_token", valid_599097
  var valid_599098 = query.getOrDefault("userIp")
  valid_599098 = validateParameter(valid_599098, JString, required = false,
                                 default = nil)
  if valid_599098 != nil:
    section.add "userIp", valid_599098
  var valid_599099 = query.getOrDefault("key")
  valid_599099 = validateParameter(valid_599099, JString, required = false,
                                 default = nil)
  if valid_599099 != nil:
    section.add "key", valid_599099
  var valid_599100 = query.getOrDefault("prettyPrint")
  valid_599100 = validateParameter(valid_599100, JBool, required = false,
                                 default = newJBool(true))
  if valid_599100 != nil:
    section.add "prettyPrint", valid_599100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599101: Call_AndroidenterpriseEntitlementsList_599089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all entitlements for the specified user. Only the ID is set.
  ## 
  let valid = call_599101.validator(path, query, header, formData, body)
  let scheme = call_599101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599101.url(scheme.get, call_599101.host, call_599101.base,
                         call_599101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599101, url, valid)

proc call*(call_599102: Call_AndroidenterpriseEntitlementsList_599089;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEntitlementsList
  ## Lists all entitlements for the specified user. Only the ID is set.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599103 = newJObject()
  var query_599104 = newJObject()
  add(query_599104, "fields", newJString(fields))
  add(query_599104, "quotaUser", newJString(quotaUser))
  add(query_599104, "alt", newJString(alt))
  add(query_599104, "oauth_token", newJString(oauthToken))
  add(query_599104, "userIp", newJString(userIp))
  add(query_599104, "key", newJString(key))
  add(path_599103, "enterpriseId", newJString(enterpriseId))
  add(query_599104, "prettyPrint", newJBool(prettyPrint))
  add(path_599103, "userId", newJString(userId))
  result = call_599102.call(path_599103, query_599104, nil, nil, nil)

var androidenterpriseEntitlementsList* = Call_AndroidenterpriseEntitlementsList_599089(
    name: "androidenterpriseEntitlementsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/entitlements",
    validator: validate_AndroidenterpriseEntitlementsList_599090,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsList_599091,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsUpdate_599122 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEntitlementsUpdate_599124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "entitlementId" in path, "`entitlementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/entitlements/"),
               (kind: VariableSegment, value: "entitlementId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEntitlementsUpdate_599123(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds or updates an entitlement to an app for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   entitlementId: JString (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599125 = path.getOrDefault("enterpriseId")
  valid_599125 = validateParameter(valid_599125, JString, required = true,
                                 default = nil)
  if valid_599125 != nil:
    section.add "enterpriseId", valid_599125
  var valid_599126 = path.getOrDefault("entitlementId")
  valid_599126 = validateParameter(valid_599126, JString, required = true,
                                 default = nil)
  if valid_599126 != nil:
    section.add "entitlementId", valid_599126
  var valid_599127 = path.getOrDefault("userId")
  valid_599127 = validateParameter(valid_599127, JString, required = true,
                                 default = nil)
  if valid_599127 != nil:
    section.add "userId", valid_599127
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   install: JBool
  ##          : Set to true to also install the product on all the user's devices where possible. Failure to install on one or more devices will not prevent this operation from returning successfully, as long as the entitlement was successfully assigned to the user.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599128 = query.getOrDefault("fields")
  valid_599128 = validateParameter(valid_599128, JString, required = false,
                                 default = nil)
  if valid_599128 != nil:
    section.add "fields", valid_599128
  var valid_599129 = query.getOrDefault("quotaUser")
  valid_599129 = validateParameter(valid_599129, JString, required = false,
                                 default = nil)
  if valid_599129 != nil:
    section.add "quotaUser", valid_599129
  var valid_599130 = query.getOrDefault("alt")
  valid_599130 = validateParameter(valid_599130, JString, required = false,
                                 default = newJString("json"))
  if valid_599130 != nil:
    section.add "alt", valid_599130
  var valid_599131 = query.getOrDefault("install")
  valid_599131 = validateParameter(valid_599131, JBool, required = false, default = nil)
  if valid_599131 != nil:
    section.add "install", valid_599131
  var valid_599132 = query.getOrDefault("oauth_token")
  valid_599132 = validateParameter(valid_599132, JString, required = false,
                                 default = nil)
  if valid_599132 != nil:
    section.add "oauth_token", valid_599132
  var valid_599133 = query.getOrDefault("userIp")
  valid_599133 = validateParameter(valid_599133, JString, required = false,
                                 default = nil)
  if valid_599133 != nil:
    section.add "userIp", valid_599133
  var valid_599134 = query.getOrDefault("key")
  valid_599134 = validateParameter(valid_599134, JString, required = false,
                                 default = nil)
  if valid_599134 != nil:
    section.add "key", valid_599134
  var valid_599135 = query.getOrDefault("prettyPrint")
  valid_599135 = validateParameter(valid_599135, JBool, required = false,
                                 default = newJBool(true))
  if valid_599135 != nil:
    section.add "prettyPrint", valid_599135
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

proc call*(call_599137: Call_AndroidenterpriseEntitlementsUpdate_599122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates an entitlement to an app for a user.
  ## 
  let valid = call_599137.validator(path, query, header, formData, body)
  let scheme = call_599137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599137.url(scheme.get, call_599137.host, call_599137.base,
                         call_599137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599137, url, valid)

proc call*(call_599138: Call_AndroidenterpriseEntitlementsUpdate_599122;
          enterpriseId: string; entitlementId: string; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          install: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEntitlementsUpdate
  ## Adds or updates an entitlement to an app for a user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   install: bool
  ##          : Set to true to also install the product on all the user's devices where possible. Failure to install on one or more devices will not prevent this operation from returning successfully, as long as the entitlement was successfully assigned to the user.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entitlementId: string (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599139 = newJObject()
  var query_599140 = newJObject()
  var body_599141 = newJObject()
  add(query_599140, "fields", newJString(fields))
  add(query_599140, "quotaUser", newJString(quotaUser))
  add(query_599140, "alt", newJString(alt))
  add(query_599140, "install", newJBool(install))
  add(query_599140, "oauth_token", newJString(oauthToken))
  add(query_599140, "userIp", newJString(userIp))
  add(query_599140, "key", newJString(key))
  add(path_599139, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_599141 = body
  add(query_599140, "prettyPrint", newJBool(prettyPrint))
  add(path_599139, "entitlementId", newJString(entitlementId))
  add(path_599139, "userId", newJString(userId))
  result = call_599138.call(path_599139, query_599140, nil, nil, body_599141)

var androidenterpriseEntitlementsUpdate* = Call_AndroidenterpriseEntitlementsUpdate_599122(
    name: "androidenterpriseEntitlementsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsUpdate_599123,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsUpdate_599124,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsGet_599105 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEntitlementsGet_599107(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "entitlementId" in path, "`entitlementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/entitlements/"),
               (kind: VariableSegment, value: "entitlementId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEntitlementsGet_599106(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of an entitlement.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   entitlementId: JString (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599108 = path.getOrDefault("enterpriseId")
  valid_599108 = validateParameter(valid_599108, JString, required = true,
                                 default = nil)
  if valid_599108 != nil:
    section.add "enterpriseId", valid_599108
  var valid_599109 = path.getOrDefault("entitlementId")
  valid_599109 = validateParameter(valid_599109, JString, required = true,
                                 default = nil)
  if valid_599109 != nil:
    section.add "entitlementId", valid_599109
  var valid_599110 = path.getOrDefault("userId")
  valid_599110 = validateParameter(valid_599110, JString, required = true,
                                 default = nil)
  if valid_599110 != nil:
    section.add "userId", valid_599110
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599111 = query.getOrDefault("fields")
  valid_599111 = validateParameter(valid_599111, JString, required = false,
                                 default = nil)
  if valid_599111 != nil:
    section.add "fields", valid_599111
  var valid_599112 = query.getOrDefault("quotaUser")
  valid_599112 = validateParameter(valid_599112, JString, required = false,
                                 default = nil)
  if valid_599112 != nil:
    section.add "quotaUser", valid_599112
  var valid_599113 = query.getOrDefault("alt")
  valid_599113 = validateParameter(valid_599113, JString, required = false,
                                 default = newJString("json"))
  if valid_599113 != nil:
    section.add "alt", valid_599113
  var valid_599114 = query.getOrDefault("oauth_token")
  valid_599114 = validateParameter(valid_599114, JString, required = false,
                                 default = nil)
  if valid_599114 != nil:
    section.add "oauth_token", valid_599114
  var valid_599115 = query.getOrDefault("userIp")
  valid_599115 = validateParameter(valid_599115, JString, required = false,
                                 default = nil)
  if valid_599115 != nil:
    section.add "userIp", valid_599115
  var valid_599116 = query.getOrDefault("key")
  valid_599116 = validateParameter(valid_599116, JString, required = false,
                                 default = nil)
  if valid_599116 != nil:
    section.add "key", valid_599116
  var valid_599117 = query.getOrDefault("prettyPrint")
  valid_599117 = validateParameter(valid_599117, JBool, required = false,
                                 default = newJBool(true))
  if valid_599117 != nil:
    section.add "prettyPrint", valid_599117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599118: Call_AndroidenterpriseEntitlementsGet_599105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of an entitlement.
  ## 
  let valid = call_599118.validator(path, query, header, formData, body)
  let scheme = call_599118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599118.url(scheme.get, call_599118.host, call_599118.base,
                         call_599118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599118, url, valid)

proc call*(call_599119: Call_AndroidenterpriseEntitlementsGet_599105;
          enterpriseId: string; entitlementId: string; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseEntitlementsGet
  ## Retrieves details of an entitlement.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entitlementId: string (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599120 = newJObject()
  var query_599121 = newJObject()
  add(query_599121, "fields", newJString(fields))
  add(query_599121, "quotaUser", newJString(quotaUser))
  add(query_599121, "alt", newJString(alt))
  add(query_599121, "oauth_token", newJString(oauthToken))
  add(query_599121, "userIp", newJString(userIp))
  add(query_599121, "key", newJString(key))
  add(path_599120, "enterpriseId", newJString(enterpriseId))
  add(query_599121, "prettyPrint", newJBool(prettyPrint))
  add(path_599120, "entitlementId", newJString(entitlementId))
  add(path_599120, "userId", newJString(userId))
  result = call_599119.call(path_599120, query_599121, nil, nil, nil)

var androidenterpriseEntitlementsGet* = Call_AndroidenterpriseEntitlementsGet_599105(
    name: "androidenterpriseEntitlementsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsGet_599106,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsGet_599107,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsPatch_599159 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEntitlementsPatch_599161(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "entitlementId" in path, "`entitlementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/entitlements/"),
               (kind: VariableSegment, value: "entitlementId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEntitlementsPatch_599160(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds or updates an entitlement to an app for a user. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   entitlementId: JString (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599162 = path.getOrDefault("enterpriseId")
  valid_599162 = validateParameter(valid_599162, JString, required = true,
                                 default = nil)
  if valid_599162 != nil:
    section.add "enterpriseId", valid_599162
  var valid_599163 = path.getOrDefault("entitlementId")
  valid_599163 = validateParameter(valid_599163, JString, required = true,
                                 default = nil)
  if valid_599163 != nil:
    section.add "entitlementId", valid_599163
  var valid_599164 = path.getOrDefault("userId")
  valid_599164 = validateParameter(valid_599164, JString, required = true,
                                 default = nil)
  if valid_599164 != nil:
    section.add "userId", valid_599164
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   install: JBool
  ##          : Set to true to also install the product on all the user's devices where possible. Failure to install on one or more devices will not prevent this operation from returning successfully, as long as the entitlement was successfully assigned to the user.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599165 = query.getOrDefault("fields")
  valid_599165 = validateParameter(valid_599165, JString, required = false,
                                 default = nil)
  if valid_599165 != nil:
    section.add "fields", valid_599165
  var valid_599166 = query.getOrDefault("quotaUser")
  valid_599166 = validateParameter(valid_599166, JString, required = false,
                                 default = nil)
  if valid_599166 != nil:
    section.add "quotaUser", valid_599166
  var valid_599167 = query.getOrDefault("alt")
  valid_599167 = validateParameter(valid_599167, JString, required = false,
                                 default = newJString("json"))
  if valid_599167 != nil:
    section.add "alt", valid_599167
  var valid_599168 = query.getOrDefault("install")
  valid_599168 = validateParameter(valid_599168, JBool, required = false, default = nil)
  if valid_599168 != nil:
    section.add "install", valid_599168
  var valid_599169 = query.getOrDefault("oauth_token")
  valid_599169 = validateParameter(valid_599169, JString, required = false,
                                 default = nil)
  if valid_599169 != nil:
    section.add "oauth_token", valid_599169
  var valid_599170 = query.getOrDefault("userIp")
  valid_599170 = validateParameter(valid_599170, JString, required = false,
                                 default = nil)
  if valid_599170 != nil:
    section.add "userIp", valid_599170
  var valid_599171 = query.getOrDefault("key")
  valid_599171 = validateParameter(valid_599171, JString, required = false,
                                 default = nil)
  if valid_599171 != nil:
    section.add "key", valid_599171
  var valid_599172 = query.getOrDefault("prettyPrint")
  valid_599172 = validateParameter(valid_599172, JBool, required = false,
                                 default = newJBool(true))
  if valid_599172 != nil:
    section.add "prettyPrint", valid_599172
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

proc call*(call_599174: Call_AndroidenterpriseEntitlementsPatch_599159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates an entitlement to an app for a user. This method supports patch semantics.
  ## 
  let valid = call_599174.validator(path, query, header, formData, body)
  let scheme = call_599174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599174.url(scheme.get, call_599174.host, call_599174.base,
                         call_599174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599174, url, valid)

proc call*(call_599175: Call_AndroidenterpriseEntitlementsPatch_599159;
          enterpriseId: string; entitlementId: string; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          install: bool = false; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseEntitlementsPatch
  ## Adds or updates an entitlement to an app for a user. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   install: bool
  ##          : Set to true to also install the product on all the user's devices where possible. Failure to install on one or more devices will not prevent this operation from returning successfully, as long as the entitlement was successfully assigned to the user.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entitlementId: string (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599176 = newJObject()
  var query_599177 = newJObject()
  var body_599178 = newJObject()
  add(query_599177, "fields", newJString(fields))
  add(query_599177, "quotaUser", newJString(quotaUser))
  add(query_599177, "alt", newJString(alt))
  add(query_599177, "install", newJBool(install))
  add(query_599177, "oauth_token", newJString(oauthToken))
  add(query_599177, "userIp", newJString(userIp))
  add(query_599177, "key", newJString(key))
  add(path_599176, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_599178 = body
  add(query_599177, "prettyPrint", newJBool(prettyPrint))
  add(path_599176, "entitlementId", newJString(entitlementId))
  add(path_599176, "userId", newJString(userId))
  result = call_599175.call(path_599176, query_599177, nil, nil, body_599178)

var androidenterpriseEntitlementsPatch* = Call_AndroidenterpriseEntitlementsPatch_599159(
    name: "androidenterpriseEntitlementsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsPatch_599160,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsPatch_599161,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsDelete_599142 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseEntitlementsDelete_599144(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "entitlementId" in path, "`entitlementId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/entitlements/"),
               (kind: VariableSegment, value: "entitlementId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEntitlementsDelete_599143(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Removes an entitlement to an app for a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   entitlementId: JString (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599145 = path.getOrDefault("enterpriseId")
  valid_599145 = validateParameter(valid_599145, JString, required = true,
                                 default = nil)
  if valid_599145 != nil:
    section.add "enterpriseId", valid_599145
  var valid_599146 = path.getOrDefault("entitlementId")
  valid_599146 = validateParameter(valid_599146, JString, required = true,
                                 default = nil)
  if valid_599146 != nil:
    section.add "entitlementId", valid_599146
  var valid_599147 = path.getOrDefault("userId")
  valid_599147 = validateParameter(valid_599147, JString, required = true,
                                 default = nil)
  if valid_599147 != nil:
    section.add "userId", valid_599147
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599148 = query.getOrDefault("fields")
  valid_599148 = validateParameter(valid_599148, JString, required = false,
                                 default = nil)
  if valid_599148 != nil:
    section.add "fields", valid_599148
  var valid_599149 = query.getOrDefault("quotaUser")
  valid_599149 = validateParameter(valid_599149, JString, required = false,
                                 default = nil)
  if valid_599149 != nil:
    section.add "quotaUser", valid_599149
  var valid_599150 = query.getOrDefault("alt")
  valid_599150 = validateParameter(valid_599150, JString, required = false,
                                 default = newJString("json"))
  if valid_599150 != nil:
    section.add "alt", valid_599150
  var valid_599151 = query.getOrDefault("oauth_token")
  valid_599151 = validateParameter(valid_599151, JString, required = false,
                                 default = nil)
  if valid_599151 != nil:
    section.add "oauth_token", valid_599151
  var valid_599152 = query.getOrDefault("userIp")
  valid_599152 = validateParameter(valid_599152, JString, required = false,
                                 default = nil)
  if valid_599152 != nil:
    section.add "userIp", valid_599152
  var valid_599153 = query.getOrDefault("key")
  valid_599153 = validateParameter(valid_599153, JString, required = false,
                                 default = nil)
  if valid_599153 != nil:
    section.add "key", valid_599153
  var valid_599154 = query.getOrDefault("prettyPrint")
  valid_599154 = validateParameter(valid_599154, JBool, required = false,
                                 default = newJBool(true))
  if valid_599154 != nil:
    section.add "prettyPrint", valid_599154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599155: Call_AndroidenterpriseEntitlementsDelete_599142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes an entitlement to an app for a user.
  ## 
  let valid = call_599155.validator(path, query, header, formData, body)
  let scheme = call_599155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599155.url(scheme.get, call_599155.host, call_599155.base,
                         call_599155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599155, url, valid)

proc call*(call_599156: Call_AndroidenterpriseEntitlementsDelete_599142;
          enterpriseId: string; entitlementId: string; userId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseEntitlementsDelete
  ## Removes an entitlement to an app for a user.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entitlementId: string (required)
  ##                : The ID of the entitlement (a product ID), e.g. "app:com.google.android.gm".
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599157 = newJObject()
  var query_599158 = newJObject()
  add(query_599158, "fields", newJString(fields))
  add(query_599158, "quotaUser", newJString(quotaUser))
  add(query_599158, "alt", newJString(alt))
  add(query_599158, "oauth_token", newJString(oauthToken))
  add(query_599158, "userIp", newJString(userIp))
  add(query_599158, "key", newJString(key))
  add(path_599157, "enterpriseId", newJString(enterpriseId))
  add(query_599158, "prettyPrint", newJBool(prettyPrint))
  add(path_599157, "entitlementId", newJString(entitlementId))
  add(path_599157, "userId", newJString(userId))
  result = call_599156.call(path_599157, query_599158, nil, nil, nil)

var androidenterpriseEntitlementsDelete* = Call_AndroidenterpriseEntitlementsDelete_599142(
    name: "androidenterpriseEntitlementsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsDelete_599143,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsDelete_599144,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserList_599179 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseManagedconfigurationsforuserList_599181(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/managedConfigurationsForUser")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsforuserList_599180(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all the per-user managed configurations for the specified user. Only the ID is set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599182 = path.getOrDefault("enterpriseId")
  valid_599182 = validateParameter(valid_599182, JString, required = true,
                                 default = nil)
  if valid_599182 != nil:
    section.add "enterpriseId", valid_599182
  var valid_599183 = path.getOrDefault("userId")
  valid_599183 = validateParameter(valid_599183, JString, required = true,
                                 default = nil)
  if valid_599183 != nil:
    section.add "userId", valid_599183
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599184 = query.getOrDefault("fields")
  valid_599184 = validateParameter(valid_599184, JString, required = false,
                                 default = nil)
  if valid_599184 != nil:
    section.add "fields", valid_599184
  var valid_599185 = query.getOrDefault("quotaUser")
  valid_599185 = validateParameter(valid_599185, JString, required = false,
                                 default = nil)
  if valid_599185 != nil:
    section.add "quotaUser", valid_599185
  var valid_599186 = query.getOrDefault("alt")
  valid_599186 = validateParameter(valid_599186, JString, required = false,
                                 default = newJString("json"))
  if valid_599186 != nil:
    section.add "alt", valid_599186
  var valid_599187 = query.getOrDefault("oauth_token")
  valid_599187 = validateParameter(valid_599187, JString, required = false,
                                 default = nil)
  if valid_599187 != nil:
    section.add "oauth_token", valid_599187
  var valid_599188 = query.getOrDefault("userIp")
  valid_599188 = validateParameter(valid_599188, JString, required = false,
                                 default = nil)
  if valid_599188 != nil:
    section.add "userIp", valid_599188
  var valid_599189 = query.getOrDefault("key")
  valid_599189 = validateParameter(valid_599189, JString, required = false,
                                 default = nil)
  if valid_599189 != nil:
    section.add "key", valid_599189
  var valid_599190 = query.getOrDefault("prettyPrint")
  valid_599190 = validateParameter(valid_599190, JBool, required = false,
                                 default = newJBool(true))
  if valid_599190 != nil:
    section.add "prettyPrint", valid_599190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599191: Call_AndroidenterpriseManagedconfigurationsforuserList_599179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the per-user managed configurations for the specified user. Only the ID is set.
  ## 
  let valid = call_599191.validator(path, query, header, formData, body)
  let scheme = call_599191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599191.url(scheme.get, call_599191.host, call_599191.base,
                         call_599191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599191, url, valid)

proc call*(call_599192: Call_AndroidenterpriseManagedconfigurationsforuserList_599179;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseManagedconfigurationsforuserList
  ## Lists all the per-user managed configurations for the specified user. Only the ID is set.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599193 = newJObject()
  var query_599194 = newJObject()
  add(query_599194, "fields", newJString(fields))
  add(query_599194, "quotaUser", newJString(quotaUser))
  add(query_599194, "alt", newJString(alt))
  add(query_599194, "oauth_token", newJString(oauthToken))
  add(query_599194, "userIp", newJString(userIp))
  add(query_599194, "key", newJString(key))
  add(path_599193, "enterpriseId", newJString(enterpriseId))
  add(query_599194, "prettyPrint", newJBool(prettyPrint))
  add(path_599193, "userId", newJString(userId))
  result = call_599192.call(path_599193, query_599194, nil, nil, nil)

var androidenterpriseManagedconfigurationsforuserList* = Call_AndroidenterpriseManagedconfigurationsforuserList_599179(
    name: "androidenterpriseManagedconfigurationsforuserList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserList_599180,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserList_599181,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserUpdate_599212 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseManagedconfigurationsforuserUpdate_599214(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "managedConfigurationForUserId" in path,
        "`managedConfigurationForUserId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForUser/"),
               (kind: VariableSegment, value: "managedConfigurationForUserId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsforuserUpdate_599213(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   managedConfigurationForUserId: JString (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599215 = path.getOrDefault("enterpriseId")
  valid_599215 = validateParameter(valid_599215, JString, required = true,
                                 default = nil)
  if valid_599215 != nil:
    section.add "enterpriseId", valid_599215
  var valid_599216 = path.getOrDefault("managedConfigurationForUserId")
  valid_599216 = validateParameter(valid_599216, JString, required = true,
                                 default = nil)
  if valid_599216 != nil:
    section.add "managedConfigurationForUserId", valid_599216
  var valid_599217 = path.getOrDefault("userId")
  valid_599217 = validateParameter(valid_599217, JString, required = true,
                                 default = nil)
  if valid_599217 != nil:
    section.add "userId", valid_599217
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599218 = query.getOrDefault("fields")
  valid_599218 = validateParameter(valid_599218, JString, required = false,
                                 default = nil)
  if valid_599218 != nil:
    section.add "fields", valid_599218
  var valid_599219 = query.getOrDefault("quotaUser")
  valid_599219 = validateParameter(valid_599219, JString, required = false,
                                 default = nil)
  if valid_599219 != nil:
    section.add "quotaUser", valid_599219
  var valid_599220 = query.getOrDefault("alt")
  valid_599220 = validateParameter(valid_599220, JString, required = false,
                                 default = newJString("json"))
  if valid_599220 != nil:
    section.add "alt", valid_599220
  var valid_599221 = query.getOrDefault("oauth_token")
  valid_599221 = validateParameter(valid_599221, JString, required = false,
                                 default = nil)
  if valid_599221 != nil:
    section.add "oauth_token", valid_599221
  var valid_599222 = query.getOrDefault("userIp")
  valid_599222 = validateParameter(valid_599222, JString, required = false,
                                 default = nil)
  if valid_599222 != nil:
    section.add "userIp", valid_599222
  var valid_599223 = query.getOrDefault("key")
  valid_599223 = validateParameter(valid_599223, JString, required = false,
                                 default = nil)
  if valid_599223 != nil:
    section.add "key", valid_599223
  var valid_599224 = query.getOrDefault("prettyPrint")
  valid_599224 = validateParameter(valid_599224, JBool, required = false,
                                 default = newJBool(true))
  if valid_599224 != nil:
    section.add "prettyPrint", valid_599224
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

proc call*(call_599226: Call_AndroidenterpriseManagedconfigurationsforuserUpdate_599212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties.
  ## 
  let valid = call_599226.validator(path, query, header, formData, body)
  let scheme = call_599226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599226.url(scheme.get, call_599226.host, call_599226.base,
                         call_599226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599226, url, valid)

proc call*(call_599227: Call_AndroidenterpriseManagedconfigurationsforuserUpdate_599212;
          enterpriseId: string; managedConfigurationForUserId: string;
          userId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseManagedconfigurationsforuserUpdate
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   managedConfigurationForUserId: string (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599228 = newJObject()
  var query_599229 = newJObject()
  var body_599230 = newJObject()
  add(query_599229, "fields", newJString(fields))
  add(query_599229, "quotaUser", newJString(quotaUser))
  add(query_599229, "alt", newJString(alt))
  add(query_599229, "oauth_token", newJString(oauthToken))
  add(query_599229, "userIp", newJString(userIp))
  add(query_599229, "key", newJString(key))
  add(path_599228, "enterpriseId", newJString(enterpriseId))
  add(path_599228, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  if body != nil:
    body_599230 = body
  add(query_599229, "prettyPrint", newJBool(prettyPrint))
  add(path_599228, "userId", newJString(userId))
  result = call_599227.call(path_599228, query_599229, nil, nil, body_599230)

var androidenterpriseManagedconfigurationsforuserUpdate* = Call_AndroidenterpriseManagedconfigurationsforuserUpdate_599212(
    name: "androidenterpriseManagedconfigurationsforuserUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserUpdate_599213,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserUpdate_599214,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserGet_599195 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseManagedconfigurationsforuserGet_599197(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "managedConfigurationForUserId" in path,
        "`managedConfigurationForUserId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForUser/"),
               (kind: VariableSegment, value: "managedConfigurationForUserId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsforuserGet_599196(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves details of a per-user managed configuration for an app for the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   managedConfigurationForUserId: JString (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599198 = path.getOrDefault("enterpriseId")
  valid_599198 = validateParameter(valid_599198, JString, required = true,
                                 default = nil)
  if valid_599198 != nil:
    section.add "enterpriseId", valid_599198
  var valid_599199 = path.getOrDefault("managedConfigurationForUserId")
  valid_599199 = validateParameter(valid_599199, JString, required = true,
                                 default = nil)
  if valid_599199 != nil:
    section.add "managedConfigurationForUserId", valid_599199
  var valid_599200 = path.getOrDefault("userId")
  valid_599200 = validateParameter(valid_599200, JString, required = true,
                                 default = nil)
  if valid_599200 != nil:
    section.add "userId", valid_599200
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599201 = query.getOrDefault("fields")
  valid_599201 = validateParameter(valid_599201, JString, required = false,
                                 default = nil)
  if valid_599201 != nil:
    section.add "fields", valid_599201
  var valid_599202 = query.getOrDefault("quotaUser")
  valid_599202 = validateParameter(valid_599202, JString, required = false,
                                 default = nil)
  if valid_599202 != nil:
    section.add "quotaUser", valid_599202
  var valid_599203 = query.getOrDefault("alt")
  valid_599203 = validateParameter(valid_599203, JString, required = false,
                                 default = newJString("json"))
  if valid_599203 != nil:
    section.add "alt", valid_599203
  var valid_599204 = query.getOrDefault("oauth_token")
  valid_599204 = validateParameter(valid_599204, JString, required = false,
                                 default = nil)
  if valid_599204 != nil:
    section.add "oauth_token", valid_599204
  var valid_599205 = query.getOrDefault("userIp")
  valid_599205 = validateParameter(valid_599205, JString, required = false,
                                 default = nil)
  if valid_599205 != nil:
    section.add "userIp", valid_599205
  var valid_599206 = query.getOrDefault("key")
  valid_599206 = validateParameter(valid_599206, JString, required = false,
                                 default = nil)
  if valid_599206 != nil:
    section.add "key", valid_599206
  var valid_599207 = query.getOrDefault("prettyPrint")
  valid_599207 = validateParameter(valid_599207, JBool, required = false,
                                 default = newJBool(true))
  if valid_599207 != nil:
    section.add "prettyPrint", valid_599207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599208: Call_AndroidenterpriseManagedconfigurationsforuserGet_599195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a per-user managed configuration for an app for the specified user.
  ## 
  let valid = call_599208.validator(path, query, header, formData, body)
  let scheme = call_599208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599208.url(scheme.get, call_599208.host, call_599208.base,
                         call_599208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599208, url, valid)

proc call*(call_599209: Call_AndroidenterpriseManagedconfigurationsforuserGet_599195;
          enterpriseId: string; managedConfigurationForUserId: string;
          userId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseManagedconfigurationsforuserGet
  ## Retrieves details of a per-user managed configuration for an app for the specified user.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   managedConfigurationForUserId: string (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599210 = newJObject()
  var query_599211 = newJObject()
  add(query_599211, "fields", newJString(fields))
  add(query_599211, "quotaUser", newJString(quotaUser))
  add(query_599211, "alt", newJString(alt))
  add(query_599211, "oauth_token", newJString(oauthToken))
  add(query_599211, "userIp", newJString(userIp))
  add(query_599211, "key", newJString(key))
  add(path_599210, "enterpriseId", newJString(enterpriseId))
  add(path_599210, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  add(query_599211, "prettyPrint", newJBool(prettyPrint))
  add(path_599210, "userId", newJString(userId))
  result = call_599209.call(path_599210, query_599211, nil, nil, nil)

var androidenterpriseManagedconfigurationsforuserGet* = Call_AndroidenterpriseManagedconfigurationsforuserGet_599195(
    name: "androidenterpriseManagedconfigurationsforuserGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserGet_599196,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserGet_599197,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserPatch_599248 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseManagedconfigurationsforuserPatch_599250(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "managedConfigurationForUserId" in path,
        "`managedConfigurationForUserId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForUser/"),
               (kind: VariableSegment, value: "managedConfigurationForUserId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsforuserPatch_599249(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   managedConfigurationForUserId: JString (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599251 = path.getOrDefault("enterpriseId")
  valid_599251 = validateParameter(valid_599251, JString, required = true,
                                 default = nil)
  if valid_599251 != nil:
    section.add "enterpriseId", valid_599251
  var valid_599252 = path.getOrDefault("managedConfigurationForUserId")
  valid_599252 = validateParameter(valid_599252, JString, required = true,
                                 default = nil)
  if valid_599252 != nil:
    section.add "managedConfigurationForUserId", valid_599252
  var valid_599253 = path.getOrDefault("userId")
  valid_599253 = validateParameter(valid_599253, JString, required = true,
                                 default = nil)
  if valid_599253 != nil:
    section.add "userId", valid_599253
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599254 = query.getOrDefault("fields")
  valid_599254 = validateParameter(valid_599254, JString, required = false,
                                 default = nil)
  if valid_599254 != nil:
    section.add "fields", valid_599254
  var valid_599255 = query.getOrDefault("quotaUser")
  valid_599255 = validateParameter(valid_599255, JString, required = false,
                                 default = nil)
  if valid_599255 != nil:
    section.add "quotaUser", valid_599255
  var valid_599256 = query.getOrDefault("alt")
  valid_599256 = validateParameter(valid_599256, JString, required = false,
                                 default = newJString("json"))
  if valid_599256 != nil:
    section.add "alt", valid_599256
  var valid_599257 = query.getOrDefault("oauth_token")
  valid_599257 = validateParameter(valid_599257, JString, required = false,
                                 default = nil)
  if valid_599257 != nil:
    section.add "oauth_token", valid_599257
  var valid_599258 = query.getOrDefault("userIp")
  valid_599258 = validateParameter(valid_599258, JString, required = false,
                                 default = nil)
  if valid_599258 != nil:
    section.add "userIp", valid_599258
  var valid_599259 = query.getOrDefault("key")
  valid_599259 = validateParameter(valid_599259, JString, required = false,
                                 default = nil)
  if valid_599259 != nil:
    section.add "key", valid_599259
  var valid_599260 = query.getOrDefault("prettyPrint")
  valid_599260 = validateParameter(valid_599260, JBool, required = false,
                                 default = newJBool(true))
  if valid_599260 != nil:
    section.add "prettyPrint", valid_599260
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

proc call*(call_599262: Call_AndroidenterpriseManagedconfigurationsforuserPatch_599248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties. This method supports patch semantics.
  ## 
  let valid = call_599262.validator(path, query, header, formData, body)
  let scheme = call_599262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599262.url(scheme.get, call_599262.host, call_599262.base,
                         call_599262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599262, url, valid)

proc call*(call_599263: Call_AndroidenterpriseManagedconfigurationsforuserPatch_599248;
          enterpriseId: string; managedConfigurationForUserId: string;
          userId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseManagedconfigurationsforuserPatch
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties. This method supports patch semantics.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   managedConfigurationForUserId: string (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599264 = newJObject()
  var query_599265 = newJObject()
  var body_599266 = newJObject()
  add(query_599265, "fields", newJString(fields))
  add(query_599265, "quotaUser", newJString(quotaUser))
  add(query_599265, "alt", newJString(alt))
  add(query_599265, "oauth_token", newJString(oauthToken))
  add(query_599265, "userIp", newJString(userIp))
  add(query_599265, "key", newJString(key))
  add(path_599264, "enterpriseId", newJString(enterpriseId))
  add(path_599264, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  if body != nil:
    body_599266 = body
  add(query_599265, "prettyPrint", newJBool(prettyPrint))
  add(path_599264, "userId", newJString(userId))
  result = call_599263.call(path_599264, query_599265, nil, nil, body_599266)

var androidenterpriseManagedconfigurationsforuserPatch* = Call_AndroidenterpriseManagedconfigurationsforuserPatch_599248(
    name: "androidenterpriseManagedconfigurationsforuserPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserPatch_599249,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserPatch_599250,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserDelete_599231 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseManagedconfigurationsforuserDelete_599233(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  assert "managedConfigurationForUserId" in path,
        "`managedConfigurationForUserId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"), (kind: ConstantSegment,
        value: "/managedConfigurationsForUser/"),
               (kind: VariableSegment, value: "managedConfigurationForUserId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseManagedconfigurationsforuserDelete_599232(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Removes a per-user managed configuration for an app for the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   managedConfigurationForUserId: JString (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599234 = path.getOrDefault("enterpriseId")
  valid_599234 = validateParameter(valid_599234, JString, required = true,
                                 default = nil)
  if valid_599234 != nil:
    section.add "enterpriseId", valid_599234
  var valid_599235 = path.getOrDefault("managedConfigurationForUserId")
  valid_599235 = validateParameter(valid_599235, JString, required = true,
                                 default = nil)
  if valid_599235 != nil:
    section.add "managedConfigurationForUserId", valid_599235
  var valid_599236 = path.getOrDefault("userId")
  valid_599236 = validateParameter(valid_599236, JString, required = true,
                                 default = nil)
  if valid_599236 != nil:
    section.add "userId", valid_599236
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599237 = query.getOrDefault("fields")
  valid_599237 = validateParameter(valid_599237, JString, required = false,
                                 default = nil)
  if valid_599237 != nil:
    section.add "fields", valid_599237
  var valid_599238 = query.getOrDefault("quotaUser")
  valid_599238 = validateParameter(valid_599238, JString, required = false,
                                 default = nil)
  if valid_599238 != nil:
    section.add "quotaUser", valid_599238
  var valid_599239 = query.getOrDefault("alt")
  valid_599239 = validateParameter(valid_599239, JString, required = false,
                                 default = newJString("json"))
  if valid_599239 != nil:
    section.add "alt", valid_599239
  var valid_599240 = query.getOrDefault("oauth_token")
  valid_599240 = validateParameter(valid_599240, JString, required = false,
                                 default = nil)
  if valid_599240 != nil:
    section.add "oauth_token", valid_599240
  var valid_599241 = query.getOrDefault("userIp")
  valid_599241 = validateParameter(valid_599241, JString, required = false,
                                 default = nil)
  if valid_599241 != nil:
    section.add "userIp", valid_599241
  var valid_599242 = query.getOrDefault("key")
  valid_599242 = validateParameter(valid_599242, JString, required = false,
                                 default = nil)
  if valid_599242 != nil:
    section.add "key", valid_599242
  var valid_599243 = query.getOrDefault("prettyPrint")
  valid_599243 = validateParameter(valid_599243, JBool, required = false,
                                 default = newJBool(true))
  if valid_599243 != nil:
    section.add "prettyPrint", valid_599243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599244: Call_AndroidenterpriseManagedconfigurationsforuserDelete_599231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a per-user managed configuration for an app for the specified user.
  ## 
  let valid = call_599244.validator(path, query, header, formData, body)
  let scheme = call_599244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599244.url(scheme.get, call_599244.host, call_599244.base,
                         call_599244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599244, url, valid)

proc call*(call_599245: Call_AndroidenterpriseManagedconfigurationsforuserDelete_599231;
          enterpriseId: string; managedConfigurationForUserId: string;
          userId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseManagedconfigurationsforuserDelete
  ## Removes a per-user managed configuration for an app for the specified user.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   managedConfigurationForUserId: string (required)
  ##                                : The ID of the managed configuration (a product ID), e.g. "app:com.google.android.gm".
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599246 = newJObject()
  var query_599247 = newJObject()
  add(query_599247, "fields", newJString(fields))
  add(query_599247, "quotaUser", newJString(quotaUser))
  add(query_599247, "alt", newJString(alt))
  add(query_599247, "oauth_token", newJString(oauthToken))
  add(query_599247, "userIp", newJString(userIp))
  add(query_599247, "key", newJString(key))
  add(path_599246, "enterpriseId", newJString(enterpriseId))
  add(path_599246, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  add(query_599247, "prettyPrint", newJBool(prettyPrint))
  add(path_599246, "userId", newJString(userId))
  result = call_599245.call(path_599246, query_599247, nil, nil, nil)

var androidenterpriseManagedconfigurationsforuserDelete* = Call_AndroidenterpriseManagedconfigurationsforuserDelete_599231(
    name: "androidenterpriseManagedconfigurationsforuserDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserDelete_599232,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserDelete_599233,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGenerateToken_599267 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseUsersGenerateToken_599269(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersGenerateToken_599268(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates a token (activation code) to allow this user to configure their managed account in the Android Setup Wizard. Revokes any previously generated token.
  ## 
  ## This call only works with Google managed accounts.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599270 = path.getOrDefault("enterpriseId")
  valid_599270 = validateParameter(valid_599270, JString, required = true,
                                 default = nil)
  if valid_599270 != nil:
    section.add "enterpriseId", valid_599270
  var valid_599271 = path.getOrDefault("userId")
  valid_599271 = validateParameter(valid_599271, JString, required = true,
                                 default = nil)
  if valid_599271 != nil:
    section.add "userId", valid_599271
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599272 = query.getOrDefault("fields")
  valid_599272 = validateParameter(valid_599272, JString, required = false,
                                 default = nil)
  if valid_599272 != nil:
    section.add "fields", valid_599272
  var valid_599273 = query.getOrDefault("quotaUser")
  valid_599273 = validateParameter(valid_599273, JString, required = false,
                                 default = nil)
  if valid_599273 != nil:
    section.add "quotaUser", valid_599273
  var valid_599274 = query.getOrDefault("alt")
  valid_599274 = validateParameter(valid_599274, JString, required = false,
                                 default = newJString("json"))
  if valid_599274 != nil:
    section.add "alt", valid_599274
  var valid_599275 = query.getOrDefault("oauth_token")
  valid_599275 = validateParameter(valid_599275, JString, required = false,
                                 default = nil)
  if valid_599275 != nil:
    section.add "oauth_token", valid_599275
  var valid_599276 = query.getOrDefault("userIp")
  valid_599276 = validateParameter(valid_599276, JString, required = false,
                                 default = nil)
  if valid_599276 != nil:
    section.add "userIp", valid_599276
  var valid_599277 = query.getOrDefault("key")
  valid_599277 = validateParameter(valid_599277, JString, required = false,
                                 default = nil)
  if valid_599277 != nil:
    section.add "key", valid_599277
  var valid_599278 = query.getOrDefault("prettyPrint")
  valid_599278 = validateParameter(valid_599278, JBool, required = false,
                                 default = newJBool(true))
  if valid_599278 != nil:
    section.add "prettyPrint", valid_599278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599279: Call_AndroidenterpriseUsersGenerateToken_599267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a token (activation code) to allow this user to configure their managed account in the Android Setup Wizard. Revokes any previously generated token.
  ## 
  ## This call only works with Google managed accounts.
  ## 
  let valid = call_599279.validator(path, query, header, formData, body)
  let scheme = call_599279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599279.url(scheme.get, call_599279.host, call_599279.base,
                         call_599279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599279, url, valid)

proc call*(call_599280: Call_AndroidenterpriseUsersGenerateToken_599267;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseUsersGenerateToken
  ## Generates a token (activation code) to allow this user to configure their managed account in the Android Setup Wizard. Revokes any previously generated token.
  ## 
  ## This call only works with Google managed accounts.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599281 = newJObject()
  var query_599282 = newJObject()
  add(query_599282, "fields", newJString(fields))
  add(query_599282, "quotaUser", newJString(quotaUser))
  add(query_599282, "alt", newJString(alt))
  add(query_599282, "oauth_token", newJString(oauthToken))
  add(query_599282, "userIp", newJString(userIp))
  add(query_599282, "key", newJString(key))
  add(path_599281, "enterpriseId", newJString(enterpriseId))
  add(query_599282, "prettyPrint", newJBool(prettyPrint))
  add(path_599281, "userId", newJString(userId))
  result = call_599280.call(path_599281, query_599282, nil, nil, nil)

var androidenterpriseUsersGenerateToken* = Call_AndroidenterpriseUsersGenerateToken_599267(
    name: "androidenterpriseUsersGenerateToken", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/token",
    validator: validate_AndroidenterpriseUsersGenerateToken_599268,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersGenerateToken_599269,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersRevokeToken_599283 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseUsersRevokeToken_599285(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "userId" in path, "`userId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userId"),
               (kind: ConstantSegment, value: "/token")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseUsersRevokeToken_599284(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Revokes a previously generated token (activation code) for the user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  ##   userId: JString (required)
  ##         : The ID of the user.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599286 = path.getOrDefault("enterpriseId")
  valid_599286 = validateParameter(valid_599286, JString, required = true,
                                 default = nil)
  if valid_599286 != nil:
    section.add "enterpriseId", valid_599286
  var valid_599287 = path.getOrDefault("userId")
  valid_599287 = validateParameter(valid_599287, JString, required = true,
                                 default = nil)
  if valid_599287 != nil:
    section.add "userId", valid_599287
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599288 = query.getOrDefault("fields")
  valid_599288 = validateParameter(valid_599288, JString, required = false,
                                 default = nil)
  if valid_599288 != nil:
    section.add "fields", valid_599288
  var valid_599289 = query.getOrDefault("quotaUser")
  valid_599289 = validateParameter(valid_599289, JString, required = false,
                                 default = nil)
  if valid_599289 != nil:
    section.add "quotaUser", valid_599289
  var valid_599290 = query.getOrDefault("alt")
  valid_599290 = validateParameter(valid_599290, JString, required = false,
                                 default = newJString("json"))
  if valid_599290 != nil:
    section.add "alt", valid_599290
  var valid_599291 = query.getOrDefault("oauth_token")
  valid_599291 = validateParameter(valid_599291, JString, required = false,
                                 default = nil)
  if valid_599291 != nil:
    section.add "oauth_token", valid_599291
  var valid_599292 = query.getOrDefault("userIp")
  valid_599292 = validateParameter(valid_599292, JString, required = false,
                                 default = nil)
  if valid_599292 != nil:
    section.add "userIp", valid_599292
  var valid_599293 = query.getOrDefault("key")
  valid_599293 = validateParameter(valid_599293, JString, required = false,
                                 default = nil)
  if valid_599293 != nil:
    section.add "key", valid_599293
  var valid_599294 = query.getOrDefault("prettyPrint")
  valid_599294 = validateParameter(valid_599294, JBool, required = false,
                                 default = newJBool(true))
  if valid_599294 != nil:
    section.add "prettyPrint", valid_599294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599295: Call_AndroidenterpriseUsersRevokeToken_599283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes a previously generated token (activation code) for the user.
  ## 
  let valid = call_599295.validator(path, query, header, formData, body)
  let scheme = call_599295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599295.url(scheme.get, call_599295.host, call_599295.base,
                         call_599295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599295, url, valid)

proc call*(call_599296: Call_AndroidenterpriseUsersRevokeToken_599283;
          enterpriseId: string; userId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseUsersRevokeToken
  ## Revokes a previously generated token (activation code) for the user.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userId: string (required)
  ##         : The ID of the user.
  var path_599297 = newJObject()
  var query_599298 = newJObject()
  add(query_599298, "fields", newJString(fields))
  add(query_599298, "quotaUser", newJString(quotaUser))
  add(query_599298, "alt", newJString(alt))
  add(query_599298, "oauth_token", newJString(oauthToken))
  add(query_599298, "userIp", newJString(userIp))
  add(query_599298, "key", newJString(key))
  add(path_599297, "enterpriseId", newJString(enterpriseId))
  add(query_599298, "prettyPrint", newJBool(prettyPrint))
  add(path_599297, "userId", newJString(userId))
  result = call_599296.call(path_599297, query_599298, nil, nil, nil)

var androidenterpriseUsersRevokeToken* = Call_AndroidenterpriseUsersRevokeToken_599283(
    name: "androidenterpriseUsersRevokeToken", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/token",
    validator: validate_AndroidenterpriseUsersRevokeToken_599284,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersRevokeToken_599285,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsInsert_599314 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseWebappsInsert_599316(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/webApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseWebappsInsert_599315(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new web app for the enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599317 = path.getOrDefault("enterpriseId")
  valid_599317 = validateParameter(valid_599317, JString, required = true,
                                 default = nil)
  if valid_599317 != nil:
    section.add "enterpriseId", valid_599317
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599318 = query.getOrDefault("fields")
  valid_599318 = validateParameter(valid_599318, JString, required = false,
                                 default = nil)
  if valid_599318 != nil:
    section.add "fields", valid_599318
  var valid_599319 = query.getOrDefault("quotaUser")
  valid_599319 = validateParameter(valid_599319, JString, required = false,
                                 default = nil)
  if valid_599319 != nil:
    section.add "quotaUser", valid_599319
  var valid_599320 = query.getOrDefault("alt")
  valid_599320 = validateParameter(valid_599320, JString, required = false,
                                 default = newJString("json"))
  if valid_599320 != nil:
    section.add "alt", valid_599320
  var valid_599321 = query.getOrDefault("oauth_token")
  valid_599321 = validateParameter(valid_599321, JString, required = false,
                                 default = nil)
  if valid_599321 != nil:
    section.add "oauth_token", valid_599321
  var valid_599322 = query.getOrDefault("userIp")
  valid_599322 = validateParameter(valid_599322, JString, required = false,
                                 default = nil)
  if valid_599322 != nil:
    section.add "userIp", valid_599322
  var valid_599323 = query.getOrDefault("key")
  valid_599323 = validateParameter(valid_599323, JString, required = false,
                                 default = nil)
  if valid_599323 != nil:
    section.add "key", valid_599323
  var valid_599324 = query.getOrDefault("prettyPrint")
  valid_599324 = validateParameter(valid_599324, JBool, required = false,
                                 default = newJBool(true))
  if valid_599324 != nil:
    section.add "prettyPrint", valid_599324
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

proc call*(call_599326: Call_AndroidenterpriseWebappsInsert_599314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new web app for the enterprise.
  ## 
  let valid = call_599326.validator(path, query, header, formData, body)
  let scheme = call_599326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599326.url(scheme.get, call_599326.host, call_599326.base,
                         call_599326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599326, url, valid)

proc call*(call_599327: Call_AndroidenterpriseWebappsInsert_599314;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## androidenterpriseWebappsInsert
  ## Creates a new web app for the enterprise.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599328 = newJObject()
  var query_599329 = newJObject()
  var body_599330 = newJObject()
  add(query_599329, "fields", newJString(fields))
  add(query_599329, "quotaUser", newJString(quotaUser))
  add(query_599329, "alt", newJString(alt))
  add(query_599329, "oauth_token", newJString(oauthToken))
  add(query_599329, "userIp", newJString(userIp))
  add(query_599329, "key", newJString(key))
  add(path_599328, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_599330 = body
  add(query_599329, "prettyPrint", newJBool(prettyPrint))
  result = call_599327.call(path_599328, query_599329, nil, nil, body_599330)

var androidenterpriseWebappsInsert* = Call_AndroidenterpriseWebappsInsert_599314(
    name: "androidenterpriseWebappsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/webApps",
    validator: validate_AndroidenterpriseWebappsInsert_599315,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsInsert_599316,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsList_599299 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseWebappsList_599301(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/webApps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseWebappsList_599300(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves the details of all web apps for a given enterprise.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `enterpriseId` field"
  var valid_599302 = path.getOrDefault("enterpriseId")
  valid_599302 = validateParameter(valid_599302, JString, required = true,
                                 default = nil)
  if valid_599302 != nil:
    section.add "enterpriseId", valid_599302
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599303 = query.getOrDefault("fields")
  valid_599303 = validateParameter(valid_599303, JString, required = false,
                                 default = nil)
  if valid_599303 != nil:
    section.add "fields", valid_599303
  var valid_599304 = query.getOrDefault("quotaUser")
  valid_599304 = validateParameter(valid_599304, JString, required = false,
                                 default = nil)
  if valid_599304 != nil:
    section.add "quotaUser", valid_599304
  var valid_599305 = query.getOrDefault("alt")
  valid_599305 = validateParameter(valid_599305, JString, required = false,
                                 default = newJString("json"))
  if valid_599305 != nil:
    section.add "alt", valid_599305
  var valid_599306 = query.getOrDefault("oauth_token")
  valid_599306 = validateParameter(valid_599306, JString, required = false,
                                 default = nil)
  if valid_599306 != nil:
    section.add "oauth_token", valid_599306
  var valid_599307 = query.getOrDefault("userIp")
  valid_599307 = validateParameter(valid_599307, JString, required = false,
                                 default = nil)
  if valid_599307 != nil:
    section.add "userIp", valid_599307
  var valid_599308 = query.getOrDefault("key")
  valid_599308 = validateParameter(valid_599308, JString, required = false,
                                 default = nil)
  if valid_599308 != nil:
    section.add "key", valid_599308
  var valid_599309 = query.getOrDefault("prettyPrint")
  valid_599309 = validateParameter(valid_599309, JBool, required = false,
                                 default = newJBool(true))
  if valid_599309 != nil:
    section.add "prettyPrint", valid_599309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599310: Call_AndroidenterpriseWebappsList_599299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of all web apps for a given enterprise.
  ## 
  let valid = call_599310.validator(path, query, header, formData, body)
  let scheme = call_599310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599310.url(scheme.get, call_599310.host, call_599310.base,
                         call_599310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599310, url, valid)

proc call*(call_599311: Call_AndroidenterpriseWebappsList_599299;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseWebappsList
  ## Retrieves the details of all web apps for a given enterprise.
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
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599312 = newJObject()
  var query_599313 = newJObject()
  add(query_599313, "fields", newJString(fields))
  add(query_599313, "quotaUser", newJString(quotaUser))
  add(query_599313, "alt", newJString(alt))
  add(query_599313, "oauth_token", newJString(oauthToken))
  add(query_599313, "userIp", newJString(userIp))
  add(query_599313, "key", newJString(key))
  add(path_599312, "enterpriseId", newJString(enterpriseId))
  add(query_599313, "prettyPrint", newJBool(prettyPrint))
  result = call_599311.call(path_599312, query_599313, nil, nil, nil)

var androidenterpriseWebappsList* = Call_AndroidenterpriseWebappsList_599299(
    name: "androidenterpriseWebappsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/webApps",
    validator: validate_AndroidenterpriseWebappsList_599300,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsList_599301,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsUpdate_599347 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseWebappsUpdate_599349(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "webAppId" in path, "`webAppId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/webApps/"),
               (kind: VariableSegment, value: "webAppId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseWebappsUpdate_599348(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing web app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webAppId: JString (required)
  ##           : The ID of the web app.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `webAppId` field"
  var valid_599350 = path.getOrDefault("webAppId")
  valid_599350 = validateParameter(valid_599350, JString, required = true,
                                 default = nil)
  if valid_599350 != nil:
    section.add "webAppId", valid_599350
  var valid_599351 = path.getOrDefault("enterpriseId")
  valid_599351 = validateParameter(valid_599351, JString, required = true,
                                 default = nil)
  if valid_599351 != nil:
    section.add "enterpriseId", valid_599351
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599352 = query.getOrDefault("fields")
  valid_599352 = validateParameter(valid_599352, JString, required = false,
                                 default = nil)
  if valid_599352 != nil:
    section.add "fields", valid_599352
  var valid_599353 = query.getOrDefault("quotaUser")
  valid_599353 = validateParameter(valid_599353, JString, required = false,
                                 default = nil)
  if valid_599353 != nil:
    section.add "quotaUser", valid_599353
  var valid_599354 = query.getOrDefault("alt")
  valid_599354 = validateParameter(valid_599354, JString, required = false,
                                 default = newJString("json"))
  if valid_599354 != nil:
    section.add "alt", valid_599354
  var valid_599355 = query.getOrDefault("oauth_token")
  valid_599355 = validateParameter(valid_599355, JString, required = false,
                                 default = nil)
  if valid_599355 != nil:
    section.add "oauth_token", valid_599355
  var valid_599356 = query.getOrDefault("userIp")
  valid_599356 = validateParameter(valid_599356, JString, required = false,
                                 default = nil)
  if valid_599356 != nil:
    section.add "userIp", valid_599356
  var valid_599357 = query.getOrDefault("key")
  valid_599357 = validateParameter(valid_599357, JString, required = false,
                                 default = nil)
  if valid_599357 != nil:
    section.add "key", valid_599357
  var valid_599358 = query.getOrDefault("prettyPrint")
  valid_599358 = validateParameter(valid_599358, JBool, required = false,
                                 default = newJBool(true))
  if valid_599358 != nil:
    section.add "prettyPrint", valid_599358
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

proc call*(call_599360: Call_AndroidenterpriseWebappsUpdate_599347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing web app.
  ## 
  let valid = call_599360.validator(path, query, header, formData, body)
  let scheme = call_599360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599360.url(scheme.get, call_599360.host, call_599360.base,
                         call_599360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599360, url, valid)

proc call*(call_599361: Call_AndroidenterpriseWebappsUpdate_599347;
          webAppId: string; enterpriseId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseWebappsUpdate
  ## Updates an existing web app.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   webAppId: string (required)
  ##           : The ID of the web app.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599362 = newJObject()
  var query_599363 = newJObject()
  var body_599364 = newJObject()
  add(query_599363, "fields", newJString(fields))
  add(query_599363, "quotaUser", newJString(quotaUser))
  add(query_599363, "alt", newJString(alt))
  add(path_599362, "webAppId", newJString(webAppId))
  add(query_599363, "oauth_token", newJString(oauthToken))
  add(query_599363, "userIp", newJString(userIp))
  add(query_599363, "key", newJString(key))
  add(path_599362, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_599364 = body
  add(query_599363, "prettyPrint", newJBool(prettyPrint))
  result = call_599361.call(path_599362, query_599363, nil, nil, body_599364)

var androidenterpriseWebappsUpdate* = Call_AndroidenterpriseWebappsUpdate_599347(
    name: "androidenterpriseWebappsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsUpdate_599348,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsUpdate_599349,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsGet_599331 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseWebappsGet_599333(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "webAppId" in path, "`webAppId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/webApps/"),
               (kind: VariableSegment, value: "webAppId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseWebappsGet_599332(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets an existing web app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webAppId: JString (required)
  ##           : The ID of the web app.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `webAppId` field"
  var valid_599334 = path.getOrDefault("webAppId")
  valid_599334 = validateParameter(valid_599334, JString, required = true,
                                 default = nil)
  if valid_599334 != nil:
    section.add "webAppId", valid_599334
  var valid_599335 = path.getOrDefault("enterpriseId")
  valid_599335 = validateParameter(valid_599335, JString, required = true,
                                 default = nil)
  if valid_599335 != nil:
    section.add "enterpriseId", valid_599335
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599336 = query.getOrDefault("fields")
  valid_599336 = validateParameter(valid_599336, JString, required = false,
                                 default = nil)
  if valid_599336 != nil:
    section.add "fields", valid_599336
  var valid_599337 = query.getOrDefault("quotaUser")
  valid_599337 = validateParameter(valid_599337, JString, required = false,
                                 default = nil)
  if valid_599337 != nil:
    section.add "quotaUser", valid_599337
  var valid_599338 = query.getOrDefault("alt")
  valid_599338 = validateParameter(valid_599338, JString, required = false,
                                 default = newJString("json"))
  if valid_599338 != nil:
    section.add "alt", valid_599338
  var valid_599339 = query.getOrDefault("oauth_token")
  valid_599339 = validateParameter(valid_599339, JString, required = false,
                                 default = nil)
  if valid_599339 != nil:
    section.add "oauth_token", valid_599339
  var valid_599340 = query.getOrDefault("userIp")
  valid_599340 = validateParameter(valid_599340, JString, required = false,
                                 default = nil)
  if valid_599340 != nil:
    section.add "userIp", valid_599340
  var valid_599341 = query.getOrDefault("key")
  valid_599341 = validateParameter(valid_599341, JString, required = false,
                                 default = nil)
  if valid_599341 != nil:
    section.add "key", valid_599341
  var valid_599342 = query.getOrDefault("prettyPrint")
  valid_599342 = validateParameter(valid_599342, JBool, required = false,
                                 default = newJBool(true))
  if valid_599342 != nil:
    section.add "prettyPrint", valid_599342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599343: Call_AndroidenterpriseWebappsGet_599331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing web app.
  ## 
  let valid = call_599343.validator(path, query, header, formData, body)
  let scheme = call_599343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599343.url(scheme.get, call_599343.host, call_599343.base,
                         call_599343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599343, url, valid)

proc call*(call_599344: Call_AndroidenterpriseWebappsGet_599331; webAppId: string;
          enterpriseId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseWebappsGet
  ## Gets an existing web app.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   webAppId: string (required)
  ##           : The ID of the web app.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599345 = newJObject()
  var query_599346 = newJObject()
  add(query_599346, "fields", newJString(fields))
  add(query_599346, "quotaUser", newJString(quotaUser))
  add(query_599346, "alt", newJString(alt))
  add(path_599345, "webAppId", newJString(webAppId))
  add(query_599346, "oauth_token", newJString(oauthToken))
  add(query_599346, "userIp", newJString(userIp))
  add(query_599346, "key", newJString(key))
  add(path_599345, "enterpriseId", newJString(enterpriseId))
  add(query_599346, "prettyPrint", newJBool(prettyPrint))
  result = call_599344.call(path_599345, query_599346, nil, nil, nil)

var androidenterpriseWebappsGet* = Call_AndroidenterpriseWebappsGet_599331(
    name: "androidenterpriseWebappsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsGet_599332,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsGet_599333,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsPatch_599381 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseWebappsPatch_599383(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "webAppId" in path, "`webAppId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/webApps/"),
               (kind: VariableSegment, value: "webAppId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseWebappsPatch_599382(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing web app. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webAppId: JString (required)
  ##           : The ID of the web app.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `webAppId` field"
  var valid_599384 = path.getOrDefault("webAppId")
  valid_599384 = validateParameter(valid_599384, JString, required = true,
                                 default = nil)
  if valid_599384 != nil:
    section.add "webAppId", valid_599384
  var valid_599385 = path.getOrDefault("enterpriseId")
  valid_599385 = validateParameter(valid_599385, JString, required = true,
                                 default = nil)
  if valid_599385 != nil:
    section.add "enterpriseId", valid_599385
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599386 = query.getOrDefault("fields")
  valid_599386 = validateParameter(valid_599386, JString, required = false,
                                 default = nil)
  if valid_599386 != nil:
    section.add "fields", valid_599386
  var valid_599387 = query.getOrDefault("quotaUser")
  valid_599387 = validateParameter(valid_599387, JString, required = false,
                                 default = nil)
  if valid_599387 != nil:
    section.add "quotaUser", valid_599387
  var valid_599388 = query.getOrDefault("alt")
  valid_599388 = validateParameter(valid_599388, JString, required = false,
                                 default = newJString("json"))
  if valid_599388 != nil:
    section.add "alt", valid_599388
  var valid_599389 = query.getOrDefault("oauth_token")
  valid_599389 = validateParameter(valid_599389, JString, required = false,
                                 default = nil)
  if valid_599389 != nil:
    section.add "oauth_token", valid_599389
  var valid_599390 = query.getOrDefault("userIp")
  valid_599390 = validateParameter(valid_599390, JString, required = false,
                                 default = nil)
  if valid_599390 != nil:
    section.add "userIp", valid_599390
  var valid_599391 = query.getOrDefault("key")
  valid_599391 = validateParameter(valid_599391, JString, required = false,
                                 default = nil)
  if valid_599391 != nil:
    section.add "key", valid_599391
  var valid_599392 = query.getOrDefault("prettyPrint")
  valid_599392 = validateParameter(valid_599392, JBool, required = false,
                                 default = newJBool(true))
  if valid_599392 != nil:
    section.add "prettyPrint", valid_599392
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

proc call*(call_599394: Call_AndroidenterpriseWebappsPatch_599381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing web app. This method supports patch semantics.
  ## 
  let valid = call_599394.validator(path, query, header, formData, body)
  let scheme = call_599394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599394.url(scheme.get, call_599394.host, call_599394.base,
                         call_599394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599394, url, valid)

proc call*(call_599395: Call_AndroidenterpriseWebappsPatch_599381;
          webAppId: string; enterpriseId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## androidenterpriseWebappsPatch
  ## Updates an existing web app. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   webAppId: string (required)
  ##           : The ID of the web app.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599396 = newJObject()
  var query_599397 = newJObject()
  var body_599398 = newJObject()
  add(query_599397, "fields", newJString(fields))
  add(query_599397, "quotaUser", newJString(quotaUser))
  add(query_599397, "alt", newJString(alt))
  add(path_599396, "webAppId", newJString(webAppId))
  add(query_599397, "oauth_token", newJString(oauthToken))
  add(query_599397, "userIp", newJString(userIp))
  add(query_599397, "key", newJString(key))
  add(path_599396, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_599398 = body
  add(query_599397, "prettyPrint", newJBool(prettyPrint))
  result = call_599395.call(path_599396, query_599397, nil, nil, body_599398)

var androidenterpriseWebappsPatch* = Call_AndroidenterpriseWebappsPatch_599381(
    name: "androidenterpriseWebappsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsPatch_599382,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsPatch_599383,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsDelete_599365 = ref object of OpenApiRestCall_597421
proc url_AndroidenterpriseWebappsDelete_599367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  assert "webAppId" in path, "`webAppId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId"),
               (kind: ConstantSegment, value: "/webApps/"),
               (kind: VariableSegment, value: "webAppId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseWebappsDelete_599366(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an existing web app.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   webAppId: JString (required)
  ##           : The ID of the web app.
  ##   enterpriseId: JString (required)
  ##               : The ID of the enterprise.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `webAppId` field"
  var valid_599368 = path.getOrDefault("webAppId")
  valid_599368 = validateParameter(valid_599368, JString, required = true,
                                 default = nil)
  if valid_599368 != nil:
    section.add "webAppId", valid_599368
  var valid_599369 = path.getOrDefault("enterpriseId")
  valid_599369 = validateParameter(valid_599369, JString, required = true,
                                 default = nil)
  if valid_599369 != nil:
    section.add "enterpriseId", valid_599369
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599370 = query.getOrDefault("fields")
  valid_599370 = validateParameter(valid_599370, JString, required = false,
                                 default = nil)
  if valid_599370 != nil:
    section.add "fields", valid_599370
  var valid_599371 = query.getOrDefault("quotaUser")
  valid_599371 = validateParameter(valid_599371, JString, required = false,
                                 default = nil)
  if valid_599371 != nil:
    section.add "quotaUser", valid_599371
  var valid_599372 = query.getOrDefault("alt")
  valid_599372 = validateParameter(valid_599372, JString, required = false,
                                 default = newJString("json"))
  if valid_599372 != nil:
    section.add "alt", valid_599372
  var valid_599373 = query.getOrDefault("oauth_token")
  valid_599373 = validateParameter(valid_599373, JString, required = false,
                                 default = nil)
  if valid_599373 != nil:
    section.add "oauth_token", valid_599373
  var valid_599374 = query.getOrDefault("userIp")
  valid_599374 = validateParameter(valid_599374, JString, required = false,
                                 default = nil)
  if valid_599374 != nil:
    section.add "userIp", valid_599374
  var valid_599375 = query.getOrDefault("key")
  valid_599375 = validateParameter(valid_599375, JString, required = false,
                                 default = nil)
  if valid_599375 != nil:
    section.add "key", valid_599375
  var valid_599376 = query.getOrDefault("prettyPrint")
  valid_599376 = validateParameter(valid_599376, JBool, required = false,
                                 default = newJBool(true))
  if valid_599376 != nil:
    section.add "prettyPrint", valid_599376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599377: Call_AndroidenterpriseWebappsDelete_599365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing web app.
  ## 
  let valid = call_599377.validator(path, query, header, formData, body)
  let scheme = call_599377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599377.url(scheme.get, call_599377.host, call_599377.base,
                         call_599377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599377, url, valid)

proc call*(call_599378: Call_AndroidenterpriseWebappsDelete_599365;
          webAppId: string; enterpriseId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterpriseWebappsDelete
  ## Deletes an existing web app.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   webAppId: string (required)
  ##           : The ID of the web app.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   enterpriseId: string (required)
  ##               : The ID of the enterprise.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599379 = newJObject()
  var query_599380 = newJObject()
  add(query_599380, "fields", newJString(fields))
  add(query_599380, "quotaUser", newJString(quotaUser))
  add(query_599380, "alt", newJString(alt))
  add(path_599379, "webAppId", newJString(webAppId))
  add(query_599380, "oauth_token", newJString(oauthToken))
  add(query_599380, "userIp", newJString(userIp))
  add(query_599380, "key", newJString(key))
  add(path_599379, "enterpriseId", newJString(enterpriseId))
  add(query_599380, "prettyPrint", newJBool(prettyPrint))
  result = call_599378.call(path_599379, query_599380, nil, nil, nil)

var androidenterpriseWebappsDelete* = Call_AndroidenterpriseWebappsDelete_599365(
    name: "androidenterpriseWebappsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsDelete_599366,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsDelete_599367,
    schemes: {Scheme.Https})
type
  Call_AndroidenterprisePermissionsGet_599399 = ref object of OpenApiRestCall_597421
proc url_AndroidenterprisePermissionsGet_599401(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "permissionId" in path, "`permissionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/permissions/"),
               (kind: VariableSegment, value: "permissionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterprisePermissionsGet_599400(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves details of an Android app permission for display to an enterprise admin.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   permissionId: JString (required)
  ##               : The ID of the permission.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `permissionId` field"
  var valid_599402 = path.getOrDefault("permissionId")
  valid_599402 = validateParameter(valid_599402, JString, required = true,
                                 default = nil)
  if valid_599402 != nil:
    section.add "permissionId", valid_599402
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de")
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_599403 = query.getOrDefault("fields")
  valid_599403 = validateParameter(valid_599403, JString, required = false,
                                 default = nil)
  if valid_599403 != nil:
    section.add "fields", valid_599403
  var valid_599404 = query.getOrDefault("quotaUser")
  valid_599404 = validateParameter(valid_599404, JString, required = false,
                                 default = nil)
  if valid_599404 != nil:
    section.add "quotaUser", valid_599404
  var valid_599405 = query.getOrDefault("alt")
  valid_599405 = validateParameter(valid_599405, JString, required = false,
                                 default = newJString("json"))
  if valid_599405 != nil:
    section.add "alt", valid_599405
  var valid_599406 = query.getOrDefault("language")
  valid_599406 = validateParameter(valid_599406, JString, required = false,
                                 default = nil)
  if valid_599406 != nil:
    section.add "language", valid_599406
  var valid_599407 = query.getOrDefault("oauth_token")
  valid_599407 = validateParameter(valid_599407, JString, required = false,
                                 default = nil)
  if valid_599407 != nil:
    section.add "oauth_token", valid_599407
  var valid_599408 = query.getOrDefault("userIp")
  valid_599408 = validateParameter(valid_599408, JString, required = false,
                                 default = nil)
  if valid_599408 != nil:
    section.add "userIp", valid_599408
  var valid_599409 = query.getOrDefault("key")
  valid_599409 = validateParameter(valid_599409, JString, required = false,
                                 default = nil)
  if valid_599409 != nil:
    section.add "key", valid_599409
  var valid_599410 = query.getOrDefault("prettyPrint")
  valid_599410 = validateParameter(valid_599410, JBool, required = false,
                                 default = newJBool(true))
  if valid_599410 != nil:
    section.add "prettyPrint", valid_599410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_599411: Call_AndroidenterprisePermissionsGet_599399;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of an Android app permission for display to an enterprise admin.
  ## 
  let valid = call_599411.validator(path, query, header, formData, body)
  let scheme = call_599411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_599411.url(scheme.get, call_599411.host, call_599411.base,
                         call_599411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_599411, url, valid)

proc call*(call_599412: Call_AndroidenterprisePermissionsGet_599399;
          permissionId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; language: string = ""; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## androidenterprisePermissionsGet
  ## Retrieves details of an Android app permission for display to an enterprise admin.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The BCP47 tag for the user's preferred language (e.g. "en-US", "de")
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   permissionId: string (required)
  ##               : The ID of the permission.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_599413 = newJObject()
  var query_599414 = newJObject()
  add(query_599414, "fields", newJString(fields))
  add(query_599414, "quotaUser", newJString(quotaUser))
  add(query_599414, "alt", newJString(alt))
  add(query_599414, "language", newJString(language))
  add(query_599414, "oauth_token", newJString(oauthToken))
  add(path_599413, "permissionId", newJString(permissionId))
  add(query_599414, "userIp", newJString(userIp))
  add(query_599414, "key", newJString(key))
  add(query_599414, "prettyPrint", newJBool(prettyPrint))
  result = call_599412.call(path_599413, query_599414, nil, nil, nil)

var androidenterprisePermissionsGet* = Call_AndroidenterprisePermissionsGet_599399(
    name: "androidenterprisePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/permissions/{permissionId}",
    validator: validate_AndroidenterprisePermissionsGet_599400,
    base: "/androidenterprise/v1", url: url_AndroidenterprisePermissionsGet_599401,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
