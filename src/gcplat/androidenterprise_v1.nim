
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_579421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579421): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidenterpriseEnterprisesList_579689 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesList_579691(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesList_579690(path: JsonNode;
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
  var valid_579803 = query.getOrDefault("fields")
  valid_579803 = validateParameter(valid_579803, JString, required = false,
                                 default = nil)
  if valid_579803 != nil:
    section.add "fields", valid_579803
  var valid_579804 = query.getOrDefault("quotaUser")
  valid_579804 = validateParameter(valid_579804, JString, required = false,
                                 default = nil)
  if valid_579804 != nil:
    section.add "quotaUser", valid_579804
  var valid_579818 = query.getOrDefault("alt")
  valid_579818 = validateParameter(valid_579818, JString, required = false,
                                 default = newJString("json"))
  if valid_579818 != nil:
    section.add "alt", valid_579818
  var valid_579819 = query.getOrDefault("oauth_token")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "oauth_token", valid_579819
  var valid_579820 = query.getOrDefault("userIp")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "userIp", valid_579820
  var valid_579821 = query.getOrDefault("key")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "key", valid_579821
  var valid_579822 = query.getOrDefault("prettyPrint")
  valid_579822 = validateParameter(valid_579822, JBool, required = false,
                                 default = newJBool(true))
  if valid_579822 != nil:
    section.add "prettyPrint", valid_579822
  assert query != nil, "query argument is necessary due to required `domain` field"
  var valid_579823 = query.getOrDefault("domain")
  valid_579823 = validateParameter(valid_579823, JString, required = true,
                                 default = nil)
  if valid_579823 != nil:
    section.add "domain", valid_579823
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579846: Call_AndroidenterpriseEnterprisesList_579689;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up an enterprise by domain name. This is only supported for enterprises created via the Google-initiated creation flow. Lookup of the id is not needed for enterprises created via the EMM-initiated flow since the EMM learns the enterprise ID in the callback specified in the Enterprises.generateSignupUrl call.
  ## 
  let valid = call_579846.validator(path, query, header, formData, body)
  let scheme = call_579846.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579846.url(scheme.get, call_579846.host, call_579846.base,
                         call_579846.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579846, url, valid)

proc call*(call_579917: Call_AndroidenterpriseEnterprisesList_579689;
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
  var query_579918 = newJObject()
  add(query_579918, "fields", newJString(fields))
  add(query_579918, "quotaUser", newJString(quotaUser))
  add(query_579918, "alt", newJString(alt))
  add(query_579918, "oauth_token", newJString(oauthToken))
  add(query_579918, "userIp", newJString(userIp))
  add(query_579918, "key", newJString(key))
  add(query_579918, "prettyPrint", newJBool(prettyPrint))
  add(query_579918, "domain", newJString(domain))
  result = call_579917.call(nil, query_579918, nil, nil, nil)

var androidenterpriseEnterprisesList* = Call_AndroidenterpriseEnterprisesList_579689(
    name: "androidenterpriseEnterprisesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises",
    validator: validate_AndroidenterpriseEnterprisesList_579690,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesList_579691,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_579958 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_579960(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_579959(
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
  var valid_579961 = query.getOrDefault("fields")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "fields", valid_579961
  var valid_579962 = query.getOrDefault("quotaUser")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "quotaUser", valid_579962
  var valid_579963 = query.getOrDefault("alt")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = newJString("json"))
  if valid_579963 != nil:
    section.add "alt", valid_579963
  var valid_579964 = query.getOrDefault("oauth_token")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "oauth_token", valid_579964
  var valid_579965 = query.getOrDefault("userIp")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "userIp", valid_579965
  var valid_579966 = query.getOrDefault("notificationSetId")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "notificationSetId", valid_579966
  var valid_579967 = query.getOrDefault("key")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "key", valid_579967
  var valid_579968 = query.getOrDefault("prettyPrint")
  valid_579968 = validateParameter(valid_579968, JBool, required = false,
                                 default = newJBool(true))
  if valid_579968 != nil:
    section.add "prettyPrint", valid_579968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579969: Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_579958;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges notifications that were received from Enterprises.PullNotificationSet to prevent subsequent calls from returning the same notifications.
  ## 
  let valid = call_579969.validator(path, query, header, formData, body)
  let scheme = call_579969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579969.url(scheme.get, call_579969.host, call_579969.base,
                         call_579969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579969, url, valid)

proc call*(call_579970: Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_579958;
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
  var query_579971 = newJObject()
  add(query_579971, "fields", newJString(fields))
  add(query_579971, "quotaUser", newJString(quotaUser))
  add(query_579971, "alt", newJString(alt))
  add(query_579971, "oauth_token", newJString(oauthToken))
  add(query_579971, "userIp", newJString(userIp))
  add(query_579971, "notificationSetId", newJString(notificationSetId))
  add(query_579971, "key", newJString(key))
  add(query_579971, "prettyPrint", newJBool(prettyPrint))
  result = call_579970.call(nil, query_579971, nil, nil, nil)

var androidenterpriseEnterprisesAcknowledgeNotificationSet* = Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_579958(
    name: "androidenterpriseEnterprisesAcknowledgeNotificationSet",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/acknowledgeNotificationSet",
    validator: validate_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_579959,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_579960,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesCompleteSignup_579972 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesCompleteSignup_579974(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesCompleteSignup_579973(path: JsonNode;
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
  var valid_579975 = query.getOrDefault("fields")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "fields", valid_579975
  var valid_579976 = query.getOrDefault("completionToken")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "completionToken", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("alt")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("json"))
  if valid_579978 != nil:
    section.add "alt", valid_579978
  var valid_579979 = query.getOrDefault("oauth_token")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = nil)
  if valid_579979 != nil:
    section.add "oauth_token", valid_579979
  var valid_579980 = query.getOrDefault("userIp")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "userIp", valid_579980
  var valid_579981 = query.getOrDefault("enterpriseToken")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "enterpriseToken", valid_579981
  var valid_579982 = query.getOrDefault("key")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "key", valid_579982
  var valid_579983 = query.getOrDefault("prettyPrint")
  valid_579983 = validateParameter(valid_579983, JBool, required = false,
                                 default = newJBool(true))
  if valid_579983 != nil:
    section.add "prettyPrint", valid_579983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579984: Call_AndroidenterpriseEnterprisesCompleteSignup_579972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes the signup flow, by specifying the Completion token and Enterprise token. This request must not be called multiple times for a given Enterprise Token.
  ## 
  let valid = call_579984.validator(path, query, header, formData, body)
  let scheme = call_579984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579984.url(scheme.get, call_579984.host, call_579984.base,
                         call_579984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579984, url, valid)

proc call*(call_579985: Call_AndroidenterpriseEnterprisesCompleteSignup_579972;
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
  var query_579986 = newJObject()
  add(query_579986, "fields", newJString(fields))
  add(query_579986, "completionToken", newJString(completionToken))
  add(query_579986, "quotaUser", newJString(quotaUser))
  add(query_579986, "alt", newJString(alt))
  add(query_579986, "oauth_token", newJString(oauthToken))
  add(query_579986, "userIp", newJString(userIp))
  add(query_579986, "enterpriseToken", newJString(enterpriseToken))
  add(query_579986, "key", newJString(key))
  add(query_579986, "prettyPrint", newJBool(prettyPrint))
  result = call_579985.call(nil, query_579986, nil, nil, nil)

var androidenterpriseEnterprisesCompleteSignup* = Call_AndroidenterpriseEnterprisesCompleteSignup_579972(
    name: "androidenterpriseEnterprisesCompleteSignup", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/completeSignup",
    validator: validate_AndroidenterpriseEnterprisesCompleteSignup_579973,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesCompleteSignup_579974,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesEnroll_579987 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesEnroll_579989(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesEnroll_579988(path: JsonNode;
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
  var valid_579990 = query.getOrDefault("token")
  valid_579990 = validateParameter(valid_579990, JString, required = true,
                                 default = nil)
  if valid_579990 != nil:
    section.add "token", valid_579990
  var valid_579991 = query.getOrDefault("fields")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "fields", valid_579991
  var valid_579992 = query.getOrDefault("quotaUser")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "quotaUser", valid_579992
  var valid_579993 = query.getOrDefault("alt")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("json"))
  if valid_579993 != nil:
    section.add "alt", valid_579993
  var valid_579994 = query.getOrDefault("oauth_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "oauth_token", valid_579994
  var valid_579995 = query.getOrDefault("userIp")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "userIp", valid_579995
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("prettyPrint")
  valid_579997 = validateParameter(valid_579997, JBool, required = false,
                                 default = newJBool(true))
  if valid_579997 != nil:
    section.add "prettyPrint", valid_579997
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

proc call*(call_579999: Call_AndroidenterpriseEnterprisesEnroll_579987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enrolls an enterprise with the calling EMM.
  ## 
  let valid = call_579999.validator(path, query, header, formData, body)
  let scheme = call_579999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579999.url(scheme.get, call_579999.host, call_579999.base,
                         call_579999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579999, url, valid)

proc call*(call_580000: Call_AndroidenterpriseEnterprisesEnroll_579987;
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
  var query_580001 = newJObject()
  var body_580002 = newJObject()
  add(query_580001, "token", newJString(token))
  add(query_580001, "fields", newJString(fields))
  add(query_580001, "quotaUser", newJString(quotaUser))
  add(query_580001, "alt", newJString(alt))
  add(query_580001, "oauth_token", newJString(oauthToken))
  add(query_580001, "userIp", newJString(userIp))
  add(query_580001, "key", newJString(key))
  if body != nil:
    body_580002 = body
  add(query_580001, "prettyPrint", newJBool(prettyPrint))
  result = call_580000.call(nil, query_580001, nil, nil, body_580002)

var androidenterpriseEnterprisesEnroll* = Call_AndroidenterpriseEnterprisesEnroll_579987(
    name: "androidenterpriseEnterprisesEnroll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/enroll",
    validator: validate_AndroidenterpriseEnterprisesEnroll_579988,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesEnroll_579989,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesPullNotificationSet_580003 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesPullNotificationSet_580005(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesPullNotificationSet_580004(
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
  var valid_580006 = query.getOrDefault("fields")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "fields", valid_580006
  var valid_580007 = query.getOrDefault("quotaUser")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "quotaUser", valid_580007
  var valid_580008 = query.getOrDefault("alt")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = newJString("json"))
  if valid_580008 != nil:
    section.add "alt", valid_580008
  var valid_580009 = query.getOrDefault("oauth_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "oauth_token", valid_580009
  var valid_580010 = query.getOrDefault("userIp")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "userIp", valid_580010
  var valid_580011 = query.getOrDefault("key")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "key", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(true))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
  var valid_580013 = query.getOrDefault("requestMode")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = newJString("returnImmediately"))
  if valid_580013 != nil:
    section.add "requestMode", valid_580013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580014: Call_AndroidenterpriseEnterprisesPullNotificationSet_580003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pulls and returns a notification set for the enterprises associated with the service account authenticated for the request. The notification set may be empty if no notification are pending.
  ## A notification set returned needs to be acknowledged within 20 seconds by calling Enterprises.AcknowledgeNotificationSet, unless the notification set is empty.
  ## Notifications that are not acknowledged within the 20 seconds will eventually be included again in the response to another PullNotificationSet request, and those that are never acknowledged will ultimately be deleted according to the Google Cloud Platform Pub/Sub system policy.
  ## Multiple requests might be performed concurrently to retrieve notifications, in which case the pending notifications (if any) will be split among each caller, if any are pending.
  ## If no notifications are present, an empty notification list is returned. Subsequent requests may return more notifications once they become available.
  ## 
  let valid = call_580014.validator(path, query, header, formData, body)
  let scheme = call_580014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580014.url(scheme.get, call_580014.host, call_580014.base,
                         call_580014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580014, url, valid)

proc call*(call_580015: Call_AndroidenterpriseEnterprisesPullNotificationSet_580003;
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
  var query_580016 = newJObject()
  add(query_580016, "fields", newJString(fields))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(query_580016, "alt", newJString(alt))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(query_580016, "userIp", newJString(userIp))
  add(query_580016, "key", newJString(key))
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  add(query_580016, "requestMode", newJString(requestMode))
  result = call_580015.call(nil, query_580016, nil, nil, nil)

var androidenterpriseEnterprisesPullNotificationSet* = Call_AndroidenterpriseEnterprisesPullNotificationSet_580003(
    name: "androidenterpriseEnterprisesPullNotificationSet",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/pullNotificationSet",
    validator: validate_AndroidenterpriseEnterprisesPullNotificationSet_580004,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesPullNotificationSet_580005,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGenerateSignupUrl_580017 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesGenerateSignupUrl_580019(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesGenerateSignupUrl_580018(
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
  var valid_580020 = query.getOrDefault("fields")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "fields", valid_580020
  var valid_580021 = query.getOrDefault("quotaUser")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "quotaUser", valid_580021
  var valid_580022 = query.getOrDefault("callbackUrl")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "callbackUrl", valid_580022
  var valid_580023 = query.getOrDefault("alt")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("json"))
  if valid_580023 != nil:
    section.add "alt", valid_580023
  var valid_580024 = query.getOrDefault("oauth_token")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "oauth_token", valid_580024
  var valid_580025 = query.getOrDefault("userIp")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "userIp", valid_580025
  var valid_580026 = query.getOrDefault("key")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "key", valid_580026
  var valid_580027 = query.getOrDefault("prettyPrint")
  valid_580027 = validateParameter(valid_580027, JBool, required = false,
                                 default = newJBool(true))
  if valid_580027 != nil:
    section.add "prettyPrint", valid_580027
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580028: Call_AndroidenterpriseEnterprisesGenerateSignupUrl_580017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a sign-up URL.
  ## 
  let valid = call_580028.validator(path, query, header, formData, body)
  let scheme = call_580028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580028.url(scheme.get, call_580028.host, call_580028.base,
                         call_580028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580028, url, valid)

proc call*(call_580029: Call_AndroidenterpriseEnterprisesGenerateSignupUrl_580017;
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
  var query_580030 = newJObject()
  add(query_580030, "fields", newJString(fields))
  add(query_580030, "quotaUser", newJString(quotaUser))
  add(query_580030, "callbackUrl", newJString(callbackUrl))
  add(query_580030, "alt", newJString(alt))
  add(query_580030, "oauth_token", newJString(oauthToken))
  add(query_580030, "userIp", newJString(userIp))
  add(query_580030, "key", newJString(key))
  add(query_580030, "prettyPrint", newJBool(prettyPrint))
  result = call_580029.call(nil, query_580030, nil, nil, nil)

var androidenterpriseEnterprisesGenerateSignupUrl* = Call_AndroidenterpriseEnterprisesGenerateSignupUrl_580017(
    name: "androidenterpriseEnterprisesGenerateSignupUrl",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/signupUrl",
    validator: validate_AndroidenterpriseEnterprisesGenerateSignupUrl_580018,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesGenerateSignupUrl_580019,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGet_580031 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesGet_580033(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "enterpriseId" in path, "`enterpriseId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/enterprises/"),
               (kind: VariableSegment, value: "enterpriseId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterpriseEnterprisesGet_580032(path: JsonNode;
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
  var valid_580048 = path.getOrDefault("enterpriseId")
  valid_580048 = validateParameter(valid_580048, JString, required = true,
                                 default = nil)
  if valid_580048 != nil:
    section.add "enterpriseId", valid_580048
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
  var valid_580049 = query.getOrDefault("fields")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "fields", valid_580049
  var valid_580050 = query.getOrDefault("quotaUser")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "quotaUser", valid_580050
  var valid_580051 = query.getOrDefault("alt")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = newJString("json"))
  if valid_580051 != nil:
    section.add "alt", valid_580051
  var valid_580052 = query.getOrDefault("oauth_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "oauth_token", valid_580052
  var valid_580053 = query.getOrDefault("userIp")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "userIp", valid_580053
  var valid_580054 = query.getOrDefault("key")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "key", valid_580054
  var valid_580055 = query.getOrDefault("prettyPrint")
  valid_580055 = validateParameter(valid_580055, JBool, required = false,
                                 default = newJBool(true))
  if valid_580055 != nil:
    section.add "prettyPrint", valid_580055
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580056: Call_AndroidenterpriseEnterprisesGet_580031;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the name and domain of an enterprise.
  ## 
  let valid = call_580056.validator(path, query, header, formData, body)
  let scheme = call_580056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580056.url(scheme.get, call_580056.host, call_580056.base,
                         call_580056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580056, url, valid)

proc call*(call_580057: Call_AndroidenterpriseEnterprisesGet_580031;
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
  var path_580058 = newJObject()
  var query_580059 = newJObject()
  add(query_580059, "fields", newJString(fields))
  add(query_580059, "quotaUser", newJString(quotaUser))
  add(query_580059, "alt", newJString(alt))
  add(query_580059, "oauth_token", newJString(oauthToken))
  add(query_580059, "userIp", newJString(userIp))
  add(query_580059, "key", newJString(key))
  add(path_580058, "enterpriseId", newJString(enterpriseId))
  add(query_580059, "prettyPrint", newJBool(prettyPrint))
  result = call_580057.call(path_580058, query_580059, nil, nil, nil)

var androidenterpriseEnterprisesGet* = Call_AndroidenterpriseEnterprisesGet_580031(
    name: "androidenterpriseEnterprisesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}",
    validator: validate_AndroidenterpriseEnterprisesGet_580032,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesGet_580033,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesSetAccount_580060 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesSetAccount_580062(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseEnterprisesSetAccount_580061(path: JsonNode;
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
  var valid_580063 = path.getOrDefault("enterpriseId")
  valid_580063 = validateParameter(valid_580063, JString, required = true,
                                 default = nil)
  if valid_580063 != nil:
    section.add "enterpriseId", valid_580063
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
  var valid_580064 = query.getOrDefault("fields")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "fields", valid_580064
  var valid_580065 = query.getOrDefault("quotaUser")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "quotaUser", valid_580065
  var valid_580066 = query.getOrDefault("alt")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = newJString("json"))
  if valid_580066 != nil:
    section.add "alt", valid_580066
  var valid_580067 = query.getOrDefault("oauth_token")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "oauth_token", valid_580067
  var valid_580068 = query.getOrDefault("userIp")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "userIp", valid_580068
  var valid_580069 = query.getOrDefault("key")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "key", valid_580069
  var valid_580070 = query.getOrDefault("prettyPrint")
  valid_580070 = validateParameter(valid_580070, JBool, required = false,
                                 default = newJBool(true))
  if valid_580070 != nil:
    section.add "prettyPrint", valid_580070
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

proc call*(call_580072: Call_AndroidenterpriseEnterprisesSetAccount_580060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the account that will be used to authenticate to the API as the enterprise.
  ## 
  let valid = call_580072.validator(path, query, header, formData, body)
  let scheme = call_580072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580072.url(scheme.get, call_580072.host, call_580072.base,
                         call_580072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580072, url, valid)

proc call*(call_580073: Call_AndroidenterpriseEnterprisesSetAccount_580060;
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
  var path_580074 = newJObject()
  var query_580075 = newJObject()
  var body_580076 = newJObject()
  add(query_580075, "fields", newJString(fields))
  add(query_580075, "quotaUser", newJString(quotaUser))
  add(query_580075, "alt", newJString(alt))
  add(query_580075, "oauth_token", newJString(oauthToken))
  add(query_580075, "userIp", newJString(userIp))
  add(query_580075, "key", newJString(key))
  add(path_580074, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580076 = body
  add(query_580075, "prettyPrint", newJBool(prettyPrint))
  result = call_580073.call(path_580074, query_580075, nil, nil, body_580076)

var androidenterpriseEnterprisesSetAccount* = Call_AndroidenterpriseEnterprisesSetAccount_580060(
    name: "androidenterpriseEnterprisesSetAccount", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/account",
    validator: validate_AndroidenterpriseEnterprisesSetAccount_580061,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesSetAccount_580062,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesCreateWebToken_580077 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesCreateWebToken_580079(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseEnterprisesCreateWebToken_580078(path: JsonNode;
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
  var valid_580080 = path.getOrDefault("enterpriseId")
  valid_580080 = validateParameter(valid_580080, JString, required = true,
                                 default = nil)
  if valid_580080 != nil:
    section.add "enterpriseId", valid_580080
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
  var valid_580081 = query.getOrDefault("fields")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "fields", valid_580081
  var valid_580082 = query.getOrDefault("quotaUser")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = nil)
  if valid_580082 != nil:
    section.add "quotaUser", valid_580082
  var valid_580083 = query.getOrDefault("alt")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = newJString("json"))
  if valid_580083 != nil:
    section.add "alt", valid_580083
  var valid_580084 = query.getOrDefault("oauth_token")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "oauth_token", valid_580084
  var valid_580085 = query.getOrDefault("userIp")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "userIp", valid_580085
  var valid_580086 = query.getOrDefault("key")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "key", valid_580086
  var valid_580087 = query.getOrDefault("prettyPrint")
  valid_580087 = validateParameter(valid_580087, JBool, required = false,
                                 default = newJBool(true))
  if valid_580087 != nil:
    section.add "prettyPrint", valid_580087
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

proc call*(call_580089: Call_AndroidenterpriseEnterprisesCreateWebToken_580077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a unique token to access an embeddable UI. To generate a web UI, pass the generated token into the managed Google Play javascript API. Each token may only be used to start one UI session. See the javascript API documentation for further information.
  ## 
  let valid = call_580089.validator(path, query, header, formData, body)
  let scheme = call_580089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580089.url(scheme.get, call_580089.host, call_580089.base,
                         call_580089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580089, url, valid)

proc call*(call_580090: Call_AndroidenterpriseEnterprisesCreateWebToken_580077;
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
  var path_580091 = newJObject()
  var query_580092 = newJObject()
  var body_580093 = newJObject()
  add(query_580092, "fields", newJString(fields))
  add(query_580092, "quotaUser", newJString(quotaUser))
  add(query_580092, "alt", newJString(alt))
  add(query_580092, "oauth_token", newJString(oauthToken))
  add(query_580092, "userIp", newJString(userIp))
  add(query_580092, "key", newJString(key))
  add(path_580091, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580093 = body
  add(query_580092, "prettyPrint", newJBool(prettyPrint))
  result = call_580090.call(path_580091, query_580092, nil, nil, body_580093)

var androidenterpriseEnterprisesCreateWebToken* = Call_AndroidenterpriseEnterprisesCreateWebToken_580077(
    name: "androidenterpriseEnterprisesCreateWebToken", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/createWebToken",
    validator: validate_AndroidenterpriseEnterprisesCreateWebToken_580078,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesCreateWebToken_580079,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseGrouplicensesList_580094 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseGrouplicensesList_580096(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseGrouplicensesList_580095(path: JsonNode;
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
  var valid_580097 = path.getOrDefault("enterpriseId")
  valid_580097 = validateParameter(valid_580097, JString, required = true,
                                 default = nil)
  if valid_580097 != nil:
    section.add "enterpriseId", valid_580097
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
  var valid_580098 = query.getOrDefault("fields")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "fields", valid_580098
  var valid_580099 = query.getOrDefault("quotaUser")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "quotaUser", valid_580099
  var valid_580100 = query.getOrDefault("alt")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("json"))
  if valid_580100 != nil:
    section.add "alt", valid_580100
  var valid_580101 = query.getOrDefault("oauth_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "oauth_token", valid_580101
  var valid_580102 = query.getOrDefault("userIp")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "userIp", valid_580102
  var valid_580103 = query.getOrDefault("key")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "key", valid_580103
  var valid_580104 = query.getOrDefault("prettyPrint")
  valid_580104 = validateParameter(valid_580104, JBool, required = false,
                                 default = newJBool(true))
  if valid_580104 != nil:
    section.add "prettyPrint", valid_580104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580105: Call_AndroidenterpriseGrouplicensesList_580094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves IDs of all products for which the enterprise has a group license.
  ## 
  let valid = call_580105.validator(path, query, header, formData, body)
  let scheme = call_580105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580105.url(scheme.get, call_580105.host, call_580105.base,
                         call_580105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580105, url, valid)

proc call*(call_580106: Call_AndroidenterpriseGrouplicensesList_580094;
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
  var path_580107 = newJObject()
  var query_580108 = newJObject()
  add(query_580108, "fields", newJString(fields))
  add(query_580108, "quotaUser", newJString(quotaUser))
  add(query_580108, "alt", newJString(alt))
  add(query_580108, "oauth_token", newJString(oauthToken))
  add(query_580108, "userIp", newJString(userIp))
  add(query_580108, "key", newJString(key))
  add(path_580107, "enterpriseId", newJString(enterpriseId))
  add(query_580108, "prettyPrint", newJBool(prettyPrint))
  result = call_580106.call(path_580107, query_580108, nil, nil, nil)

var androidenterpriseGrouplicensesList* = Call_AndroidenterpriseGrouplicensesList_580094(
    name: "androidenterpriseGrouplicensesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/groupLicenses",
    validator: validate_AndroidenterpriseGrouplicensesList_580095,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseGrouplicensesList_580096,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseGrouplicensesGet_580109 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseGrouplicensesGet_580111(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseGrouplicensesGet_580110(path: JsonNode;
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
  var valid_580112 = path.getOrDefault("groupLicenseId")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "groupLicenseId", valid_580112
  var valid_580113 = path.getOrDefault("enterpriseId")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "enterpriseId", valid_580113
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
  var valid_580114 = query.getOrDefault("fields")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "fields", valid_580114
  var valid_580115 = query.getOrDefault("quotaUser")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "quotaUser", valid_580115
  var valid_580116 = query.getOrDefault("alt")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("json"))
  if valid_580116 != nil:
    section.add "alt", valid_580116
  var valid_580117 = query.getOrDefault("oauth_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "oauth_token", valid_580117
  var valid_580118 = query.getOrDefault("userIp")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "userIp", valid_580118
  var valid_580119 = query.getOrDefault("key")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "key", valid_580119
  var valid_580120 = query.getOrDefault("prettyPrint")
  valid_580120 = validateParameter(valid_580120, JBool, required = false,
                                 default = newJBool(true))
  if valid_580120 != nil:
    section.add "prettyPrint", valid_580120
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580121: Call_AndroidenterpriseGrouplicensesGet_580109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of an enterprise's group license for a product.
  ## 
  let valid = call_580121.validator(path, query, header, formData, body)
  let scheme = call_580121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580121.url(scheme.get, call_580121.host, call_580121.base,
                         call_580121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580121, url, valid)

proc call*(call_580122: Call_AndroidenterpriseGrouplicensesGet_580109;
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
  var path_580123 = newJObject()
  var query_580124 = newJObject()
  add(query_580124, "fields", newJString(fields))
  add(query_580124, "quotaUser", newJString(quotaUser))
  add(query_580124, "alt", newJString(alt))
  add(query_580124, "oauth_token", newJString(oauthToken))
  add(query_580124, "userIp", newJString(userIp))
  add(path_580123, "groupLicenseId", newJString(groupLicenseId))
  add(query_580124, "key", newJString(key))
  add(path_580123, "enterpriseId", newJString(enterpriseId))
  add(query_580124, "prettyPrint", newJBool(prettyPrint))
  result = call_580122.call(path_580123, query_580124, nil, nil, nil)

var androidenterpriseGrouplicensesGet* = Call_AndroidenterpriseGrouplicensesGet_580109(
    name: "androidenterpriseGrouplicensesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/groupLicenses/{groupLicenseId}",
    validator: validate_AndroidenterpriseGrouplicensesGet_580110,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseGrouplicensesGet_580111,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseGrouplicenseusersList_580125 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseGrouplicenseusersList_580127(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseGrouplicenseusersList_580126(path: JsonNode;
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
  var valid_580128 = path.getOrDefault("groupLicenseId")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "groupLicenseId", valid_580128
  var valid_580129 = path.getOrDefault("enterpriseId")
  valid_580129 = validateParameter(valid_580129, JString, required = true,
                                 default = nil)
  if valid_580129 != nil:
    section.add "enterpriseId", valid_580129
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
  var valid_580130 = query.getOrDefault("fields")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "fields", valid_580130
  var valid_580131 = query.getOrDefault("quotaUser")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "quotaUser", valid_580131
  var valid_580132 = query.getOrDefault("alt")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = newJString("json"))
  if valid_580132 != nil:
    section.add "alt", valid_580132
  var valid_580133 = query.getOrDefault("oauth_token")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "oauth_token", valid_580133
  var valid_580134 = query.getOrDefault("userIp")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "userIp", valid_580134
  var valid_580135 = query.getOrDefault("key")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "key", valid_580135
  var valid_580136 = query.getOrDefault("prettyPrint")
  valid_580136 = validateParameter(valid_580136, JBool, required = false,
                                 default = newJBool(true))
  if valid_580136 != nil:
    section.add "prettyPrint", valid_580136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580137: Call_AndroidenterpriseGrouplicenseusersList_580125;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the IDs of the users who have been granted entitlements under the license.
  ## 
  let valid = call_580137.validator(path, query, header, formData, body)
  let scheme = call_580137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580137.url(scheme.get, call_580137.host, call_580137.base,
                         call_580137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580137, url, valid)

proc call*(call_580138: Call_AndroidenterpriseGrouplicenseusersList_580125;
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
  var path_580139 = newJObject()
  var query_580140 = newJObject()
  add(query_580140, "fields", newJString(fields))
  add(query_580140, "quotaUser", newJString(quotaUser))
  add(query_580140, "alt", newJString(alt))
  add(query_580140, "oauth_token", newJString(oauthToken))
  add(query_580140, "userIp", newJString(userIp))
  add(path_580139, "groupLicenseId", newJString(groupLicenseId))
  add(query_580140, "key", newJString(key))
  add(path_580139, "enterpriseId", newJString(enterpriseId))
  add(query_580140, "prettyPrint", newJBool(prettyPrint))
  result = call_580138.call(path_580139, query_580140, nil, nil, nil)

var androidenterpriseGrouplicenseusersList* = Call_AndroidenterpriseGrouplicenseusersList_580125(
    name: "androidenterpriseGrouplicenseusersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/groupLicenses/{groupLicenseId}/users",
    validator: validate_AndroidenterpriseGrouplicenseusersList_580126,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseGrouplicenseusersList_580127,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsList_580141 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseProductsList_580143(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseProductsList_580142(path: JsonNode; query: JsonNode;
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
  var valid_580144 = path.getOrDefault("enterpriseId")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "enterpriseId", valid_580144
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
  var valid_580145 = query.getOrDefault("token")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "token", valid_580145
  var valid_580146 = query.getOrDefault("fields")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "fields", valid_580146
  var valid_580147 = query.getOrDefault("quotaUser")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "quotaUser", valid_580147
  var valid_580148 = query.getOrDefault("alt")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("json"))
  if valid_580148 != nil:
    section.add "alt", valid_580148
  var valid_580149 = query.getOrDefault("language")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "language", valid_580149
  var valid_580150 = query.getOrDefault("query")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "query", valid_580150
  var valid_580151 = query.getOrDefault("oauth_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "oauth_token", valid_580151
  var valid_580152 = query.getOrDefault("userIp")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "userIp", valid_580152
  var valid_580153 = query.getOrDefault("maxResults")
  valid_580153 = validateParameter(valid_580153, JInt, required = false, default = nil)
  if valid_580153 != nil:
    section.add "maxResults", valid_580153
  var valid_580154 = query.getOrDefault("key")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "key", valid_580154
  var valid_580155 = query.getOrDefault("approved")
  valid_580155 = validateParameter(valid_580155, JBool, required = false, default = nil)
  if valid_580155 != nil:
    section.add "approved", valid_580155
  var valid_580156 = query.getOrDefault("prettyPrint")
  valid_580156 = validateParameter(valid_580156, JBool, required = false,
                                 default = newJBool(true))
  if valid_580156 != nil:
    section.add "prettyPrint", valid_580156
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580157: Call_AndroidenterpriseProductsList_580141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finds approved products that match a query, or all approved products if there is no query.
  ## 
  let valid = call_580157.validator(path, query, header, formData, body)
  let scheme = call_580157.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580157.url(scheme.get, call_580157.host, call_580157.base,
                         call_580157.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580157, url, valid)

proc call*(call_580158: Call_AndroidenterpriseProductsList_580141;
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
  var path_580159 = newJObject()
  var query_580160 = newJObject()
  add(query_580160, "token", newJString(token))
  add(query_580160, "fields", newJString(fields))
  add(query_580160, "quotaUser", newJString(quotaUser))
  add(query_580160, "alt", newJString(alt))
  add(query_580160, "language", newJString(language))
  add(query_580160, "query", newJString(query))
  add(query_580160, "oauth_token", newJString(oauthToken))
  add(query_580160, "userIp", newJString(userIp))
  add(query_580160, "maxResults", newJInt(maxResults))
  add(query_580160, "key", newJString(key))
  add(path_580159, "enterpriseId", newJString(enterpriseId))
  add(query_580160, "approved", newJBool(approved))
  add(query_580160, "prettyPrint", newJBool(prettyPrint))
  result = call_580158.call(path_580159, query_580160, nil, nil, nil)

var androidenterpriseProductsList* = Call_AndroidenterpriseProductsList_580141(
    name: "androidenterpriseProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products",
    validator: validate_AndroidenterpriseProductsList_580142,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsList_580143,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGet_580161 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseProductsGet_580163(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseProductsGet_580162(path: JsonNode; query: JsonNode;
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
  var valid_580164 = path.getOrDefault("enterpriseId")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "enterpriseId", valid_580164
  var valid_580165 = path.getOrDefault("productId")
  valid_580165 = validateParameter(valid_580165, JString, required = true,
                                 default = nil)
  if valid_580165 != nil:
    section.add "productId", valid_580165
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
  var valid_580166 = query.getOrDefault("fields")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "fields", valid_580166
  var valid_580167 = query.getOrDefault("quotaUser")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "quotaUser", valid_580167
  var valid_580168 = query.getOrDefault("alt")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = newJString("json"))
  if valid_580168 != nil:
    section.add "alt", valid_580168
  var valid_580169 = query.getOrDefault("language")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "language", valid_580169
  var valid_580170 = query.getOrDefault("oauth_token")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "oauth_token", valid_580170
  var valid_580171 = query.getOrDefault("userIp")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "userIp", valid_580171
  var valid_580172 = query.getOrDefault("key")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "key", valid_580172
  var valid_580173 = query.getOrDefault("prettyPrint")
  valid_580173 = validateParameter(valid_580173, JBool, required = false,
                                 default = newJBool(true))
  if valid_580173 != nil:
    section.add "prettyPrint", valid_580173
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580174: Call_AndroidenterpriseProductsGet_580161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves details of a product for display to an enterprise admin.
  ## 
  let valid = call_580174.validator(path, query, header, formData, body)
  let scheme = call_580174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580174.url(scheme.get, call_580174.host, call_580174.base,
                         call_580174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580174, url, valid)

proc call*(call_580175: Call_AndroidenterpriseProductsGet_580161;
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
  var path_580176 = newJObject()
  var query_580177 = newJObject()
  add(query_580177, "fields", newJString(fields))
  add(query_580177, "quotaUser", newJString(quotaUser))
  add(query_580177, "alt", newJString(alt))
  add(query_580177, "language", newJString(language))
  add(query_580177, "oauth_token", newJString(oauthToken))
  add(query_580177, "userIp", newJString(userIp))
  add(query_580177, "key", newJString(key))
  add(path_580176, "enterpriseId", newJString(enterpriseId))
  add(path_580176, "productId", newJString(productId))
  add(query_580177, "prettyPrint", newJBool(prettyPrint))
  result = call_580175.call(path_580176, query_580177, nil, nil, nil)

var androidenterpriseProductsGet* = Call_AndroidenterpriseProductsGet_580161(
    name: "androidenterpriseProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}",
    validator: validate_AndroidenterpriseProductsGet_580162,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsGet_580163,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGetAppRestrictionsSchema_580178 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseProductsGetAppRestrictionsSchema_580180(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseProductsGetAppRestrictionsSchema_580179(
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
  var valid_580181 = path.getOrDefault("enterpriseId")
  valid_580181 = validateParameter(valid_580181, JString, required = true,
                                 default = nil)
  if valid_580181 != nil:
    section.add "enterpriseId", valid_580181
  var valid_580182 = path.getOrDefault("productId")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "productId", valid_580182
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
  var valid_580183 = query.getOrDefault("fields")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "fields", valid_580183
  var valid_580184 = query.getOrDefault("quotaUser")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "quotaUser", valid_580184
  var valid_580185 = query.getOrDefault("alt")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = newJString("json"))
  if valid_580185 != nil:
    section.add "alt", valid_580185
  var valid_580186 = query.getOrDefault("language")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "language", valid_580186
  var valid_580187 = query.getOrDefault("oauth_token")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = nil)
  if valid_580187 != nil:
    section.add "oauth_token", valid_580187
  var valid_580188 = query.getOrDefault("userIp")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "userIp", valid_580188
  var valid_580189 = query.getOrDefault("key")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "key", valid_580189
  var valid_580190 = query.getOrDefault("prettyPrint")
  valid_580190 = validateParameter(valid_580190, JBool, required = false,
                                 default = newJBool(true))
  if valid_580190 != nil:
    section.add "prettyPrint", valid_580190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580191: Call_AndroidenterpriseProductsGetAppRestrictionsSchema_580178;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the schema that defines the configurable properties for this product. All products have a schema, but this schema may be empty if no managed configurations have been defined. This schema can be used to populate a UI that allows an admin to configure the product. To apply a managed configuration based on the schema obtained using this API, see Managed Configurations through Play.
  ## 
  let valid = call_580191.validator(path, query, header, formData, body)
  let scheme = call_580191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580191.url(scheme.get, call_580191.host, call_580191.base,
                         call_580191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580191, url, valid)

proc call*(call_580192: Call_AndroidenterpriseProductsGetAppRestrictionsSchema_580178;
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
  var path_580193 = newJObject()
  var query_580194 = newJObject()
  add(query_580194, "fields", newJString(fields))
  add(query_580194, "quotaUser", newJString(quotaUser))
  add(query_580194, "alt", newJString(alt))
  add(query_580194, "language", newJString(language))
  add(query_580194, "oauth_token", newJString(oauthToken))
  add(query_580194, "userIp", newJString(userIp))
  add(query_580194, "key", newJString(key))
  add(path_580193, "enterpriseId", newJString(enterpriseId))
  add(path_580193, "productId", newJString(productId))
  add(query_580194, "prettyPrint", newJBool(prettyPrint))
  result = call_580192.call(path_580193, query_580194, nil, nil, nil)

var androidenterpriseProductsGetAppRestrictionsSchema* = Call_AndroidenterpriseProductsGetAppRestrictionsSchema_580178(
    name: "androidenterpriseProductsGetAppRestrictionsSchema",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products/{productId}/appRestrictionsSchema",
    validator: validate_AndroidenterpriseProductsGetAppRestrictionsSchema_580179,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseProductsGetAppRestrictionsSchema_580180,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsApprove_580195 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseProductsApprove_580197(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseProductsApprove_580196(path: JsonNode;
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
  var valid_580198 = path.getOrDefault("enterpriseId")
  valid_580198 = validateParameter(valid_580198, JString, required = true,
                                 default = nil)
  if valid_580198 != nil:
    section.add "enterpriseId", valid_580198
  var valid_580199 = path.getOrDefault("productId")
  valid_580199 = validateParameter(valid_580199, JString, required = true,
                                 default = nil)
  if valid_580199 != nil:
    section.add "productId", valid_580199
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
  var valid_580200 = query.getOrDefault("fields")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "fields", valid_580200
  var valid_580201 = query.getOrDefault("quotaUser")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "quotaUser", valid_580201
  var valid_580202 = query.getOrDefault("alt")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = newJString("json"))
  if valid_580202 != nil:
    section.add "alt", valid_580202
  var valid_580203 = query.getOrDefault("oauth_token")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "oauth_token", valid_580203
  var valid_580204 = query.getOrDefault("userIp")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "userIp", valid_580204
  var valid_580205 = query.getOrDefault("key")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "key", valid_580205
  var valid_580206 = query.getOrDefault("prettyPrint")
  valid_580206 = validateParameter(valid_580206, JBool, required = false,
                                 default = newJBool(true))
  if valid_580206 != nil:
    section.add "prettyPrint", valid_580206
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

proc call*(call_580208: Call_AndroidenterpriseProductsApprove_580195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Approves the specified product and the relevant app permissions, if any. The maximum number of products that you can approve per enterprise customer is 1,000.
  ## 
  ## To learn how to use managed Google Play to design and create a store layout to display approved products to your users, see Store Layout Design.
  ## 
  let valid = call_580208.validator(path, query, header, formData, body)
  let scheme = call_580208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580208.url(scheme.get, call_580208.host, call_580208.base,
                         call_580208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580208, url, valid)

proc call*(call_580209: Call_AndroidenterpriseProductsApprove_580195;
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
  var path_580210 = newJObject()
  var query_580211 = newJObject()
  var body_580212 = newJObject()
  add(query_580211, "fields", newJString(fields))
  add(query_580211, "quotaUser", newJString(quotaUser))
  add(query_580211, "alt", newJString(alt))
  add(query_580211, "oauth_token", newJString(oauthToken))
  add(query_580211, "userIp", newJString(userIp))
  add(query_580211, "key", newJString(key))
  add(path_580210, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580212 = body
  add(query_580211, "prettyPrint", newJBool(prettyPrint))
  add(path_580210, "productId", newJString(productId))
  result = call_580209.call(path_580210, query_580211, nil, nil, body_580212)

var androidenterpriseProductsApprove* = Call_AndroidenterpriseProductsApprove_580195(
    name: "androidenterpriseProductsApprove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}/approve",
    validator: validate_AndroidenterpriseProductsApprove_580196,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsApprove_580197,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGenerateApprovalUrl_580213 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseProductsGenerateApprovalUrl_580215(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseProductsGenerateApprovalUrl_580214(path: JsonNode;
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
  var valid_580216 = path.getOrDefault("enterpriseId")
  valid_580216 = validateParameter(valid_580216, JString, required = true,
                                 default = nil)
  if valid_580216 != nil:
    section.add "enterpriseId", valid_580216
  var valid_580217 = path.getOrDefault("productId")
  valid_580217 = validateParameter(valid_580217, JString, required = true,
                                 default = nil)
  if valid_580217 != nil:
    section.add "productId", valid_580217
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
  var valid_580218 = query.getOrDefault("fields")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "fields", valid_580218
  var valid_580219 = query.getOrDefault("quotaUser")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "quotaUser", valid_580219
  var valid_580220 = query.getOrDefault("alt")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = newJString("json"))
  if valid_580220 != nil:
    section.add "alt", valid_580220
  var valid_580221 = query.getOrDefault("oauth_token")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "oauth_token", valid_580221
  var valid_580222 = query.getOrDefault("userIp")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "userIp", valid_580222
  var valid_580223 = query.getOrDefault("key")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "key", valid_580223
  var valid_580224 = query.getOrDefault("languageCode")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "languageCode", valid_580224
  var valid_580225 = query.getOrDefault("prettyPrint")
  valid_580225 = validateParameter(valid_580225, JBool, required = false,
                                 default = newJBool(true))
  if valid_580225 != nil:
    section.add "prettyPrint", valid_580225
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580226: Call_AndroidenterpriseProductsGenerateApprovalUrl_580213;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a URL that can be rendered in an iframe to display the permissions (if any) of a product. An enterprise admin must view these permissions and accept them on behalf of their organization in order to approve that product.
  ## 
  ## Admins should accept the displayed permissions by interacting with a separate UI element in the EMM console, which in turn should trigger the use of this URL as the approvalUrlInfo.approvalUrl property in a Products.approve call to approve the product. This URL can only be used to display permissions for up to 1 day.
  ## 
  let valid = call_580226.validator(path, query, header, formData, body)
  let scheme = call_580226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580226.url(scheme.get, call_580226.host, call_580226.base,
                         call_580226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580226, url, valid)

proc call*(call_580227: Call_AndroidenterpriseProductsGenerateApprovalUrl_580213;
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
  var path_580228 = newJObject()
  var query_580229 = newJObject()
  add(query_580229, "fields", newJString(fields))
  add(query_580229, "quotaUser", newJString(quotaUser))
  add(query_580229, "alt", newJString(alt))
  add(query_580229, "oauth_token", newJString(oauthToken))
  add(query_580229, "userIp", newJString(userIp))
  add(query_580229, "key", newJString(key))
  add(query_580229, "languageCode", newJString(languageCode))
  add(path_580228, "enterpriseId", newJString(enterpriseId))
  add(path_580228, "productId", newJString(productId))
  add(query_580229, "prettyPrint", newJBool(prettyPrint))
  result = call_580227.call(path_580228, query_580229, nil, nil, nil)

var androidenterpriseProductsGenerateApprovalUrl* = Call_AndroidenterpriseProductsGenerateApprovalUrl_580213(
    name: "androidenterpriseProductsGenerateApprovalUrl",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products/{productId}/generateApprovalUrl",
    validator: validate_AndroidenterpriseProductsGenerateApprovalUrl_580214,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseProductsGenerateApprovalUrl_580215,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationssettingsList_580230 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseManagedconfigurationssettingsList_580232(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseManagedconfigurationssettingsList_580231(
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
  var valid_580233 = path.getOrDefault("enterpriseId")
  valid_580233 = validateParameter(valid_580233, JString, required = true,
                                 default = nil)
  if valid_580233 != nil:
    section.add "enterpriseId", valid_580233
  var valid_580234 = path.getOrDefault("productId")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "productId", valid_580234
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
  var valid_580235 = query.getOrDefault("fields")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "fields", valid_580235
  var valid_580236 = query.getOrDefault("quotaUser")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "quotaUser", valid_580236
  var valid_580237 = query.getOrDefault("alt")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = newJString("json"))
  if valid_580237 != nil:
    section.add "alt", valid_580237
  var valid_580238 = query.getOrDefault("oauth_token")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = nil)
  if valid_580238 != nil:
    section.add "oauth_token", valid_580238
  var valid_580239 = query.getOrDefault("userIp")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "userIp", valid_580239
  var valid_580240 = query.getOrDefault("key")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "key", valid_580240
  var valid_580241 = query.getOrDefault("prettyPrint")
  valid_580241 = validateParameter(valid_580241, JBool, required = false,
                                 default = newJBool(true))
  if valid_580241 != nil:
    section.add "prettyPrint", valid_580241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580242: Call_AndroidenterpriseManagedconfigurationssettingsList_580230;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the managed configurations settings for the specified app.
  ## 
  let valid = call_580242.validator(path, query, header, formData, body)
  let scheme = call_580242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580242.url(scheme.get, call_580242.host, call_580242.base,
                         call_580242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580242, url, valid)

proc call*(call_580243: Call_AndroidenterpriseManagedconfigurationssettingsList_580230;
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
  var path_580244 = newJObject()
  var query_580245 = newJObject()
  add(query_580245, "fields", newJString(fields))
  add(query_580245, "quotaUser", newJString(quotaUser))
  add(query_580245, "alt", newJString(alt))
  add(query_580245, "oauth_token", newJString(oauthToken))
  add(query_580245, "userIp", newJString(userIp))
  add(query_580245, "key", newJString(key))
  add(path_580244, "enterpriseId", newJString(enterpriseId))
  add(path_580244, "productId", newJString(productId))
  add(query_580245, "prettyPrint", newJBool(prettyPrint))
  result = call_580243.call(path_580244, query_580245, nil, nil, nil)

var androidenterpriseManagedconfigurationssettingsList* = Call_AndroidenterpriseManagedconfigurationssettingsList_580230(
    name: "androidenterpriseManagedconfigurationssettingsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products/{productId}/managedConfigurationsSettings",
    validator: validate_AndroidenterpriseManagedconfigurationssettingsList_580231,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationssettingsList_580232,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGetPermissions_580246 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseProductsGetPermissions_580248(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseProductsGetPermissions_580247(path: JsonNode;
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
  var valid_580249 = path.getOrDefault("enterpriseId")
  valid_580249 = validateParameter(valid_580249, JString, required = true,
                                 default = nil)
  if valid_580249 != nil:
    section.add "enterpriseId", valid_580249
  var valid_580250 = path.getOrDefault("productId")
  valid_580250 = validateParameter(valid_580250, JString, required = true,
                                 default = nil)
  if valid_580250 != nil:
    section.add "productId", valid_580250
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
  var valid_580251 = query.getOrDefault("fields")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "fields", valid_580251
  var valid_580252 = query.getOrDefault("quotaUser")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "quotaUser", valid_580252
  var valid_580253 = query.getOrDefault("alt")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = newJString("json"))
  if valid_580253 != nil:
    section.add "alt", valid_580253
  var valid_580254 = query.getOrDefault("oauth_token")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "oauth_token", valid_580254
  var valid_580255 = query.getOrDefault("userIp")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "userIp", valid_580255
  var valid_580256 = query.getOrDefault("key")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "key", valid_580256
  var valid_580257 = query.getOrDefault("prettyPrint")
  valid_580257 = validateParameter(valid_580257, JBool, required = false,
                                 default = newJBool(true))
  if valid_580257 != nil:
    section.add "prettyPrint", valid_580257
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580258: Call_AndroidenterpriseProductsGetPermissions_580246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the Android app permissions required by this app.
  ## 
  let valid = call_580258.validator(path, query, header, formData, body)
  let scheme = call_580258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580258.url(scheme.get, call_580258.host, call_580258.base,
                         call_580258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580258, url, valid)

proc call*(call_580259: Call_AndroidenterpriseProductsGetPermissions_580246;
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
  var path_580260 = newJObject()
  var query_580261 = newJObject()
  add(query_580261, "fields", newJString(fields))
  add(query_580261, "quotaUser", newJString(quotaUser))
  add(query_580261, "alt", newJString(alt))
  add(query_580261, "oauth_token", newJString(oauthToken))
  add(query_580261, "userIp", newJString(userIp))
  add(query_580261, "key", newJString(key))
  add(path_580260, "enterpriseId", newJString(enterpriseId))
  add(path_580260, "productId", newJString(productId))
  add(query_580261, "prettyPrint", newJBool(prettyPrint))
  result = call_580259.call(path_580260, query_580261, nil, nil, nil)

var androidenterpriseProductsGetPermissions* = Call_AndroidenterpriseProductsGetPermissions_580246(
    name: "androidenterpriseProductsGetPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}/permissions",
    validator: validate_AndroidenterpriseProductsGetPermissions_580247,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseProductsGetPermissions_580248,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsUnapprove_580262 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseProductsUnapprove_580264(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseProductsUnapprove_580263(path: JsonNode;
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
  var valid_580265 = path.getOrDefault("enterpriseId")
  valid_580265 = validateParameter(valid_580265, JString, required = true,
                                 default = nil)
  if valid_580265 != nil:
    section.add "enterpriseId", valid_580265
  var valid_580266 = path.getOrDefault("productId")
  valid_580266 = validateParameter(valid_580266, JString, required = true,
                                 default = nil)
  if valid_580266 != nil:
    section.add "productId", valid_580266
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
  var valid_580267 = query.getOrDefault("fields")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "fields", valid_580267
  var valid_580268 = query.getOrDefault("quotaUser")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "quotaUser", valid_580268
  var valid_580269 = query.getOrDefault("alt")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = newJString("json"))
  if valid_580269 != nil:
    section.add "alt", valid_580269
  var valid_580270 = query.getOrDefault("oauth_token")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "oauth_token", valid_580270
  var valid_580271 = query.getOrDefault("userIp")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "userIp", valid_580271
  var valid_580272 = query.getOrDefault("key")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "key", valid_580272
  var valid_580273 = query.getOrDefault("prettyPrint")
  valid_580273 = validateParameter(valid_580273, JBool, required = false,
                                 default = newJBool(true))
  if valid_580273 != nil:
    section.add "prettyPrint", valid_580273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580274: Call_AndroidenterpriseProductsUnapprove_580262;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unapproves the specified product (and the relevant app permissions, if any)
  ## 
  let valid = call_580274.validator(path, query, header, formData, body)
  let scheme = call_580274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580274.url(scheme.get, call_580274.host, call_580274.base,
                         call_580274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580274, url, valid)

proc call*(call_580275: Call_AndroidenterpriseProductsUnapprove_580262;
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
  var path_580276 = newJObject()
  var query_580277 = newJObject()
  add(query_580277, "fields", newJString(fields))
  add(query_580277, "quotaUser", newJString(quotaUser))
  add(query_580277, "alt", newJString(alt))
  add(query_580277, "oauth_token", newJString(oauthToken))
  add(query_580277, "userIp", newJString(userIp))
  add(query_580277, "key", newJString(key))
  add(path_580276, "enterpriseId", newJString(enterpriseId))
  add(path_580276, "productId", newJString(productId))
  add(query_580277, "prettyPrint", newJBool(prettyPrint))
  result = call_580275.call(path_580276, query_580277, nil, nil, nil)

var androidenterpriseProductsUnapprove* = Call_AndroidenterpriseProductsUnapprove_580262(
    name: "androidenterpriseProductsUnapprove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}/unapprove",
    validator: validate_AndroidenterpriseProductsUnapprove_580263,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsUnapprove_580264,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesSendTestPushNotification_580278 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesSendTestPushNotification_580280(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseEnterprisesSendTestPushNotification_580279(
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
  var valid_580281 = path.getOrDefault("enterpriseId")
  valid_580281 = validateParameter(valid_580281, JString, required = true,
                                 default = nil)
  if valid_580281 != nil:
    section.add "enterpriseId", valid_580281
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
  var valid_580282 = query.getOrDefault("fields")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "fields", valid_580282
  var valid_580283 = query.getOrDefault("quotaUser")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "quotaUser", valid_580283
  var valid_580284 = query.getOrDefault("alt")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = newJString("json"))
  if valid_580284 != nil:
    section.add "alt", valid_580284
  var valid_580285 = query.getOrDefault("oauth_token")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "oauth_token", valid_580285
  var valid_580286 = query.getOrDefault("userIp")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "userIp", valid_580286
  var valid_580287 = query.getOrDefault("key")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "key", valid_580287
  var valid_580288 = query.getOrDefault("prettyPrint")
  valid_580288 = validateParameter(valid_580288, JBool, required = false,
                                 default = newJBool(true))
  if valid_580288 != nil:
    section.add "prettyPrint", valid_580288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580289: Call_AndroidenterpriseEnterprisesSendTestPushNotification_580278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sends a test notification to validate the EMM integration with the Google Cloud Pub/Sub service for this enterprise.
  ## 
  let valid = call_580289.validator(path, query, header, formData, body)
  let scheme = call_580289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580289.url(scheme.get, call_580289.host, call_580289.base,
                         call_580289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580289, url, valid)

proc call*(call_580290: Call_AndroidenterpriseEnterprisesSendTestPushNotification_580278;
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
  var path_580291 = newJObject()
  var query_580292 = newJObject()
  add(query_580292, "fields", newJString(fields))
  add(query_580292, "quotaUser", newJString(quotaUser))
  add(query_580292, "alt", newJString(alt))
  add(query_580292, "oauth_token", newJString(oauthToken))
  add(query_580292, "userIp", newJString(userIp))
  add(query_580292, "key", newJString(key))
  add(path_580291, "enterpriseId", newJString(enterpriseId))
  add(query_580292, "prettyPrint", newJBool(prettyPrint))
  result = call_580290.call(path_580291, query_580292, nil, nil, nil)

var androidenterpriseEnterprisesSendTestPushNotification* = Call_AndroidenterpriseEnterprisesSendTestPushNotification_580278(
    name: "androidenterpriseEnterprisesSendTestPushNotification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/sendTestPushNotification",
    validator: validate_AndroidenterpriseEnterprisesSendTestPushNotification_580279,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesSendTestPushNotification_580280,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGetServiceAccount_580293 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesGetServiceAccount_580295(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseEnterprisesGetServiceAccount_580294(
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
  var valid_580296 = path.getOrDefault("enterpriseId")
  valid_580296 = validateParameter(valid_580296, JString, required = true,
                                 default = nil)
  if valid_580296 != nil:
    section.add "enterpriseId", valid_580296
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
  var valid_580297 = query.getOrDefault("keyType")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = newJString("googleCredentials"))
  if valid_580297 != nil:
    section.add "keyType", valid_580297
  var valid_580298 = query.getOrDefault("fields")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "fields", valid_580298
  var valid_580299 = query.getOrDefault("quotaUser")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "quotaUser", valid_580299
  var valid_580300 = query.getOrDefault("alt")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = newJString("json"))
  if valid_580300 != nil:
    section.add "alt", valid_580300
  var valid_580301 = query.getOrDefault("oauth_token")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "oauth_token", valid_580301
  var valid_580302 = query.getOrDefault("userIp")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "userIp", valid_580302
  var valid_580303 = query.getOrDefault("key")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "key", valid_580303
  var valid_580304 = query.getOrDefault("prettyPrint")
  valid_580304 = validateParameter(valid_580304, JBool, required = false,
                                 default = newJBool(true))
  if valid_580304 != nil:
    section.add "prettyPrint", valid_580304
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580305: Call_AndroidenterpriseEnterprisesGetServiceAccount_580293;
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
  let valid = call_580305.validator(path, query, header, formData, body)
  let scheme = call_580305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580305.url(scheme.get, call_580305.host, call_580305.base,
                         call_580305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580305, url, valid)

proc call*(call_580306: Call_AndroidenterpriseEnterprisesGetServiceAccount_580293;
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
  var path_580307 = newJObject()
  var query_580308 = newJObject()
  add(query_580308, "keyType", newJString(keyType))
  add(query_580308, "fields", newJString(fields))
  add(query_580308, "quotaUser", newJString(quotaUser))
  add(query_580308, "alt", newJString(alt))
  add(query_580308, "oauth_token", newJString(oauthToken))
  add(query_580308, "userIp", newJString(userIp))
  add(query_580308, "key", newJString(key))
  add(path_580307, "enterpriseId", newJString(enterpriseId))
  add(query_580308, "prettyPrint", newJBool(prettyPrint))
  result = call_580306.call(path_580307, query_580308, nil, nil, nil)

var androidenterpriseEnterprisesGetServiceAccount* = Call_AndroidenterpriseEnterprisesGetServiceAccount_580293(
    name: "androidenterpriseEnterprisesGetServiceAccount",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccount",
    validator: validate_AndroidenterpriseEnterprisesGetServiceAccount_580294,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesGetServiceAccount_580295,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseServiceaccountkeysInsert_580324 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseServiceaccountkeysInsert_580326(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseServiceaccountkeysInsert_580325(path: JsonNode;
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
  var valid_580327 = path.getOrDefault("enterpriseId")
  valid_580327 = validateParameter(valid_580327, JString, required = true,
                                 default = nil)
  if valid_580327 != nil:
    section.add "enterpriseId", valid_580327
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
  var valid_580328 = query.getOrDefault("fields")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "fields", valid_580328
  var valid_580329 = query.getOrDefault("quotaUser")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "quotaUser", valid_580329
  var valid_580330 = query.getOrDefault("alt")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = newJString("json"))
  if valid_580330 != nil:
    section.add "alt", valid_580330
  var valid_580331 = query.getOrDefault("oauth_token")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "oauth_token", valid_580331
  var valid_580332 = query.getOrDefault("userIp")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "userIp", valid_580332
  var valid_580333 = query.getOrDefault("key")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "key", valid_580333
  var valid_580334 = query.getOrDefault("prettyPrint")
  valid_580334 = validateParameter(valid_580334, JBool, required = false,
                                 default = newJBool(true))
  if valid_580334 != nil:
    section.add "prettyPrint", valid_580334
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

proc call*(call_580336: Call_AndroidenterpriseServiceaccountkeysInsert_580324;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates new credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  ## Only the type of the key should be populated in the resource to be inserted.
  ## 
  let valid = call_580336.validator(path, query, header, formData, body)
  let scheme = call_580336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580336.url(scheme.get, call_580336.host, call_580336.base,
                         call_580336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580336, url, valid)

proc call*(call_580337: Call_AndroidenterpriseServiceaccountkeysInsert_580324;
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
  var path_580338 = newJObject()
  var query_580339 = newJObject()
  var body_580340 = newJObject()
  add(query_580339, "fields", newJString(fields))
  add(query_580339, "quotaUser", newJString(quotaUser))
  add(query_580339, "alt", newJString(alt))
  add(query_580339, "oauth_token", newJString(oauthToken))
  add(query_580339, "userIp", newJString(userIp))
  add(query_580339, "key", newJString(key))
  add(path_580338, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580340 = body
  add(query_580339, "prettyPrint", newJBool(prettyPrint))
  result = call_580337.call(path_580338, query_580339, nil, nil, body_580340)

var androidenterpriseServiceaccountkeysInsert* = Call_AndroidenterpriseServiceaccountkeysInsert_580324(
    name: "androidenterpriseServiceaccountkeysInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccountKeys",
    validator: validate_AndroidenterpriseServiceaccountkeysInsert_580325,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseServiceaccountkeysInsert_580326,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseServiceaccountkeysList_580309 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseServiceaccountkeysList_580311(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseServiceaccountkeysList_580310(path: JsonNode;
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
  var valid_580312 = path.getOrDefault("enterpriseId")
  valid_580312 = validateParameter(valid_580312, JString, required = true,
                                 default = nil)
  if valid_580312 != nil:
    section.add "enterpriseId", valid_580312
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
  var valid_580313 = query.getOrDefault("fields")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = nil)
  if valid_580313 != nil:
    section.add "fields", valid_580313
  var valid_580314 = query.getOrDefault("quotaUser")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "quotaUser", valid_580314
  var valid_580315 = query.getOrDefault("alt")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = newJString("json"))
  if valid_580315 != nil:
    section.add "alt", valid_580315
  var valid_580316 = query.getOrDefault("oauth_token")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "oauth_token", valid_580316
  var valid_580317 = query.getOrDefault("userIp")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "userIp", valid_580317
  var valid_580318 = query.getOrDefault("key")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "key", valid_580318
  var valid_580319 = query.getOrDefault("prettyPrint")
  valid_580319 = validateParameter(valid_580319, JBool, required = false,
                                 default = newJBool(true))
  if valid_580319 != nil:
    section.add "prettyPrint", valid_580319
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580320: Call_AndroidenterpriseServiceaccountkeysList_580309;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all active credentials for the service account associated with this enterprise. Only the ID and key type are returned. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  let valid = call_580320.validator(path, query, header, formData, body)
  let scheme = call_580320.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580320.url(scheme.get, call_580320.host, call_580320.base,
                         call_580320.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580320, url, valid)

proc call*(call_580321: Call_AndroidenterpriseServiceaccountkeysList_580309;
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
  var path_580322 = newJObject()
  var query_580323 = newJObject()
  add(query_580323, "fields", newJString(fields))
  add(query_580323, "quotaUser", newJString(quotaUser))
  add(query_580323, "alt", newJString(alt))
  add(query_580323, "oauth_token", newJString(oauthToken))
  add(query_580323, "userIp", newJString(userIp))
  add(query_580323, "key", newJString(key))
  add(path_580322, "enterpriseId", newJString(enterpriseId))
  add(query_580323, "prettyPrint", newJBool(prettyPrint))
  result = call_580321.call(path_580322, query_580323, nil, nil, nil)

var androidenterpriseServiceaccountkeysList* = Call_AndroidenterpriseServiceaccountkeysList_580309(
    name: "androidenterpriseServiceaccountkeysList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccountKeys",
    validator: validate_AndroidenterpriseServiceaccountkeysList_580310,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseServiceaccountkeysList_580311,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseServiceaccountkeysDelete_580341 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseServiceaccountkeysDelete_580343(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseServiceaccountkeysDelete_580342(path: JsonNode;
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
  var valid_580344 = path.getOrDefault("keyId")
  valid_580344 = validateParameter(valid_580344, JString, required = true,
                                 default = nil)
  if valid_580344 != nil:
    section.add "keyId", valid_580344
  var valid_580345 = path.getOrDefault("enterpriseId")
  valid_580345 = validateParameter(valid_580345, JString, required = true,
                                 default = nil)
  if valid_580345 != nil:
    section.add "enterpriseId", valid_580345
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
  var valid_580346 = query.getOrDefault("fields")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "fields", valid_580346
  var valid_580347 = query.getOrDefault("quotaUser")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "quotaUser", valid_580347
  var valid_580348 = query.getOrDefault("alt")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = newJString("json"))
  if valid_580348 != nil:
    section.add "alt", valid_580348
  var valid_580349 = query.getOrDefault("oauth_token")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "oauth_token", valid_580349
  var valid_580350 = query.getOrDefault("userIp")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "userIp", valid_580350
  var valid_580351 = query.getOrDefault("key")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "key", valid_580351
  var valid_580352 = query.getOrDefault("prettyPrint")
  valid_580352 = validateParameter(valid_580352, JBool, required = false,
                                 default = newJBool(true))
  if valid_580352 != nil:
    section.add "prettyPrint", valid_580352
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580353: Call_AndroidenterpriseServiceaccountkeysDelete_580341;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes and invalidates the specified credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  let valid = call_580353.validator(path, query, header, formData, body)
  let scheme = call_580353.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580353.url(scheme.get, call_580353.host, call_580353.base,
                         call_580353.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580353, url, valid)

proc call*(call_580354: Call_AndroidenterpriseServiceaccountkeysDelete_580341;
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
  var path_580355 = newJObject()
  var query_580356 = newJObject()
  add(path_580355, "keyId", newJString(keyId))
  add(query_580356, "fields", newJString(fields))
  add(query_580356, "quotaUser", newJString(quotaUser))
  add(query_580356, "alt", newJString(alt))
  add(query_580356, "oauth_token", newJString(oauthToken))
  add(query_580356, "userIp", newJString(userIp))
  add(query_580356, "key", newJString(key))
  add(path_580355, "enterpriseId", newJString(enterpriseId))
  add(query_580356, "prettyPrint", newJBool(prettyPrint))
  result = call_580354.call(path_580355, query_580356, nil, nil, nil)

var androidenterpriseServiceaccountkeysDelete* = Call_AndroidenterpriseServiceaccountkeysDelete_580341(
    name: "androidenterpriseServiceaccountkeysDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccountKeys/{keyId}",
    validator: validate_AndroidenterpriseServiceaccountkeysDelete_580342,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseServiceaccountkeysDelete_580343,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesSetStoreLayout_580372 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesSetStoreLayout_580374(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseEnterprisesSetStoreLayout_580373(path: JsonNode;
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
  var valid_580375 = path.getOrDefault("enterpriseId")
  valid_580375 = validateParameter(valid_580375, JString, required = true,
                                 default = nil)
  if valid_580375 != nil:
    section.add "enterpriseId", valid_580375
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
  var valid_580376 = query.getOrDefault("fields")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "fields", valid_580376
  var valid_580377 = query.getOrDefault("quotaUser")
  valid_580377 = validateParameter(valid_580377, JString, required = false,
                                 default = nil)
  if valid_580377 != nil:
    section.add "quotaUser", valid_580377
  var valid_580378 = query.getOrDefault("alt")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = newJString("json"))
  if valid_580378 != nil:
    section.add "alt", valid_580378
  var valid_580379 = query.getOrDefault("oauth_token")
  valid_580379 = validateParameter(valid_580379, JString, required = false,
                                 default = nil)
  if valid_580379 != nil:
    section.add "oauth_token", valid_580379
  var valid_580380 = query.getOrDefault("userIp")
  valid_580380 = validateParameter(valid_580380, JString, required = false,
                                 default = nil)
  if valid_580380 != nil:
    section.add "userIp", valid_580380
  var valid_580381 = query.getOrDefault("key")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "key", valid_580381
  var valid_580382 = query.getOrDefault("prettyPrint")
  valid_580382 = validateParameter(valid_580382, JBool, required = false,
                                 default = newJBool(true))
  if valid_580382 != nil:
    section.add "prettyPrint", valid_580382
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

proc call*(call_580384: Call_AndroidenterpriseEnterprisesSetStoreLayout_580372;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the store layout for the enterprise. By default, storeLayoutType is set to "basic" and the basic store layout is enabled. The basic layout only contains apps approved by the admin, and that have been added to the available product set for a user (using the  setAvailableProductSet call). Apps on the page are sorted in order of their product ID value. If you create a custom store layout (by setting storeLayoutType = "custom" and setting a homepage), the basic store layout is disabled.
  ## 
  let valid = call_580384.validator(path, query, header, formData, body)
  let scheme = call_580384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580384.url(scheme.get, call_580384.host, call_580384.base,
                         call_580384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580384, url, valid)

proc call*(call_580385: Call_AndroidenterpriseEnterprisesSetStoreLayout_580372;
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
  var path_580386 = newJObject()
  var query_580387 = newJObject()
  var body_580388 = newJObject()
  add(query_580387, "fields", newJString(fields))
  add(query_580387, "quotaUser", newJString(quotaUser))
  add(query_580387, "alt", newJString(alt))
  add(query_580387, "oauth_token", newJString(oauthToken))
  add(query_580387, "userIp", newJString(userIp))
  add(query_580387, "key", newJString(key))
  add(path_580386, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580388 = body
  add(query_580387, "prettyPrint", newJBool(prettyPrint))
  result = call_580385.call(path_580386, query_580387, nil, nil, body_580388)

var androidenterpriseEnterprisesSetStoreLayout* = Call_AndroidenterpriseEnterprisesSetStoreLayout_580372(
    name: "androidenterpriseEnterprisesSetStoreLayout", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout",
    validator: validate_AndroidenterpriseEnterprisesSetStoreLayout_580373,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesSetStoreLayout_580374,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGetStoreLayout_580357 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesGetStoreLayout_580359(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseEnterprisesGetStoreLayout_580358(path: JsonNode;
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
  var valid_580360 = path.getOrDefault("enterpriseId")
  valid_580360 = validateParameter(valid_580360, JString, required = true,
                                 default = nil)
  if valid_580360 != nil:
    section.add "enterpriseId", valid_580360
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
  var valid_580361 = query.getOrDefault("fields")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "fields", valid_580361
  var valid_580362 = query.getOrDefault("quotaUser")
  valid_580362 = validateParameter(valid_580362, JString, required = false,
                                 default = nil)
  if valid_580362 != nil:
    section.add "quotaUser", valid_580362
  var valid_580363 = query.getOrDefault("alt")
  valid_580363 = validateParameter(valid_580363, JString, required = false,
                                 default = newJString("json"))
  if valid_580363 != nil:
    section.add "alt", valid_580363
  var valid_580364 = query.getOrDefault("oauth_token")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "oauth_token", valid_580364
  var valid_580365 = query.getOrDefault("userIp")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "userIp", valid_580365
  var valid_580366 = query.getOrDefault("key")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "key", valid_580366
  var valid_580367 = query.getOrDefault("prettyPrint")
  valid_580367 = validateParameter(valid_580367, JBool, required = false,
                                 default = newJBool(true))
  if valid_580367 != nil:
    section.add "prettyPrint", valid_580367
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580368: Call_AndroidenterpriseEnterprisesGetStoreLayout_580357;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the store layout for the enterprise. If the store layout has not been set, returns "basic" as the store layout type and no homepage.
  ## 
  let valid = call_580368.validator(path, query, header, formData, body)
  let scheme = call_580368.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580368.url(scheme.get, call_580368.host, call_580368.base,
                         call_580368.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580368, url, valid)

proc call*(call_580369: Call_AndroidenterpriseEnterprisesGetStoreLayout_580357;
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
  var path_580370 = newJObject()
  var query_580371 = newJObject()
  add(query_580371, "fields", newJString(fields))
  add(query_580371, "quotaUser", newJString(quotaUser))
  add(query_580371, "alt", newJString(alt))
  add(query_580371, "oauth_token", newJString(oauthToken))
  add(query_580371, "userIp", newJString(userIp))
  add(query_580371, "key", newJString(key))
  add(path_580370, "enterpriseId", newJString(enterpriseId))
  add(query_580371, "prettyPrint", newJBool(prettyPrint))
  result = call_580369.call(path_580370, query_580371, nil, nil, nil)

var androidenterpriseEnterprisesGetStoreLayout* = Call_AndroidenterpriseEnterprisesGetStoreLayout_580357(
    name: "androidenterpriseEnterprisesGetStoreLayout", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout",
    validator: validate_AndroidenterpriseEnterprisesGetStoreLayout_580358,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesGetStoreLayout_580359,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesInsert_580404 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseStorelayoutpagesInsert_580406(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseStorelayoutpagesInsert_580405(path: JsonNode;
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
  var valid_580407 = path.getOrDefault("enterpriseId")
  valid_580407 = validateParameter(valid_580407, JString, required = true,
                                 default = nil)
  if valid_580407 != nil:
    section.add "enterpriseId", valid_580407
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
  var valid_580408 = query.getOrDefault("fields")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "fields", valid_580408
  var valid_580409 = query.getOrDefault("quotaUser")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = nil)
  if valid_580409 != nil:
    section.add "quotaUser", valid_580409
  var valid_580410 = query.getOrDefault("alt")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = newJString("json"))
  if valid_580410 != nil:
    section.add "alt", valid_580410
  var valid_580411 = query.getOrDefault("oauth_token")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "oauth_token", valid_580411
  var valid_580412 = query.getOrDefault("userIp")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "userIp", valid_580412
  var valid_580413 = query.getOrDefault("key")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "key", valid_580413
  var valid_580414 = query.getOrDefault("prettyPrint")
  valid_580414 = validateParameter(valid_580414, JBool, required = false,
                                 default = newJBool(true))
  if valid_580414 != nil:
    section.add "prettyPrint", valid_580414
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

proc call*(call_580416: Call_AndroidenterpriseStorelayoutpagesInsert_580404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new store page.
  ## 
  let valid = call_580416.validator(path, query, header, formData, body)
  let scheme = call_580416.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580416.url(scheme.get, call_580416.host, call_580416.base,
                         call_580416.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580416, url, valid)

proc call*(call_580417: Call_AndroidenterpriseStorelayoutpagesInsert_580404;
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
  var path_580418 = newJObject()
  var query_580419 = newJObject()
  var body_580420 = newJObject()
  add(query_580419, "fields", newJString(fields))
  add(query_580419, "quotaUser", newJString(quotaUser))
  add(query_580419, "alt", newJString(alt))
  add(query_580419, "oauth_token", newJString(oauthToken))
  add(query_580419, "userIp", newJString(userIp))
  add(query_580419, "key", newJString(key))
  add(path_580418, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580420 = body
  add(query_580419, "prettyPrint", newJBool(prettyPrint))
  result = call_580417.call(path_580418, query_580419, nil, nil, body_580420)

var androidenterpriseStorelayoutpagesInsert* = Call_AndroidenterpriseStorelayoutpagesInsert_580404(
    name: "androidenterpriseStorelayoutpagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages",
    validator: validate_AndroidenterpriseStorelayoutpagesInsert_580405,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesInsert_580406,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesList_580389 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseStorelayoutpagesList_580391(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseStorelayoutpagesList_580390(path: JsonNode;
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
  var valid_580392 = path.getOrDefault("enterpriseId")
  valid_580392 = validateParameter(valid_580392, JString, required = true,
                                 default = nil)
  if valid_580392 != nil:
    section.add "enterpriseId", valid_580392
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
  var valid_580393 = query.getOrDefault("fields")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = nil)
  if valid_580393 != nil:
    section.add "fields", valid_580393
  var valid_580394 = query.getOrDefault("quotaUser")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "quotaUser", valid_580394
  var valid_580395 = query.getOrDefault("alt")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = newJString("json"))
  if valid_580395 != nil:
    section.add "alt", valid_580395
  var valid_580396 = query.getOrDefault("oauth_token")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "oauth_token", valid_580396
  var valid_580397 = query.getOrDefault("userIp")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "userIp", valid_580397
  var valid_580398 = query.getOrDefault("key")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "key", valid_580398
  var valid_580399 = query.getOrDefault("prettyPrint")
  valid_580399 = validateParameter(valid_580399, JBool, required = false,
                                 default = newJBool(true))
  if valid_580399 != nil:
    section.add "prettyPrint", valid_580399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580400: Call_AndroidenterpriseStorelayoutpagesList_580389;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all pages in the store.
  ## 
  let valid = call_580400.validator(path, query, header, formData, body)
  let scheme = call_580400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580400.url(scheme.get, call_580400.host, call_580400.base,
                         call_580400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580400, url, valid)

proc call*(call_580401: Call_AndroidenterpriseStorelayoutpagesList_580389;
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
  var path_580402 = newJObject()
  var query_580403 = newJObject()
  add(query_580403, "fields", newJString(fields))
  add(query_580403, "quotaUser", newJString(quotaUser))
  add(query_580403, "alt", newJString(alt))
  add(query_580403, "oauth_token", newJString(oauthToken))
  add(query_580403, "userIp", newJString(userIp))
  add(query_580403, "key", newJString(key))
  add(path_580402, "enterpriseId", newJString(enterpriseId))
  add(query_580403, "prettyPrint", newJBool(prettyPrint))
  result = call_580401.call(path_580402, query_580403, nil, nil, nil)

var androidenterpriseStorelayoutpagesList* = Call_AndroidenterpriseStorelayoutpagesList_580389(
    name: "androidenterpriseStorelayoutpagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages",
    validator: validate_AndroidenterpriseStorelayoutpagesList_580390,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseStorelayoutpagesList_580391,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesUpdate_580437 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseStorelayoutpagesUpdate_580439(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseStorelayoutpagesUpdate_580438(path: JsonNode;
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
  var valid_580440 = path.getOrDefault("enterpriseId")
  valid_580440 = validateParameter(valid_580440, JString, required = true,
                                 default = nil)
  if valid_580440 != nil:
    section.add "enterpriseId", valid_580440
  var valid_580441 = path.getOrDefault("pageId")
  valid_580441 = validateParameter(valid_580441, JString, required = true,
                                 default = nil)
  if valid_580441 != nil:
    section.add "pageId", valid_580441
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
  var valid_580442 = query.getOrDefault("fields")
  valid_580442 = validateParameter(valid_580442, JString, required = false,
                                 default = nil)
  if valid_580442 != nil:
    section.add "fields", valid_580442
  var valid_580443 = query.getOrDefault("quotaUser")
  valid_580443 = validateParameter(valid_580443, JString, required = false,
                                 default = nil)
  if valid_580443 != nil:
    section.add "quotaUser", valid_580443
  var valid_580444 = query.getOrDefault("alt")
  valid_580444 = validateParameter(valid_580444, JString, required = false,
                                 default = newJString("json"))
  if valid_580444 != nil:
    section.add "alt", valid_580444
  var valid_580445 = query.getOrDefault("oauth_token")
  valid_580445 = validateParameter(valid_580445, JString, required = false,
                                 default = nil)
  if valid_580445 != nil:
    section.add "oauth_token", valid_580445
  var valid_580446 = query.getOrDefault("userIp")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "userIp", valid_580446
  var valid_580447 = query.getOrDefault("key")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "key", valid_580447
  var valid_580448 = query.getOrDefault("prettyPrint")
  valid_580448 = validateParameter(valid_580448, JBool, required = false,
                                 default = newJBool(true))
  if valid_580448 != nil:
    section.add "prettyPrint", valid_580448
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

proc call*(call_580450: Call_AndroidenterpriseStorelayoutpagesUpdate_580437;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the content of a store page.
  ## 
  let valid = call_580450.validator(path, query, header, formData, body)
  let scheme = call_580450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580450.url(scheme.get, call_580450.host, call_580450.base,
                         call_580450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580450, url, valid)

proc call*(call_580451: Call_AndroidenterpriseStorelayoutpagesUpdate_580437;
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
  var path_580452 = newJObject()
  var query_580453 = newJObject()
  var body_580454 = newJObject()
  add(query_580453, "fields", newJString(fields))
  add(query_580453, "quotaUser", newJString(quotaUser))
  add(query_580453, "alt", newJString(alt))
  add(query_580453, "oauth_token", newJString(oauthToken))
  add(query_580453, "userIp", newJString(userIp))
  add(query_580453, "key", newJString(key))
  add(path_580452, "enterpriseId", newJString(enterpriseId))
  add(path_580452, "pageId", newJString(pageId))
  if body != nil:
    body_580454 = body
  add(query_580453, "prettyPrint", newJBool(prettyPrint))
  result = call_580451.call(path_580452, query_580453, nil, nil, body_580454)

var androidenterpriseStorelayoutpagesUpdate* = Call_AndroidenterpriseStorelayoutpagesUpdate_580437(
    name: "androidenterpriseStorelayoutpagesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesUpdate_580438,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesUpdate_580439,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesGet_580421 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseStorelayoutpagesGet_580423(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseStorelayoutpagesGet_580422(path: JsonNode;
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
  var valid_580424 = path.getOrDefault("enterpriseId")
  valid_580424 = validateParameter(valid_580424, JString, required = true,
                                 default = nil)
  if valid_580424 != nil:
    section.add "enterpriseId", valid_580424
  var valid_580425 = path.getOrDefault("pageId")
  valid_580425 = validateParameter(valid_580425, JString, required = true,
                                 default = nil)
  if valid_580425 != nil:
    section.add "pageId", valid_580425
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
  var valid_580426 = query.getOrDefault("fields")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = nil)
  if valid_580426 != nil:
    section.add "fields", valid_580426
  var valid_580427 = query.getOrDefault("quotaUser")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = nil)
  if valid_580427 != nil:
    section.add "quotaUser", valid_580427
  var valid_580428 = query.getOrDefault("alt")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = newJString("json"))
  if valid_580428 != nil:
    section.add "alt", valid_580428
  var valid_580429 = query.getOrDefault("oauth_token")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "oauth_token", valid_580429
  var valid_580430 = query.getOrDefault("userIp")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = nil)
  if valid_580430 != nil:
    section.add "userIp", valid_580430
  var valid_580431 = query.getOrDefault("key")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "key", valid_580431
  var valid_580432 = query.getOrDefault("prettyPrint")
  valid_580432 = validateParameter(valid_580432, JBool, required = false,
                                 default = newJBool(true))
  if valid_580432 != nil:
    section.add "prettyPrint", valid_580432
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580433: Call_AndroidenterpriseStorelayoutpagesGet_580421;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a store page.
  ## 
  let valid = call_580433.validator(path, query, header, formData, body)
  let scheme = call_580433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580433.url(scheme.get, call_580433.host, call_580433.base,
                         call_580433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580433, url, valid)

proc call*(call_580434: Call_AndroidenterpriseStorelayoutpagesGet_580421;
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
  var path_580435 = newJObject()
  var query_580436 = newJObject()
  add(query_580436, "fields", newJString(fields))
  add(query_580436, "quotaUser", newJString(quotaUser))
  add(query_580436, "alt", newJString(alt))
  add(query_580436, "oauth_token", newJString(oauthToken))
  add(query_580436, "userIp", newJString(userIp))
  add(query_580436, "key", newJString(key))
  add(path_580435, "enterpriseId", newJString(enterpriseId))
  add(path_580435, "pageId", newJString(pageId))
  add(query_580436, "prettyPrint", newJBool(prettyPrint))
  result = call_580434.call(path_580435, query_580436, nil, nil, nil)

var androidenterpriseStorelayoutpagesGet* = Call_AndroidenterpriseStorelayoutpagesGet_580421(
    name: "androidenterpriseStorelayoutpagesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesGet_580422,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseStorelayoutpagesGet_580423,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesPatch_580471 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseStorelayoutpagesPatch_580473(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseStorelayoutpagesPatch_580472(path: JsonNode;
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
  var valid_580474 = path.getOrDefault("enterpriseId")
  valid_580474 = validateParameter(valid_580474, JString, required = true,
                                 default = nil)
  if valid_580474 != nil:
    section.add "enterpriseId", valid_580474
  var valid_580475 = path.getOrDefault("pageId")
  valid_580475 = validateParameter(valid_580475, JString, required = true,
                                 default = nil)
  if valid_580475 != nil:
    section.add "pageId", valid_580475
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
  var valid_580476 = query.getOrDefault("fields")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "fields", valid_580476
  var valid_580477 = query.getOrDefault("quotaUser")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "quotaUser", valid_580477
  var valid_580478 = query.getOrDefault("alt")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = newJString("json"))
  if valid_580478 != nil:
    section.add "alt", valid_580478
  var valid_580479 = query.getOrDefault("oauth_token")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "oauth_token", valid_580479
  var valid_580480 = query.getOrDefault("userIp")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "userIp", valid_580480
  var valid_580481 = query.getOrDefault("key")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = nil)
  if valid_580481 != nil:
    section.add "key", valid_580481
  var valid_580482 = query.getOrDefault("prettyPrint")
  valid_580482 = validateParameter(valid_580482, JBool, required = false,
                                 default = newJBool(true))
  if valid_580482 != nil:
    section.add "prettyPrint", valid_580482
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

proc call*(call_580484: Call_AndroidenterpriseStorelayoutpagesPatch_580471;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the content of a store page. This method supports patch semantics.
  ## 
  let valid = call_580484.validator(path, query, header, formData, body)
  let scheme = call_580484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580484.url(scheme.get, call_580484.host, call_580484.base,
                         call_580484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580484, url, valid)

proc call*(call_580485: Call_AndroidenterpriseStorelayoutpagesPatch_580471;
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
  var path_580486 = newJObject()
  var query_580487 = newJObject()
  var body_580488 = newJObject()
  add(query_580487, "fields", newJString(fields))
  add(query_580487, "quotaUser", newJString(quotaUser))
  add(query_580487, "alt", newJString(alt))
  add(query_580487, "oauth_token", newJString(oauthToken))
  add(query_580487, "userIp", newJString(userIp))
  add(query_580487, "key", newJString(key))
  add(path_580486, "enterpriseId", newJString(enterpriseId))
  add(path_580486, "pageId", newJString(pageId))
  if body != nil:
    body_580488 = body
  add(query_580487, "prettyPrint", newJBool(prettyPrint))
  result = call_580485.call(path_580486, query_580487, nil, nil, body_580488)

var androidenterpriseStorelayoutpagesPatch* = Call_AndroidenterpriseStorelayoutpagesPatch_580471(
    name: "androidenterpriseStorelayoutpagesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesPatch_580472,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesPatch_580473,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesDelete_580455 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseStorelayoutpagesDelete_580457(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseStorelayoutpagesDelete_580456(path: JsonNode;
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
  var valid_580458 = path.getOrDefault("enterpriseId")
  valid_580458 = validateParameter(valid_580458, JString, required = true,
                                 default = nil)
  if valid_580458 != nil:
    section.add "enterpriseId", valid_580458
  var valid_580459 = path.getOrDefault("pageId")
  valid_580459 = validateParameter(valid_580459, JString, required = true,
                                 default = nil)
  if valid_580459 != nil:
    section.add "pageId", valid_580459
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
  var valid_580460 = query.getOrDefault("fields")
  valid_580460 = validateParameter(valid_580460, JString, required = false,
                                 default = nil)
  if valid_580460 != nil:
    section.add "fields", valid_580460
  var valid_580461 = query.getOrDefault("quotaUser")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "quotaUser", valid_580461
  var valid_580462 = query.getOrDefault("alt")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = newJString("json"))
  if valid_580462 != nil:
    section.add "alt", valid_580462
  var valid_580463 = query.getOrDefault("oauth_token")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = nil)
  if valid_580463 != nil:
    section.add "oauth_token", valid_580463
  var valid_580464 = query.getOrDefault("userIp")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "userIp", valid_580464
  var valid_580465 = query.getOrDefault("key")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "key", valid_580465
  var valid_580466 = query.getOrDefault("prettyPrint")
  valid_580466 = validateParameter(valid_580466, JBool, required = false,
                                 default = newJBool(true))
  if valid_580466 != nil:
    section.add "prettyPrint", valid_580466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580467: Call_AndroidenterpriseStorelayoutpagesDelete_580455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a store page.
  ## 
  let valid = call_580467.validator(path, query, header, formData, body)
  let scheme = call_580467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580467.url(scheme.get, call_580467.host, call_580467.base,
                         call_580467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580467, url, valid)

proc call*(call_580468: Call_AndroidenterpriseStorelayoutpagesDelete_580455;
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
  var path_580469 = newJObject()
  var query_580470 = newJObject()
  add(query_580470, "fields", newJString(fields))
  add(query_580470, "quotaUser", newJString(quotaUser))
  add(query_580470, "alt", newJString(alt))
  add(query_580470, "oauth_token", newJString(oauthToken))
  add(query_580470, "userIp", newJString(userIp))
  add(query_580470, "key", newJString(key))
  add(path_580469, "enterpriseId", newJString(enterpriseId))
  add(path_580469, "pageId", newJString(pageId))
  add(query_580470, "prettyPrint", newJBool(prettyPrint))
  result = call_580468.call(path_580469, query_580470, nil, nil, nil)

var androidenterpriseStorelayoutpagesDelete* = Call_AndroidenterpriseStorelayoutpagesDelete_580455(
    name: "androidenterpriseStorelayoutpagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesDelete_580456,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesDelete_580457,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersInsert_580505 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseStorelayoutclustersInsert_580507(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseStorelayoutclustersInsert_580506(path: JsonNode;
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
  var valid_580508 = path.getOrDefault("enterpriseId")
  valid_580508 = validateParameter(valid_580508, JString, required = true,
                                 default = nil)
  if valid_580508 != nil:
    section.add "enterpriseId", valid_580508
  var valid_580509 = path.getOrDefault("pageId")
  valid_580509 = validateParameter(valid_580509, JString, required = true,
                                 default = nil)
  if valid_580509 != nil:
    section.add "pageId", valid_580509
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
  var valid_580510 = query.getOrDefault("fields")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "fields", valid_580510
  var valid_580511 = query.getOrDefault("quotaUser")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "quotaUser", valid_580511
  var valid_580512 = query.getOrDefault("alt")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = newJString("json"))
  if valid_580512 != nil:
    section.add "alt", valid_580512
  var valid_580513 = query.getOrDefault("oauth_token")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "oauth_token", valid_580513
  var valid_580514 = query.getOrDefault("userIp")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "userIp", valid_580514
  var valid_580515 = query.getOrDefault("key")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "key", valid_580515
  var valid_580516 = query.getOrDefault("prettyPrint")
  valid_580516 = validateParameter(valid_580516, JBool, required = false,
                                 default = newJBool(true))
  if valid_580516 != nil:
    section.add "prettyPrint", valid_580516
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

proc call*(call_580518: Call_AndroidenterpriseStorelayoutclustersInsert_580505;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new cluster in a page.
  ## 
  let valid = call_580518.validator(path, query, header, formData, body)
  let scheme = call_580518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580518.url(scheme.get, call_580518.host, call_580518.base,
                         call_580518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580518, url, valid)

proc call*(call_580519: Call_AndroidenterpriseStorelayoutclustersInsert_580505;
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
  var path_580520 = newJObject()
  var query_580521 = newJObject()
  var body_580522 = newJObject()
  add(query_580521, "fields", newJString(fields))
  add(query_580521, "quotaUser", newJString(quotaUser))
  add(query_580521, "alt", newJString(alt))
  add(query_580521, "oauth_token", newJString(oauthToken))
  add(query_580521, "userIp", newJString(userIp))
  add(query_580521, "key", newJString(key))
  add(path_580520, "enterpriseId", newJString(enterpriseId))
  add(path_580520, "pageId", newJString(pageId))
  if body != nil:
    body_580522 = body
  add(query_580521, "prettyPrint", newJBool(prettyPrint))
  result = call_580519.call(path_580520, query_580521, nil, nil, body_580522)

var androidenterpriseStorelayoutclustersInsert* = Call_AndroidenterpriseStorelayoutclustersInsert_580505(
    name: "androidenterpriseStorelayoutclustersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters",
    validator: validate_AndroidenterpriseStorelayoutclustersInsert_580506,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersInsert_580507,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersList_580489 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseStorelayoutclustersList_580491(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseStorelayoutclustersList_580490(path: JsonNode;
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
  var valid_580492 = path.getOrDefault("enterpriseId")
  valid_580492 = validateParameter(valid_580492, JString, required = true,
                                 default = nil)
  if valid_580492 != nil:
    section.add "enterpriseId", valid_580492
  var valid_580493 = path.getOrDefault("pageId")
  valid_580493 = validateParameter(valid_580493, JString, required = true,
                                 default = nil)
  if valid_580493 != nil:
    section.add "pageId", valid_580493
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
  var valid_580494 = query.getOrDefault("fields")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "fields", valid_580494
  var valid_580495 = query.getOrDefault("quotaUser")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "quotaUser", valid_580495
  var valid_580496 = query.getOrDefault("alt")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = newJString("json"))
  if valid_580496 != nil:
    section.add "alt", valid_580496
  var valid_580497 = query.getOrDefault("oauth_token")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = nil)
  if valid_580497 != nil:
    section.add "oauth_token", valid_580497
  var valid_580498 = query.getOrDefault("userIp")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "userIp", valid_580498
  var valid_580499 = query.getOrDefault("key")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "key", valid_580499
  var valid_580500 = query.getOrDefault("prettyPrint")
  valid_580500 = validateParameter(valid_580500, JBool, required = false,
                                 default = newJBool(true))
  if valid_580500 != nil:
    section.add "prettyPrint", valid_580500
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580501: Call_AndroidenterpriseStorelayoutclustersList_580489;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all clusters on the specified page.
  ## 
  let valid = call_580501.validator(path, query, header, formData, body)
  let scheme = call_580501.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580501.url(scheme.get, call_580501.host, call_580501.base,
                         call_580501.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580501, url, valid)

proc call*(call_580502: Call_AndroidenterpriseStorelayoutclustersList_580489;
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
  var path_580503 = newJObject()
  var query_580504 = newJObject()
  add(query_580504, "fields", newJString(fields))
  add(query_580504, "quotaUser", newJString(quotaUser))
  add(query_580504, "alt", newJString(alt))
  add(query_580504, "oauth_token", newJString(oauthToken))
  add(query_580504, "userIp", newJString(userIp))
  add(query_580504, "key", newJString(key))
  add(path_580503, "enterpriseId", newJString(enterpriseId))
  add(path_580503, "pageId", newJString(pageId))
  add(query_580504, "prettyPrint", newJBool(prettyPrint))
  result = call_580502.call(path_580503, query_580504, nil, nil, nil)

var androidenterpriseStorelayoutclustersList* = Call_AndroidenterpriseStorelayoutclustersList_580489(
    name: "androidenterpriseStorelayoutclustersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters",
    validator: validate_AndroidenterpriseStorelayoutclustersList_580490,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersList_580491,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersUpdate_580540 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseStorelayoutclustersUpdate_580542(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseStorelayoutclustersUpdate_580541(path: JsonNode;
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
  var valid_580543 = path.getOrDefault("enterpriseId")
  valid_580543 = validateParameter(valid_580543, JString, required = true,
                                 default = nil)
  if valid_580543 != nil:
    section.add "enterpriseId", valid_580543
  var valid_580544 = path.getOrDefault("pageId")
  valid_580544 = validateParameter(valid_580544, JString, required = true,
                                 default = nil)
  if valid_580544 != nil:
    section.add "pageId", valid_580544
  var valid_580545 = path.getOrDefault("clusterId")
  valid_580545 = validateParameter(valid_580545, JString, required = true,
                                 default = nil)
  if valid_580545 != nil:
    section.add "clusterId", valid_580545
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
  var valid_580546 = query.getOrDefault("fields")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "fields", valid_580546
  var valid_580547 = query.getOrDefault("quotaUser")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "quotaUser", valid_580547
  var valid_580548 = query.getOrDefault("alt")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = newJString("json"))
  if valid_580548 != nil:
    section.add "alt", valid_580548
  var valid_580549 = query.getOrDefault("oauth_token")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "oauth_token", valid_580549
  var valid_580550 = query.getOrDefault("userIp")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "userIp", valid_580550
  var valid_580551 = query.getOrDefault("key")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "key", valid_580551
  var valid_580552 = query.getOrDefault("prettyPrint")
  valid_580552 = validateParameter(valid_580552, JBool, required = false,
                                 default = newJBool(true))
  if valid_580552 != nil:
    section.add "prettyPrint", valid_580552
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

proc call*(call_580554: Call_AndroidenterpriseStorelayoutclustersUpdate_580540;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster.
  ## 
  let valid = call_580554.validator(path, query, header, formData, body)
  let scheme = call_580554.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580554.url(scheme.get, call_580554.host, call_580554.base,
                         call_580554.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580554, url, valid)

proc call*(call_580555: Call_AndroidenterpriseStorelayoutclustersUpdate_580540;
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
  var path_580556 = newJObject()
  var query_580557 = newJObject()
  var body_580558 = newJObject()
  add(query_580557, "fields", newJString(fields))
  add(query_580557, "quotaUser", newJString(quotaUser))
  add(query_580557, "alt", newJString(alt))
  add(query_580557, "oauth_token", newJString(oauthToken))
  add(query_580557, "userIp", newJString(userIp))
  add(query_580557, "key", newJString(key))
  add(path_580556, "enterpriseId", newJString(enterpriseId))
  add(path_580556, "pageId", newJString(pageId))
  if body != nil:
    body_580558 = body
  add(query_580557, "prettyPrint", newJBool(prettyPrint))
  add(path_580556, "clusterId", newJString(clusterId))
  result = call_580555.call(path_580556, query_580557, nil, nil, body_580558)

var androidenterpriseStorelayoutclustersUpdate* = Call_AndroidenterpriseStorelayoutclustersUpdate_580540(
    name: "androidenterpriseStorelayoutclustersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersUpdate_580541,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersUpdate_580542,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersGet_580523 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseStorelayoutclustersGet_580525(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseStorelayoutclustersGet_580524(path: JsonNode;
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
  var valid_580526 = path.getOrDefault("enterpriseId")
  valid_580526 = validateParameter(valid_580526, JString, required = true,
                                 default = nil)
  if valid_580526 != nil:
    section.add "enterpriseId", valid_580526
  var valid_580527 = path.getOrDefault("pageId")
  valid_580527 = validateParameter(valid_580527, JString, required = true,
                                 default = nil)
  if valid_580527 != nil:
    section.add "pageId", valid_580527
  var valid_580528 = path.getOrDefault("clusterId")
  valid_580528 = validateParameter(valid_580528, JString, required = true,
                                 default = nil)
  if valid_580528 != nil:
    section.add "clusterId", valid_580528
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
  var valid_580529 = query.getOrDefault("fields")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "fields", valid_580529
  var valid_580530 = query.getOrDefault("quotaUser")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "quotaUser", valid_580530
  var valid_580531 = query.getOrDefault("alt")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = newJString("json"))
  if valid_580531 != nil:
    section.add "alt", valid_580531
  var valid_580532 = query.getOrDefault("oauth_token")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "oauth_token", valid_580532
  var valid_580533 = query.getOrDefault("userIp")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "userIp", valid_580533
  var valid_580534 = query.getOrDefault("key")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "key", valid_580534
  var valid_580535 = query.getOrDefault("prettyPrint")
  valid_580535 = validateParameter(valid_580535, JBool, required = false,
                                 default = newJBool(true))
  if valid_580535 != nil:
    section.add "prettyPrint", valid_580535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580536: Call_AndroidenterpriseStorelayoutclustersGet_580523;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a cluster.
  ## 
  let valid = call_580536.validator(path, query, header, formData, body)
  let scheme = call_580536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580536.url(scheme.get, call_580536.host, call_580536.base,
                         call_580536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580536, url, valid)

proc call*(call_580537: Call_AndroidenterpriseStorelayoutclustersGet_580523;
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
  var path_580538 = newJObject()
  var query_580539 = newJObject()
  add(query_580539, "fields", newJString(fields))
  add(query_580539, "quotaUser", newJString(quotaUser))
  add(query_580539, "alt", newJString(alt))
  add(query_580539, "oauth_token", newJString(oauthToken))
  add(query_580539, "userIp", newJString(userIp))
  add(query_580539, "key", newJString(key))
  add(path_580538, "enterpriseId", newJString(enterpriseId))
  add(path_580538, "pageId", newJString(pageId))
  add(query_580539, "prettyPrint", newJBool(prettyPrint))
  add(path_580538, "clusterId", newJString(clusterId))
  result = call_580537.call(path_580538, query_580539, nil, nil, nil)

var androidenterpriseStorelayoutclustersGet* = Call_AndroidenterpriseStorelayoutclustersGet_580523(
    name: "androidenterpriseStorelayoutclustersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersGet_580524,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersGet_580525,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersPatch_580576 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseStorelayoutclustersPatch_580578(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseStorelayoutclustersPatch_580577(path: JsonNode;
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
  var valid_580579 = path.getOrDefault("enterpriseId")
  valid_580579 = validateParameter(valid_580579, JString, required = true,
                                 default = nil)
  if valid_580579 != nil:
    section.add "enterpriseId", valid_580579
  var valid_580580 = path.getOrDefault("pageId")
  valid_580580 = validateParameter(valid_580580, JString, required = true,
                                 default = nil)
  if valid_580580 != nil:
    section.add "pageId", valid_580580
  var valid_580581 = path.getOrDefault("clusterId")
  valid_580581 = validateParameter(valid_580581, JString, required = true,
                                 default = nil)
  if valid_580581 != nil:
    section.add "clusterId", valid_580581
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
  var valid_580582 = query.getOrDefault("fields")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "fields", valid_580582
  var valid_580583 = query.getOrDefault("quotaUser")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "quotaUser", valid_580583
  var valid_580584 = query.getOrDefault("alt")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = newJString("json"))
  if valid_580584 != nil:
    section.add "alt", valid_580584
  var valid_580585 = query.getOrDefault("oauth_token")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "oauth_token", valid_580585
  var valid_580586 = query.getOrDefault("userIp")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = nil)
  if valid_580586 != nil:
    section.add "userIp", valid_580586
  var valid_580587 = query.getOrDefault("key")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "key", valid_580587
  var valid_580588 = query.getOrDefault("prettyPrint")
  valid_580588 = validateParameter(valid_580588, JBool, required = false,
                                 default = newJBool(true))
  if valid_580588 != nil:
    section.add "prettyPrint", valid_580588
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

proc call*(call_580590: Call_AndroidenterpriseStorelayoutclustersPatch_580576;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster. This method supports patch semantics.
  ## 
  let valid = call_580590.validator(path, query, header, formData, body)
  let scheme = call_580590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580590.url(scheme.get, call_580590.host, call_580590.base,
                         call_580590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580590, url, valid)

proc call*(call_580591: Call_AndroidenterpriseStorelayoutclustersPatch_580576;
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
  var path_580592 = newJObject()
  var query_580593 = newJObject()
  var body_580594 = newJObject()
  add(query_580593, "fields", newJString(fields))
  add(query_580593, "quotaUser", newJString(quotaUser))
  add(query_580593, "alt", newJString(alt))
  add(query_580593, "oauth_token", newJString(oauthToken))
  add(query_580593, "userIp", newJString(userIp))
  add(query_580593, "key", newJString(key))
  add(path_580592, "enterpriseId", newJString(enterpriseId))
  add(path_580592, "pageId", newJString(pageId))
  if body != nil:
    body_580594 = body
  add(query_580593, "prettyPrint", newJBool(prettyPrint))
  add(path_580592, "clusterId", newJString(clusterId))
  result = call_580591.call(path_580592, query_580593, nil, nil, body_580594)

var androidenterpriseStorelayoutclustersPatch* = Call_AndroidenterpriseStorelayoutclustersPatch_580576(
    name: "androidenterpriseStorelayoutclustersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersPatch_580577,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersPatch_580578,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersDelete_580559 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseStorelayoutclustersDelete_580561(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseStorelayoutclustersDelete_580560(path: JsonNode;
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
  var valid_580562 = path.getOrDefault("enterpriseId")
  valid_580562 = validateParameter(valid_580562, JString, required = true,
                                 default = nil)
  if valid_580562 != nil:
    section.add "enterpriseId", valid_580562
  var valid_580563 = path.getOrDefault("pageId")
  valid_580563 = validateParameter(valid_580563, JString, required = true,
                                 default = nil)
  if valid_580563 != nil:
    section.add "pageId", valid_580563
  var valid_580564 = path.getOrDefault("clusterId")
  valid_580564 = validateParameter(valid_580564, JString, required = true,
                                 default = nil)
  if valid_580564 != nil:
    section.add "clusterId", valid_580564
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
  var valid_580565 = query.getOrDefault("fields")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = nil)
  if valid_580565 != nil:
    section.add "fields", valid_580565
  var valid_580566 = query.getOrDefault("quotaUser")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "quotaUser", valid_580566
  var valid_580567 = query.getOrDefault("alt")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = newJString("json"))
  if valid_580567 != nil:
    section.add "alt", valid_580567
  var valid_580568 = query.getOrDefault("oauth_token")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "oauth_token", valid_580568
  var valid_580569 = query.getOrDefault("userIp")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "userIp", valid_580569
  var valid_580570 = query.getOrDefault("key")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "key", valid_580570
  var valid_580571 = query.getOrDefault("prettyPrint")
  valid_580571 = validateParameter(valid_580571, JBool, required = false,
                                 default = newJBool(true))
  if valid_580571 != nil:
    section.add "prettyPrint", valid_580571
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580572: Call_AndroidenterpriseStorelayoutclustersDelete_580559;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a cluster.
  ## 
  let valid = call_580572.validator(path, query, header, formData, body)
  let scheme = call_580572.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580572.url(scheme.get, call_580572.host, call_580572.base,
                         call_580572.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580572, url, valid)

proc call*(call_580573: Call_AndroidenterpriseStorelayoutclustersDelete_580559;
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
  var path_580574 = newJObject()
  var query_580575 = newJObject()
  add(query_580575, "fields", newJString(fields))
  add(query_580575, "quotaUser", newJString(quotaUser))
  add(query_580575, "alt", newJString(alt))
  add(query_580575, "oauth_token", newJString(oauthToken))
  add(query_580575, "userIp", newJString(userIp))
  add(query_580575, "key", newJString(key))
  add(path_580574, "enterpriseId", newJString(enterpriseId))
  add(path_580574, "pageId", newJString(pageId))
  add(query_580575, "prettyPrint", newJBool(prettyPrint))
  add(path_580574, "clusterId", newJString(clusterId))
  result = call_580573.call(path_580574, query_580575, nil, nil, nil)

var androidenterpriseStorelayoutclustersDelete* = Call_AndroidenterpriseStorelayoutclustersDelete_580559(
    name: "androidenterpriseStorelayoutclustersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersDelete_580560,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersDelete_580561,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesUnenroll_580595 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEnterprisesUnenroll_580597(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseEnterprisesUnenroll_580596(path: JsonNode;
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
  var valid_580598 = path.getOrDefault("enterpriseId")
  valid_580598 = validateParameter(valid_580598, JString, required = true,
                                 default = nil)
  if valid_580598 != nil:
    section.add "enterpriseId", valid_580598
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
  var valid_580599 = query.getOrDefault("fields")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "fields", valid_580599
  var valid_580600 = query.getOrDefault("quotaUser")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "quotaUser", valid_580600
  var valid_580601 = query.getOrDefault("alt")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = newJString("json"))
  if valid_580601 != nil:
    section.add "alt", valid_580601
  var valid_580602 = query.getOrDefault("oauth_token")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = nil)
  if valid_580602 != nil:
    section.add "oauth_token", valid_580602
  var valid_580603 = query.getOrDefault("userIp")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "userIp", valid_580603
  var valid_580604 = query.getOrDefault("key")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "key", valid_580604
  var valid_580605 = query.getOrDefault("prettyPrint")
  valid_580605 = validateParameter(valid_580605, JBool, required = false,
                                 default = newJBool(true))
  if valid_580605 != nil:
    section.add "prettyPrint", valid_580605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580606: Call_AndroidenterpriseEnterprisesUnenroll_580595;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unenrolls an enterprise from the calling EMM.
  ## 
  let valid = call_580606.validator(path, query, header, formData, body)
  let scheme = call_580606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580606.url(scheme.get, call_580606.host, call_580606.base,
                         call_580606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580606, url, valid)

proc call*(call_580607: Call_AndroidenterpriseEnterprisesUnenroll_580595;
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
  var path_580608 = newJObject()
  var query_580609 = newJObject()
  add(query_580609, "fields", newJString(fields))
  add(query_580609, "quotaUser", newJString(quotaUser))
  add(query_580609, "alt", newJString(alt))
  add(query_580609, "oauth_token", newJString(oauthToken))
  add(query_580609, "userIp", newJString(userIp))
  add(query_580609, "key", newJString(key))
  add(path_580608, "enterpriseId", newJString(enterpriseId))
  add(query_580609, "prettyPrint", newJBool(prettyPrint))
  result = call_580607.call(path_580608, query_580609, nil, nil, nil)

var androidenterpriseEnterprisesUnenroll* = Call_AndroidenterpriseEnterprisesUnenroll_580595(
    name: "androidenterpriseEnterprisesUnenroll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/unenroll",
    validator: validate_AndroidenterpriseEnterprisesUnenroll_580596,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesUnenroll_580597,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersInsert_580626 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseUsersInsert_580628(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseUsersInsert_580627(path: JsonNode; query: JsonNode;
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
  var valid_580629 = path.getOrDefault("enterpriseId")
  valid_580629 = validateParameter(valid_580629, JString, required = true,
                                 default = nil)
  if valid_580629 != nil:
    section.add "enterpriseId", valid_580629
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
  var valid_580630 = query.getOrDefault("fields")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "fields", valid_580630
  var valid_580631 = query.getOrDefault("quotaUser")
  valid_580631 = validateParameter(valid_580631, JString, required = false,
                                 default = nil)
  if valid_580631 != nil:
    section.add "quotaUser", valid_580631
  var valid_580632 = query.getOrDefault("alt")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = newJString("json"))
  if valid_580632 != nil:
    section.add "alt", valid_580632
  var valid_580633 = query.getOrDefault("oauth_token")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "oauth_token", valid_580633
  var valid_580634 = query.getOrDefault("userIp")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "userIp", valid_580634
  var valid_580635 = query.getOrDefault("key")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "key", valid_580635
  var valid_580636 = query.getOrDefault("prettyPrint")
  valid_580636 = validateParameter(valid_580636, JBool, required = false,
                                 default = newJBool(true))
  if valid_580636 != nil:
    section.add "prettyPrint", valid_580636
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

proc call*(call_580638: Call_AndroidenterpriseUsersInsert_580626; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new EMM-managed user.
  ## 
  ## The Users resource passed in the body of the request should include an accountIdentifier and an accountType.
  ## If a corresponding user already exists with the same account identifier, the user will be updated with the resource. In this case only the displayName field can be changed.
  ## 
  let valid = call_580638.validator(path, query, header, formData, body)
  let scheme = call_580638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580638.url(scheme.get, call_580638.host, call_580638.base,
                         call_580638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580638, url, valid)

proc call*(call_580639: Call_AndroidenterpriseUsersInsert_580626;
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
  var path_580640 = newJObject()
  var query_580641 = newJObject()
  var body_580642 = newJObject()
  add(query_580641, "fields", newJString(fields))
  add(query_580641, "quotaUser", newJString(quotaUser))
  add(query_580641, "alt", newJString(alt))
  add(query_580641, "oauth_token", newJString(oauthToken))
  add(query_580641, "userIp", newJString(userIp))
  add(query_580641, "key", newJString(key))
  add(path_580640, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580642 = body
  add(query_580641, "prettyPrint", newJBool(prettyPrint))
  result = call_580639.call(path_580640, query_580641, nil, nil, body_580642)

var androidenterpriseUsersInsert* = Call_AndroidenterpriseUsersInsert_580626(
    name: "androidenterpriseUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users",
    validator: validate_AndroidenterpriseUsersInsert_580627,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersInsert_580628,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersList_580610 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseUsersList_580612(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseUsersList_580611(path: JsonNode; query: JsonNode;
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
  var valid_580613 = path.getOrDefault("enterpriseId")
  valid_580613 = validateParameter(valid_580613, JString, required = true,
                                 default = nil)
  if valid_580613 != nil:
    section.add "enterpriseId", valid_580613
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
  var valid_580614 = query.getOrDefault("fields")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "fields", valid_580614
  var valid_580615 = query.getOrDefault("quotaUser")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "quotaUser", valid_580615
  var valid_580616 = query.getOrDefault("alt")
  valid_580616 = validateParameter(valid_580616, JString, required = false,
                                 default = newJString("json"))
  if valid_580616 != nil:
    section.add "alt", valid_580616
  var valid_580617 = query.getOrDefault("oauth_token")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "oauth_token", valid_580617
  var valid_580618 = query.getOrDefault("userIp")
  valid_580618 = validateParameter(valid_580618, JString, required = false,
                                 default = nil)
  if valid_580618 != nil:
    section.add "userIp", valid_580618
  assert query != nil, "query argument is necessary due to required `email` field"
  var valid_580619 = query.getOrDefault("email")
  valid_580619 = validateParameter(valid_580619, JString, required = true,
                                 default = nil)
  if valid_580619 != nil:
    section.add "email", valid_580619
  var valid_580620 = query.getOrDefault("key")
  valid_580620 = validateParameter(valid_580620, JString, required = false,
                                 default = nil)
  if valid_580620 != nil:
    section.add "key", valid_580620
  var valid_580621 = query.getOrDefault("prettyPrint")
  valid_580621 = validateParameter(valid_580621, JBool, required = false,
                                 default = newJBool(true))
  if valid_580621 != nil:
    section.add "prettyPrint", valid_580621
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580622: Call_AndroidenterpriseUsersList_580610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Looks up a user by primary email address. This is only supported for Google-managed users. Lookup of the id is not needed for EMM-managed users because the id is already returned in the result of the Users.insert call.
  ## 
  let valid = call_580622.validator(path, query, header, formData, body)
  let scheme = call_580622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580622.url(scheme.get, call_580622.host, call_580622.base,
                         call_580622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580622, url, valid)

proc call*(call_580623: Call_AndroidenterpriseUsersList_580610; email: string;
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
  var path_580624 = newJObject()
  var query_580625 = newJObject()
  add(query_580625, "fields", newJString(fields))
  add(query_580625, "quotaUser", newJString(quotaUser))
  add(query_580625, "alt", newJString(alt))
  add(query_580625, "oauth_token", newJString(oauthToken))
  add(query_580625, "userIp", newJString(userIp))
  add(query_580625, "email", newJString(email))
  add(query_580625, "key", newJString(key))
  add(path_580624, "enterpriseId", newJString(enterpriseId))
  add(query_580625, "prettyPrint", newJBool(prettyPrint))
  result = call_580623.call(path_580624, query_580625, nil, nil, nil)

var androidenterpriseUsersList* = Call_AndroidenterpriseUsersList_580610(
    name: "androidenterpriseUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users",
    validator: validate_AndroidenterpriseUsersList_580611,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersList_580612,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersUpdate_580659 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseUsersUpdate_580661(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseUsersUpdate_580660(path: JsonNode; query: JsonNode;
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
  var valid_580662 = path.getOrDefault("enterpriseId")
  valid_580662 = validateParameter(valid_580662, JString, required = true,
                                 default = nil)
  if valid_580662 != nil:
    section.add "enterpriseId", valid_580662
  var valid_580663 = path.getOrDefault("userId")
  valid_580663 = validateParameter(valid_580663, JString, required = true,
                                 default = nil)
  if valid_580663 != nil:
    section.add "userId", valid_580663
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
  var valid_580664 = query.getOrDefault("fields")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "fields", valid_580664
  var valid_580665 = query.getOrDefault("quotaUser")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = nil)
  if valid_580665 != nil:
    section.add "quotaUser", valid_580665
  var valid_580666 = query.getOrDefault("alt")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = newJString("json"))
  if valid_580666 != nil:
    section.add "alt", valid_580666
  var valid_580667 = query.getOrDefault("oauth_token")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "oauth_token", valid_580667
  var valid_580668 = query.getOrDefault("userIp")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "userIp", valid_580668
  var valid_580669 = query.getOrDefault("key")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = nil)
  if valid_580669 != nil:
    section.add "key", valid_580669
  var valid_580670 = query.getOrDefault("prettyPrint")
  valid_580670 = validateParameter(valid_580670, JBool, required = false,
                                 default = newJBool(true))
  if valid_580670 != nil:
    section.add "prettyPrint", valid_580670
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

proc call*(call_580672: Call_AndroidenterpriseUsersUpdate_580659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value.
  ## 
  let valid = call_580672.validator(path, query, header, formData, body)
  let scheme = call_580672.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580672.url(scheme.get, call_580672.host, call_580672.base,
                         call_580672.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580672, url, valid)

proc call*(call_580673: Call_AndroidenterpriseUsersUpdate_580659;
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
  var path_580674 = newJObject()
  var query_580675 = newJObject()
  var body_580676 = newJObject()
  add(query_580675, "fields", newJString(fields))
  add(query_580675, "quotaUser", newJString(quotaUser))
  add(query_580675, "alt", newJString(alt))
  add(query_580675, "oauth_token", newJString(oauthToken))
  add(query_580675, "userIp", newJString(userIp))
  add(query_580675, "key", newJString(key))
  add(path_580674, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580676 = body
  add(query_580675, "prettyPrint", newJBool(prettyPrint))
  add(path_580674, "userId", newJString(userId))
  result = call_580673.call(path_580674, query_580675, nil, nil, body_580676)

var androidenterpriseUsersUpdate* = Call_AndroidenterpriseUsersUpdate_580659(
    name: "androidenterpriseUsersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersUpdate_580660,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersUpdate_580661,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGet_580643 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseUsersGet_580645(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseUsersGet_580644(path: JsonNode; query: JsonNode;
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
  var valid_580646 = path.getOrDefault("enterpriseId")
  valid_580646 = validateParameter(valid_580646, JString, required = true,
                                 default = nil)
  if valid_580646 != nil:
    section.add "enterpriseId", valid_580646
  var valid_580647 = path.getOrDefault("userId")
  valid_580647 = validateParameter(valid_580647, JString, required = true,
                                 default = nil)
  if valid_580647 != nil:
    section.add "userId", valid_580647
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
  var valid_580648 = query.getOrDefault("fields")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "fields", valid_580648
  var valid_580649 = query.getOrDefault("quotaUser")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = nil)
  if valid_580649 != nil:
    section.add "quotaUser", valid_580649
  var valid_580650 = query.getOrDefault("alt")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = newJString("json"))
  if valid_580650 != nil:
    section.add "alt", valid_580650
  var valid_580651 = query.getOrDefault("oauth_token")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "oauth_token", valid_580651
  var valid_580652 = query.getOrDefault("userIp")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "userIp", valid_580652
  var valid_580653 = query.getOrDefault("key")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "key", valid_580653
  var valid_580654 = query.getOrDefault("prettyPrint")
  valid_580654 = validateParameter(valid_580654, JBool, required = false,
                                 default = newJBool(true))
  if valid_580654 != nil:
    section.add "prettyPrint", valid_580654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580655: Call_AndroidenterpriseUsersGet_580643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a user's details.
  ## 
  let valid = call_580655.validator(path, query, header, formData, body)
  let scheme = call_580655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580655.url(scheme.get, call_580655.host, call_580655.base,
                         call_580655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580655, url, valid)

proc call*(call_580656: Call_AndroidenterpriseUsersGet_580643;
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
  var path_580657 = newJObject()
  var query_580658 = newJObject()
  add(query_580658, "fields", newJString(fields))
  add(query_580658, "quotaUser", newJString(quotaUser))
  add(query_580658, "alt", newJString(alt))
  add(query_580658, "oauth_token", newJString(oauthToken))
  add(query_580658, "userIp", newJString(userIp))
  add(query_580658, "key", newJString(key))
  add(path_580657, "enterpriseId", newJString(enterpriseId))
  add(query_580658, "prettyPrint", newJBool(prettyPrint))
  add(path_580657, "userId", newJString(userId))
  result = call_580656.call(path_580657, query_580658, nil, nil, nil)

var androidenterpriseUsersGet* = Call_AndroidenterpriseUsersGet_580643(
    name: "androidenterpriseUsersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersGet_580644,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersGet_580645,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersPatch_580693 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseUsersPatch_580695(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseUsersPatch_580694(path: JsonNode; query: JsonNode;
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
  var valid_580696 = path.getOrDefault("enterpriseId")
  valid_580696 = validateParameter(valid_580696, JString, required = true,
                                 default = nil)
  if valid_580696 != nil:
    section.add "enterpriseId", valid_580696
  var valid_580697 = path.getOrDefault("userId")
  valid_580697 = validateParameter(valid_580697, JString, required = true,
                                 default = nil)
  if valid_580697 != nil:
    section.add "userId", valid_580697
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
  var valid_580698 = query.getOrDefault("fields")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "fields", valid_580698
  var valid_580699 = query.getOrDefault("quotaUser")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "quotaUser", valid_580699
  var valid_580700 = query.getOrDefault("alt")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = newJString("json"))
  if valid_580700 != nil:
    section.add "alt", valid_580700
  var valid_580701 = query.getOrDefault("oauth_token")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = nil)
  if valid_580701 != nil:
    section.add "oauth_token", valid_580701
  var valid_580702 = query.getOrDefault("userIp")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = nil)
  if valid_580702 != nil:
    section.add "userIp", valid_580702
  var valid_580703 = query.getOrDefault("key")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "key", valid_580703
  var valid_580704 = query.getOrDefault("prettyPrint")
  valid_580704 = validateParameter(valid_580704, JBool, required = false,
                                 default = newJBool(true))
  if valid_580704 != nil:
    section.add "prettyPrint", valid_580704
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

proc call*(call_580706: Call_AndroidenterpriseUsersPatch_580693; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value. This method supports patch semantics.
  ## 
  let valid = call_580706.validator(path, query, header, formData, body)
  let scheme = call_580706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580706.url(scheme.get, call_580706.host, call_580706.base,
                         call_580706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580706, url, valid)

proc call*(call_580707: Call_AndroidenterpriseUsersPatch_580693;
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
  var path_580708 = newJObject()
  var query_580709 = newJObject()
  var body_580710 = newJObject()
  add(query_580709, "fields", newJString(fields))
  add(query_580709, "quotaUser", newJString(quotaUser))
  add(query_580709, "alt", newJString(alt))
  add(query_580709, "oauth_token", newJString(oauthToken))
  add(query_580709, "userIp", newJString(userIp))
  add(query_580709, "key", newJString(key))
  add(path_580708, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580710 = body
  add(query_580709, "prettyPrint", newJBool(prettyPrint))
  add(path_580708, "userId", newJString(userId))
  result = call_580707.call(path_580708, query_580709, nil, nil, body_580710)

var androidenterpriseUsersPatch* = Call_AndroidenterpriseUsersPatch_580693(
    name: "androidenterpriseUsersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersPatch_580694,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersPatch_580695,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersDelete_580677 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseUsersDelete_580679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseUsersDelete_580678(path: JsonNode; query: JsonNode;
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
  var valid_580680 = path.getOrDefault("enterpriseId")
  valid_580680 = validateParameter(valid_580680, JString, required = true,
                                 default = nil)
  if valid_580680 != nil:
    section.add "enterpriseId", valid_580680
  var valid_580681 = path.getOrDefault("userId")
  valid_580681 = validateParameter(valid_580681, JString, required = true,
                                 default = nil)
  if valid_580681 != nil:
    section.add "userId", valid_580681
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
  var valid_580682 = query.getOrDefault("fields")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = nil)
  if valid_580682 != nil:
    section.add "fields", valid_580682
  var valid_580683 = query.getOrDefault("quotaUser")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = nil)
  if valid_580683 != nil:
    section.add "quotaUser", valid_580683
  var valid_580684 = query.getOrDefault("alt")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = newJString("json"))
  if valid_580684 != nil:
    section.add "alt", valid_580684
  var valid_580685 = query.getOrDefault("oauth_token")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = nil)
  if valid_580685 != nil:
    section.add "oauth_token", valid_580685
  var valid_580686 = query.getOrDefault("userIp")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = nil)
  if valid_580686 != nil:
    section.add "userIp", valid_580686
  var valid_580687 = query.getOrDefault("key")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = nil)
  if valid_580687 != nil:
    section.add "key", valid_580687
  var valid_580688 = query.getOrDefault("prettyPrint")
  valid_580688 = validateParameter(valid_580688, JBool, required = false,
                                 default = newJBool(true))
  if valid_580688 != nil:
    section.add "prettyPrint", valid_580688
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580689: Call_AndroidenterpriseUsersDelete_580677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deleted an EMM-managed user.
  ## 
  let valid = call_580689.validator(path, query, header, formData, body)
  let scheme = call_580689.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580689.url(scheme.get, call_580689.host, call_580689.base,
                         call_580689.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580689, url, valid)

proc call*(call_580690: Call_AndroidenterpriseUsersDelete_580677;
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
  var path_580691 = newJObject()
  var query_580692 = newJObject()
  add(query_580692, "fields", newJString(fields))
  add(query_580692, "quotaUser", newJString(quotaUser))
  add(query_580692, "alt", newJString(alt))
  add(query_580692, "oauth_token", newJString(oauthToken))
  add(query_580692, "userIp", newJString(userIp))
  add(query_580692, "key", newJString(key))
  add(path_580691, "enterpriseId", newJString(enterpriseId))
  add(query_580692, "prettyPrint", newJBool(prettyPrint))
  add(path_580691, "userId", newJString(userId))
  result = call_580690.call(path_580691, query_580692, nil, nil, nil)

var androidenterpriseUsersDelete* = Call_AndroidenterpriseUsersDelete_580677(
    name: "androidenterpriseUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersDelete_580678,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersDelete_580679,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGenerateAuthenticationToken_580711 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseUsersGenerateAuthenticationToken_580713(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseUsersGenerateAuthenticationToken_580712(
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
  var valid_580714 = path.getOrDefault("enterpriseId")
  valid_580714 = validateParameter(valid_580714, JString, required = true,
                                 default = nil)
  if valid_580714 != nil:
    section.add "enterpriseId", valid_580714
  var valid_580715 = path.getOrDefault("userId")
  valid_580715 = validateParameter(valid_580715, JString, required = true,
                                 default = nil)
  if valid_580715 != nil:
    section.add "userId", valid_580715
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
  var valid_580716 = query.getOrDefault("fields")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "fields", valid_580716
  var valid_580717 = query.getOrDefault("quotaUser")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = nil)
  if valid_580717 != nil:
    section.add "quotaUser", valid_580717
  var valid_580718 = query.getOrDefault("alt")
  valid_580718 = validateParameter(valid_580718, JString, required = false,
                                 default = newJString("json"))
  if valid_580718 != nil:
    section.add "alt", valid_580718
  var valid_580719 = query.getOrDefault("oauth_token")
  valid_580719 = validateParameter(valid_580719, JString, required = false,
                                 default = nil)
  if valid_580719 != nil:
    section.add "oauth_token", valid_580719
  var valid_580720 = query.getOrDefault("userIp")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "userIp", valid_580720
  var valid_580721 = query.getOrDefault("key")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "key", valid_580721
  var valid_580722 = query.getOrDefault("prettyPrint")
  valid_580722 = validateParameter(valid_580722, JBool, required = false,
                                 default = newJBool(true))
  if valid_580722 != nil:
    section.add "prettyPrint", valid_580722
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580723: Call_AndroidenterpriseUsersGenerateAuthenticationToken_580711;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates an authentication token which the device policy client can use to provision the given EMM-managed user account on a device. The generated token is single-use and expires after a few minutes.
  ## 
  ## You can provision a maximum of 10 devices per user.
  ## 
  ## This call only works with EMM-managed accounts.
  ## 
  let valid = call_580723.validator(path, query, header, formData, body)
  let scheme = call_580723.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580723.url(scheme.get, call_580723.host, call_580723.base,
                         call_580723.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580723, url, valid)

proc call*(call_580724: Call_AndroidenterpriseUsersGenerateAuthenticationToken_580711;
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
  var path_580725 = newJObject()
  var query_580726 = newJObject()
  add(query_580726, "fields", newJString(fields))
  add(query_580726, "quotaUser", newJString(quotaUser))
  add(query_580726, "alt", newJString(alt))
  add(query_580726, "oauth_token", newJString(oauthToken))
  add(query_580726, "userIp", newJString(userIp))
  add(query_580726, "key", newJString(key))
  add(path_580725, "enterpriseId", newJString(enterpriseId))
  add(query_580726, "prettyPrint", newJBool(prettyPrint))
  add(path_580725, "userId", newJString(userId))
  result = call_580724.call(path_580725, query_580726, nil, nil, nil)

var androidenterpriseUsersGenerateAuthenticationToken* = Call_AndroidenterpriseUsersGenerateAuthenticationToken_580711(
    name: "androidenterpriseUsersGenerateAuthenticationToken",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/authenticationToken",
    validator: validate_AndroidenterpriseUsersGenerateAuthenticationToken_580712,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersGenerateAuthenticationToken_580713,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersSetAvailableProductSet_580743 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseUsersSetAvailableProductSet_580745(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseUsersSetAvailableProductSet_580744(path: JsonNode;
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
  var valid_580746 = path.getOrDefault("enterpriseId")
  valid_580746 = validateParameter(valid_580746, JString, required = true,
                                 default = nil)
  if valid_580746 != nil:
    section.add "enterpriseId", valid_580746
  var valid_580747 = path.getOrDefault("userId")
  valid_580747 = validateParameter(valid_580747, JString, required = true,
                                 default = nil)
  if valid_580747 != nil:
    section.add "userId", valid_580747
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
  var valid_580748 = query.getOrDefault("fields")
  valid_580748 = validateParameter(valid_580748, JString, required = false,
                                 default = nil)
  if valid_580748 != nil:
    section.add "fields", valid_580748
  var valid_580749 = query.getOrDefault("quotaUser")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = nil)
  if valid_580749 != nil:
    section.add "quotaUser", valid_580749
  var valid_580750 = query.getOrDefault("alt")
  valid_580750 = validateParameter(valid_580750, JString, required = false,
                                 default = newJString("json"))
  if valid_580750 != nil:
    section.add "alt", valid_580750
  var valid_580751 = query.getOrDefault("oauth_token")
  valid_580751 = validateParameter(valid_580751, JString, required = false,
                                 default = nil)
  if valid_580751 != nil:
    section.add "oauth_token", valid_580751
  var valid_580752 = query.getOrDefault("userIp")
  valid_580752 = validateParameter(valid_580752, JString, required = false,
                                 default = nil)
  if valid_580752 != nil:
    section.add "userIp", valid_580752
  var valid_580753 = query.getOrDefault("key")
  valid_580753 = validateParameter(valid_580753, JString, required = false,
                                 default = nil)
  if valid_580753 != nil:
    section.add "key", valid_580753
  var valid_580754 = query.getOrDefault("prettyPrint")
  valid_580754 = validateParameter(valid_580754, JBool, required = false,
                                 default = newJBool(true))
  if valid_580754 != nil:
    section.add "prettyPrint", valid_580754
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

proc call*(call_580756: Call_AndroidenterpriseUsersSetAvailableProductSet_580743;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the set of products that a user is entitled to access (referred to as whitelisted products). Only products that are approved or products that were previously approved (products with revoked approval) can be whitelisted.
  ## 
  let valid = call_580756.validator(path, query, header, formData, body)
  let scheme = call_580756.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580756.url(scheme.get, call_580756.host, call_580756.base,
                         call_580756.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580756, url, valid)

proc call*(call_580757: Call_AndroidenterpriseUsersSetAvailableProductSet_580743;
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
  var path_580758 = newJObject()
  var query_580759 = newJObject()
  var body_580760 = newJObject()
  add(query_580759, "fields", newJString(fields))
  add(query_580759, "quotaUser", newJString(quotaUser))
  add(query_580759, "alt", newJString(alt))
  add(query_580759, "oauth_token", newJString(oauthToken))
  add(query_580759, "userIp", newJString(userIp))
  add(query_580759, "key", newJString(key))
  add(path_580758, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580760 = body
  add(query_580759, "prettyPrint", newJBool(prettyPrint))
  add(path_580758, "userId", newJString(userId))
  result = call_580757.call(path_580758, query_580759, nil, nil, body_580760)

var androidenterpriseUsersSetAvailableProductSet* = Call_AndroidenterpriseUsersSetAvailableProductSet_580743(
    name: "androidenterpriseUsersSetAvailableProductSet",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/availableProductSet",
    validator: validate_AndroidenterpriseUsersSetAvailableProductSet_580744,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersSetAvailableProductSet_580745,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGetAvailableProductSet_580727 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseUsersGetAvailableProductSet_580729(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseUsersGetAvailableProductSet_580728(path: JsonNode;
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
  var valid_580730 = path.getOrDefault("enterpriseId")
  valid_580730 = validateParameter(valid_580730, JString, required = true,
                                 default = nil)
  if valid_580730 != nil:
    section.add "enterpriseId", valid_580730
  var valid_580731 = path.getOrDefault("userId")
  valid_580731 = validateParameter(valid_580731, JString, required = true,
                                 default = nil)
  if valid_580731 != nil:
    section.add "userId", valid_580731
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
  var valid_580732 = query.getOrDefault("fields")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "fields", valid_580732
  var valid_580733 = query.getOrDefault("quotaUser")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "quotaUser", valid_580733
  var valid_580734 = query.getOrDefault("alt")
  valid_580734 = validateParameter(valid_580734, JString, required = false,
                                 default = newJString("json"))
  if valid_580734 != nil:
    section.add "alt", valid_580734
  var valid_580735 = query.getOrDefault("oauth_token")
  valid_580735 = validateParameter(valid_580735, JString, required = false,
                                 default = nil)
  if valid_580735 != nil:
    section.add "oauth_token", valid_580735
  var valid_580736 = query.getOrDefault("userIp")
  valid_580736 = validateParameter(valid_580736, JString, required = false,
                                 default = nil)
  if valid_580736 != nil:
    section.add "userIp", valid_580736
  var valid_580737 = query.getOrDefault("key")
  valid_580737 = validateParameter(valid_580737, JString, required = false,
                                 default = nil)
  if valid_580737 != nil:
    section.add "key", valid_580737
  var valid_580738 = query.getOrDefault("prettyPrint")
  valid_580738 = validateParameter(valid_580738, JBool, required = false,
                                 default = newJBool(true))
  if valid_580738 != nil:
    section.add "prettyPrint", valid_580738
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580739: Call_AndroidenterpriseUsersGetAvailableProductSet_580727;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the set of products a user is entitled to access.
  ## 
  let valid = call_580739.validator(path, query, header, formData, body)
  let scheme = call_580739.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580739.url(scheme.get, call_580739.host, call_580739.base,
                         call_580739.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580739, url, valid)

proc call*(call_580740: Call_AndroidenterpriseUsersGetAvailableProductSet_580727;
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
  var path_580741 = newJObject()
  var query_580742 = newJObject()
  add(query_580742, "fields", newJString(fields))
  add(query_580742, "quotaUser", newJString(quotaUser))
  add(query_580742, "alt", newJString(alt))
  add(query_580742, "oauth_token", newJString(oauthToken))
  add(query_580742, "userIp", newJString(userIp))
  add(query_580742, "key", newJString(key))
  add(path_580741, "enterpriseId", newJString(enterpriseId))
  add(query_580742, "prettyPrint", newJBool(prettyPrint))
  add(path_580741, "userId", newJString(userId))
  result = call_580740.call(path_580741, query_580742, nil, nil, nil)

var androidenterpriseUsersGetAvailableProductSet* = Call_AndroidenterpriseUsersGetAvailableProductSet_580727(
    name: "androidenterpriseUsersGetAvailableProductSet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/availableProductSet",
    validator: validate_AndroidenterpriseUsersGetAvailableProductSet_580728,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersGetAvailableProductSet_580729,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersRevokeDeviceAccess_580761 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseUsersRevokeDeviceAccess_580763(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseUsersRevokeDeviceAccess_580762(path: JsonNode;
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
  var valid_580764 = path.getOrDefault("enterpriseId")
  valid_580764 = validateParameter(valid_580764, JString, required = true,
                                 default = nil)
  if valid_580764 != nil:
    section.add "enterpriseId", valid_580764
  var valid_580765 = path.getOrDefault("userId")
  valid_580765 = validateParameter(valid_580765, JString, required = true,
                                 default = nil)
  if valid_580765 != nil:
    section.add "userId", valid_580765
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
  var valid_580766 = query.getOrDefault("fields")
  valid_580766 = validateParameter(valid_580766, JString, required = false,
                                 default = nil)
  if valid_580766 != nil:
    section.add "fields", valid_580766
  var valid_580767 = query.getOrDefault("quotaUser")
  valid_580767 = validateParameter(valid_580767, JString, required = false,
                                 default = nil)
  if valid_580767 != nil:
    section.add "quotaUser", valid_580767
  var valid_580768 = query.getOrDefault("alt")
  valid_580768 = validateParameter(valid_580768, JString, required = false,
                                 default = newJString("json"))
  if valid_580768 != nil:
    section.add "alt", valid_580768
  var valid_580769 = query.getOrDefault("oauth_token")
  valid_580769 = validateParameter(valid_580769, JString, required = false,
                                 default = nil)
  if valid_580769 != nil:
    section.add "oauth_token", valid_580769
  var valid_580770 = query.getOrDefault("userIp")
  valid_580770 = validateParameter(valid_580770, JString, required = false,
                                 default = nil)
  if valid_580770 != nil:
    section.add "userIp", valid_580770
  var valid_580771 = query.getOrDefault("key")
  valid_580771 = validateParameter(valid_580771, JString, required = false,
                                 default = nil)
  if valid_580771 != nil:
    section.add "key", valid_580771
  var valid_580772 = query.getOrDefault("prettyPrint")
  valid_580772 = validateParameter(valid_580772, JBool, required = false,
                                 default = newJBool(true))
  if valid_580772 != nil:
    section.add "prettyPrint", valid_580772
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580773: Call_AndroidenterpriseUsersRevokeDeviceAccess_580761;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes access to all devices currently provisioned to the user. The user will no longer be able to use the managed Play store on any of their managed devices.
  ## 
  ## This call only works with EMM-managed accounts.
  ## 
  let valid = call_580773.validator(path, query, header, formData, body)
  let scheme = call_580773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580773.url(scheme.get, call_580773.host, call_580773.base,
                         call_580773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580773, url, valid)

proc call*(call_580774: Call_AndroidenterpriseUsersRevokeDeviceAccess_580761;
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
  var path_580775 = newJObject()
  var query_580776 = newJObject()
  add(query_580776, "fields", newJString(fields))
  add(query_580776, "quotaUser", newJString(quotaUser))
  add(query_580776, "alt", newJString(alt))
  add(query_580776, "oauth_token", newJString(oauthToken))
  add(query_580776, "userIp", newJString(userIp))
  add(query_580776, "key", newJString(key))
  add(path_580775, "enterpriseId", newJString(enterpriseId))
  add(query_580776, "prettyPrint", newJBool(prettyPrint))
  add(path_580775, "userId", newJString(userId))
  result = call_580774.call(path_580775, query_580776, nil, nil, nil)

var androidenterpriseUsersRevokeDeviceAccess* = Call_AndroidenterpriseUsersRevokeDeviceAccess_580761(
    name: "androidenterpriseUsersRevokeDeviceAccess", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/deviceAccess",
    validator: validate_AndroidenterpriseUsersRevokeDeviceAccess_580762,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersRevokeDeviceAccess_580763,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesList_580777 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseDevicesList_580779(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseDevicesList_580778(path: JsonNode; query: JsonNode;
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
  var valid_580780 = path.getOrDefault("enterpriseId")
  valid_580780 = validateParameter(valid_580780, JString, required = true,
                                 default = nil)
  if valid_580780 != nil:
    section.add "enterpriseId", valid_580780
  var valid_580781 = path.getOrDefault("userId")
  valid_580781 = validateParameter(valid_580781, JString, required = true,
                                 default = nil)
  if valid_580781 != nil:
    section.add "userId", valid_580781
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
  var valid_580782 = query.getOrDefault("fields")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "fields", valid_580782
  var valid_580783 = query.getOrDefault("quotaUser")
  valid_580783 = validateParameter(valid_580783, JString, required = false,
                                 default = nil)
  if valid_580783 != nil:
    section.add "quotaUser", valid_580783
  var valid_580784 = query.getOrDefault("alt")
  valid_580784 = validateParameter(valid_580784, JString, required = false,
                                 default = newJString("json"))
  if valid_580784 != nil:
    section.add "alt", valid_580784
  var valid_580785 = query.getOrDefault("oauth_token")
  valid_580785 = validateParameter(valid_580785, JString, required = false,
                                 default = nil)
  if valid_580785 != nil:
    section.add "oauth_token", valid_580785
  var valid_580786 = query.getOrDefault("userIp")
  valid_580786 = validateParameter(valid_580786, JString, required = false,
                                 default = nil)
  if valid_580786 != nil:
    section.add "userIp", valid_580786
  var valid_580787 = query.getOrDefault("key")
  valid_580787 = validateParameter(valid_580787, JString, required = false,
                                 default = nil)
  if valid_580787 != nil:
    section.add "key", valid_580787
  var valid_580788 = query.getOrDefault("prettyPrint")
  valid_580788 = validateParameter(valid_580788, JBool, required = false,
                                 default = newJBool(true))
  if valid_580788 != nil:
    section.add "prettyPrint", valid_580788
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580789: Call_AndroidenterpriseDevicesList_580777; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the IDs of all of a user's devices.
  ## 
  let valid = call_580789.validator(path, query, header, formData, body)
  let scheme = call_580789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580789.url(scheme.get, call_580789.host, call_580789.base,
                         call_580789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580789, url, valid)

proc call*(call_580790: Call_AndroidenterpriseDevicesList_580777;
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
  var path_580791 = newJObject()
  var query_580792 = newJObject()
  add(query_580792, "fields", newJString(fields))
  add(query_580792, "quotaUser", newJString(quotaUser))
  add(query_580792, "alt", newJString(alt))
  add(query_580792, "oauth_token", newJString(oauthToken))
  add(query_580792, "userIp", newJString(userIp))
  add(query_580792, "key", newJString(key))
  add(path_580791, "enterpriseId", newJString(enterpriseId))
  add(query_580792, "prettyPrint", newJBool(prettyPrint))
  add(path_580791, "userId", newJString(userId))
  result = call_580790.call(path_580791, query_580792, nil, nil, nil)

var androidenterpriseDevicesList* = Call_AndroidenterpriseDevicesList_580777(
    name: "androidenterpriseDevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices",
    validator: validate_AndroidenterpriseDevicesList_580778,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesList_580779,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesUpdate_580810 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseDevicesUpdate_580812(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseDevicesUpdate_580811(path: JsonNode;
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
  var valid_580813 = path.getOrDefault("deviceId")
  valid_580813 = validateParameter(valid_580813, JString, required = true,
                                 default = nil)
  if valid_580813 != nil:
    section.add "deviceId", valid_580813
  var valid_580814 = path.getOrDefault("enterpriseId")
  valid_580814 = validateParameter(valid_580814, JString, required = true,
                                 default = nil)
  if valid_580814 != nil:
    section.add "enterpriseId", valid_580814
  var valid_580815 = path.getOrDefault("userId")
  valid_580815 = validateParameter(valid_580815, JString, required = true,
                                 default = nil)
  if valid_580815 != nil:
    section.add "userId", valid_580815
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
  var valid_580816 = query.getOrDefault("fields")
  valid_580816 = validateParameter(valid_580816, JString, required = false,
                                 default = nil)
  if valid_580816 != nil:
    section.add "fields", valid_580816
  var valid_580817 = query.getOrDefault("quotaUser")
  valid_580817 = validateParameter(valid_580817, JString, required = false,
                                 default = nil)
  if valid_580817 != nil:
    section.add "quotaUser", valid_580817
  var valid_580818 = query.getOrDefault("alt")
  valid_580818 = validateParameter(valid_580818, JString, required = false,
                                 default = newJString("json"))
  if valid_580818 != nil:
    section.add "alt", valid_580818
  var valid_580819 = query.getOrDefault("oauth_token")
  valid_580819 = validateParameter(valid_580819, JString, required = false,
                                 default = nil)
  if valid_580819 != nil:
    section.add "oauth_token", valid_580819
  var valid_580820 = query.getOrDefault("userIp")
  valid_580820 = validateParameter(valid_580820, JString, required = false,
                                 default = nil)
  if valid_580820 != nil:
    section.add "userIp", valid_580820
  var valid_580821 = query.getOrDefault("key")
  valid_580821 = validateParameter(valid_580821, JString, required = false,
                                 default = nil)
  if valid_580821 != nil:
    section.add "key", valid_580821
  var valid_580822 = query.getOrDefault("prettyPrint")
  valid_580822 = validateParameter(valid_580822, JBool, required = false,
                                 default = newJBool(true))
  if valid_580822 != nil:
    section.add "prettyPrint", valid_580822
  var valid_580823 = query.getOrDefault("updateMask")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = nil)
  if valid_580823 != nil:
    section.add "updateMask", valid_580823
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

proc call*(call_580825: Call_AndroidenterpriseDevicesUpdate_580810; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the device policy
  ## 
  let valid = call_580825.validator(path, query, header, formData, body)
  let scheme = call_580825.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580825.url(scheme.get, call_580825.host, call_580825.base,
                         call_580825.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580825, url, valid)

proc call*(call_580826: Call_AndroidenterpriseDevicesUpdate_580810;
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
  var path_580827 = newJObject()
  var query_580828 = newJObject()
  var body_580829 = newJObject()
  add(query_580828, "fields", newJString(fields))
  add(query_580828, "quotaUser", newJString(quotaUser))
  add(query_580828, "alt", newJString(alt))
  add(path_580827, "deviceId", newJString(deviceId))
  add(query_580828, "oauth_token", newJString(oauthToken))
  add(query_580828, "userIp", newJString(userIp))
  add(query_580828, "key", newJString(key))
  add(path_580827, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580829 = body
  add(query_580828, "prettyPrint", newJBool(prettyPrint))
  add(query_580828, "updateMask", newJString(updateMask))
  add(path_580827, "userId", newJString(userId))
  result = call_580826.call(path_580827, query_580828, nil, nil, body_580829)

var androidenterpriseDevicesUpdate* = Call_AndroidenterpriseDevicesUpdate_580810(
    name: "androidenterpriseDevicesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}",
    validator: validate_AndroidenterpriseDevicesUpdate_580811,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesUpdate_580812,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesGet_580793 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseDevicesGet_580795(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseDevicesGet_580794(path: JsonNode; query: JsonNode;
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
  var valid_580796 = path.getOrDefault("deviceId")
  valid_580796 = validateParameter(valid_580796, JString, required = true,
                                 default = nil)
  if valid_580796 != nil:
    section.add "deviceId", valid_580796
  var valid_580797 = path.getOrDefault("enterpriseId")
  valid_580797 = validateParameter(valid_580797, JString, required = true,
                                 default = nil)
  if valid_580797 != nil:
    section.add "enterpriseId", valid_580797
  var valid_580798 = path.getOrDefault("userId")
  valid_580798 = validateParameter(valid_580798, JString, required = true,
                                 default = nil)
  if valid_580798 != nil:
    section.add "userId", valid_580798
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
  var valid_580799 = query.getOrDefault("fields")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = nil)
  if valid_580799 != nil:
    section.add "fields", valid_580799
  var valid_580800 = query.getOrDefault("quotaUser")
  valid_580800 = validateParameter(valid_580800, JString, required = false,
                                 default = nil)
  if valid_580800 != nil:
    section.add "quotaUser", valid_580800
  var valid_580801 = query.getOrDefault("alt")
  valid_580801 = validateParameter(valid_580801, JString, required = false,
                                 default = newJString("json"))
  if valid_580801 != nil:
    section.add "alt", valid_580801
  var valid_580802 = query.getOrDefault("oauth_token")
  valid_580802 = validateParameter(valid_580802, JString, required = false,
                                 default = nil)
  if valid_580802 != nil:
    section.add "oauth_token", valid_580802
  var valid_580803 = query.getOrDefault("userIp")
  valid_580803 = validateParameter(valid_580803, JString, required = false,
                                 default = nil)
  if valid_580803 != nil:
    section.add "userIp", valid_580803
  var valid_580804 = query.getOrDefault("key")
  valid_580804 = validateParameter(valid_580804, JString, required = false,
                                 default = nil)
  if valid_580804 != nil:
    section.add "key", valid_580804
  var valid_580805 = query.getOrDefault("prettyPrint")
  valid_580805 = validateParameter(valid_580805, JBool, required = false,
                                 default = newJBool(true))
  if valid_580805 != nil:
    section.add "prettyPrint", valid_580805
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580806: Call_AndroidenterpriseDevicesGet_580793; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a device.
  ## 
  let valid = call_580806.validator(path, query, header, formData, body)
  let scheme = call_580806.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580806.url(scheme.get, call_580806.host, call_580806.base,
                         call_580806.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580806, url, valid)

proc call*(call_580807: Call_AndroidenterpriseDevicesGet_580793; deviceId: string;
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
  var path_580808 = newJObject()
  var query_580809 = newJObject()
  add(query_580809, "fields", newJString(fields))
  add(query_580809, "quotaUser", newJString(quotaUser))
  add(query_580809, "alt", newJString(alt))
  add(path_580808, "deviceId", newJString(deviceId))
  add(query_580809, "oauth_token", newJString(oauthToken))
  add(query_580809, "userIp", newJString(userIp))
  add(query_580809, "key", newJString(key))
  add(path_580808, "enterpriseId", newJString(enterpriseId))
  add(query_580809, "prettyPrint", newJBool(prettyPrint))
  add(path_580808, "userId", newJString(userId))
  result = call_580807.call(path_580808, query_580809, nil, nil, nil)

var androidenterpriseDevicesGet* = Call_AndroidenterpriseDevicesGet_580793(
    name: "androidenterpriseDevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}",
    validator: validate_AndroidenterpriseDevicesGet_580794,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesGet_580795,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesPatch_580830 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseDevicesPatch_580832(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseDevicesPatch_580831(path: JsonNode; query: JsonNode;
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
  var valid_580833 = path.getOrDefault("deviceId")
  valid_580833 = validateParameter(valid_580833, JString, required = true,
                                 default = nil)
  if valid_580833 != nil:
    section.add "deviceId", valid_580833
  var valid_580834 = path.getOrDefault("enterpriseId")
  valid_580834 = validateParameter(valid_580834, JString, required = true,
                                 default = nil)
  if valid_580834 != nil:
    section.add "enterpriseId", valid_580834
  var valid_580835 = path.getOrDefault("userId")
  valid_580835 = validateParameter(valid_580835, JString, required = true,
                                 default = nil)
  if valid_580835 != nil:
    section.add "userId", valid_580835
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
  var valid_580836 = query.getOrDefault("fields")
  valid_580836 = validateParameter(valid_580836, JString, required = false,
                                 default = nil)
  if valid_580836 != nil:
    section.add "fields", valid_580836
  var valid_580837 = query.getOrDefault("quotaUser")
  valid_580837 = validateParameter(valid_580837, JString, required = false,
                                 default = nil)
  if valid_580837 != nil:
    section.add "quotaUser", valid_580837
  var valid_580838 = query.getOrDefault("alt")
  valid_580838 = validateParameter(valid_580838, JString, required = false,
                                 default = newJString("json"))
  if valid_580838 != nil:
    section.add "alt", valid_580838
  var valid_580839 = query.getOrDefault("oauth_token")
  valid_580839 = validateParameter(valid_580839, JString, required = false,
                                 default = nil)
  if valid_580839 != nil:
    section.add "oauth_token", valid_580839
  var valid_580840 = query.getOrDefault("userIp")
  valid_580840 = validateParameter(valid_580840, JString, required = false,
                                 default = nil)
  if valid_580840 != nil:
    section.add "userIp", valid_580840
  var valid_580841 = query.getOrDefault("key")
  valid_580841 = validateParameter(valid_580841, JString, required = false,
                                 default = nil)
  if valid_580841 != nil:
    section.add "key", valid_580841
  var valid_580842 = query.getOrDefault("prettyPrint")
  valid_580842 = validateParameter(valid_580842, JBool, required = false,
                                 default = newJBool(true))
  if valid_580842 != nil:
    section.add "prettyPrint", valid_580842
  var valid_580843 = query.getOrDefault("updateMask")
  valid_580843 = validateParameter(valid_580843, JString, required = false,
                                 default = nil)
  if valid_580843 != nil:
    section.add "updateMask", valid_580843
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

proc call*(call_580845: Call_AndroidenterpriseDevicesPatch_580830; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the device policy. This method supports patch semantics.
  ## 
  let valid = call_580845.validator(path, query, header, formData, body)
  let scheme = call_580845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580845.url(scheme.get, call_580845.host, call_580845.base,
                         call_580845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580845, url, valid)

proc call*(call_580846: Call_AndroidenterpriseDevicesPatch_580830;
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
  var path_580847 = newJObject()
  var query_580848 = newJObject()
  var body_580849 = newJObject()
  add(query_580848, "fields", newJString(fields))
  add(query_580848, "quotaUser", newJString(quotaUser))
  add(query_580848, "alt", newJString(alt))
  add(path_580847, "deviceId", newJString(deviceId))
  add(query_580848, "oauth_token", newJString(oauthToken))
  add(query_580848, "userIp", newJString(userIp))
  add(query_580848, "key", newJString(key))
  add(path_580847, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580849 = body
  add(query_580848, "prettyPrint", newJBool(prettyPrint))
  add(query_580848, "updateMask", newJString(updateMask))
  add(path_580847, "userId", newJString(userId))
  result = call_580846.call(path_580847, query_580848, nil, nil, body_580849)

var androidenterpriseDevicesPatch* = Call_AndroidenterpriseDevicesPatch_580830(
    name: "androidenterpriseDevicesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}",
    validator: validate_AndroidenterpriseDevicesPatch_580831,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesPatch_580832,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesForceReportUpload_580850 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseDevicesForceReportUpload_580852(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseDevicesForceReportUpload_580851(path: JsonNode;
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
  var valid_580853 = path.getOrDefault("deviceId")
  valid_580853 = validateParameter(valid_580853, JString, required = true,
                                 default = nil)
  if valid_580853 != nil:
    section.add "deviceId", valid_580853
  var valid_580854 = path.getOrDefault("enterpriseId")
  valid_580854 = validateParameter(valid_580854, JString, required = true,
                                 default = nil)
  if valid_580854 != nil:
    section.add "enterpriseId", valid_580854
  var valid_580855 = path.getOrDefault("userId")
  valid_580855 = validateParameter(valid_580855, JString, required = true,
                                 default = nil)
  if valid_580855 != nil:
    section.add "userId", valid_580855
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
  var valid_580856 = query.getOrDefault("fields")
  valid_580856 = validateParameter(valid_580856, JString, required = false,
                                 default = nil)
  if valid_580856 != nil:
    section.add "fields", valid_580856
  var valid_580857 = query.getOrDefault("quotaUser")
  valid_580857 = validateParameter(valid_580857, JString, required = false,
                                 default = nil)
  if valid_580857 != nil:
    section.add "quotaUser", valid_580857
  var valid_580858 = query.getOrDefault("alt")
  valid_580858 = validateParameter(valid_580858, JString, required = false,
                                 default = newJString("json"))
  if valid_580858 != nil:
    section.add "alt", valid_580858
  var valid_580859 = query.getOrDefault("oauth_token")
  valid_580859 = validateParameter(valid_580859, JString, required = false,
                                 default = nil)
  if valid_580859 != nil:
    section.add "oauth_token", valid_580859
  var valid_580860 = query.getOrDefault("userIp")
  valid_580860 = validateParameter(valid_580860, JString, required = false,
                                 default = nil)
  if valid_580860 != nil:
    section.add "userIp", valid_580860
  var valid_580861 = query.getOrDefault("key")
  valid_580861 = validateParameter(valid_580861, JString, required = false,
                                 default = nil)
  if valid_580861 != nil:
    section.add "key", valid_580861
  var valid_580862 = query.getOrDefault("prettyPrint")
  valid_580862 = validateParameter(valid_580862, JBool, required = false,
                                 default = newJBool(true))
  if valid_580862 != nil:
    section.add "prettyPrint", valid_580862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580863: Call_AndroidenterpriseDevicesForceReportUpload_580850;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a report containing any changes in app states on the device since the last report was generated. You can call this method up to 3 times every 24 hours for a given device.
  ## 
  let valid = call_580863.validator(path, query, header, formData, body)
  let scheme = call_580863.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580863.url(scheme.get, call_580863.host, call_580863.base,
                         call_580863.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580863, url, valid)

proc call*(call_580864: Call_AndroidenterpriseDevicesForceReportUpload_580850;
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
  var path_580865 = newJObject()
  var query_580866 = newJObject()
  add(query_580866, "fields", newJString(fields))
  add(query_580866, "quotaUser", newJString(quotaUser))
  add(query_580866, "alt", newJString(alt))
  add(path_580865, "deviceId", newJString(deviceId))
  add(query_580866, "oauth_token", newJString(oauthToken))
  add(query_580866, "userIp", newJString(userIp))
  add(query_580866, "key", newJString(key))
  add(path_580865, "enterpriseId", newJString(enterpriseId))
  add(query_580866, "prettyPrint", newJBool(prettyPrint))
  add(path_580865, "userId", newJString(userId))
  result = call_580864.call(path_580865, query_580866, nil, nil, nil)

var androidenterpriseDevicesForceReportUpload* = Call_AndroidenterpriseDevicesForceReportUpload_580850(
    name: "androidenterpriseDevicesForceReportUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/forceReportUpload",
    validator: validate_AndroidenterpriseDevicesForceReportUpload_580851,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseDevicesForceReportUpload_580852,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsList_580867 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseInstallsList_580869(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseInstallsList_580868(path: JsonNode; query: JsonNode;
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
  var valid_580870 = path.getOrDefault("deviceId")
  valid_580870 = validateParameter(valid_580870, JString, required = true,
                                 default = nil)
  if valid_580870 != nil:
    section.add "deviceId", valid_580870
  var valid_580871 = path.getOrDefault("enterpriseId")
  valid_580871 = validateParameter(valid_580871, JString, required = true,
                                 default = nil)
  if valid_580871 != nil:
    section.add "enterpriseId", valid_580871
  var valid_580872 = path.getOrDefault("userId")
  valid_580872 = validateParameter(valid_580872, JString, required = true,
                                 default = nil)
  if valid_580872 != nil:
    section.add "userId", valid_580872
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
  var valid_580873 = query.getOrDefault("fields")
  valid_580873 = validateParameter(valid_580873, JString, required = false,
                                 default = nil)
  if valid_580873 != nil:
    section.add "fields", valid_580873
  var valid_580874 = query.getOrDefault("quotaUser")
  valid_580874 = validateParameter(valid_580874, JString, required = false,
                                 default = nil)
  if valid_580874 != nil:
    section.add "quotaUser", valid_580874
  var valid_580875 = query.getOrDefault("alt")
  valid_580875 = validateParameter(valid_580875, JString, required = false,
                                 default = newJString("json"))
  if valid_580875 != nil:
    section.add "alt", valid_580875
  var valid_580876 = query.getOrDefault("oauth_token")
  valid_580876 = validateParameter(valid_580876, JString, required = false,
                                 default = nil)
  if valid_580876 != nil:
    section.add "oauth_token", valid_580876
  var valid_580877 = query.getOrDefault("userIp")
  valid_580877 = validateParameter(valid_580877, JString, required = false,
                                 default = nil)
  if valid_580877 != nil:
    section.add "userIp", valid_580877
  var valid_580878 = query.getOrDefault("key")
  valid_580878 = validateParameter(valid_580878, JString, required = false,
                                 default = nil)
  if valid_580878 != nil:
    section.add "key", valid_580878
  var valid_580879 = query.getOrDefault("prettyPrint")
  valid_580879 = validateParameter(valid_580879, JBool, required = false,
                                 default = newJBool(true))
  if valid_580879 != nil:
    section.add "prettyPrint", valid_580879
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580880: Call_AndroidenterpriseInstallsList_580867; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of all apps installed on the specified device.
  ## 
  let valid = call_580880.validator(path, query, header, formData, body)
  let scheme = call_580880.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580880.url(scheme.get, call_580880.host, call_580880.base,
                         call_580880.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580880, url, valid)

proc call*(call_580881: Call_AndroidenterpriseInstallsList_580867;
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
  var path_580882 = newJObject()
  var query_580883 = newJObject()
  add(query_580883, "fields", newJString(fields))
  add(query_580883, "quotaUser", newJString(quotaUser))
  add(query_580883, "alt", newJString(alt))
  add(path_580882, "deviceId", newJString(deviceId))
  add(query_580883, "oauth_token", newJString(oauthToken))
  add(query_580883, "userIp", newJString(userIp))
  add(query_580883, "key", newJString(key))
  add(path_580882, "enterpriseId", newJString(enterpriseId))
  add(query_580883, "prettyPrint", newJBool(prettyPrint))
  add(path_580882, "userId", newJString(userId))
  result = call_580881.call(path_580882, query_580883, nil, nil, nil)

var androidenterpriseInstallsList* = Call_AndroidenterpriseInstallsList_580867(
    name: "androidenterpriseInstallsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs",
    validator: validate_AndroidenterpriseInstallsList_580868,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsList_580869,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsUpdate_580902 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseInstallsUpdate_580904(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseInstallsUpdate_580903(path: JsonNode;
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
  var valid_580905 = path.getOrDefault("installId")
  valid_580905 = validateParameter(valid_580905, JString, required = true,
                                 default = nil)
  if valid_580905 != nil:
    section.add "installId", valid_580905
  var valid_580906 = path.getOrDefault("deviceId")
  valid_580906 = validateParameter(valid_580906, JString, required = true,
                                 default = nil)
  if valid_580906 != nil:
    section.add "deviceId", valid_580906
  var valid_580907 = path.getOrDefault("enterpriseId")
  valid_580907 = validateParameter(valid_580907, JString, required = true,
                                 default = nil)
  if valid_580907 != nil:
    section.add "enterpriseId", valid_580907
  var valid_580908 = path.getOrDefault("userId")
  valid_580908 = validateParameter(valid_580908, JString, required = true,
                                 default = nil)
  if valid_580908 != nil:
    section.add "userId", valid_580908
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
  var valid_580909 = query.getOrDefault("fields")
  valid_580909 = validateParameter(valid_580909, JString, required = false,
                                 default = nil)
  if valid_580909 != nil:
    section.add "fields", valid_580909
  var valid_580910 = query.getOrDefault("quotaUser")
  valid_580910 = validateParameter(valid_580910, JString, required = false,
                                 default = nil)
  if valid_580910 != nil:
    section.add "quotaUser", valid_580910
  var valid_580911 = query.getOrDefault("alt")
  valid_580911 = validateParameter(valid_580911, JString, required = false,
                                 default = newJString("json"))
  if valid_580911 != nil:
    section.add "alt", valid_580911
  var valid_580912 = query.getOrDefault("oauth_token")
  valid_580912 = validateParameter(valid_580912, JString, required = false,
                                 default = nil)
  if valid_580912 != nil:
    section.add "oauth_token", valid_580912
  var valid_580913 = query.getOrDefault("userIp")
  valid_580913 = validateParameter(valid_580913, JString, required = false,
                                 default = nil)
  if valid_580913 != nil:
    section.add "userIp", valid_580913
  var valid_580914 = query.getOrDefault("key")
  valid_580914 = validateParameter(valid_580914, JString, required = false,
                                 default = nil)
  if valid_580914 != nil:
    section.add "key", valid_580914
  var valid_580915 = query.getOrDefault("prettyPrint")
  valid_580915 = validateParameter(valid_580915, JBool, required = false,
                                 default = newJBool(true))
  if valid_580915 != nil:
    section.add "prettyPrint", valid_580915
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

proc call*(call_580917: Call_AndroidenterpriseInstallsUpdate_580902;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary.
  ## 
  let valid = call_580917.validator(path, query, header, formData, body)
  let scheme = call_580917.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580917.url(scheme.get, call_580917.host, call_580917.base,
                         call_580917.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580917, url, valid)

proc call*(call_580918: Call_AndroidenterpriseInstallsUpdate_580902;
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
  var path_580919 = newJObject()
  var query_580920 = newJObject()
  var body_580921 = newJObject()
  add(query_580920, "fields", newJString(fields))
  add(query_580920, "quotaUser", newJString(quotaUser))
  add(path_580919, "installId", newJString(installId))
  add(query_580920, "alt", newJString(alt))
  add(path_580919, "deviceId", newJString(deviceId))
  add(query_580920, "oauth_token", newJString(oauthToken))
  add(query_580920, "userIp", newJString(userIp))
  add(query_580920, "key", newJString(key))
  add(path_580919, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580921 = body
  add(query_580920, "prettyPrint", newJBool(prettyPrint))
  add(path_580919, "userId", newJString(userId))
  result = call_580918.call(path_580919, query_580920, nil, nil, body_580921)

var androidenterpriseInstallsUpdate* = Call_AndroidenterpriseInstallsUpdate_580902(
    name: "androidenterpriseInstallsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsUpdate_580903,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsUpdate_580904,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsGet_580884 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseInstallsGet_580886(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseInstallsGet_580885(path: JsonNode; query: JsonNode;
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
  var valid_580887 = path.getOrDefault("installId")
  valid_580887 = validateParameter(valid_580887, JString, required = true,
                                 default = nil)
  if valid_580887 != nil:
    section.add "installId", valid_580887
  var valid_580888 = path.getOrDefault("deviceId")
  valid_580888 = validateParameter(valid_580888, JString, required = true,
                                 default = nil)
  if valid_580888 != nil:
    section.add "deviceId", valid_580888
  var valid_580889 = path.getOrDefault("enterpriseId")
  valid_580889 = validateParameter(valid_580889, JString, required = true,
                                 default = nil)
  if valid_580889 != nil:
    section.add "enterpriseId", valid_580889
  var valid_580890 = path.getOrDefault("userId")
  valid_580890 = validateParameter(valid_580890, JString, required = true,
                                 default = nil)
  if valid_580890 != nil:
    section.add "userId", valid_580890
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
  var valid_580891 = query.getOrDefault("fields")
  valid_580891 = validateParameter(valid_580891, JString, required = false,
                                 default = nil)
  if valid_580891 != nil:
    section.add "fields", valid_580891
  var valid_580892 = query.getOrDefault("quotaUser")
  valid_580892 = validateParameter(valid_580892, JString, required = false,
                                 default = nil)
  if valid_580892 != nil:
    section.add "quotaUser", valid_580892
  var valid_580893 = query.getOrDefault("alt")
  valid_580893 = validateParameter(valid_580893, JString, required = false,
                                 default = newJString("json"))
  if valid_580893 != nil:
    section.add "alt", valid_580893
  var valid_580894 = query.getOrDefault("oauth_token")
  valid_580894 = validateParameter(valid_580894, JString, required = false,
                                 default = nil)
  if valid_580894 != nil:
    section.add "oauth_token", valid_580894
  var valid_580895 = query.getOrDefault("userIp")
  valid_580895 = validateParameter(valid_580895, JString, required = false,
                                 default = nil)
  if valid_580895 != nil:
    section.add "userIp", valid_580895
  var valid_580896 = query.getOrDefault("key")
  valid_580896 = validateParameter(valid_580896, JString, required = false,
                                 default = nil)
  if valid_580896 != nil:
    section.add "key", valid_580896
  var valid_580897 = query.getOrDefault("prettyPrint")
  valid_580897 = validateParameter(valid_580897, JBool, required = false,
                                 default = newJBool(true))
  if valid_580897 != nil:
    section.add "prettyPrint", valid_580897
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580898: Call_AndroidenterpriseInstallsGet_580884; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves details of an installation of an app on a device.
  ## 
  let valid = call_580898.validator(path, query, header, formData, body)
  let scheme = call_580898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580898.url(scheme.get, call_580898.host, call_580898.base,
                         call_580898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580898, url, valid)

proc call*(call_580899: Call_AndroidenterpriseInstallsGet_580884;
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
  var path_580900 = newJObject()
  var query_580901 = newJObject()
  add(query_580901, "fields", newJString(fields))
  add(query_580901, "quotaUser", newJString(quotaUser))
  add(path_580900, "installId", newJString(installId))
  add(query_580901, "alt", newJString(alt))
  add(path_580900, "deviceId", newJString(deviceId))
  add(query_580901, "oauth_token", newJString(oauthToken))
  add(query_580901, "userIp", newJString(userIp))
  add(query_580901, "key", newJString(key))
  add(path_580900, "enterpriseId", newJString(enterpriseId))
  add(query_580901, "prettyPrint", newJBool(prettyPrint))
  add(path_580900, "userId", newJString(userId))
  result = call_580899.call(path_580900, query_580901, nil, nil, nil)

var androidenterpriseInstallsGet* = Call_AndroidenterpriseInstallsGet_580884(
    name: "androidenterpriseInstallsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsGet_580885,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsGet_580886,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsPatch_580940 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseInstallsPatch_580942(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseInstallsPatch_580941(path: JsonNode;
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
  var valid_580943 = path.getOrDefault("installId")
  valid_580943 = validateParameter(valid_580943, JString, required = true,
                                 default = nil)
  if valid_580943 != nil:
    section.add "installId", valid_580943
  var valid_580944 = path.getOrDefault("deviceId")
  valid_580944 = validateParameter(valid_580944, JString, required = true,
                                 default = nil)
  if valid_580944 != nil:
    section.add "deviceId", valid_580944
  var valid_580945 = path.getOrDefault("enterpriseId")
  valid_580945 = validateParameter(valid_580945, JString, required = true,
                                 default = nil)
  if valid_580945 != nil:
    section.add "enterpriseId", valid_580945
  var valid_580946 = path.getOrDefault("userId")
  valid_580946 = validateParameter(valid_580946, JString, required = true,
                                 default = nil)
  if valid_580946 != nil:
    section.add "userId", valid_580946
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
  var valid_580947 = query.getOrDefault("fields")
  valid_580947 = validateParameter(valid_580947, JString, required = false,
                                 default = nil)
  if valid_580947 != nil:
    section.add "fields", valid_580947
  var valid_580948 = query.getOrDefault("quotaUser")
  valid_580948 = validateParameter(valid_580948, JString, required = false,
                                 default = nil)
  if valid_580948 != nil:
    section.add "quotaUser", valid_580948
  var valid_580949 = query.getOrDefault("alt")
  valid_580949 = validateParameter(valid_580949, JString, required = false,
                                 default = newJString("json"))
  if valid_580949 != nil:
    section.add "alt", valid_580949
  var valid_580950 = query.getOrDefault("oauth_token")
  valid_580950 = validateParameter(valid_580950, JString, required = false,
                                 default = nil)
  if valid_580950 != nil:
    section.add "oauth_token", valid_580950
  var valid_580951 = query.getOrDefault("userIp")
  valid_580951 = validateParameter(valid_580951, JString, required = false,
                                 default = nil)
  if valid_580951 != nil:
    section.add "userIp", valid_580951
  var valid_580952 = query.getOrDefault("key")
  valid_580952 = validateParameter(valid_580952, JString, required = false,
                                 default = nil)
  if valid_580952 != nil:
    section.add "key", valid_580952
  var valid_580953 = query.getOrDefault("prettyPrint")
  valid_580953 = validateParameter(valid_580953, JBool, required = false,
                                 default = newJBool(true))
  if valid_580953 != nil:
    section.add "prettyPrint", valid_580953
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

proc call*(call_580955: Call_AndroidenterpriseInstallsPatch_580940; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary. This method supports patch semantics.
  ## 
  let valid = call_580955.validator(path, query, header, formData, body)
  let scheme = call_580955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580955.url(scheme.get, call_580955.host, call_580955.base,
                         call_580955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580955, url, valid)

proc call*(call_580956: Call_AndroidenterpriseInstallsPatch_580940;
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
  var path_580957 = newJObject()
  var query_580958 = newJObject()
  var body_580959 = newJObject()
  add(query_580958, "fields", newJString(fields))
  add(query_580958, "quotaUser", newJString(quotaUser))
  add(path_580957, "installId", newJString(installId))
  add(query_580958, "alt", newJString(alt))
  add(path_580957, "deviceId", newJString(deviceId))
  add(query_580958, "oauth_token", newJString(oauthToken))
  add(query_580958, "userIp", newJString(userIp))
  add(query_580958, "key", newJString(key))
  add(path_580957, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_580959 = body
  add(query_580958, "prettyPrint", newJBool(prettyPrint))
  add(path_580957, "userId", newJString(userId))
  result = call_580956.call(path_580957, query_580958, nil, nil, body_580959)

var androidenterpriseInstallsPatch* = Call_AndroidenterpriseInstallsPatch_580940(
    name: "androidenterpriseInstallsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsPatch_580941,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsPatch_580942,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsDelete_580922 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseInstallsDelete_580924(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseInstallsDelete_580923(path: JsonNode;
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
  var valid_580925 = path.getOrDefault("installId")
  valid_580925 = validateParameter(valid_580925, JString, required = true,
                                 default = nil)
  if valid_580925 != nil:
    section.add "installId", valid_580925
  var valid_580926 = path.getOrDefault("deviceId")
  valid_580926 = validateParameter(valid_580926, JString, required = true,
                                 default = nil)
  if valid_580926 != nil:
    section.add "deviceId", valid_580926
  var valid_580927 = path.getOrDefault("enterpriseId")
  valid_580927 = validateParameter(valid_580927, JString, required = true,
                                 default = nil)
  if valid_580927 != nil:
    section.add "enterpriseId", valid_580927
  var valid_580928 = path.getOrDefault("userId")
  valid_580928 = validateParameter(valid_580928, JString, required = true,
                                 default = nil)
  if valid_580928 != nil:
    section.add "userId", valid_580928
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
  var valid_580929 = query.getOrDefault("fields")
  valid_580929 = validateParameter(valid_580929, JString, required = false,
                                 default = nil)
  if valid_580929 != nil:
    section.add "fields", valid_580929
  var valid_580930 = query.getOrDefault("quotaUser")
  valid_580930 = validateParameter(valid_580930, JString, required = false,
                                 default = nil)
  if valid_580930 != nil:
    section.add "quotaUser", valid_580930
  var valid_580931 = query.getOrDefault("alt")
  valid_580931 = validateParameter(valid_580931, JString, required = false,
                                 default = newJString("json"))
  if valid_580931 != nil:
    section.add "alt", valid_580931
  var valid_580932 = query.getOrDefault("oauth_token")
  valid_580932 = validateParameter(valid_580932, JString, required = false,
                                 default = nil)
  if valid_580932 != nil:
    section.add "oauth_token", valid_580932
  var valid_580933 = query.getOrDefault("userIp")
  valid_580933 = validateParameter(valid_580933, JString, required = false,
                                 default = nil)
  if valid_580933 != nil:
    section.add "userIp", valid_580933
  var valid_580934 = query.getOrDefault("key")
  valid_580934 = validateParameter(valid_580934, JString, required = false,
                                 default = nil)
  if valid_580934 != nil:
    section.add "key", valid_580934
  var valid_580935 = query.getOrDefault("prettyPrint")
  valid_580935 = validateParameter(valid_580935, JBool, required = false,
                                 default = newJBool(true))
  if valid_580935 != nil:
    section.add "prettyPrint", valid_580935
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580936: Call_AndroidenterpriseInstallsDelete_580922;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests to remove an app from a device. A call to get or list will still show the app as installed on the device until it is actually removed.
  ## 
  let valid = call_580936.validator(path, query, header, formData, body)
  let scheme = call_580936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580936.url(scheme.get, call_580936.host, call_580936.base,
                         call_580936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580936, url, valid)

proc call*(call_580937: Call_AndroidenterpriseInstallsDelete_580922;
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
  var path_580938 = newJObject()
  var query_580939 = newJObject()
  add(query_580939, "fields", newJString(fields))
  add(query_580939, "quotaUser", newJString(quotaUser))
  add(path_580938, "installId", newJString(installId))
  add(query_580939, "alt", newJString(alt))
  add(path_580938, "deviceId", newJString(deviceId))
  add(query_580939, "oauth_token", newJString(oauthToken))
  add(query_580939, "userIp", newJString(userIp))
  add(query_580939, "key", newJString(key))
  add(path_580938, "enterpriseId", newJString(enterpriseId))
  add(query_580939, "prettyPrint", newJBool(prettyPrint))
  add(path_580938, "userId", newJString(userId))
  result = call_580937.call(path_580938, query_580939, nil, nil, nil)

var androidenterpriseInstallsDelete* = Call_AndroidenterpriseInstallsDelete_580922(
    name: "androidenterpriseInstallsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsDelete_580923,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsDelete_580924,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceList_580960 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseManagedconfigurationsfordeviceList_580962(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseManagedconfigurationsfordeviceList_580961(
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
  var valid_580963 = path.getOrDefault("deviceId")
  valid_580963 = validateParameter(valid_580963, JString, required = true,
                                 default = nil)
  if valid_580963 != nil:
    section.add "deviceId", valid_580963
  var valid_580964 = path.getOrDefault("enterpriseId")
  valid_580964 = validateParameter(valid_580964, JString, required = true,
                                 default = nil)
  if valid_580964 != nil:
    section.add "enterpriseId", valid_580964
  var valid_580965 = path.getOrDefault("userId")
  valid_580965 = validateParameter(valid_580965, JString, required = true,
                                 default = nil)
  if valid_580965 != nil:
    section.add "userId", valid_580965
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
  var valid_580966 = query.getOrDefault("fields")
  valid_580966 = validateParameter(valid_580966, JString, required = false,
                                 default = nil)
  if valid_580966 != nil:
    section.add "fields", valid_580966
  var valid_580967 = query.getOrDefault("quotaUser")
  valid_580967 = validateParameter(valid_580967, JString, required = false,
                                 default = nil)
  if valid_580967 != nil:
    section.add "quotaUser", valid_580967
  var valid_580968 = query.getOrDefault("alt")
  valid_580968 = validateParameter(valid_580968, JString, required = false,
                                 default = newJString("json"))
  if valid_580968 != nil:
    section.add "alt", valid_580968
  var valid_580969 = query.getOrDefault("oauth_token")
  valid_580969 = validateParameter(valid_580969, JString, required = false,
                                 default = nil)
  if valid_580969 != nil:
    section.add "oauth_token", valid_580969
  var valid_580970 = query.getOrDefault("userIp")
  valid_580970 = validateParameter(valid_580970, JString, required = false,
                                 default = nil)
  if valid_580970 != nil:
    section.add "userIp", valid_580970
  var valid_580971 = query.getOrDefault("key")
  valid_580971 = validateParameter(valid_580971, JString, required = false,
                                 default = nil)
  if valid_580971 != nil:
    section.add "key", valid_580971
  var valid_580972 = query.getOrDefault("prettyPrint")
  valid_580972 = validateParameter(valid_580972, JBool, required = false,
                                 default = newJBool(true))
  if valid_580972 != nil:
    section.add "prettyPrint", valid_580972
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580973: Call_AndroidenterpriseManagedconfigurationsfordeviceList_580960;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the per-device managed configurations for the specified device. Only the ID is set.
  ## 
  let valid = call_580973.validator(path, query, header, formData, body)
  let scheme = call_580973.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580973.url(scheme.get, call_580973.host, call_580973.base,
                         call_580973.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580973, url, valid)

proc call*(call_580974: Call_AndroidenterpriseManagedconfigurationsfordeviceList_580960;
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
  var path_580975 = newJObject()
  var query_580976 = newJObject()
  add(query_580976, "fields", newJString(fields))
  add(query_580976, "quotaUser", newJString(quotaUser))
  add(query_580976, "alt", newJString(alt))
  add(path_580975, "deviceId", newJString(deviceId))
  add(query_580976, "oauth_token", newJString(oauthToken))
  add(query_580976, "userIp", newJString(userIp))
  add(query_580976, "key", newJString(key))
  add(path_580975, "enterpriseId", newJString(enterpriseId))
  add(query_580976, "prettyPrint", newJBool(prettyPrint))
  add(path_580975, "userId", newJString(userId))
  result = call_580974.call(path_580975, query_580976, nil, nil, nil)

var androidenterpriseManagedconfigurationsfordeviceList* = Call_AndroidenterpriseManagedconfigurationsfordeviceList_580960(
    name: "androidenterpriseManagedconfigurationsfordeviceList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceList_580961,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceList_580962,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_580995 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseManagedconfigurationsfordeviceUpdate_580997(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseManagedconfigurationsfordeviceUpdate_580996(
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
  var valid_580998 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_580998 = validateParameter(valid_580998, JString, required = true,
                                 default = nil)
  if valid_580998 != nil:
    section.add "managedConfigurationForDeviceId", valid_580998
  var valid_580999 = path.getOrDefault("deviceId")
  valid_580999 = validateParameter(valid_580999, JString, required = true,
                                 default = nil)
  if valid_580999 != nil:
    section.add "deviceId", valid_580999
  var valid_581000 = path.getOrDefault("enterpriseId")
  valid_581000 = validateParameter(valid_581000, JString, required = true,
                                 default = nil)
  if valid_581000 != nil:
    section.add "enterpriseId", valid_581000
  var valid_581001 = path.getOrDefault("userId")
  valid_581001 = validateParameter(valid_581001, JString, required = true,
                                 default = nil)
  if valid_581001 != nil:
    section.add "userId", valid_581001
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
  var valid_581002 = query.getOrDefault("fields")
  valid_581002 = validateParameter(valid_581002, JString, required = false,
                                 default = nil)
  if valid_581002 != nil:
    section.add "fields", valid_581002
  var valid_581003 = query.getOrDefault("quotaUser")
  valid_581003 = validateParameter(valid_581003, JString, required = false,
                                 default = nil)
  if valid_581003 != nil:
    section.add "quotaUser", valid_581003
  var valid_581004 = query.getOrDefault("alt")
  valid_581004 = validateParameter(valid_581004, JString, required = false,
                                 default = newJString("json"))
  if valid_581004 != nil:
    section.add "alt", valid_581004
  var valid_581005 = query.getOrDefault("oauth_token")
  valid_581005 = validateParameter(valid_581005, JString, required = false,
                                 default = nil)
  if valid_581005 != nil:
    section.add "oauth_token", valid_581005
  var valid_581006 = query.getOrDefault("userIp")
  valid_581006 = validateParameter(valid_581006, JString, required = false,
                                 default = nil)
  if valid_581006 != nil:
    section.add "userIp", valid_581006
  var valid_581007 = query.getOrDefault("key")
  valid_581007 = validateParameter(valid_581007, JString, required = false,
                                 default = nil)
  if valid_581007 != nil:
    section.add "key", valid_581007
  var valid_581008 = query.getOrDefault("prettyPrint")
  valid_581008 = validateParameter(valid_581008, JBool, required = false,
                                 default = newJBool(true))
  if valid_581008 != nil:
    section.add "prettyPrint", valid_581008
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

proc call*(call_581010: Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_580995;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates a per-device managed configuration for an app for the specified device.
  ## 
  let valid = call_581010.validator(path, query, header, formData, body)
  let scheme = call_581010.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581010.url(scheme.get, call_581010.host, call_581010.base,
                         call_581010.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581010, url, valid)

proc call*(call_581011: Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_580995;
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
  var path_581012 = newJObject()
  var query_581013 = newJObject()
  var body_581014 = newJObject()
  add(query_581013, "fields", newJString(fields))
  add(query_581013, "quotaUser", newJString(quotaUser))
  add(path_581012, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_581013, "alt", newJString(alt))
  add(path_581012, "deviceId", newJString(deviceId))
  add(query_581013, "oauth_token", newJString(oauthToken))
  add(query_581013, "userIp", newJString(userIp))
  add(query_581013, "key", newJString(key))
  add(path_581012, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_581014 = body
  add(query_581013, "prettyPrint", newJBool(prettyPrint))
  add(path_581012, "userId", newJString(userId))
  result = call_581011.call(path_581012, query_581013, nil, nil, body_581014)

var androidenterpriseManagedconfigurationsfordeviceUpdate* = Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_580995(
    name: "androidenterpriseManagedconfigurationsfordeviceUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceUpdate_580996,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceUpdate_580997,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceGet_580977 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseManagedconfigurationsfordeviceGet_580979(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseManagedconfigurationsfordeviceGet_580978(
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
  var valid_580980 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_580980 = validateParameter(valid_580980, JString, required = true,
                                 default = nil)
  if valid_580980 != nil:
    section.add "managedConfigurationForDeviceId", valid_580980
  var valid_580981 = path.getOrDefault("deviceId")
  valid_580981 = validateParameter(valid_580981, JString, required = true,
                                 default = nil)
  if valid_580981 != nil:
    section.add "deviceId", valid_580981
  var valid_580982 = path.getOrDefault("enterpriseId")
  valid_580982 = validateParameter(valid_580982, JString, required = true,
                                 default = nil)
  if valid_580982 != nil:
    section.add "enterpriseId", valid_580982
  var valid_580983 = path.getOrDefault("userId")
  valid_580983 = validateParameter(valid_580983, JString, required = true,
                                 default = nil)
  if valid_580983 != nil:
    section.add "userId", valid_580983
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
  var valid_580984 = query.getOrDefault("fields")
  valid_580984 = validateParameter(valid_580984, JString, required = false,
                                 default = nil)
  if valid_580984 != nil:
    section.add "fields", valid_580984
  var valid_580985 = query.getOrDefault("quotaUser")
  valid_580985 = validateParameter(valid_580985, JString, required = false,
                                 default = nil)
  if valid_580985 != nil:
    section.add "quotaUser", valid_580985
  var valid_580986 = query.getOrDefault("alt")
  valid_580986 = validateParameter(valid_580986, JString, required = false,
                                 default = newJString("json"))
  if valid_580986 != nil:
    section.add "alt", valid_580986
  var valid_580987 = query.getOrDefault("oauth_token")
  valid_580987 = validateParameter(valid_580987, JString, required = false,
                                 default = nil)
  if valid_580987 != nil:
    section.add "oauth_token", valid_580987
  var valid_580988 = query.getOrDefault("userIp")
  valid_580988 = validateParameter(valid_580988, JString, required = false,
                                 default = nil)
  if valid_580988 != nil:
    section.add "userIp", valid_580988
  var valid_580989 = query.getOrDefault("key")
  valid_580989 = validateParameter(valid_580989, JString, required = false,
                                 default = nil)
  if valid_580989 != nil:
    section.add "key", valid_580989
  var valid_580990 = query.getOrDefault("prettyPrint")
  valid_580990 = validateParameter(valid_580990, JBool, required = false,
                                 default = newJBool(true))
  if valid_580990 != nil:
    section.add "prettyPrint", valid_580990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580991: Call_AndroidenterpriseManagedconfigurationsfordeviceGet_580977;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a per-device managed configuration.
  ## 
  let valid = call_580991.validator(path, query, header, formData, body)
  let scheme = call_580991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580991.url(scheme.get, call_580991.host, call_580991.base,
                         call_580991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580991, url, valid)

proc call*(call_580992: Call_AndroidenterpriseManagedconfigurationsfordeviceGet_580977;
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
  var path_580993 = newJObject()
  var query_580994 = newJObject()
  add(query_580994, "fields", newJString(fields))
  add(query_580994, "quotaUser", newJString(quotaUser))
  add(path_580993, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_580994, "alt", newJString(alt))
  add(path_580993, "deviceId", newJString(deviceId))
  add(query_580994, "oauth_token", newJString(oauthToken))
  add(query_580994, "userIp", newJString(userIp))
  add(query_580994, "key", newJString(key))
  add(path_580993, "enterpriseId", newJString(enterpriseId))
  add(query_580994, "prettyPrint", newJBool(prettyPrint))
  add(path_580993, "userId", newJString(userId))
  result = call_580992.call(path_580993, query_580994, nil, nil, nil)

var androidenterpriseManagedconfigurationsfordeviceGet* = Call_AndroidenterpriseManagedconfigurationsfordeviceGet_580977(
    name: "androidenterpriseManagedconfigurationsfordeviceGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceGet_580978,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceGet_580979,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordevicePatch_581033 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseManagedconfigurationsfordevicePatch_581035(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseManagedconfigurationsfordevicePatch_581034(
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
  var valid_581036 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_581036 = validateParameter(valid_581036, JString, required = true,
                                 default = nil)
  if valid_581036 != nil:
    section.add "managedConfigurationForDeviceId", valid_581036
  var valid_581037 = path.getOrDefault("deviceId")
  valid_581037 = validateParameter(valid_581037, JString, required = true,
                                 default = nil)
  if valid_581037 != nil:
    section.add "deviceId", valid_581037
  var valid_581038 = path.getOrDefault("enterpriseId")
  valid_581038 = validateParameter(valid_581038, JString, required = true,
                                 default = nil)
  if valid_581038 != nil:
    section.add "enterpriseId", valid_581038
  var valid_581039 = path.getOrDefault("userId")
  valid_581039 = validateParameter(valid_581039, JString, required = true,
                                 default = nil)
  if valid_581039 != nil:
    section.add "userId", valid_581039
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
  var valid_581040 = query.getOrDefault("fields")
  valid_581040 = validateParameter(valid_581040, JString, required = false,
                                 default = nil)
  if valid_581040 != nil:
    section.add "fields", valid_581040
  var valid_581041 = query.getOrDefault("quotaUser")
  valid_581041 = validateParameter(valid_581041, JString, required = false,
                                 default = nil)
  if valid_581041 != nil:
    section.add "quotaUser", valid_581041
  var valid_581042 = query.getOrDefault("alt")
  valid_581042 = validateParameter(valid_581042, JString, required = false,
                                 default = newJString("json"))
  if valid_581042 != nil:
    section.add "alt", valid_581042
  var valid_581043 = query.getOrDefault("oauth_token")
  valid_581043 = validateParameter(valid_581043, JString, required = false,
                                 default = nil)
  if valid_581043 != nil:
    section.add "oauth_token", valid_581043
  var valid_581044 = query.getOrDefault("userIp")
  valid_581044 = validateParameter(valid_581044, JString, required = false,
                                 default = nil)
  if valid_581044 != nil:
    section.add "userIp", valid_581044
  var valid_581045 = query.getOrDefault("key")
  valid_581045 = validateParameter(valid_581045, JString, required = false,
                                 default = nil)
  if valid_581045 != nil:
    section.add "key", valid_581045
  var valid_581046 = query.getOrDefault("prettyPrint")
  valid_581046 = validateParameter(valid_581046, JBool, required = false,
                                 default = newJBool(true))
  if valid_581046 != nil:
    section.add "prettyPrint", valid_581046
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

proc call*(call_581048: Call_AndroidenterpriseManagedconfigurationsfordevicePatch_581033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates a per-device managed configuration for an app for the specified device. This method supports patch semantics.
  ## 
  let valid = call_581048.validator(path, query, header, formData, body)
  let scheme = call_581048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581048.url(scheme.get, call_581048.host, call_581048.base,
                         call_581048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581048, url, valid)

proc call*(call_581049: Call_AndroidenterpriseManagedconfigurationsfordevicePatch_581033;
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
  var path_581050 = newJObject()
  var query_581051 = newJObject()
  var body_581052 = newJObject()
  add(query_581051, "fields", newJString(fields))
  add(query_581051, "quotaUser", newJString(quotaUser))
  add(path_581050, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_581051, "alt", newJString(alt))
  add(path_581050, "deviceId", newJString(deviceId))
  add(query_581051, "oauth_token", newJString(oauthToken))
  add(query_581051, "userIp", newJString(userIp))
  add(query_581051, "key", newJString(key))
  add(path_581050, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_581052 = body
  add(query_581051, "prettyPrint", newJBool(prettyPrint))
  add(path_581050, "userId", newJString(userId))
  result = call_581049.call(path_581050, query_581051, nil, nil, body_581052)

var androidenterpriseManagedconfigurationsfordevicePatch* = Call_AndroidenterpriseManagedconfigurationsfordevicePatch_581033(
    name: "androidenterpriseManagedconfigurationsfordevicePatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordevicePatch_581034,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordevicePatch_581035,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_581015 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseManagedconfigurationsfordeviceDelete_581017(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseManagedconfigurationsfordeviceDelete_581016(
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
  var valid_581018 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_581018 = validateParameter(valid_581018, JString, required = true,
                                 default = nil)
  if valid_581018 != nil:
    section.add "managedConfigurationForDeviceId", valid_581018
  var valid_581019 = path.getOrDefault("deviceId")
  valid_581019 = validateParameter(valid_581019, JString, required = true,
                                 default = nil)
  if valid_581019 != nil:
    section.add "deviceId", valid_581019
  var valid_581020 = path.getOrDefault("enterpriseId")
  valid_581020 = validateParameter(valid_581020, JString, required = true,
                                 default = nil)
  if valid_581020 != nil:
    section.add "enterpriseId", valid_581020
  var valid_581021 = path.getOrDefault("userId")
  valid_581021 = validateParameter(valid_581021, JString, required = true,
                                 default = nil)
  if valid_581021 != nil:
    section.add "userId", valid_581021
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
  var valid_581022 = query.getOrDefault("fields")
  valid_581022 = validateParameter(valid_581022, JString, required = false,
                                 default = nil)
  if valid_581022 != nil:
    section.add "fields", valid_581022
  var valid_581023 = query.getOrDefault("quotaUser")
  valid_581023 = validateParameter(valid_581023, JString, required = false,
                                 default = nil)
  if valid_581023 != nil:
    section.add "quotaUser", valid_581023
  var valid_581024 = query.getOrDefault("alt")
  valid_581024 = validateParameter(valid_581024, JString, required = false,
                                 default = newJString("json"))
  if valid_581024 != nil:
    section.add "alt", valid_581024
  var valid_581025 = query.getOrDefault("oauth_token")
  valid_581025 = validateParameter(valid_581025, JString, required = false,
                                 default = nil)
  if valid_581025 != nil:
    section.add "oauth_token", valid_581025
  var valid_581026 = query.getOrDefault("userIp")
  valid_581026 = validateParameter(valid_581026, JString, required = false,
                                 default = nil)
  if valid_581026 != nil:
    section.add "userIp", valid_581026
  var valid_581027 = query.getOrDefault("key")
  valid_581027 = validateParameter(valid_581027, JString, required = false,
                                 default = nil)
  if valid_581027 != nil:
    section.add "key", valid_581027
  var valid_581028 = query.getOrDefault("prettyPrint")
  valid_581028 = validateParameter(valid_581028, JBool, required = false,
                                 default = newJBool(true))
  if valid_581028 != nil:
    section.add "prettyPrint", valid_581028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581029: Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_581015;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a per-device managed configuration for an app for the specified device.
  ## 
  let valid = call_581029.validator(path, query, header, formData, body)
  let scheme = call_581029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581029.url(scheme.get, call_581029.host, call_581029.base,
                         call_581029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581029, url, valid)

proc call*(call_581030: Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_581015;
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
  var path_581031 = newJObject()
  var query_581032 = newJObject()
  add(query_581032, "fields", newJString(fields))
  add(query_581032, "quotaUser", newJString(quotaUser))
  add(path_581031, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_581032, "alt", newJString(alt))
  add(path_581031, "deviceId", newJString(deviceId))
  add(query_581032, "oauth_token", newJString(oauthToken))
  add(query_581032, "userIp", newJString(userIp))
  add(query_581032, "key", newJString(key))
  add(path_581031, "enterpriseId", newJString(enterpriseId))
  add(query_581032, "prettyPrint", newJBool(prettyPrint))
  add(path_581031, "userId", newJString(userId))
  result = call_581030.call(path_581031, query_581032, nil, nil, nil)

var androidenterpriseManagedconfigurationsfordeviceDelete* = Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_581015(
    name: "androidenterpriseManagedconfigurationsfordeviceDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceDelete_581016,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceDelete_581017,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesSetState_581070 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseDevicesSetState_581072(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseDevicesSetState_581071(path: JsonNode;
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
  var valid_581073 = path.getOrDefault("deviceId")
  valid_581073 = validateParameter(valid_581073, JString, required = true,
                                 default = nil)
  if valid_581073 != nil:
    section.add "deviceId", valid_581073
  var valid_581074 = path.getOrDefault("enterpriseId")
  valid_581074 = validateParameter(valid_581074, JString, required = true,
                                 default = nil)
  if valid_581074 != nil:
    section.add "enterpriseId", valid_581074
  var valid_581075 = path.getOrDefault("userId")
  valid_581075 = validateParameter(valid_581075, JString, required = true,
                                 default = nil)
  if valid_581075 != nil:
    section.add "userId", valid_581075
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
  var valid_581076 = query.getOrDefault("fields")
  valid_581076 = validateParameter(valid_581076, JString, required = false,
                                 default = nil)
  if valid_581076 != nil:
    section.add "fields", valid_581076
  var valid_581077 = query.getOrDefault("quotaUser")
  valid_581077 = validateParameter(valid_581077, JString, required = false,
                                 default = nil)
  if valid_581077 != nil:
    section.add "quotaUser", valid_581077
  var valid_581078 = query.getOrDefault("alt")
  valid_581078 = validateParameter(valid_581078, JString, required = false,
                                 default = newJString("json"))
  if valid_581078 != nil:
    section.add "alt", valid_581078
  var valid_581079 = query.getOrDefault("oauth_token")
  valid_581079 = validateParameter(valid_581079, JString, required = false,
                                 default = nil)
  if valid_581079 != nil:
    section.add "oauth_token", valid_581079
  var valid_581080 = query.getOrDefault("userIp")
  valid_581080 = validateParameter(valid_581080, JString, required = false,
                                 default = nil)
  if valid_581080 != nil:
    section.add "userIp", valid_581080
  var valid_581081 = query.getOrDefault("key")
  valid_581081 = validateParameter(valid_581081, JString, required = false,
                                 default = nil)
  if valid_581081 != nil:
    section.add "key", valid_581081
  var valid_581082 = query.getOrDefault("prettyPrint")
  valid_581082 = validateParameter(valid_581082, JBool, required = false,
                                 default = newJBool(true))
  if valid_581082 != nil:
    section.add "prettyPrint", valid_581082
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

proc call*(call_581084: Call_AndroidenterpriseDevicesSetState_581070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ## 
  let valid = call_581084.validator(path, query, header, formData, body)
  let scheme = call_581084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581084.url(scheme.get, call_581084.host, call_581084.base,
                         call_581084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581084, url, valid)

proc call*(call_581085: Call_AndroidenterpriseDevicesSetState_581070;
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
  var path_581086 = newJObject()
  var query_581087 = newJObject()
  var body_581088 = newJObject()
  add(query_581087, "fields", newJString(fields))
  add(query_581087, "quotaUser", newJString(quotaUser))
  add(query_581087, "alt", newJString(alt))
  add(path_581086, "deviceId", newJString(deviceId))
  add(query_581087, "oauth_token", newJString(oauthToken))
  add(query_581087, "userIp", newJString(userIp))
  add(query_581087, "key", newJString(key))
  add(path_581086, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_581088 = body
  add(query_581087, "prettyPrint", newJBool(prettyPrint))
  add(path_581086, "userId", newJString(userId))
  result = call_581085.call(path_581086, query_581087, nil, nil, body_581088)

var androidenterpriseDevicesSetState* = Call_AndroidenterpriseDevicesSetState_581070(
    name: "androidenterpriseDevicesSetState", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/state",
    validator: validate_AndroidenterpriseDevicesSetState_581071,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesSetState_581072,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesGetState_581053 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseDevicesGetState_581055(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseDevicesGetState_581054(path: JsonNode;
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
  var valid_581056 = path.getOrDefault("deviceId")
  valid_581056 = validateParameter(valid_581056, JString, required = true,
                                 default = nil)
  if valid_581056 != nil:
    section.add "deviceId", valid_581056
  var valid_581057 = path.getOrDefault("enterpriseId")
  valid_581057 = validateParameter(valid_581057, JString, required = true,
                                 default = nil)
  if valid_581057 != nil:
    section.add "enterpriseId", valid_581057
  var valid_581058 = path.getOrDefault("userId")
  valid_581058 = validateParameter(valid_581058, JString, required = true,
                                 default = nil)
  if valid_581058 != nil:
    section.add "userId", valid_581058
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
  var valid_581059 = query.getOrDefault("fields")
  valid_581059 = validateParameter(valid_581059, JString, required = false,
                                 default = nil)
  if valid_581059 != nil:
    section.add "fields", valid_581059
  var valid_581060 = query.getOrDefault("quotaUser")
  valid_581060 = validateParameter(valid_581060, JString, required = false,
                                 default = nil)
  if valid_581060 != nil:
    section.add "quotaUser", valid_581060
  var valid_581061 = query.getOrDefault("alt")
  valid_581061 = validateParameter(valid_581061, JString, required = false,
                                 default = newJString("json"))
  if valid_581061 != nil:
    section.add "alt", valid_581061
  var valid_581062 = query.getOrDefault("oauth_token")
  valid_581062 = validateParameter(valid_581062, JString, required = false,
                                 default = nil)
  if valid_581062 != nil:
    section.add "oauth_token", valid_581062
  var valid_581063 = query.getOrDefault("userIp")
  valid_581063 = validateParameter(valid_581063, JString, required = false,
                                 default = nil)
  if valid_581063 != nil:
    section.add "userIp", valid_581063
  var valid_581064 = query.getOrDefault("key")
  valid_581064 = validateParameter(valid_581064, JString, required = false,
                                 default = nil)
  if valid_581064 != nil:
    section.add "key", valid_581064
  var valid_581065 = query.getOrDefault("prettyPrint")
  valid_581065 = validateParameter(valid_581065, JBool, required = false,
                                 default = newJBool(true))
  if valid_581065 != nil:
    section.add "prettyPrint", valid_581065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581066: Call_AndroidenterpriseDevicesGetState_581053;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ## 
  let valid = call_581066.validator(path, query, header, formData, body)
  let scheme = call_581066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581066.url(scheme.get, call_581066.host, call_581066.base,
                         call_581066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581066, url, valid)

proc call*(call_581067: Call_AndroidenterpriseDevicesGetState_581053;
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
  var path_581068 = newJObject()
  var query_581069 = newJObject()
  add(query_581069, "fields", newJString(fields))
  add(query_581069, "quotaUser", newJString(quotaUser))
  add(query_581069, "alt", newJString(alt))
  add(path_581068, "deviceId", newJString(deviceId))
  add(query_581069, "oauth_token", newJString(oauthToken))
  add(query_581069, "userIp", newJString(userIp))
  add(query_581069, "key", newJString(key))
  add(path_581068, "enterpriseId", newJString(enterpriseId))
  add(query_581069, "prettyPrint", newJBool(prettyPrint))
  add(path_581068, "userId", newJString(userId))
  result = call_581067.call(path_581068, query_581069, nil, nil, nil)

var androidenterpriseDevicesGetState* = Call_AndroidenterpriseDevicesGetState_581053(
    name: "androidenterpriseDevicesGetState", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/state",
    validator: validate_AndroidenterpriseDevicesGetState_581054,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesGetState_581055,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsList_581089 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEntitlementsList_581091(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseEntitlementsList_581090(path: JsonNode;
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
  var valid_581092 = path.getOrDefault("enterpriseId")
  valid_581092 = validateParameter(valid_581092, JString, required = true,
                                 default = nil)
  if valid_581092 != nil:
    section.add "enterpriseId", valid_581092
  var valid_581093 = path.getOrDefault("userId")
  valid_581093 = validateParameter(valid_581093, JString, required = true,
                                 default = nil)
  if valid_581093 != nil:
    section.add "userId", valid_581093
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
  var valid_581094 = query.getOrDefault("fields")
  valid_581094 = validateParameter(valid_581094, JString, required = false,
                                 default = nil)
  if valid_581094 != nil:
    section.add "fields", valid_581094
  var valid_581095 = query.getOrDefault("quotaUser")
  valid_581095 = validateParameter(valid_581095, JString, required = false,
                                 default = nil)
  if valid_581095 != nil:
    section.add "quotaUser", valid_581095
  var valid_581096 = query.getOrDefault("alt")
  valid_581096 = validateParameter(valid_581096, JString, required = false,
                                 default = newJString("json"))
  if valid_581096 != nil:
    section.add "alt", valid_581096
  var valid_581097 = query.getOrDefault("oauth_token")
  valid_581097 = validateParameter(valid_581097, JString, required = false,
                                 default = nil)
  if valid_581097 != nil:
    section.add "oauth_token", valid_581097
  var valid_581098 = query.getOrDefault("userIp")
  valid_581098 = validateParameter(valid_581098, JString, required = false,
                                 default = nil)
  if valid_581098 != nil:
    section.add "userIp", valid_581098
  var valid_581099 = query.getOrDefault("key")
  valid_581099 = validateParameter(valid_581099, JString, required = false,
                                 default = nil)
  if valid_581099 != nil:
    section.add "key", valid_581099
  var valid_581100 = query.getOrDefault("prettyPrint")
  valid_581100 = validateParameter(valid_581100, JBool, required = false,
                                 default = newJBool(true))
  if valid_581100 != nil:
    section.add "prettyPrint", valid_581100
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581101: Call_AndroidenterpriseEntitlementsList_581089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all entitlements for the specified user. Only the ID is set.
  ## 
  let valid = call_581101.validator(path, query, header, formData, body)
  let scheme = call_581101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581101.url(scheme.get, call_581101.host, call_581101.base,
                         call_581101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581101, url, valid)

proc call*(call_581102: Call_AndroidenterpriseEntitlementsList_581089;
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
  var path_581103 = newJObject()
  var query_581104 = newJObject()
  add(query_581104, "fields", newJString(fields))
  add(query_581104, "quotaUser", newJString(quotaUser))
  add(query_581104, "alt", newJString(alt))
  add(query_581104, "oauth_token", newJString(oauthToken))
  add(query_581104, "userIp", newJString(userIp))
  add(query_581104, "key", newJString(key))
  add(path_581103, "enterpriseId", newJString(enterpriseId))
  add(query_581104, "prettyPrint", newJBool(prettyPrint))
  add(path_581103, "userId", newJString(userId))
  result = call_581102.call(path_581103, query_581104, nil, nil, nil)

var androidenterpriseEntitlementsList* = Call_AndroidenterpriseEntitlementsList_581089(
    name: "androidenterpriseEntitlementsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/entitlements",
    validator: validate_AndroidenterpriseEntitlementsList_581090,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsList_581091,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsUpdate_581122 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEntitlementsUpdate_581124(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseEntitlementsUpdate_581123(path: JsonNode;
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
  var valid_581125 = path.getOrDefault("enterpriseId")
  valid_581125 = validateParameter(valid_581125, JString, required = true,
                                 default = nil)
  if valid_581125 != nil:
    section.add "enterpriseId", valid_581125
  var valid_581126 = path.getOrDefault("entitlementId")
  valid_581126 = validateParameter(valid_581126, JString, required = true,
                                 default = nil)
  if valid_581126 != nil:
    section.add "entitlementId", valid_581126
  var valid_581127 = path.getOrDefault("userId")
  valid_581127 = validateParameter(valid_581127, JString, required = true,
                                 default = nil)
  if valid_581127 != nil:
    section.add "userId", valid_581127
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
  var valid_581128 = query.getOrDefault("fields")
  valid_581128 = validateParameter(valid_581128, JString, required = false,
                                 default = nil)
  if valid_581128 != nil:
    section.add "fields", valid_581128
  var valid_581129 = query.getOrDefault("quotaUser")
  valid_581129 = validateParameter(valid_581129, JString, required = false,
                                 default = nil)
  if valid_581129 != nil:
    section.add "quotaUser", valid_581129
  var valid_581130 = query.getOrDefault("alt")
  valid_581130 = validateParameter(valid_581130, JString, required = false,
                                 default = newJString("json"))
  if valid_581130 != nil:
    section.add "alt", valid_581130
  var valid_581131 = query.getOrDefault("install")
  valid_581131 = validateParameter(valid_581131, JBool, required = false, default = nil)
  if valid_581131 != nil:
    section.add "install", valid_581131
  var valid_581132 = query.getOrDefault("oauth_token")
  valid_581132 = validateParameter(valid_581132, JString, required = false,
                                 default = nil)
  if valid_581132 != nil:
    section.add "oauth_token", valid_581132
  var valid_581133 = query.getOrDefault("userIp")
  valid_581133 = validateParameter(valid_581133, JString, required = false,
                                 default = nil)
  if valid_581133 != nil:
    section.add "userIp", valid_581133
  var valid_581134 = query.getOrDefault("key")
  valid_581134 = validateParameter(valid_581134, JString, required = false,
                                 default = nil)
  if valid_581134 != nil:
    section.add "key", valid_581134
  var valid_581135 = query.getOrDefault("prettyPrint")
  valid_581135 = validateParameter(valid_581135, JBool, required = false,
                                 default = newJBool(true))
  if valid_581135 != nil:
    section.add "prettyPrint", valid_581135
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

proc call*(call_581137: Call_AndroidenterpriseEntitlementsUpdate_581122;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates an entitlement to an app for a user.
  ## 
  let valid = call_581137.validator(path, query, header, formData, body)
  let scheme = call_581137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581137.url(scheme.get, call_581137.host, call_581137.base,
                         call_581137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581137, url, valid)

proc call*(call_581138: Call_AndroidenterpriseEntitlementsUpdate_581122;
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
  var path_581139 = newJObject()
  var query_581140 = newJObject()
  var body_581141 = newJObject()
  add(query_581140, "fields", newJString(fields))
  add(query_581140, "quotaUser", newJString(quotaUser))
  add(query_581140, "alt", newJString(alt))
  add(query_581140, "install", newJBool(install))
  add(query_581140, "oauth_token", newJString(oauthToken))
  add(query_581140, "userIp", newJString(userIp))
  add(query_581140, "key", newJString(key))
  add(path_581139, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_581141 = body
  add(query_581140, "prettyPrint", newJBool(prettyPrint))
  add(path_581139, "entitlementId", newJString(entitlementId))
  add(path_581139, "userId", newJString(userId))
  result = call_581138.call(path_581139, query_581140, nil, nil, body_581141)

var androidenterpriseEntitlementsUpdate* = Call_AndroidenterpriseEntitlementsUpdate_581122(
    name: "androidenterpriseEntitlementsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsUpdate_581123,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsUpdate_581124,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsGet_581105 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEntitlementsGet_581107(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseEntitlementsGet_581106(path: JsonNode;
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
  var valid_581108 = path.getOrDefault("enterpriseId")
  valid_581108 = validateParameter(valid_581108, JString, required = true,
                                 default = nil)
  if valid_581108 != nil:
    section.add "enterpriseId", valid_581108
  var valid_581109 = path.getOrDefault("entitlementId")
  valid_581109 = validateParameter(valid_581109, JString, required = true,
                                 default = nil)
  if valid_581109 != nil:
    section.add "entitlementId", valid_581109
  var valid_581110 = path.getOrDefault("userId")
  valid_581110 = validateParameter(valid_581110, JString, required = true,
                                 default = nil)
  if valid_581110 != nil:
    section.add "userId", valid_581110
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
  var valid_581111 = query.getOrDefault("fields")
  valid_581111 = validateParameter(valid_581111, JString, required = false,
                                 default = nil)
  if valid_581111 != nil:
    section.add "fields", valid_581111
  var valid_581112 = query.getOrDefault("quotaUser")
  valid_581112 = validateParameter(valid_581112, JString, required = false,
                                 default = nil)
  if valid_581112 != nil:
    section.add "quotaUser", valid_581112
  var valid_581113 = query.getOrDefault("alt")
  valid_581113 = validateParameter(valid_581113, JString, required = false,
                                 default = newJString("json"))
  if valid_581113 != nil:
    section.add "alt", valid_581113
  var valid_581114 = query.getOrDefault("oauth_token")
  valid_581114 = validateParameter(valid_581114, JString, required = false,
                                 default = nil)
  if valid_581114 != nil:
    section.add "oauth_token", valid_581114
  var valid_581115 = query.getOrDefault("userIp")
  valid_581115 = validateParameter(valid_581115, JString, required = false,
                                 default = nil)
  if valid_581115 != nil:
    section.add "userIp", valid_581115
  var valid_581116 = query.getOrDefault("key")
  valid_581116 = validateParameter(valid_581116, JString, required = false,
                                 default = nil)
  if valid_581116 != nil:
    section.add "key", valid_581116
  var valid_581117 = query.getOrDefault("prettyPrint")
  valid_581117 = validateParameter(valid_581117, JBool, required = false,
                                 default = newJBool(true))
  if valid_581117 != nil:
    section.add "prettyPrint", valid_581117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581118: Call_AndroidenterpriseEntitlementsGet_581105;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of an entitlement.
  ## 
  let valid = call_581118.validator(path, query, header, formData, body)
  let scheme = call_581118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581118.url(scheme.get, call_581118.host, call_581118.base,
                         call_581118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581118, url, valid)

proc call*(call_581119: Call_AndroidenterpriseEntitlementsGet_581105;
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
  var path_581120 = newJObject()
  var query_581121 = newJObject()
  add(query_581121, "fields", newJString(fields))
  add(query_581121, "quotaUser", newJString(quotaUser))
  add(query_581121, "alt", newJString(alt))
  add(query_581121, "oauth_token", newJString(oauthToken))
  add(query_581121, "userIp", newJString(userIp))
  add(query_581121, "key", newJString(key))
  add(path_581120, "enterpriseId", newJString(enterpriseId))
  add(query_581121, "prettyPrint", newJBool(prettyPrint))
  add(path_581120, "entitlementId", newJString(entitlementId))
  add(path_581120, "userId", newJString(userId))
  result = call_581119.call(path_581120, query_581121, nil, nil, nil)

var androidenterpriseEntitlementsGet* = Call_AndroidenterpriseEntitlementsGet_581105(
    name: "androidenterpriseEntitlementsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsGet_581106,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsGet_581107,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsPatch_581159 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEntitlementsPatch_581161(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseEntitlementsPatch_581160(path: JsonNode;
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
  var valid_581162 = path.getOrDefault("enterpriseId")
  valid_581162 = validateParameter(valid_581162, JString, required = true,
                                 default = nil)
  if valid_581162 != nil:
    section.add "enterpriseId", valid_581162
  var valid_581163 = path.getOrDefault("entitlementId")
  valid_581163 = validateParameter(valid_581163, JString, required = true,
                                 default = nil)
  if valid_581163 != nil:
    section.add "entitlementId", valid_581163
  var valid_581164 = path.getOrDefault("userId")
  valid_581164 = validateParameter(valid_581164, JString, required = true,
                                 default = nil)
  if valid_581164 != nil:
    section.add "userId", valid_581164
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
  var valid_581165 = query.getOrDefault("fields")
  valid_581165 = validateParameter(valid_581165, JString, required = false,
                                 default = nil)
  if valid_581165 != nil:
    section.add "fields", valid_581165
  var valid_581166 = query.getOrDefault("quotaUser")
  valid_581166 = validateParameter(valid_581166, JString, required = false,
                                 default = nil)
  if valid_581166 != nil:
    section.add "quotaUser", valid_581166
  var valid_581167 = query.getOrDefault("alt")
  valid_581167 = validateParameter(valid_581167, JString, required = false,
                                 default = newJString("json"))
  if valid_581167 != nil:
    section.add "alt", valid_581167
  var valid_581168 = query.getOrDefault("install")
  valid_581168 = validateParameter(valid_581168, JBool, required = false, default = nil)
  if valid_581168 != nil:
    section.add "install", valid_581168
  var valid_581169 = query.getOrDefault("oauth_token")
  valid_581169 = validateParameter(valid_581169, JString, required = false,
                                 default = nil)
  if valid_581169 != nil:
    section.add "oauth_token", valid_581169
  var valid_581170 = query.getOrDefault("userIp")
  valid_581170 = validateParameter(valid_581170, JString, required = false,
                                 default = nil)
  if valid_581170 != nil:
    section.add "userIp", valid_581170
  var valid_581171 = query.getOrDefault("key")
  valid_581171 = validateParameter(valid_581171, JString, required = false,
                                 default = nil)
  if valid_581171 != nil:
    section.add "key", valid_581171
  var valid_581172 = query.getOrDefault("prettyPrint")
  valid_581172 = validateParameter(valid_581172, JBool, required = false,
                                 default = newJBool(true))
  if valid_581172 != nil:
    section.add "prettyPrint", valid_581172
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

proc call*(call_581174: Call_AndroidenterpriseEntitlementsPatch_581159;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates an entitlement to an app for a user. This method supports patch semantics.
  ## 
  let valid = call_581174.validator(path, query, header, formData, body)
  let scheme = call_581174.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581174.url(scheme.get, call_581174.host, call_581174.base,
                         call_581174.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581174, url, valid)

proc call*(call_581175: Call_AndroidenterpriseEntitlementsPatch_581159;
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
  var path_581176 = newJObject()
  var query_581177 = newJObject()
  var body_581178 = newJObject()
  add(query_581177, "fields", newJString(fields))
  add(query_581177, "quotaUser", newJString(quotaUser))
  add(query_581177, "alt", newJString(alt))
  add(query_581177, "install", newJBool(install))
  add(query_581177, "oauth_token", newJString(oauthToken))
  add(query_581177, "userIp", newJString(userIp))
  add(query_581177, "key", newJString(key))
  add(path_581176, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_581178 = body
  add(query_581177, "prettyPrint", newJBool(prettyPrint))
  add(path_581176, "entitlementId", newJString(entitlementId))
  add(path_581176, "userId", newJString(userId))
  result = call_581175.call(path_581176, query_581177, nil, nil, body_581178)

var androidenterpriseEntitlementsPatch* = Call_AndroidenterpriseEntitlementsPatch_581159(
    name: "androidenterpriseEntitlementsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsPatch_581160,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsPatch_581161,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsDelete_581142 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseEntitlementsDelete_581144(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseEntitlementsDelete_581143(path: JsonNode;
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
  var valid_581145 = path.getOrDefault("enterpriseId")
  valid_581145 = validateParameter(valid_581145, JString, required = true,
                                 default = nil)
  if valid_581145 != nil:
    section.add "enterpriseId", valid_581145
  var valid_581146 = path.getOrDefault("entitlementId")
  valid_581146 = validateParameter(valid_581146, JString, required = true,
                                 default = nil)
  if valid_581146 != nil:
    section.add "entitlementId", valid_581146
  var valid_581147 = path.getOrDefault("userId")
  valid_581147 = validateParameter(valid_581147, JString, required = true,
                                 default = nil)
  if valid_581147 != nil:
    section.add "userId", valid_581147
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
  var valid_581148 = query.getOrDefault("fields")
  valid_581148 = validateParameter(valid_581148, JString, required = false,
                                 default = nil)
  if valid_581148 != nil:
    section.add "fields", valid_581148
  var valid_581149 = query.getOrDefault("quotaUser")
  valid_581149 = validateParameter(valid_581149, JString, required = false,
                                 default = nil)
  if valid_581149 != nil:
    section.add "quotaUser", valid_581149
  var valid_581150 = query.getOrDefault("alt")
  valid_581150 = validateParameter(valid_581150, JString, required = false,
                                 default = newJString("json"))
  if valid_581150 != nil:
    section.add "alt", valid_581150
  var valid_581151 = query.getOrDefault("oauth_token")
  valid_581151 = validateParameter(valid_581151, JString, required = false,
                                 default = nil)
  if valid_581151 != nil:
    section.add "oauth_token", valid_581151
  var valid_581152 = query.getOrDefault("userIp")
  valid_581152 = validateParameter(valid_581152, JString, required = false,
                                 default = nil)
  if valid_581152 != nil:
    section.add "userIp", valid_581152
  var valid_581153 = query.getOrDefault("key")
  valid_581153 = validateParameter(valid_581153, JString, required = false,
                                 default = nil)
  if valid_581153 != nil:
    section.add "key", valid_581153
  var valid_581154 = query.getOrDefault("prettyPrint")
  valid_581154 = validateParameter(valid_581154, JBool, required = false,
                                 default = newJBool(true))
  if valid_581154 != nil:
    section.add "prettyPrint", valid_581154
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581155: Call_AndroidenterpriseEntitlementsDelete_581142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes an entitlement to an app for a user.
  ## 
  let valid = call_581155.validator(path, query, header, formData, body)
  let scheme = call_581155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581155.url(scheme.get, call_581155.host, call_581155.base,
                         call_581155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581155, url, valid)

proc call*(call_581156: Call_AndroidenterpriseEntitlementsDelete_581142;
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
  var path_581157 = newJObject()
  var query_581158 = newJObject()
  add(query_581158, "fields", newJString(fields))
  add(query_581158, "quotaUser", newJString(quotaUser))
  add(query_581158, "alt", newJString(alt))
  add(query_581158, "oauth_token", newJString(oauthToken))
  add(query_581158, "userIp", newJString(userIp))
  add(query_581158, "key", newJString(key))
  add(path_581157, "enterpriseId", newJString(enterpriseId))
  add(query_581158, "prettyPrint", newJBool(prettyPrint))
  add(path_581157, "entitlementId", newJString(entitlementId))
  add(path_581157, "userId", newJString(userId))
  result = call_581156.call(path_581157, query_581158, nil, nil, nil)

var androidenterpriseEntitlementsDelete* = Call_AndroidenterpriseEntitlementsDelete_581142(
    name: "androidenterpriseEntitlementsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsDelete_581143,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsDelete_581144,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserList_581179 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseManagedconfigurationsforuserList_581181(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseManagedconfigurationsforuserList_581180(
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
  var valid_581182 = path.getOrDefault("enterpriseId")
  valid_581182 = validateParameter(valid_581182, JString, required = true,
                                 default = nil)
  if valid_581182 != nil:
    section.add "enterpriseId", valid_581182
  var valid_581183 = path.getOrDefault("userId")
  valid_581183 = validateParameter(valid_581183, JString, required = true,
                                 default = nil)
  if valid_581183 != nil:
    section.add "userId", valid_581183
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
  var valid_581184 = query.getOrDefault("fields")
  valid_581184 = validateParameter(valid_581184, JString, required = false,
                                 default = nil)
  if valid_581184 != nil:
    section.add "fields", valid_581184
  var valid_581185 = query.getOrDefault("quotaUser")
  valid_581185 = validateParameter(valid_581185, JString, required = false,
                                 default = nil)
  if valid_581185 != nil:
    section.add "quotaUser", valid_581185
  var valid_581186 = query.getOrDefault("alt")
  valid_581186 = validateParameter(valid_581186, JString, required = false,
                                 default = newJString("json"))
  if valid_581186 != nil:
    section.add "alt", valid_581186
  var valid_581187 = query.getOrDefault("oauth_token")
  valid_581187 = validateParameter(valid_581187, JString, required = false,
                                 default = nil)
  if valid_581187 != nil:
    section.add "oauth_token", valid_581187
  var valid_581188 = query.getOrDefault("userIp")
  valid_581188 = validateParameter(valid_581188, JString, required = false,
                                 default = nil)
  if valid_581188 != nil:
    section.add "userIp", valid_581188
  var valid_581189 = query.getOrDefault("key")
  valid_581189 = validateParameter(valid_581189, JString, required = false,
                                 default = nil)
  if valid_581189 != nil:
    section.add "key", valid_581189
  var valid_581190 = query.getOrDefault("prettyPrint")
  valid_581190 = validateParameter(valid_581190, JBool, required = false,
                                 default = newJBool(true))
  if valid_581190 != nil:
    section.add "prettyPrint", valid_581190
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581191: Call_AndroidenterpriseManagedconfigurationsforuserList_581179;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the per-user managed configurations for the specified user. Only the ID is set.
  ## 
  let valid = call_581191.validator(path, query, header, formData, body)
  let scheme = call_581191.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581191.url(scheme.get, call_581191.host, call_581191.base,
                         call_581191.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581191, url, valid)

proc call*(call_581192: Call_AndroidenterpriseManagedconfigurationsforuserList_581179;
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
  var path_581193 = newJObject()
  var query_581194 = newJObject()
  add(query_581194, "fields", newJString(fields))
  add(query_581194, "quotaUser", newJString(quotaUser))
  add(query_581194, "alt", newJString(alt))
  add(query_581194, "oauth_token", newJString(oauthToken))
  add(query_581194, "userIp", newJString(userIp))
  add(query_581194, "key", newJString(key))
  add(path_581193, "enterpriseId", newJString(enterpriseId))
  add(query_581194, "prettyPrint", newJBool(prettyPrint))
  add(path_581193, "userId", newJString(userId))
  result = call_581192.call(path_581193, query_581194, nil, nil, nil)

var androidenterpriseManagedconfigurationsforuserList* = Call_AndroidenterpriseManagedconfigurationsforuserList_581179(
    name: "androidenterpriseManagedconfigurationsforuserList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserList_581180,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserList_581181,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserUpdate_581212 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseManagedconfigurationsforuserUpdate_581214(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseManagedconfigurationsforuserUpdate_581213(
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
  var valid_581215 = path.getOrDefault("enterpriseId")
  valid_581215 = validateParameter(valid_581215, JString, required = true,
                                 default = nil)
  if valid_581215 != nil:
    section.add "enterpriseId", valid_581215
  var valid_581216 = path.getOrDefault("managedConfigurationForUserId")
  valid_581216 = validateParameter(valid_581216, JString, required = true,
                                 default = nil)
  if valid_581216 != nil:
    section.add "managedConfigurationForUserId", valid_581216
  var valid_581217 = path.getOrDefault("userId")
  valid_581217 = validateParameter(valid_581217, JString, required = true,
                                 default = nil)
  if valid_581217 != nil:
    section.add "userId", valid_581217
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
  var valid_581218 = query.getOrDefault("fields")
  valid_581218 = validateParameter(valid_581218, JString, required = false,
                                 default = nil)
  if valid_581218 != nil:
    section.add "fields", valid_581218
  var valid_581219 = query.getOrDefault("quotaUser")
  valid_581219 = validateParameter(valid_581219, JString, required = false,
                                 default = nil)
  if valid_581219 != nil:
    section.add "quotaUser", valid_581219
  var valid_581220 = query.getOrDefault("alt")
  valid_581220 = validateParameter(valid_581220, JString, required = false,
                                 default = newJString("json"))
  if valid_581220 != nil:
    section.add "alt", valid_581220
  var valid_581221 = query.getOrDefault("oauth_token")
  valid_581221 = validateParameter(valid_581221, JString, required = false,
                                 default = nil)
  if valid_581221 != nil:
    section.add "oauth_token", valid_581221
  var valid_581222 = query.getOrDefault("userIp")
  valid_581222 = validateParameter(valid_581222, JString, required = false,
                                 default = nil)
  if valid_581222 != nil:
    section.add "userIp", valid_581222
  var valid_581223 = query.getOrDefault("key")
  valid_581223 = validateParameter(valid_581223, JString, required = false,
                                 default = nil)
  if valid_581223 != nil:
    section.add "key", valid_581223
  var valid_581224 = query.getOrDefault("prettyPrint")
  valid_581224 = validateParameter(valid_581224, JBool, required = false,
                                 default = newJBool(true))
  if valid_581224 != nil:
    section.add "prettyPrint", valid_581224
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

proc call*(call_581226: Call_AndroidenterpriseManagedconfigurationsforuserUpdate_581212;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties.
  ## 
  let valid = call_581226.validator(path, query, header, formData, body)
  let scheme = call_581226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581226.url(scheme.get, call_581226.host, call_581226.base,
                         call_581226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581226, url, valid)

proc call*(call_581227: Call_AndroidenterpriseManagedconfigurationsforuserUpdate_581212;
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
  var path_581228 = newJObject()
  var query_581229 = newJObject()
  var body_581230 = newJObject()
  add(query_581229, "fields", newJString(fields))
  add(query_581229, "quotaUser", newJString(quotaUser))
  add(query_581229, "alt", newJString(alt))
  add(query_581229, "oauth_token", newJString(oauthToken))
  add(query_581229, "userIp", newJString(userIp))
  add(query_581229, "key", newJString(key))
  add(path_581228, "enterpriseId", newJString(enterpriseId))
  add(path_581228, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  if body != nil:
    body_581230 = body
  add(query_581229, "prettyPrint", newJBool(prettyPrint))
  add(path_581228, "userId", newJString(userId))
  result = call_581227.call(path_581228, query_581229, nil, nil, body_581230)

var androidenterpriseManagedconfigurationsforuserUpdate* = Call_AndroidenterpriseManagedconfigurationsforuserUpdate_581212(
    name: "androidenterpriseManagedconfigurationsforuserUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserUpdate_581213,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserUpdate_581214,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserGet_581195 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseManagedconfigurationsforuserGet_581197(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseManagedconfigurationsforuserGet_581196(
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
  var valid_581198 = path.getOrDefault("enterpriseId")
  valid_581198 = validateParameter(valid_581198, JString, required = true,
                                 default = nil)
  if valid_581198 != nil:
    section.add "enterpriseId", valid_581198
  var valid_581199 = path.getOrDefault("managedConfigurationForUserId")
  valid_581199 = validateParameter(valid_581199, JString, required = true,
                                 default = nil)
  if valid_581199 != nil:
    section.add "managedConfigurationForUserId", valid_581199
  var valid_581200 = path.getOrDefault("userId")
  valid_581200 = validateParameter(valid_581200, JString, required = true,
                                 default = nil)
  if valid_581200 != nil:
    section.add "userId", valid_581200
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
  var valid_581201 = query.getOrDefault("fields")
  valid_581201 = validateParameter(valid_581201, JString, required = false,
                                 default = nil)
  if valid_581201 != nil:
    section.add "fields", valid_581201
  var valid_581202 = query.getOrDefault("quotaUser")
  valid_581202 = validateParameter(valid_581202, JString, required = false,
                                 default = nil)
  if valid_581202 != nil:
    section.add "quotaUser", valid_581202
  var valid_581203 = query.getOrDefault("alt")
  valid_581203 = validateParameter(valid_581203, JString, required = false,
                                 default = newJString("json"))
  if valid_581203 != nil:
    section.add "alt", valid_581203
  var valid_581204 = query.getOrDefault("oauth_token")
  valid_581204 = validateParameter(valid_581204, JString, required = false,
                                 default = nil)
  if valid_581204 != nil:
    section.add "oauth_token", valid_581204
  var valid_581205 = query.getOrDefault("userIp")
  valid_581205 = validateParameter(valid_581205, JString, required = false,
                                 default = nil)
  if valid_581205 != nil:
    section.add "userIp", valid_581205
  var valid_581206 = query.getOrDefault("key")
  valid_581206 = validateParameter(valid_581206, JString, required = false,
                                 default = nil)
  if valid_581206 != nil:
    section.add "key", valid_581206
  var valid_581207 = query.getOrDefault("prettyPrint")
  valid_581207 = validateParameter(valid_581207, JBool, required = false,
                                 default = newJBool(true))
  if valid_581207 != nil:
    section.add "prettyPrint", valid_581207
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581208: Call_AndroidenterpriseManagedconfigurationsforuserGet_581195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a per-user managed configuration for an app for the specified user.
  ## 
  let valid = call_581208.validator(path, query, header, formData, body)
  let scheme = call_581208.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581208.url(scheme.get, call_581208.host, call_581208.base,
                         call_581208.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581208, url, valid)

proc call*(call_581209: Call_AndroidenterpriseManagedconfigurationsforuserGet_581195;
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
  var path_581210 = newJObject()
  var query_581211 = newJObject()
  add(query_581211, "fields", newJString(fields))
  add(query_581211, "quotaUser", newJString(quotaUser))
  add(query_581211, "alt", newJString(alt))
  add(query_581211, "oauth_token", newJString(oauthToken))
  add(query_581211, "userIp", newJString(userIp))
  add(query_581211, "key", newJString(key))
  add(path_581210, "enterpriseId", newJString(enterpriseId))
  add(path_581210, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  add(query_581211, "prettyPrint", newJBool(prettyPrint))
  add(path_581210, "userId", newJString(userId))
  result = call_581209.call(path_581210, query_581211, nil, nil, nil)

var androidenterpriseManagedconfigurationsforuserGet* = Call_AndroidenterpriseManagedconfigurationsforuserGet_581195(
    name: "androidenterpriseManagedconfigurationsforuserGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserGet_581196,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserGet_581197,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserPatch_581248 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseManagedconfigurationsforuserPatch_581250(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseManagedconfigurationsforuserPatch_581249(
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
  var valid_581251 = path.getOrDefault("enterpriseId")
  valid_581251 = validateParameter(valid_581251, JString, required = true,
                                 default = nil)
  if valid_581251 != nil:
    section.add "enterpriseId", valid_581251
  var valid_581252 = path.getOrDefault("managedConfigurationForUserId")
  valid_581252 = validateParameter(valid_581252, JString, required = true,
                                 default = nil)
  if valid_581252 != nil:
    section.add "managedConfigurationForUserId", valid_581252
  var valid_581253 = path.getOrDefault("userId")
  valid_581253 = validateParameter(valid_581253, JString, required = true,
                                 default = nil)
  if valid_581253 != nil:
    section.add "userId", valid_581253
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
  var valid_581254 = query.getOrDefault("fields")
  valid_581254 = validateParameter(valid_581254, JString, required = false,
                                 default = nil)
  if valid_581254 != nil:
    section.add "fields", valid_581254
  var valid_581255 = query.getOrDefault("quotaUser")
  valid_581255 = validateParameter(valid_581255, JString, required = false,
                                 default = nil)
  if valid_581255 != nil:
    section.add "quotaUser", valid_581255
  var valid_581256 = query.getOrDefault("alt")
  valid_581256 = validateParameter(valid_581256, JString, required = false,
                                 default = newJString("json"))
  if valid_581256 != nil:
    section.add "alt", valid_581256
  var valid_581257 = query.getOrDefault("oauth_token")
  valid_581257 = validateParameter(valid_581257, JString, required = false,
                                 default = nil)
  if valid_581257 != nil:
    section.add "oauth_token", valid_581257
  var valid_581258 = query.getOrDefault("userIp")
  valid_581258 = validateParameter(valid_581258, JString, required = false,
                                 default = nil)
  if valid_581258 != nil:
    section.add "userIp", valid_581258
  var valid_581259 = query.getOrDefault("key")
  valid_581259 = validateParameter(valid_581259, JString, required = false,
                                 default = nil)
  if valid_581259 != nil:
    section.add "key", valid_581259
  var valid_581260 = query.getOrDefault("prettyPrint")
  valid_581260 = validateParameter(valid_581260, JBool, required = false,
                                 default = newJBool(true))
  if valid_581260 != nil:
    section.add "prettyPrint", valid_581260
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

proc call*(call_581262: Call_AndroidenterpriseManagedconfigurationsforuserPatch_581248;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties. This method supports patch semantics.
  ## 
  let valid = call_581262.validator(path, query, header, formData, body)
  let scheme = call_581262.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581262.url(scheme.get, call_581262.host, call_581262.base,
                         call_581262.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581262, url, valid)

proc call*(call_581263: Call_AndroidenterpriseManagedconfigurationsforuserPatch_581248;
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
  var path_581264 = newJObject()
  var query_581265 = newJObject()
  var body_581266 = newJObject()
  add(query_581265, "fields", newJString(fields))
  add(query_581265, "quotaUser", newJString(quotaUser))
  add(query_581265, "alt", newJString(alt))
  add(query_581265, "oauth_token", newJString(oauthToken))
  add(query_581265, "userIp", newJString(userIp))
  add(query_581265, "key", newJString(key))
  add(path_581264, "enterpriseId", newJString(enterpriseId))
  add(path_581264, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  if body != nil:
    body_581266 = body
  add(query_581265, "prettyPrint", newJBool(prettyPrint))
  add(path_581264, "userId", newJString(userId))
  result = call_581263.call(path_581264, query_581265, nil, nil, body_581266)

var androidenterpriseManagedconfigurationsforuserPatch* = Call_AndroidenterpriseManagedconfigurationsforuserPatch_581248(
    name: "androidenterpriseManagedconfigurationsforuserPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserPatch_581249,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserPatch_581250,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserDelete_581231 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseManagedconfigurationsforuserDelete_581233(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseManagedconfigurationsforuserDelete_581232(
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
  var valid_581234 = path.getOrDefault("enterpriseId")
  valid_581234 = validateParameter(valid_581234, JString, required = true,
                                 default = nil)
  if valid_581234 != nil:
    section.add "enterpriseId", valid_581234
  var valid_581235 = path.getOrDefault("managedConfigurationForUserId")
  valid_581235 = validateParameter(valid_581235, JString, required = true,
                                 default = nil)
  if valid_581235 != nil:
    section.add "managedConfigurationForUserId", valid_581235
  var valid_581236 = path.getOrDefault("userId")
  valid_581236 = validateParameter(valid_581236, JString, required = true,
                                 default = nil)
  if valid_581236 != nil:
    section.add "userId", valid_581236
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
  var valid_581237 = query.getOrDefault("fields")
  valid_581237 = validateParameter(valid_581237, JString, required = false,
                                 default = nil)
  if valid_581237 != nil:
    section.add "fields", valid_581237
  var valid_581238 = query.getOrDefault("quotaUser")
  valid_581238 = validateParameter(valid_581238, JString, required = false,
                                 default = nil)
  if valid_581238 != nil:
    section.add "quotaUser", valid_581238
  var valid_581239 = query.getOrDefault("alt")
  valid_581239 = validateParameter(valid_581239, JString, required = false,
                                 default = newJString("json"))
  if valid_581239 != nil:
    section.add "alt", valid_581239
  var valid_581240 = query.getOrDefault("oauth_token")
  valid_581240 = validateParameter(valid_581240, JString, required = false,
                                 default = nil)
  if valid_581240 != nil:
    section.add "oauth_token", valid_581240
  var valid_581241 = query.getOrDefault("userIp")
  valid_581241 = validateParameter(valid_581241, JString, required = false,
                                 default = nil)
  if valid_581241 != nil:
    section.add "userIp", valid_581241
  var valid_581242 = query.getOrDefault("key")
  valid_581242 = validateParameter(valid_581242, JString, required = false,
                                 default = nil)
  if valid_581242 != nil:
    section.add "key", valid_581242
  var valid_581243 = query.getOrDefault("prettyPrint")
  valid_581243 = validateParameter(valid_581243, JBool, required = false,
                                 default = newJBool(true))
  if valid_581243 != nil:
    section.add "prettyPrint", valid_581243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581244: Call_AndroidenterpriseManagedconfigurationsforuserDelete_581231;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a per-user managed configuration for an app for the specified user.
  ## 
  let valid = call_581244.validator(path, query, header, formData, body)
  let scheme = call_581244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581244.url(scheme.get, call_581244.host, call_581244.base,
                         call_581244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581244, url, valid)

proc call*(call_581245: Call_AndroidenterpriseManagedconfigurationsforuserDelete_581231;
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
  var path_581246 = newJObject()
  var query_581247 = newJObject()
  add(query_581247, "fields", newJString(fields))
  add(query_581247, "quotaUser", newJString(quotaUser))
  add(query_581247, "alt", newJString(alt))
  add(query_581247, "oauth_token", newJString(oauthToken))
  add(query_581247, "userIp", newJString(userIp))
  add(query_581247, "key", newJString(key))
  add(path_581246, "enterpriseId", newJString(enterpriseId))
  add(path_581246, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  add(query_581247, "prettyPrint", newJBool(prettyPrint))
  add(path_581246, "userId", newJString(userId))
  result = call_581245.call(path_581246, query_581247, nil, nil, nil)

var androidenterpriseManagedconfigurationsforuserDelete* = Call_AndroidenterpriseManagedconfigurationsforuserDelete_581231(
    name: "androidenterpriseManagedconfigurationsforuserDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserDelete_581232,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserDelete_581233,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGenerateToken_581267 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseUsersGenerateToken_581269(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseUsersGenerateToken_581268(path: JsonNode;
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
  var valid_581270 = path.getOrDefault("enterpriseId")
  valid_581270 = validateParameter(valid_581270, JString, required = true,
                                 default = nil)
  if valid_581270 != nil:
    section.add "enterpriseId", valid_581270
  var valid_581271 = path.getOrDefault("userId")
  valid_581271 = validateParameter(valid_581271, JString, required = true,
                                 default = nil)
  if valid_581271 != nil:
    section.add "userId", valid_581271
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
  var valid_581272 = query.getOrDefault("fields")
  valid_581272 = validateParameter(valid_581272, JString, required = false,
                                 default = nil)
  if valid_581272 != nil:
    section.add "fields", valid_581272
  var valid_581273 = query.getOrDefault("quotaUser")
  valid_581273 = validateParameter(valid_581273, JString, required = false,
                                 default = nil)
  if valid_581273 != nil:
    section.add "quotaUser", valid_581273
  var valid_581274 = query.getOrDefault("alt")
  valid_581274 = validateParameter(valid_581274, JString, required = false,
                                 default = newJString("json"))
  if valid_581274 != nil:
    section.add "alt", valid_581274
  var valid_581275 = query.getOrDefault("oauth_token")
  valid_581275 = validateParameter(valid_581275, JString, required = false,
                                 default = nil)
  if valid_581275 != nil:
    section.add "oauth_token", valid_581275
  var valid_581276 = query.getOrDefault("userIp")
  valid_581276 = validateParameter(valid_581276, JString, required = false,
                                 default = nil)
  if valid_581276 != nil:
    section.add "userIp", valid_581276
  var valid_581277 = query.getOrDefault("key")
  valid_581277 = validateParameter(valid_581277, JString, required = false,
                                 default = nil)
  if valid_581277 != nil:
    section.add "key", valid_581277
  var valid_581278 = query.getOrDefault("prettyPrint")
  valid_581278 = validateParameter(valid_581278, JBool, required = false,
                                 default = newJBool(true))
  if valid_581278 != nil:
    section.add "prettyPrint", valid_581278
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581279: Call_AndroidenterpriseUsersGenerateToken_581267;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a token (activation code) to allow this user to configure their managed account in the Android Setup Wizard. Revokes any previously generated token.
  ## 
  ## This call only works with Google managed accounts.
  ## 
  let valid = call_581279.validator(path, query, header, formData, body)
  let scheme = call_581279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581279.url(scheme.get, call_581279.host, call_581279.base,
                         call_581279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581279, url, valid)

proc call*(call_581280: Call_AndroidenterpriseUsersGenerateToken_581267;
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
  var path_581281 = newJObject()
  var query_581282 = newJObject()
  add(query_581282, "fields", newJString(fields))
  add(query_581282, "quotaUser", newJString(quotaUser))
  add(query_581282, "alt", newJString(alt))
  add(query_581282, "oauth_token", newJString(oauthToken))
  add(query_581282, "userIp", newJString(userIp))
  add(query_581282, "key", newJString(key))
  add(path_581281, "enterpriseId", newJString(enterpriseId))
  add(query_581282, "prettyPrint", newJBool(prettyPrint))
  add(path_581281, "userId", newJString(userId))
  result = call_581280.call(path_581281, query_581282, nil, nil, nil)

var androidenterpriseUsersGenerateToken* = Call_AndroidenterpriseUsersGenerateToken_581267(
    name: "androidenterpriseUsersGenerateToken", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/token",
    validator: validate_AndroidenterpriseUsersGenerateToken_581268,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersGenerateToken_581269,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersRevokeToken_581283 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseUsersRevokeToken_581285(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseUsersRevokeToken_581284(path: JsonNode;
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
  var valid_581286 = path.getOrDefault("enterpriseId")
  valid_581286 = validateParameter(valid_581286, JString, required = true,
                                 default = nil)
  if valid_581286 != nil:
    section.add "enterpriseId", valid_581286
  var valid_581287 = path.getOrDefault("userId")
  valid_581287 = validateParameter(valid_581287, JString, required = true,
                                 default = nil)
  if valid_581287 != nil:
    section.add "userId", valid_581287
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
  var valid_581288 = query.getOrDefault("fields")
  valid_581288 = validateParameter(valid_581288, JString, required = false,
                                 default = nil)
  if valid_581288 != nil:
    section.add "fields", valid_581288
  var valid_581289 = query.getOrDefault("quotaUser")
  valid_581289 = validateParameter(valid_581289, JString, required = false,
                                 default = nil)
  if valid_581289 != nil:
    section.add "quotaUser", valid_581289
  var valid_581290 = query.getOrDefault("alt")
  valid_581290 = validateParameter(valid_581290, JString, required = false,
                                 default = newJString("json"))
  if valid_581290 != nil:
    section.add "alt", valid_581290
  var valid_581291 = query.getOrDefault("oauth_token")
  valid_581291 = validateParameter(valid_581291, JString, required = false,
                                 default = nil)
  if valid_581291 != nil:
    section.add "oauth_token", valid_581291
  var valid_581292 = query.getOrDefault("userIp")
  valid_581292 = validateParameter(valid_581292, JString, required = false,
                                 default = nil)
  if valid_581292 != nil:
    section.add "userIp", valid_581292
  var valid_581293 = query.getOrDefault("key")
  valid_581293 = validateParameter(valid_581293, JString, required = false,
                                 default = nil)
  if valid_581293 != nil:
    section.add "key", valid_581293
  var valid_581294 = query.getOrDefault("prettyPrint")
  valid_581294 = validateParameter(valid_581294, JBool, required = false,
                                 default = newJBool(true))
  if valid_581294 != nil:
    section.add "prettyPrint", valid_581294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581295: Call_AndroidenterpriseUsersRevokeToken_581283;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes a previously generated token (activation code) for the user.
  ## 
  let valid = call_581295.validator(path, query, header, formData, body)
  let scheme = call_581295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581295.url(scheme.get, call_581295.host, call_581295.base,
                         call_581295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581295, url, valid)

proc call*(call_581296: Call_AndroidenterpriseUsersRevokeToken_581283;
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
  var path_581297 = newJObject()
  var query_581298 = newJObject()
  add(query_581298, "fields", newJString(fields))
  add(query_581298, "quotaUser", newJString(quotaUser))
  add(query_581298, "alt", newJString(alt))
  add(query_581298, "oauth_token", newJString(oauthToken))
  add(query_581298, "userIp", newJString(userIp))
  add(query_581298, "key", newJString(key))
  add(path_581297, "enterpriseId", newJString(enterpriseId))
  add(query_581298, "prettyPrint", newJBool(prettyPrint))
  add(path_581297, "userId", newJString(userId))
  result = call_581296.call(path_581297, query_581298, nil, nil, nil)

var androidenterpriseUsersRevokeToken* = Call_AndroidenterpriseUsersRevokeToken_581283(
    name: "androidenterpriseUsersRevokeToken", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/token",
    validator: validate_AndroidenterpriseUsersRevokeToken_581284,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersRevokeToken_581285,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsInsert_581314 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseWebappsInsert_581316(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseWebappsInsert_581315(path: JsonNode;
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
  var valid_581317 = path.getOrDefault("enterpriseId")
  valid_581317 = validateParameter(valid_581317, JString, required = true,
                                 default = nil)
  if valid_581317 != nil:
    section.add "enterpriseId", valid_581317
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
  var valid_581318 = query.getOrDefault("fields")
  valid_581318 = validateParameter(valid_581318, JString, required = false,
                                 default = nil)
  if valid_581318 != nil:
    section.add "fields", valid_581318
  var valid_581319 = query.getOrDefault("quotaUser")
  valid_581319 = validateParameter(valid_581319, JString, required = false,
                                 default = nil)
  if valid_581319 != nil:
    section.add "quotaUser", valid_581319
  var valid_581320 = query.getOrDefault("alt")
  valid_581320 = validateParameter(valid_581320, JString, required = false,
                                 default = newJString("json"))
  if valid_581320 != nil:
    section.add "alt", valid_581320
  var valid_581321 = query.getOrDefault("oauth_token")
  valid_581321 = validateParameter(valid_581321, JString, required = false,
                                 default = nil)
  if valid_581321 != nil:
    section.add "oauth_token", valid_581321
  var valid_581322 = query.getOrDefault("userIp")
  valid_581322 = validateParameter(valid_581322, JString, required = false,
                                 default = nil)
  if valid_581322 != nil:
    section.add "userIp", valid_581322
  var valid_581323 = query.getOrDefault("key")
  valid_581323 = validateParameter(valid_581323, JString, required = false,
                                 default = nil)
  if valid_581323 != nil:
    section.add "key", valid_581323
  var valid_581324 = query.getOrDefault("prettyPrint")
  valid_581324 = validateParameter(valid_581324, JBool, required = false,
                                 default = newJBool(true))
  if valid_581324 != nil:
    section.add "prettyPrint", valid_581324
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

proc call*(call_581326: Call_AndroidenterpriseWebappsInsert_581314; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new web app for the enterprise.
  ## 
  let valid = call_581326.validator(path, query, header, formData, body)
  let scheme = call_581326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581326.url(scheme.get, call_581326.host, call_581326.base,
                         call_581326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581326, url, valid)

proc call*(call_581327: Call_AndroidenterpriseWebappsInsert_581314;
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
  var path_581328 = newJObject()
  var query_581329 = newJObject()
  var body_581330 = newJObject()
  add(query_581329, "fields", newJString(fields))
  add(query_581329, "quotaUser", newJString(quotaUser))
  add(query_581329, "alt", newJString(alt))
  add(query_581329, "oauth_token", newJString(oauthToken))
  add(query_581329, "userIp", newJString(userIp))
  add(query_581329, "key", newJString(key))
  add(path_581328, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_581330 = body
  add(query_581329, "prettyPrint", newJBool(prettyPrint))
  result = call_581327.call(path_581328, query_581329, nil, nil, body_581330)

var androidenterpriseWebappsInsert* = Call_AndroidenterpriseWebappsInsert_581314(
    name: "androidenterpriseWebappsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/webApps",
    validator: validate_AndroidenterpriseWebappsInsert_581315,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsInsert_581316,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsList_581299 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseWebappsList_581301(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseWebappsList_581300(path: JsonNode; query: JsonNode;
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
  var valid_581302 = path.getOrDefault("enterpriseId")
  valid_581302 = validateParameter(valid_581302, JString, required = true,
                                 default = nil)
  if valid_581302 != nil:
    section.add "enterpriseId", valid_581302
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
  var valid_581303 = query.getOrDefault("fields")
  valid_581303 = validateParameter(valid_581303, JString, required = false,
                                 default = nil)
  if valid_581303 != nil:
    section.add "fields", valid_581303
  var valid_581304 = query.getOrDefault("quotaUser")
  valid_581304 = validateParameter(valid_581304, JString, required = false,
                                 default = nil)
  if valid_581304 != nil:
    section.add "quotaUser", valid_581304
  var valid_581305 = query.getOrDefault("alt")
  valid_581305 = validateParameter(valid_581305, JString, required = false,
                                 default = newJString("json"))
  if valid_581305 != nil:
    section.add "alt", valid_581305
  var valid_581306 = query.getOrDefault("oauth_token")
  valid_581306 = validateParameter(valid_581306, JString, required = false,
                                 default = nil)
  if valid_581306 != nil:
    section.add "oauth_token", valid_581306
  var valid_581307 = query.getOrDefault("userIp")
  valid_581307 = validateParameter(valid_581307, JString, required = false,
                                 default = nil)
  if valid_581307 != nil:
    section.add "userIp", valid_581307
  var valid_581308 = query.getOrDefault("key")
  valid_581308 = validateParameter(valid_581308, JString, required = false,
                                 default = nil)
  if valid_581308 != nil:
    section.add "key", valid_581308
  var valid_581309 = query.getOrDefault("prettyPrint")
  valid_581309 = validateParameter(valid_581309, JBool, required = false,
                                 default = newJBool(true))
  if valid_581309 != nil:
    section.add "prettyPrint", valid_581309
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581310: Call_AndroidenterpriseWebappsList_581299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of all web apps for a given enterprise.
  ## 
  let valid = call_581310.validator(path, query, header, formData, body)
  let scheme = call_581310.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581310.url(scheme.get, call_581310.host, call_581310.base,
                         call_581310.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581310, url, valid)

proc call*(call_581311: Call_AndroidenterpriseWebappsList_581299;
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
  var path_581312 = newJObject()
  var query_581313 = newJObject()
  add(query_581313, "fields", newJString(fields))
  add(query_581313, "quotaUser", newJString(quotaUser))
  add(query_581313, "alt", newJString(alt))
  add(query_581313, "oauth_token", newJString(oauthToken))
  add(query_581313, "userIp", newJString(userIp))
  add(query_581313, "key", newJString(key))
  add(path_581312, "enterpriseId", newJString(enterpriseId))
  add(query_581313, "prettyPrint", newJBool(prettyPrint))
  result = call_581311.call(path_581312, query_581313, nil, nil, nil)

var androidenterpriseWebappsList* = Call_AndroidenterpriseWebappsList_581299(
    name: "androidenterpriseWebappsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/webApps",
    validator: validate_AndroidenterpriseWebappsList_581300,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsList_581301,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsUpdate_581347 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseWebappsUpdate_581349(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseWebappsUpdate_581348(path: JsonNode;
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
  var valid_581350 = path.getOrDefault("webAppId")
  valid_581350 = validateParameter(valid_581350, JString, required = true,
                                 default = nil)
  if valid_581350 != nil:
    section.add "webAppId", valid_581350
  var valid_581351 = path.getOrDefault("enterpriseId")
  valid_581351 = validateParameter(valid_581351, JString, required = true,
                                 default = nil)
  if valid_581351 != nil:
    section.add "enterpriseId", valid_581351
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
  var valid_581352 = query.getOrDefault("fields")
  valid_581352 = validateParameter(valid_581352, JString, required = false,
                                 default = nil)
  if valid_581352 != nil:
    section.add "fields", valid_581352
  var valid_581353 = query.getOrDefault("quotaUser")
  valid_581353 = validateParameter(valid_581353, JString, required = false,
                                 default = nil)
  if valid_581353 != nil:
    section.add "quotaUser", valid_581353
  var valid_581354 = query.getOrDefault("alt")
  valid_581354 = validateParameter(valid_581354, JString, required = false,
                                 default = newJString("json"))
  if valid_581354 != nil:
    section.add "alt", valid_581354
  var valid_581355 = query.getOrDefault("oauth_token")
  valid_581355 = validateParameter(valid_581355, JString, required = false,
                                 default = nil)
  if valid_581355 != nil:
    section.add "oauth_token", valid_581355
  var valid_581356 = query.getOrDefault("userIp")
  valid_581356 = validateParameter(valid_581356, JString, required = false,
                                 default = nil)
  if valid_581356 != nil:
    section.add "userIp", valid_581356
  var valid_581357 = query.getOrDefault("key")
  valid_581357 = validateParameter(valid_581357, JString, required = false,
                                 default = nil)
  if valid_581357 != nil:
    section.add "key", valid_581357
  var valid_581358 = query.getOrDefault("prettyPrint")
  valid_581358 = validateParameter(valid_581358, JBool, required = false,
                                 default = newJBool(true))
  if valid_581358 != nil:
    section.add "prettyPrint", valid_581358
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

proc call*(call_581360: Call_AndroidenterpriseWebappsUpdate_581347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing web app.
  ## 
  let valid = call_581360.validator(path, query, header, formData, body)
  let scheme = call_581360.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581360.url(scheme.get, call_581360.host, call_581360.base,
                         call_581360.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581360, url, valid)

proc call*(call_581361: Call_AndroidenterpriseWebappsUpdate_581347;
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
  var path_581362 = newJObject()
  var query_581363 = newJObject()
  var body_581364 = newJObject()
  add(query_581363, "fields", newJString(fields))
  add(query_581363, "quotaUser", newJString(quotaUser))
  add(query_581363, "alt", newJString(alt))
  add(path_581362, "webAppId", newJString(webAppId))
  add(query_581363, "oauth_token", newJString(oauthToken))
  add(query_581363, "userIp", newJString(userIp))
  add(query_581363, "key", newJString(key))
  add(path_581362, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_581364 = body
  add(query_581363, "prettyPrint", newJBool(prettyPrint))
  result = call_581361.call(path_581362, query_581363, nil, nil, body_581364)

var androidenterpriseWebappsUpdate* = Call_AndroidenterpriseWebappsUpdate_581347(
    name: "androidenterpriseWebappsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsUpdate_581348,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsUpdate_581349,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsGet_581331 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseWebappsGet_581333(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseWebappsGet_581332(path: JsonNode; query: JsonNode;
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
  var valid_581334 = path.getOrDefault("webAppId")
  valid_581334 = validateParameter(valid_581334, JString, required = true,
                                 default = nil)
  if valid_581334 != nil:
    section.add "webAppId", valid_581334
  var valid_581335 = path.getOrDefault("enterpriseId")
  valid_581335 = validateParameter(valid_581335, JString, required = true,
                                 default = nil)
  if valid_581335 != nil:
    section.add "enterpriseId", valid_581335
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
  var valid_581336 = query.getOrDefault("fields")
  valid_581336 = validateParameter(valid_581336, JString, required = false,
                                 default = nil)
  if valid_581336 != nil:
    section.add "fields", valid_581336
  var valid_581337 = query.getOrDefault("quotaUser")
  valid_581337 = validateParameter(valid_581337, JString, required = false,
                                 default = nil)
  if valid_581337 != nil:
    section.add "quotaUser", valid_581337
  var valid_581338 = query.getOrDefault("alt")
  valid_581338 = validateParameter(valid_581338, JString, required = false,
                                 default = newJString("json"))
  if valid_581338 != nil:
    section.add "alt", valid_581338
  var valid_581339 = query.getOrDefault("oauth_token")
  valid_581339 = validateParameter(valid_581339, JString, required = false,
                                 default = nil)
  if valid_581339 != nil:
    section.add "oauth_token", valid_581339
  var valid_581340 = query.getOrDefault("userIp")
  valid_581340 = validateParameter(valid_581340, JString, required = false,
                                 default = nil)
  if valid_581340 != nil:
    section.add "userIp", valid_581340
  var valid_581341 = query.getOrDefault("key")
  valid_581341 = validateParameter(valid_581341, JString, required = false,
                                 default = nil)
  if valid_581341 != nil:
    section.add "key", valid_581341
  var valid_581342 = query.getOrDefault("prettyPrint")
  valid_581342 = validateParameter(valid_581342, JBool, required = false,
                                 default = newJBool(true))
  if valid_581342 != nil:
    section.add "prettyPrint", valid_581342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581343: Call_AndroidenterpriseWebappsGet_581331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing web app.
  ## 
  let valid = call_581343.validator(path, query, header, formData, body)
  let scheme = call_581343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581343.url(scheme.get, call_581343.host, call_581343.base,
                         call_581343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581343, url, valid)

proc call*(call_581344: Call_AndroidenterpriseWebappsGet_581331; webAppId: string;
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
  var path_581345 = newJObject()
  var query_581346 = newJObject()
  add(query_581346, "fields", newJString(fields))
  add(query_581346, "quotaUser", newJString(quotaUser))
  add(query_581346, "alt", newJString(alt))
  add(path_581345, "webAppId", newJString(webAppId))
  add(query_581346, "oauth_token", newJString(oauthToken))
  add(query_581346, "userIp", newJString(userIp))
  add(query_581346, "key", newJString(key))
  add(path_581345, "enterpriseId", newJString(enterpriseId))
  add(query_581346, "prettyPrint", newJBool(prettyPrint))
  result = call_581344.call(path_581345, query_581346, nil, nil, nil)

var androidenterpriseWebappsGet* = Call_AndroidenterpriseWebappsGet_581331(
    name: "androidenterpriseWebappsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsGet_581332,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsGet_581333,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsPatch_581381 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseWebappsPatch_581383(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseWebappsPatch_581382(path: JsonNode; query: JsonNode;
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
  var valid_581384 = path.getOrDefault("webAppId")
  valid_581384 = validateParameter(valid_581384, JString, required = true,
                                 default = nil)
  if valid_581384 != nil:
    section.add "webAppId", valid_581384
  var valid_581385 = path.getOrDefault("enterpriseId")
  valid_581385 = validateParameter(valid_581385, JString, required = true,
                                 default = nil)
  if valid_581385 != nil:
    section.add "enterpriseId", valid_581385
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
  var valid_581386 = query.getOrDefault("fields")
  valid_581386 = validateParameter(valid_581386, JString, required = false,
                                 default = nil)
  if valid_581386 != nil:
    section.add "fields", valid_581386
  var valid_581387 = query.getOrDefault("quotaUser")
  valid_581387 = validateParameter(valid_581387, JString, required = false,
                                 default = nil)
  if valid_581387 != nil:
    section.add "quotaUser", valid_581387
  var valid_581388 = query.getOrDefault("alt")
  valid_581388 = validateParameter(valid_581388, JString, required = false,
                                 default = newJString("json"))
  if valid_581388 != nil:
    section.add "alt", valid_581388
  var valid_581389 = query.getOrDefault("oauth_token")
  valid_581389 = validateParameter(valid_581389, JString, required = false,
                                 default = nil)
  if valid_581389 != nil:
    section.add "oauth_token", valid_581389
  var valid_581390 = query.getOrDefault("userIp")
  valid_581390 = validateParameter(valid_581390, JString, required = false,
                                 default = nil)
  if valid_581390 != nil:
    section.add "userIp", valid_581390
  var valid_581391 = query.getOrDefault("key")
  valid_581391 = validateParameter(valid_581391, JString, required = false,
                                 default = nil)
  if valid_581391 != nil:
    section.add "key", valid_581391
  var valid_581392 = query.getOrDefault("prettyPrint")
  valid_581392 = validateParameter(valid_581392, JBool, required = false,
                                 default = newJBool(true))
  if valid_581392 != nil:
    section.add "prettyPrint", valid_581392
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

proc call*(call_581394: Call_AndroidenterpriseWebappsPatch_581381; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing web app. This method supports patch semantics.
  ## 
  let valid = call_581394.validator(path, query, header, formData, body)
  let scheme = call_581394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581394.url(scheme.get, call_581394.host, call_581394.base,
                         call_581394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581394, url, valid)

proc call*(call_581395: Call_AndroidenterpriseWebappsPatch_581381;
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
  var path_581396 = newJObject()
  var query_581397 = newJObject()
  var body_581398 = newJObject()
  add(query_581397, "fields", newJString(fields))
  add(query_581397, "quotaUser", newJString(quotaUser))
  add(query_581397, "alt", newJString(alt))
  add(path_581396, "webAppId", newJString(webAppId))
  add(query_581397, "oauth_token", newJString(oauthToken))
  add(query_581397, "userIp", newJString(userIp))
  add(query_581397, "key", newJString(key))
  add(path_581396, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_581398 = body
  add(query_581397, "prettyPrint", newJBool(prettyPrint))
  result = call_581395.call(path_581396, query_581397, nil, nil, body_581398)

var androidenterpriseWebappsPatch* = Call_AndroidenterpriseWebappsPatch_581381(
    name: "androidenterpriseWebappsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsPatch_581382,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsPatch_581383,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsDelete_581365 = ref object of OpenApiRestCall_579421
proc url_AndroidenterpriseWebappsDelete_581367(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_AndroidenterpriseWebappsDelete_581366(path: JsonNode;
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
  var valid_581368 = path.getOrDefault("webAppId")
  valid_581368 = validateParameter(valid_581368, JString, required = true,
                                 default = nil)
  if valid_581368 != nil:
    section.add "webAppId", valid_581368
  var valid_581369 = path.getOrDefault("enterpriseId")
  valid_581369 = validateParameter(valid_581369, JString, required = true,
                                 default = nil)
  if valid_581369 != nil:
    section.add "enterpriseId", valid_581369
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
  var valid_581370 = query.getOrDefault("fields")
  valid_581370 = validateParameter(valid_581370, JString, required = false,
                                 default = nil)
  if valid_581370 != nil:
    section.add "fields", valid_581370
  var valid_581371 = query.getOrDefault("quotaUser")
  valid_581371 = validateParameter(valid_581371, JString, required = false,
                                 default = nil)
  if valid_581371 != nil:
    section.add "quotaUser", valid_581371
  var valid_581372 = query.getOrDefault("alt")
  valid_581372 = validateParameter(valid_581372, JString, required = false,
                                 default = newJString("json"))
  if valid_581372 != nil:
    section.add "alt", valid_581372
  var valid_581373 = query.getOrDefault("oauth_token")
  valid_581373 = validateParameter(valid_581373, JString, required = false,
                                 default = nil)
  if valid_581373 != nil:
    section.add "oauth_token", valid_581373
  var valid_581374 = query.getOrDefault("userIp")
  valid_581374 = validateParameter(valid_581374, JString, required = false,
                                 default = nil)
  if valid_581374 != nil:
    section.add "userIp", valid_581374
  var valid_581375 = query.getOrDefault("key")
  valid_581375 = validateParameter(valid_581375, JString, required = false,
                                 default = nil)
  if valid_581375 != nil:
    section.add "key", valid_581375
  var valid_581376 = query.getOrDefault("prettyPrint")
  valid_581376 = validateParameter(valid_581376, JBool, required = false,
                                 default = newJBool(true))
  if valid_581376 != nil:
    section.add "prettyPrint", valid_581376
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581377: Call_AndroidenterpriseWebappsDelete_581365; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing web app.
  ## 
  let valid = call_581377.validator(path, query, header, formData, body)
  let scheme = call_581377.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581377.url(scheme.get, call_581377.host, call_581377.base,
                         call_581377.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581377, url, valid)

proc call*(call_581378: Call_AndroidenterpriseWebappsDelete_581365;
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
  var path_581379 = newJObject()
  var query_581380 = newJObject()
  add(query_581380, "fields", newJString(fields))
  add(query_581380, "quotaUser", newJString(quotaUser))
  add(query_581380, "alt", newJString(alt))
  add(path_581379, "webAppId", newJString(webAppId))
  add(query_581380, "oauth_token", newJString(oauthToken))
  add(query_581380, "userIp", newJString(userIp))
  add(query_581380, "key", newJString(key))
  add(path_581379, "enterpriseId", newJString(enterpriseId))
  add(query_581380, "prettyPrint", newJBool(prettyPrint))
  result = call_581378.call(path_581379, query_581380, nil, nil, nil)

var androidenterpriseWebappsDelete* = Call_AndroidenterpriseWebappsDelete_581365(
    name: "androidenterpriseWebappsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsDelete_581366,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsDelete_581367,
    schemes: {Scheme.Https})
type
  Call_AndroidenterprisePermissionsGet_581399 = ref object of OpenApiRestCall_579421
proc url_AndroidenterprisePermissionsGet_581401(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "permissionId" in path, "`permissionId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/permissions/"),
               (kind: VariableSegment, value: "permissionId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_AndroidenterprisePermissionsGet_581400(path: JsonNode;
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
  var valid_581402 = path.getOrDefault("permissionId")
  valid_581402 = validateParameter(valid_581402, JString, required = true,
                                 default = nil)
  if valid_581402 != nil:
    section.add "permissionId", valid_581402
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
  var valid_581403 = query.getOrDefault("fields")
  valid_581403 = validateParameter(valid_581403, JString, required = false,
                                 default = nil)
  if valid_581403 != nil:
    section.add "fields", valid_581403
  var valid_581404 = query.getOrDefault("quotaUser")
  valid_581404 = validateParameter(valid_581404, JString, required = false,
                                 default = nil)
  if valid_581404 != nil:
    section.add "quotaUser", valid_581404
  var valid_581405 = query.getOrDefault("alt")
  valid_581405 = validateParameter(valid_581405, JString, required = false,
                                 default = newJString("json"))
  if valid_581405 != nil:
    section.add "alt", valid_581405
  var valid_581406 = query.getOrDefault("language")
  valid_581406 = validateParameter(valid_581406, JString, required = false,
                                 default = nil)
  if valid_581406 != nil:
    section.add "language", valid_581406
  var valid_581407 = query.getOrDefault("oauth_token")
  valid_581407 = validateParameter(valid_581407, JString, required = false,
                                 default = nil)
  if valid_581407 != nil:
    section.add "oauth_token", valid_581407
  var valid_581408 = query.getOrDefault("userIp")
  valid_581408 = validateParameter(valid_581408, JString, required = false,
                                 default = nil)
  if valid_581408 != nil:
    section.add "userIp", valid_581408
  var valid_581409 = query.getOrDefault("key")
  valid_581409 = validateParameter(valid_581409, JString, required = false,
                                 default = nil)
  if valid_581409 != nil:
    section.add "key", valid_581409
  var valid_581410 = query.getOrDefault("prettyPrint")
  valid_581410 = validateParameter(valid_581410, JBool, required = false,
                                 default = newJBool(true))
  if valid_581410 != nil:
    section.add "prettyPrint", valid_581410
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581411: Call_AndroidenterprisePermissionsGet_581399;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of an Android app permission for display to an enterprise admin.
  ## 
  let valid = call_581411.validator(path, query, header, formData, body)
  let scheme = call_581411.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581411.url(scheme.get, call_581411.host, call_581411.base,
                         call_581411.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581411, url, valid)

proc call*(call_581412: Call_AndroidenterprisePermissionsGet_581399;
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
  var path_581413 = newJObject()
  var query_581414 = newJObject()
  add(query_581414, "fields", newJString(fields))
  add(query_581414, "quotaUser", newJString(quotaUser))
  add(query_581414, "alt", newJString(alt))
  add(query_581414, "language", newJString(language))
  add(query_581414, "oauth_token", newJString(oauthToken))
  add(path_581413, "permissionId", newJString(permissionId))
  add(query_581414, "userIp", newJString(userIp))
  add(query_581414, "key", newJString(key))
  add(query_581414, "prettyPrint", newJBool(prettyPrint))
  result = call_581412.call(path_581413, query_581414, nil, nil, nil)

var androidenterprisePermissionsGet* = Call_AndroidenterprisePermissionsGet_581399(
    name: "androidenterprisePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/permissions/{permissionId}",
    validator: validate_AndroidenterprisePermissionsGet_581400,
    base: "/androidenterprise/v1", url: url_AndroidenterprisePermissionsGet_581401,
    schemes: {Scheme.Https})
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
