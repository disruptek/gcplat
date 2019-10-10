
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
  gcpServiceName = "androidenterprise"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AndroidenterpriseEnterprisesList_588718 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesList_588720(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesList_588719(path: JsonNode;
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
  var valid_588832 = query.getOrDefault("fields")
  valid_588832 = validateParameter(valid_588832, JString, required = false,
                                 default = nil)
  if valid_588832 != nil:
    section.add "fields", valid_588832
  var valid_588833 = query.getOrDefault("quotaUser")
  valid_588833 = validateParameter(valid_588833, JString, required = false,
                                 default = nil)
  if valid_588833 != nil:
    section.add "quotaUser", valid_588833
  var valid_588847 = query.getOrDefault("alt")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = newJString("json"))
  if valid_588847 != nil:
    section.add "alt", valid_588847
  var valid_588848 = query.getOrDefault("oauth_token")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "oauth_token", valid_588848
  var valid_588849 = query.getOrDefault("userIp")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "userIp", valid_588849
  var valid_588850 = query.getOrDefault("key")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "key", valid_588850
  var valid_588851 = query.getOrDefault("prettyPrint")
  valid_588851 = validateParameter(valid_588851, JBool, required = false,
                                 default = newJBool(true))
  if valid_588851 != nil:
    section.add "prettyPrint", valid_588851
  assert query != nil, "query argument is necessary due to required `domain` field"
  var valid_588852 = query.getOrDefault("domain")
  valid_588852 = validateParameter(valid_588852, JString, required = true,
                                 default = nil)
  if valid_588852 != nil:
    section.add "domain", valid_588852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588875: Call_AndroidenterpriseEnterprisesList_588718;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Looks up an enterprise by domain name. This is only supported for enterprises created via the Google-initiated creation flow. Lookup of the id is not needed for enterprises created via the EMM-initiated flow since the EMM learns the enterprise ID in the callback specified in the Enterprises.generateSignupUrl call.
  ## 
  let valid = call_588875.validator(path, query, header, formData, body)
  let scheme = call_588875.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588875.url(scheme.get, call_588875.host, call_588875.base,
                         call_588875.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588875, url, valid)

proc call*(call_588946: Call_AndroidenterpriseEnterprisesList_588718;
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
  var query_588947 = newJObject()
  add(query_588947, "fields", newJString(fields))
  add(query_588947, "quotaUser", newJString(quotaUser))
  add(query_588947, "alt", newJString(alt))
  add(query_588947, "oauth_token", newJString(oauthToken))
  add(query_588947, "userIp", newJString(userIp))
  add(query_588947, "key", newJString(key))
  add(query_588947, "prettyPrint", newJBool(prettyPrint))
  add(query_588947, "domain", newJString(domain))
  result = call_588946.call(nil, query_588947, nil, nil, nil)

var androidenterpriseEnterprisesList* = Call_AndroidenterpriseEnterprisesList_588718(
    name: "androidenterpriseEnterprisesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises",
    validator: validate_AndroidenterpriseEnterprisesList_588719,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesList_588720,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_588987 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_588989(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_588988(
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
  var valid_588990 = query.getOrDefault("fields")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = nil)
  if valid_588990 != nil:
    section.add "fields", valid_588990
  var valid_588991 = query.getOrDefault("quotaUser")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = nil)
  if valid_588991 != nil:
    section.add "quotaUser", valid_588991
  var valid_588992 = query.getOrDefault("alt")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = newJString("json"))
  if valid_588992 != nil:
    section.add "alt", valid_588992
  var valid_588993 = query.getOrDefault("oauth_token")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "oauth_token", valid_588993
  var valid_588994 = query.getOrDefault("userIp")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "userIp", valid_588994
  var valid_588995 = query.getOrDefault("notificationSetId")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "notificationSetId", valid_588995
  var valid_588996 = query.getOrDefault("key")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "key", valid_588996
  var valid_588997 = query.getOrDefault("prettyPrint")
  valid_588997 = validateParameter(valid_588997, JBool, required = false,
                                 default = newJBool(true))
  if valid_588997 != nil:
    section.add "prettyPrint", valid_588997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588998: Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_588987;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Acknowledges notifications that were received from Enterprises.PullNotificationSet to prevent subsequent calls from returning the same notifications.
  ## 
  let valid = call_588998.validator(path, query, header, formData, body)
  let scheme = call_588998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588998.url(scheme.get, call_588998.host, call_588998.base,
                         call_588998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588998, url, valid)

proc call*(call_588999: Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_588987;
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
  var query_589000 = newJObject()
  add(query_589000, "fields", newJString(fields))
  add(query_589000, "quotaUser", newJString(quotaUser))
  add(query_589000, "alt", newJString(alt))
  add(query_589000, "oauth_token", newJString(oauthToken))
  add(query_589000, "userIp", newJString(userIp))
  add(query_589000, "notificationSetId", newJString(notificationSetId))
  add(query_589000, "key", newJString(key))
  add(query_589000, "prettyPrint", newJBool(prettyPrint))
  result = call_588999.call(nil, query_589000, nil, nil, nil)

var androidenterpriseEnterprisesAcknowledgeNotificationSet* = Call_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_588987(
    name: "androidenterpriseEnterprisesAcknowledgeNotificationSet",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/acknowledgeNotificationSet",
    validator: validate_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_588988,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesAcknowledgeNotificationSet_588989,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesCompleteSignup_589001 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesCompleteSignup_589003(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesCompleteSignup_589002(path: JsonNode;
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
  var valid_589004 = query.getOrDefault("fields")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "fields", valid_589004
  var valid_589005 = query.getOrDefault("completionToken")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "completionToken", valid_589005
  var valid_589006 = query.getOrDefault("quotaUser")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "quotaUser", valid_589006
  var valid_589007 = query.getOrDefault("alt")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = newJString("json"))
  if valid_589007 != nil:
    section.add "alt", valid_589007
  var valid_589008 = query.getOrDefault("oauth_token")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "oauth_token", valid_589008
  var valid_589009 = query.getOrDefault("userIp")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "userIp", valid_589009
  var valid_589010 = query.getOrDefault("enterpriseToken")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "enterpriseToken", valid_589010
  var valid_589011 = query.getOrDefault("key")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "key", valid_589011
  var valid_589012 = query.getOrDefault("prettyPrint")
  valid_589012 = validateParameter(valid_589012, JBool, required = false,
                                 default = newJBool(true))
  if valid_589012 != nil:
    section.add "prettyPrint", valid_589012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589013: Call_AndroidenterpriseEnterprisesCompleteSignup_589001;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Completes the signup flow, by specifying the Completion token and Enterprise token. This request must not be called multiple times for a given Enterprise Token.
  ## 
  let valid = call_589013.validator(path, query, header, formData, body)
  let scheme = call_589013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589013.url(scheme.get, call_589013.host, call_589013.base,
                         call_589013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589013, url, valid)

proc call*(call_589014: Call_AndroidenterpriseEnterprisesCompleteSignup_589001;
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
  var query_589015 = newJObject()
  add(query_589015, "fields", newJString(fields))
  add(query_589015, "completionToken", newJString(completionToken))
  add(query_589015, "quotaUser", newJString(quotaUser))
  add(query_589015, "alt", newJString(alt))
  add(query_589015, "oauth_token", newJString(oauthToken))
  add(query_589015, "userIp", newJString(userIp))
  add(query_589015, "enterpriseToken", newJString(enterpriseToken))
  add(query_589015, "key", newJString(key))
  add(query_589015, "prettyPrint", newJBool(prettyPrint))
  result = call_589014.call(nil, query_589015, nil, nil, nil)

var androidenterpriseEnterprisesCompleteSignup* = Call_AndroidenterpriseEnterprisesCompleteSignup_589001(
    name: "androidenterpriseEnterprisesCompleteSignup", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/completeSignup",
    validator: validate_AndroidenterpriseEnterprisesCompleteSignup_589002,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesCompleteSignup_589003,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesEnroll_589016 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesEnroll_589018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesEnroll_589017(path: JsonNode;
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
  var valid_589019 = query.getOrDefault("token")
  valid_589019 = validateParameter(valid_589019, JString, required = true,
                                 default = nil)
  if valid_589019 != nil:
    section.add "token", valid_589019
  var valid_589020 = query.getOrDefault("fields")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "fields", valid_589020
  var valid_589021 = query.getOrDefault("quotaUser")
  valid_589021 = validateParameter(valid_589021, JString, required = false,
                                 default = nil)
  if valid_589021 != nil:
    section.add "quotaUser", valid_589021
  var valid_589022 = query.getOrDefault("alt")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = newJString("json"))
  if valid_589022 != nil:
    section.add "alt", valid_589022
  var valid_589023 = query.getOrDefault("oauth_token")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "oauth_token", valid_589023
  var valid_589024 = query.getOrDefault("userIp")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "userIp", valid_589024
  var valid_589025 = query.getOrDefault("key")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "key", valid_589025
  var valid_589026 = query.getOrDefault("prettyPrint")
  valid_589026 = validateParameter(valid_589026, JBool, required = false,
                                 default = newJBool(true))
  if valid_589026 != nil:
    section.add "prettyPrint", valid_589026
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

proc call*(call_589028: Call_AndroidenterpriseEnterprisesEnroll_589016;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Enrolls an enterprise with the calling EMM.
  ## 
  let valid = call_589028.validator(path, query, header, formData, body)
  let scheme = call_589028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589028.url(scheme.get, call_589028.host, call_589028.base,
                         call_589028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589028, url, valid)

proc call*(call_589029: Call_AndroidenterpriseEnterprisesEnroll_589016;
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
  var query_589030 = newJObject()
  var body_589031 = newJObject()
  add(query_589030, "token", newJString(token))
  add(query_589030, "fields", newJString(fields))
  add(query_589030, "quotaUser", newJString(quotaUser))
  add(query_589030, "alt", newJString(alt))
  add(query_589030, "oauth_token", newJString(oauthToken))
  add(query_589030, "userIp", newJString(userIp))
  add(query_589030, "key", newJString(key))
  if body != nil:
    body_589031 = body
  add(query_589030, "prettyPrint", newJBool(prettyPrint))
  result = call_589029.call(nil, query_589030, nil, nil, body_589031)

var androidenterpriseEnterprisesEnroll* = Call_AndroidenterpriseEnterprisesEnroll_589016(
    name: "androidenterpriseEnterprisesEnroll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/enroll",
    validator: validate_AndroidenterpriseEnterprisesEnroll_589017,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesEnroll_589018,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesPullNotificationSet_589032 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesPullNotificationSet_589034(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesPullNotificationSet_589033(
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
  var valid_589035 = query.getOrDefault("fields")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "fields", valid_589035
  var valid_589036 = query.getOrDefault("quotaUser")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "quotaUser", valid_589036
  var valid_589037 = query.getOrDefault("alt")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("json"))
  if valid_589037 != nil:
    section.add "alt", valid_589037
  var valid_589038 = query.getOrDefault("oauth_token")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "oauth_token", valid_589038
  var valid_589039 = query.getOrDefault("userIp")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "userIp", valid_589039
  var valid_589040 = query.getOrDefault("key")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "key", valid_589040
  var valid_589041 = query.getOrDefault("prettyPrint")
  valid_589041 = validateParameter(valid_589041, JBool, required = false,
                                 default = newJBool(true))
  if valid_589041 != nil:
    section.add "prettyPrint", valid_589041
  var valid_589042 = query.getOrDefault("requestMode")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = newJString("returnImmediately"))
  if valid_589042 != nil:
    section.add "requestMode", valid_589042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589043: Call_AndroidenterpriseEnterprisesPullNotificationSet_589032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Pulls and returns a notification set for the enterprises associated with the service account authenticated for the request. The notification set may be empty if no notification are pending.
  ## A notification set returned needs to be acknowledged within 20 seconds by calling Enterprises.AcknowledgeNotificationSet, unless the notification set is empty.
  ## Notifications that are not acknowledged within the 20 seconds will eventually be included again in the response to another PullNotificationSet request, and those that are never acknowledged will ultimately be deleted according to the Google Cloud Platform Pub/Sub system policy.
  ## Multiple requests might be performed concurrently to retrieve notifications, in which case the pending notifications (if any) will be split among each caller, if any are pending.
  ## If no notifications are present, an empty notification list is returned. Subsequent requests may return more notifications once they become available.
  ## 
  let valid = call_589043.validator(path, query, header, formData, body)
  let scheme = call_589043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589043.url(scheme.get, call_589043.host, call_589043.base,
                         call_589043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589043, url, valid)

proc call*(call_589044: Call_AndroidenterpriseEnterprisesPullNotificationSet_589032;
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
  var query_589045 = newJObject()
  add(query_589045, "fields", newJString(fields))
  add(query_589045, "quotaUser", newJString(quotaUser))
  add(query_589045, "alt", newJString(alt))
  add(query_589045, "oauth_token", newJString(oauthToken))
  add(query_589045, "userIp", newJString(userIp))
  add(query_589045, "key", newJString(key))
  add(query_589045, "prettyPrint", newJBool(prettyPrint))
  add(query_589045, "requestMode", newJString(requestMode))
  result = call_589044.call(nil, query_589045, nil, nil, nil)

var androidenterpriseEnterprisesPullNotificationSet* = Call_AndroidenterpriseEnterprisesPullNotificationSet_589032(
    name: "androidenterpriseEnterprisesPullNotificationSet",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/pullNotificationSet",
    validator: validate_AndroidenterpriseEnterprisesPullNotificationSet_589033,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesPullNotificationSet_589034,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGenerateSignupUrl_589046 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesGenerateSignupUrl_589048(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AndroidenterpriseEnterprisesGenerateSignupUrl_589047(
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
  var valid_589049 = query.getOrDefault("fields")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "fields", valid_589049
  var valid_589050 = query.getOrDefault("quotaUser")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "quotaUser", valid_589050
  var valid_589051 = query.getOrDefault("callbackUrl")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "callbackUrl", valid_589051
  var valid_589052 = query.getOrDefault("alt")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = newJString("json"))
  if valid_589052 != nil:
    section.add "alt", valid_589052
  var valid_589053 = query.getOrDefault("oauth_token")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "oauth_token", valid_589053
  var valid_589054 = query.getOrDefault("userIp")
  valid_589054 = validateParameter(valid_589054, JString, required = false,
                                 default = nil)
  if valid_589054 != nil:
    section.add "userIp", valid_589054
  var valid_589055 = query.getOrDefault("key")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "key", valid_589055
  var valid_589056 = query.getOrDefault("prettyPrint")
  valid_589056 = validateParameter(valid_589056, JBool, required = false,
                                 default = newJBool(true))
  if valid_589056 != nil:
    section.add "prettyPrint", valid_589056
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589057: Call_AndroidenterpriseEnterprisesGenerateSignupUrl_589046;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a sign-up URL.
  ## 
  let valid = call_589057.validator(path, query, header, formData, body)
  let scheme = call_589057.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589057.url(scheme.get, call_589057.host, call_589057.base,
                         call_589057.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589057, url, valid)

proc call*(call_589058: Call_AndroidenterpriseEnterprisesGenerateSignupUrl_589046;
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
  var query_589059 = newJObject()
  add(query_589059, "fields", newJString(fields))
  add(query_589059, "quotaUser", newJString(quotaUser))
  add(query_589059, "callbackUrl", newJString(callbackUrl))
  add(query_589059, "alt", newJString(alt))
  add(query_589059, "oauth_token", newJString(oauthToken))
  add(query_589059, "userIp", newJString(userIp))
  add(query_589059, "key", newJString(key))
  add(query_589059, "prettyPrint", newJBool(prettyPrint))
  result = call_589058.call(nil, query_589059, nil, nil, nil)

var androidenterpriseEnterprisesGenerateSignupUrl* = Call_AndroidenterpriseEnterprisesGenerateSignupUrl_589046(
    name: "androidenterpriseEnterprisesGenerateSignupUrl",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/signupUrl",
    validator: validate_AndroidenterpriseEnterprisesGenerateSignupUrl_589047,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesGenerateSignupUrl_589048,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGet_589060 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesGet_589062(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseEnterprisesGet_589061(path: JsonNode;
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
  var valid_589077 = path.getOrDefault("enterpriseId")
  valid_589077 = validateParameter(valid_589077, JString, required = true,
                                 default = nil)
  if valid_589077 != nil:
    section.add "enterpriseId", valid_589077
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
  var valid_589078 = query.getOrDefault("fields")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = nil)
  if valid_589078 != nil:
    section.add "fields", valid_589078
  var valid_589079 = query.getOrDefault("quotaUser")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "quotaUser", valid_589079
  var valid_589080 = query.getOrDefault("alt")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = newJString("json"))
  if valid_589080 != nil:
    section.add "alt", valid_589080
  var valid_589081 = query.getOrDefault("oauth_token")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "oauth_token", valid_589081
  var valid_589082 = query.getOrDefault("userIp")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "userIp", valid_589082
  var valid_589083 = query.getOrDefault("key")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "key", valid_589083
  var valid_589084 = query.getOrDefault("prettyPrint")
  valid_589084 = validateParameter(valid_589084, JBool, required = false,
                                 default = newJBool(true))
  if valid_589084 != nil:
    section.add "prettyPrint", valid_589084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589085: Call_AndroidenterpriseEnterprisesGet_589060;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the name and domain of an enterprise.
  ## 
  let valid = call_589085.validator(path, query, header, formData, body)
  let scheme = call_589085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589085.url(scheme.get, call_589085.host, call_589085.base,
                         call_589085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589085, url, valid)

proc call*(call_589086: Call_AndroidenterpriseEnterprisesGet_589060;
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
  var path_589087 = newJObject()
  var query_589088 = newJObject()
  add(query_589088, "fields", newJString(fields))
  add(query_589088, "quotaUser", newJString(quotaUser))
  add(query_589088, "alt", newJString(alt))
  add(query_589088, "oauth_token", newJString(oauthToken))
  add(query_589088, "userIp", newJString(userIp))
  add(query_589088, "key", newJString(key))
  add(path_589087, "enterpriseId", newJString(enterpriseId))
  add(query_589088, "prettyPrint", newJBool(prettyPrint))
  result = call_589086.call(path_589087, query_589088, nil, nil, nil)

var androidenterpriseEnterprisesGet* = Call_AndroidenterpriseEnterprisesGet_589060(
    name: "androidenterpriseEnterprisesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}",
    validator: validate_AndroidenterpriseEnterprisesGet_589061,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesGet_589062,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesSetAccount_589089 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesSetAccount_589091(protocol: Scheme;
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

proc validate_AndroidenterpriseEnterprisesSetAccount_589090(path: JsonNode;
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
  var valid_589092 = path.getOrDefault("enterpriseId")
  valid_589092 = validateParameter(valid_589092, JString, required = true,
                                 default = nil)
  if valid_589092 != nil:
    section.add "enterpriseId", valid_589092
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
  var valid_589093 = query.getOrDefault("fields")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "fields", valid_589093
  var valid_589094 = query.getOrDefault("quotaUser")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "quotaUser", valid_589094
  var valid_589095 = query.getOrDefault("alt")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = newJString("json"))
  if valid_589095 != nil:
    section.add "alt", valid_589095
  var valid_589096 = query.getOrDefault("oauth_token")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "oauth_token", valid_589096
  var valid_589097 = query.getOrDefault("userIp")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "userIp", valid_589097
  var valid_589098 = query.getOrDefault("key")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "key", valid_589098
  var valid_589099 = query.getOrDefault("prettyPrint")
  valid_589099 = validateParameter(valid_589099, JBool, required = false,
                                 default = newJBool(true))
  if valid_589099 != nil:
    section.add "prettyPrint", valid_589099
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

proc call*(call_589101: Call_AndroidenterpriseEnterprisesSetAccount_589089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the account that will be used to authenticate to the API as the enterprise.
  ## 
  let valid = call_589101.validator(path, query, header, formData, body)
  let scheme = call_589101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589101.url(scheme.get, call_589101.host, call_589101.base,
                         call_589101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589101, url, valid)

proc call*(call_589102: Call_AndroidenterpriseEnterprisesSetAccount_589089;
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
  var path_589103 = newJObject()
  var query_589104 = newJObject()
  var body_589105 = newJObject()
  add(query_589104, "fields", newJString(fields))
  add(query_589104, "quotaUser", newJString(quotaUser))
  add(query_589104, "alt", newJString(alt))
  add(query_589104, "oauth_token", newJString(oauthToken))
  add(query_589104, "userIp", newJString(userIp))
  add(query_589104, "key", newJString(key))
  add(path_589103, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589105 = body
  add(query_589104, "prettyPrint", newJBool(prettyPrint))
  result = call_589102.call(path_589103, query_589104, nil, nil, body_589105)

var androidenterpriseEnterprisesSetAccount* = Call_AndroidenterpriseEnterprisesSetAccount_589089(
    name: "androidenterpriseEnterprisesSetAccount", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/account",
    validator: validate_AndroidenterpriseEnterprisesSetAccount_589090,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesSetAccount_589091,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesCreateWebToken_589106 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesCreateWebToken_589108(protocol: Scheme;
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

proc validate_AndroidenterpriseEnterprisesCreateWebToken_589107(path: JsonNode;
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
  var valid_589109 = path.getOrDefault("enterpriseId")
  valid_589109 = validateParameter(valid_589109, JString, required = true,
                                 default = nil)
  if valid_589109 != nil:
    section.add "enterpriseId", valid_589109
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
  var valid_589110 = query.getOrDefault("fields")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "fields", valid_589110
  var valid_589111 = query.getOrDefault("quotaUser")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = nil)
  if valid_589111 != nil:
    section.add "quotaUser", valid_589111
  var valid_589112 = query.getOrDefault("alt")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = newJString("json"))
  if valid_589112 != nil:
    section.add "alt", valid_589112
  var valid_589113 = query.getOrDefault("oauth_token")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "oauth_token", valid_589113
  var valid_589114 = query.getOrDefault("userIp")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "userIp", valid_589114
  var valid_589115 = query.getOrDefault("key")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = nil)
  if valid_589115 != nil:
    section.add "key", valid_589115
  var valid_589116 = query.getOrDefault("prettyPrint")
  valid_589116 = validateParameter(valid_589116, JBool, required = false,
                                 default = newJBool(true))
  if valid_589116 != nil:
    section.add "prettyPrint", valid_589116
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

proc call*(call_589118: Call_AndroidenterpriseEnterprisesCreateWebToken_589106;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a unique token to access an embeddable UI. To generate a web UI, pass the generated token into the managed Google Play javascript API. Each token may only be used to start one UI session. See the javascript API documentation for further information.
  ## 
  let valid = call_589118.validator(path, query, header, formData, body)
  let scheme = call_589118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589118.url(scheme.get, call_589118.host, call_589118.base,
                         call_589118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589118, url, valid)

proc call*(call_589119: Call_AndroidenterpriseEnterprisesCreateWebToken_589106;
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
  var path_589120 = newJObject()
  var query_589121 = newJObject()
  var body_589122 = newJObject()
  add(query_589121, "fields", newJString(fields))
  add(query_589121, "quotaUser", newJString(quotaUser))
  add(query_589121, "alt", newJString(alt))
  add(query_589121, "oauth_token", newJString(oauthToken))
  add(query_589121, "userIp", newJString(userIp))
  add(query_589121, "key", newJString(key))
  add(path_589120, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589122 = body
  add(query_589121, "prettyPrint", newJBool(prettyPrint))
  result = call_589119.call(path_589120, query_589121, nil, nil, body_589122)

var androidenterpriseEnterprisesCreateWebToken* = Call_AndroidenterpriseEnterprisesCreateWebToken_589106(
    name: "androidenterpriseEnterprisesCreateWebToken", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/createWebToken",
    validator: validate_AndroidenterpriseEnterprisesCreateWebToken_589107,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesCreateWebToken_589108,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseGrouplicensesList_589123 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseGrouplicensesList_589125(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseGrouplicensesList_589124(path: JsonNode;
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
  var valid_589126 = path.getOrDefault("enterpriseId")
  valid_589126 = validateParameter(valid_589126, JString, required = true,
                                 default = nil)
  if valid_589126 != nil:
    section.add "enterpriseId", valid_589126
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
  var valid_589127 = query.getOrDefault("fields")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "fields", valid_589127
  var valid_589128 = query.getOrDefault("quotaUser")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "quotaUser", valid_589128
  var valid_589129 = query.getOrDefault("alt")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = newJString("json"))
  if valid_589129 != nil:
    section.add "alt", valid_589129
  var valid_589130 = query.getOrDefault("oauth_token")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "oauth_token", valid_589130
  var valid_589131 = query.getOrDefault("userIp")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "userIp", valid_589131
  var valid_589132 = query.getOrDefault("key")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "key", valid_589132
  var valid_589133 = query.getOrDefault("prettyPrint")
  valid_589133 = validateParameter(valid_589133, JBool, required = false,
                                 default = newJBool(true))
  if valid_589133 != nil:
    section.add "prettyPrint", valid_589133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589134: Call_AndroidenterpriseGrouplicensesList_589123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves IDs of all products for which the enterprise has a group license.
  ## 
  let valid = call_589134.validator(path, query, header, formData, body)
  let scheme = call_589134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589134.url(scheme.get, call_589134.host, call_589134.base,
                         call_589134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589134, url, valid)

proc call*(call_589135: Call_AndroidenterpriseGrouplicensesList_589123;
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
  var path_589136 = newJObject()
  var query_589137 = newJObject()
  add(query_589137, "fields", newJString(fields))
  add(query_589137, "quotaUser", newJString(quotaUser))
  add(query_589137, "alt", newJString(alt))
  add(query_589137, "oauth_token", newJString(oauthToken))
  add(query_589137, "userIp", newJString(userIp))
  add(query_589137, "key", newJString(key))
  add(path_589136, "enterpriseId", newJString(enterpriseId))
  add(query_589137, "prettyPrint", newJBool(prettyPrint))
  result = call_589135.call(path_589136, query_589137, nil, nil, nil)

var androidenterpriseGrouplicensesList* = Call_AndroidenterpriseGrouplicensesList_589123(
    name: "androidenterpriseGrouplicensesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/groupLicenses",
    validator: validate_AndroidenterpriseGrouplicensesList_589124,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseGrouplicensesList_589125,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseGrouplicensesGet_589138 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseGrouplicensesGet_589140(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseGrouplicensesGet_589139(path: JsonNode;
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
  var valid_589141 = path.getOrDefault("groupLicenseId")
  valid_589141 = validateParameter(valid_589141, JString, required = true,
                                 default = nil)
  if valid_589141 != nil:
    section.add "groupLicenseId", valid_589141
  var valid_589142 = path.getOrDefault("enterpriseId")
  valid_589142 = validateParameter(valid_589142, JString, required = true,
                                 default = nil)
  if valid_589142 != nil:
    section.add "enterpriseId", valid_589142
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
  var valid_589143 = query.getOrDefault("fields")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "fields", valid_589143
  var valid_589144 = query.getOrDefault("quotaUser")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "quotaUser", valid_589144
  var valid_589145 = query.getOrDefault("alt")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = newJString("json"))
  if valid_589145 != nil:
    section.add "alt", valid_589145
  var valid_589146 = query.getOrDefault("oauth_token")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "oauth_token", valid_589146
  var valid_589147 = query.getOrDefault("userIp")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "userIp", valid_589147
  var valid_589148 = query.getOrDefault("key")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "key", valid_589148
  var valid_589149 = query.getOrDefault("prettyPrint")
  valid_589149 = validateParameter(valid_589149, JBool, required = false,
                                 default = newJBool(true))
  if valid_589149 != nil:
    section.add "prettyPrint", valid_589149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589150: Call_AndroidenterpriseGrouplicensesGet_589138;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of an enterprise's group license for a product.
  ## 
  let valid = call_589150.validator(path, query, header, formData, body)
  let scheme = call_589150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589150.url(scheme.get, call_589150.host, call_589150.base,
                         call_589150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589150, url, valid)

proc call*(call_589151: Call_AndroidenterpriseGrouplicensesGet_589138;
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
  var path_589152 = newJObject()
  var query_589153 = newJObject()
  add(query_589153, "fields", newJString(fields))
  add(query_589153, "quotaUser", newJString(quotaUser))
  add(query_589153, "alt", newJString(alt))
  add(query_589153, "oauth_token", newJString(oauthToken))
  add(query_589153, "userIp", newJString(userIp))
  add(path_589152, "groupLicenseId", newJString(groupLicenseId))
  add(query_589153, "key", newJString(key))
  add(path_589152, "enterpriseId", newJString(enterpriseId))
  add(query_589153, "prettyPrint", newJBool(prettyPrint))
  result = call_589151.call(path_589152, query_589153, nil, nil, nil)

var androidenterpriseGrouplicensesGet* = Call_AndroidenterpriseGrouplicensesGet_589138(
    name: "androidenterpriseGrouplicensesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/groupLicenses/{groupLicenseId}",
    validator: validate_AndroidenterpriseGrouplicensesGet_589139,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseGrouplicensesGet_589140,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseGrouplicenseusersList_589154 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseGrouplicenseusersList_589156(protocol: Scheme;
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

proc validate_AndroidenterpriseGrouplicenseusersList_589155(path: JsonNode;
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
  var valid_589157 = path.getOrDefault("groupLicenseId")
  valid_589157 = validateParameter(valid_589157, JString, required = true,
                                 default = nil)
  if valid_589157 != nil:
    section.add "groupLicenseId", valid_589157
  var valid_589158 = path.getOrDefault("enterpriseId")
  valid_589158 = validateParameter(valid_589158, JString, required = true,
                                 default = nil)
  if valid_589158 != nil:
    section.add "enterpriseId", valid_589158
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
  var valid_589159 = query.getOrDefault("fields")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "fields", valid_589159
  var valid_589160 = query.getOrDefault("quotaUser")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "quotaUser", valid_589160
  var valid_589161 = query.getOrDefault("alt")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = newJString("json"))
  if valid_589161 != nil:
    section.add "alt", valid_589161
  var valid_589162 = query.getOrDefault("oauth_token")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "oauth_token", valid_589162
  var valid_589163 = query.getOrDefault("userIp")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "userIp", valid_589163
  var valid_589164 = query.getOrDefault("key")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "key", valid_589164
  var valid_589165 = query.getOrDefault("prettyPrint")
  valid_589165 = validateParameter(valid_589165, JBool, required = false,
                                 default = newJBool(true))
  if valid_589165 != nil:
    section.add "prettyPrint", valid_589165
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589166: Call_AndroidenterpriseGrouplicenseusersList_589154;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the IDs of the users who have been granted entitlements under the license.
  ## 
  let valid = call_589166.validator(path, query, header, formData, body)
  let scheme = call_589166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589166.url(scheme.get, call_589166.host, call_589166.base,
                         call_589166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589166, url, valid)

proc call*(call_589167: Call_AndroidenterpriseGrouplicenseusersList_589154;
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
  var path_589168 = newJObject()
  var query_589169 = newJObject()
  add(query_589169, "fields", newJString(fields))
  add(query_589169, "quotaUser", newJString(quotaUser))
  add(query_589169, "alt", newJString(alt))
  add(query_589169, "oauth_token", newJString(oauthToken))
  add(query_589169, "userIp", newJString(userIp))
  add(path_589168, "groupLicenseId", newJString(groupLicenseId))
  add(query_589169, "key", newJString(key))
  add(path_589168, "enterpriseId", newJString(enterpriseId))
  add(query_589169, "prettyPrint", newJBool(prettyPrint))
  result = call_589167.call(path_589168, query_589169, nil, nil, nil)

var androidenterpriseGrouplicenseusersList* = Call_AndroidenterpriseGrouplicenseusersList_589154(
    name: "androidenterpriseGrouplicenseusersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/groupLicenses/{groupLicenseId}/users",
    validator: validate_AndroidenterpriseGrouplicenseusersList_589155,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseGrouplicenseusersList_589156,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsList_589170 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseProductsList_589172(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseProductsList_589171(path: JsonNode; query: JsonNode;
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
  var valid_589173 = path.getOrDefault("enterpriseId")
  valid_589173 = validateParameter(valid_589173, JString, required = true,
                                 default = nil)
  if valid_589173 != nil:
    section.add "enterpriseId", valid_589173
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
  var valid_589174 = query.getOrDefault("token")
  valid_589174 = validateParameter(valid_589174, JString, required = false,
                                 default = nil)
  if valid_589174 != nil:
    section.add "token", valid_589174
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
  var valid_589178 = query.getOrDefault("language")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "language", valid_589178
  var valid_589179 = query.getOrDefault("query")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "query", valid_589179
  var valid_589180 = query.getOrDefault("oauth_token")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "oauth_token", valid_589180
  var valid_589181 = query.getOrDefault("userIp")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "userIp", valid_589181
  var valid_589182 = query.getOrDefault("maxResults")
  valid_589182 = validateParameter(valid_589182, JInt, required = false, default = nil)
  if valid_589182 != nil:
    section.add "maxResults", valid_589182
  var valid_589183 = query.getOrDefault("key")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "key", valid_589183
  var valid_589184 = query.getOrDefault("approved")
  valid_589184 = validateParameter(valid_589184, JBool, required = false, default = nil)
  if valid_589184 != nil:
    section.add "approved", valid_589184
  var valid_589185 = query.getOrDefault("prettyPrint")
  valid_589185 = validateParameter(valid_589185, JBool, required = false,
                                 default = newJBool(true))
  if valid_589185 != nil:
    section.add "prettyPrint", valid_589185
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589186: Call_AndroidenterpriseProductsList_589170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Finds approved products that match a query, or all approved products if there is no query.
  ## 
  let valid = call_589186.validator(path, query, header, formData, body)
  let scheme = call_589186.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589186.url(scheme.get, call_589186.host, call_589186.base,
                         call_589186.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589186, url, valid)

proc call*(call_589187: Call_AndroidenterpriseProductsList_589170;
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
  var path_589188 = newJObject()
  var query_589189 = newJObject()
  add(query_589189, "token", newJString(token))
  add(query_589189, "fields", newJString(fields))
  add(query_589189, "quotaUser", newJString(quotaUser))
  add(query_589189, "alt", newJString(alt))
  add(query_589189, "language", newJString(language))
  add(query_589189, "query", newJString(query))
  add(query_589189, "oauth_token", newJString(oauthToken))
  add(query_589189, "userIp", newJString(userIp))
  add(query_589189, "maxResults", newJInt(maxResults))
  add(query_589189, "key", newJString(key))
  add(path_589188, "enterpriseId", newJString(enterpriseId))
  add(query_589189, "approved", newJBool(approved))
  add(query_589189, "prettyPrint", newJBool(prettyPrint))
  result = call_589187.call(path_589188, query_589189, nil, nil, nil)

var androidenterpriseProductsList* = Call_AndroidenterpriseProductsList_589170(
    name: "androidenterpriseProductsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products",
    validator: validate_AndroidenterpriseProductsList_589171,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsList_589172,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGet_589190 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseProductsGet_589192(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseProductsGet_589191(path: JsonNode; query: JsonNode;
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
  var valid_589193 = path.getOrDefault("enterpriseId")
  valid_589193 = validateParameter(valid_589193, JString, required = true,
                                 default = nil)
  if valid_589193 != nil:
    section.add "enterpriseId", valid_589193
  var valid_589194 = path.getOrDefault("productId")
  valid_589194 = validateParameter(valid_589194, JString, required = true,
                                 default = nil)
  if valid_589194 != nil:
    section.add "productId", valid_589194
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
  var valid_589195 = query.getOrDefault("fields")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "fields", valid_589195
  var valid_589196 = query.getOrDefault("quotaUser")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "quotaUser", valid_589196
  var valid_589197 = query.getOrDefault("alt")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = newJString("json"))
  if valid_589197 != nil:
    section.add "alt", valid_589197
  var valid_589198 = query.getOrDefault("language")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "language", valid_589198
  var valid_589199 = query.getOrDefault("oauth_token")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "oauth_token", valid_589199
  var valid_589200 = query.getOrDefault("userIp")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "userIp", valid_589200
  var valid_589201 = query.getOrDefault("key")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = nil)
  if valid_589201 != nil:
    section.add "key", valid_589201
  var valid_589202 = query.getOrDefault("prettyPrint")
  valid_589202 = validateParameter(valid_589202, JBool, required = false,
                                 default = newJBool(true))
  if valid_589202 != nil:
    section.add "prettyPrint", valid_589202
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589203: Call_AndroidenterpriseProductsGet_589190; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves details of a product for display to an enterprise admin.
  ## 
  let valid = call_589203.validator(path, query, header, formData, body)
  let scheme = call_589203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589203.url(scheme.get, call_589203.host, call_589203.base,
                         call_589203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589203, url, valid)

proc call*(call_589204: Call_AndroidenterpriseProductsGet_589190;
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
  var path_589205 = newJObject()
  var query_589206 = newJObject()
  add(query_589206, "fields", newJString(fields))
  add(query_589206, "quotaUser", newJString(quotaUser))
  add(query_589206, "alt", newJString(alt))
  add(query_589206, "language", newJString(language))
  add(query_589206, "oauth_token", newJString(oauthToken))
  add(query_589206, "userIp", newJString(userIp))
  add(query_589206, "key", newJString(key))
  add(path_589205, "enterpriseId", newJString(enterpriseId))
  add(path_589205, "productId", newJString(productId))
  add(query_589206, "prettyPrint", newJBool(prettyPrint))
  result = call_589204.call(path_589205, query_589206, nil, nil, nil)

var androidenterpriseProductsGet* = Call_AndroidenterpriseProductsGet_589190(
    name: "androidenterpriseProductsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}",
    validator: validate_AndroidenterpriseProductsGet_589191,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsGet_589192,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGetAppRestrictionsSchema_589207 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseProductsGetAppRestrictionsSchema_589209(
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

proc validate_AndroidenterpriseProductsGetAppRestrictionsSchema_589208(
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
  var valid_589210 = path.getOrDefault("enterpriseId")
  valid_589210 = validateParameter(valid_589210, JString, required = true,
                                 default = nil)
  if valid_589210 != nil:
    section.add "enterpriseId", valid_589210
  var valid_589211 = path.getOrDefault("productId")
  valid_589211 = validateParameter(valid_589211, JString, required = true,
                                 default = nil)
  if valid_589211 != nil:
    section.add "productId", valid_589211
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
  var valid_589212 = query.getOrDefault("fields")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "fields", valid_589212
  var valid_589213 = query.getOrDefault("quotaUser")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "quotaUser", valid_589213
  var valid_589214 = query.getOrDefault("alt")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = newJString("json"))
  if valid_589214 != nil:
    section.add "alt", valid_589214
  var valid_589215 = query.getOrDefault("language")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "language", valid_589215
  var valid_589216 = query.getOrDefault("oauth_token")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "oauth_token", valid_589216
  var valid_589217 = query.getOrDefault("userIp")
  valid_589217 = validateParameter(valid_589217, JString, required = false,
                                 default = nil)
  if valid_589217 != nil:
    section.add "userIp", valid_589217
  var valid_589218 = query.getOrDefault("key")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "key", valid_589218
  var valid_589219 = query.getOrDefault("prettyPrint")
  valid_589219 = validateParameter(valid_589219, JBool, required = false,
                                 default = newJBool(true))
  if valid_589219 != nil:
    section.add "prettyPrint", valid_589219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589220: Call_AndroidenterpriseProductsGetAppRestrictionsSchema_589207;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the schema that defines the configurable properties for this product. All products have a schema, but this schema may be empty if no managed configurations have been defined. This schema can be used to populate a UI that allows an admin to configure the product. To apply a managed configuration based on the schema obtained using this API, see Managed Configurations through Play.
  ## 
  let valid = call_589220.validator(path, query, header, formData, body)
  let scheme = call_589220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589220.url(scheme.get, call_589220.host, call_589220.base,
                         call_589220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589220, url, valid)

proc call*(call_589221: Call_AndroidenterpriseProductsGetAppRestrictionsSchema_589207;
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
  var path_589222 = newJObject()
  var query_589223 = newJObject()
  add(query_589223, "fields", newJString(fields))
  add(query_589223, "quotaUser", newJString(quotaUser))
  add(query_589223, "alt", newJString(alt))
  add(query_589223, "language", newJString(language))
  add(query_589223, "oauth_token", newJString(oauthToken))
  add(query_589223, "userIp", newJString(userIp))
  add(query_589223, "key", newJString(key))
  add(path_589222, "enterpriseId", newJString(enterpriseId))
  add(path_589222, "productId", newJString(productId))
  add(query_589223, "prettyPrint", newJBool(prettyPrint))
  result = call_589221.call(path_589222, query_589223, nil, nil, nil)

var androidenterpriseProductsGetAppRestrictionsSchema* = Call_AndroidenterpriseProductsGetAppRestrictionsSchema_589207(
    name: "androidenterpriseProductsGetAppRestrictionsSchema",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products/{productId}/appRestrictionsSchema",
    validator: validate_AndroidenterpriseProductsGetAppRestrictionsSchema_589208,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseProductsGetAppRestrictionsSchema_589209,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsApprove_589224 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseProductsApprove_589226(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseProductsApprove_589225(path: JsonNode;
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
  var valid_589227 = path.getOrDefault("enterpriseId")
  valid_589227 = validateParameter(valid_589227, JString, required = true,
                                 default = nil)
  if valid_589227 != nil:
    section.add "enterpriseId", valid_589227
  var valid_589228 = path.getOrDefault("productId")
  valid_589228 = validateParameter(valid_589228, JString, required = true,
                                 default = nil)
  if valid_589228 != nil:
    section.add "productId", valid_589228
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
  var valid_589229 = query.getOrDefault("fields")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "fields", valid_589229
  var valid_589230 = query.getOrDefault("quotaUser")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "quotaUser", valid_589230
  var valid_589231 = query.getOrDefault("alt")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = newJString("json"))
  if valid_589231 != nil:
    section.add "alt", valid_589231
  var valid_589232 = query.getOrDefault("oauth_token")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "oauth_token", valid_589232
  var valid_589233 = query.getOrDefault("userIp")
  valid_589233 = validateParameter(valid_589233, JString, required = false,
                                 default = nil)
  if valid_589233 != nil:
    section.add "userIp", valid_589233
  var valid_589234 = query.getOrDefault("key")
  valid_589234 = validateParameter(valid_589234, JString, required = false,
                                 default = nil)
  if valid_589234 != nil:
    section.add "key", valid_589234
  var valid_589235 = query.getOrDefault("prettyPrint")
  valid_589235 = validateParameter(valid_589235, JBool, required = false,
                                 default = newJBool(true))
  if valid_589235 != nil:
    section.add "prettyPrint", valid_589235
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

proc call*(call_589237: Call_AndroidenterpriseProductsApprove_589224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Approves the specified product and the relevant app permissions, if any. The maximum number of products that you can approve per enterprise customer is 1,000.
  ## 
  ## To learn how to use managed Google Play to design and create a store layout to display approved products to your users, see Store Layout Design.
  ## 
  let valid = call_589237.validator(path, query, header, formData, body)
  let scheme = call_589237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589237.url(scheme.get, call_589237.host, call_589237.base,
                         call_589237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589237, url, valid)

proc call*(call_589238: Call_AndroidenterpriseProductsApprove_589224;
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
  var path_589239 = newJObject()
  var query_589240 = newJObject()
  var body_589241 = newJObject()
  add(query_589240, "fields", newJString(fields))
  add(query_589240, "quotaUser", newJString(quotaUser))
  add(query_589240, "alt", newJString(alt))
  add(query_589240, "oauth_token", newJString(oauthToken))
  add(query_589240, "userIp", newJString(userIp))
  add(query_589240, "key", newJString(key))
  add(path_589239, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589241 = body
  add(query_589240, "prettyPrint", newJBool(prettyPrint))
  add(path_589239, "productId", newJString(productId))
  result = call_589238.call(path_589239, query_589240, nil, nil, body_589241)

var androidenterpriseProductsApprove* = Call_AndroidenterpriseProductsApprove_589224(
    name: "androidenterpriseProductsApprove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}/approve",
    validator: validate_AndroidenterpriseProductsApprove_589225,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsApprove_589226,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGenerateApprovalUrl_589242 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseProductsGenerateApprovalUrl_589244(protocol: Scheme;
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

proc validate_AndroidenterpriseProductsGenerateApprovalUrl_589243(path: JsonNode;
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
  var valid_589245 = path.getOrDefault("enterpriseId")
  valid_589245 = validateParameter(valid_589245, JString, required = true,
                                 default = nil)
  if valid_589245 != nil:
    section.add "enterpriseId", valid_589245
  var valid_589246 = path.getOrDefault("productId")
  valid_589246 = validateParameter(valid_589246, JString, required = true,
                                 default = nil)
  if valid_589246 != nil:
    section.add "productId", valid_589246
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
  var valid_589247 = query.getOrDefault("fields")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "fields", valid_589247
  var valid_589248 = query.getOrDefault("quotaUser")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "quotaUser", valid_589248
  var valid_589249 = query.getOrDefault("alt")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = newJString("json"))
  if valid_589249 != nil:
    section.add "alt", valid_589249
  var valid_589250 = query.getOrDefault("oauth_token")
  valid_589250 = validateParameter(valid_589250, JString, required = false,
                                 default = nil)
  if valid_589250 != nil:
    section.add "oauth_token", valid_589250
  var valid_589251 = query.getOrDefault("userIp")
  valid_589251 = validateParameter(valid_589251, JString, required = false,
                                 default = nil)
  if valid_589251 != nil:
    section.add "userIp", valid_589251
  var valid_589252 = query.getOrDefault("key")
  valid_589252 = validateParameter(valid_589252, JString, required = false,
                                 default = nil)
  if valid_589252 != nil:
    section.add "key", valid_589252
  var valid_589253 = query.getOrDefault("languageCode")
  valid_589253 = validateParameter(valid_589253, JString, required = false,
                                 default = nil)
  if valid_589253 != nil:
    section.add "languageCode", valid_589253
  var valid_589254 = query.getOrDefault("prettyPrint")
  valid_589254 = validateParameter(valid_589254, JBool, required = false,
                                 default = newJBool(true))
  if valid_589254 != nil:
    section.add "prettyPrint", valid_589254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589255: Call_AndroidenterpriseProductsGenerateApprovalUrl_589242;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a URL that can be rendered in an iframe to display the permissions (if any) of a product. An enterprise admin must view these permissions and accept them on behalf of their organization in order to approve that product.
  ## 
  ## Admins should accept the displayed permissions by interacting with a separate UI element in the EMM console, which in turn should trigger the use of this URL as the approvalUrlInfo.approvalUrl property in a Products.approve call to approve the product. This URL can only be used to display permissions for up to 1 day.
  ## 
  let valid = call_589255.validator(path, query, header, formData, body)
  let scheme = call_589255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589255.url(scheme.get, call_589255.host, call_589255.base,
                         call_589255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589255, url, valid)

proc call*(call_589256: Call_AndroidenterpriseProductsGenerateApprovalUrl_589242;
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
  var path_589257 = newJObject()
  var query_589258 = newJObject()
  add(query_589258, "fields", newJString(fields))
  add(query_589258, "quotaUser", newJString(quotaUser))
  add(query_589258, "alt", newJString(alt))
  add(query_589258, "oauth_token", newJString(oauthToken))
  add(query_589258, "userIp", newJString(userIp))
  add(query_589258, "key", newJString(key))
  add(query_589258, "languageCode", newJString(languageCode))
  add(path_589257, "enterpriseId", newJString(enterpriseId))
  add(path_589257, "productId", newJString(productId))
  add(query_589258, "prettyPrint", newJBool(prettyPrint))
  result = call_589256.call(path_589257, query_589258, nil, nil, nil)

var androidenterpriseProductsGenerateApprovalUrl* = Call_AndroidenterpriseProductsGenerateApprovalUrl_589242(
    name: "androidenterpriseProductsGenerateApprovalUrl",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products/{productId}/generateApprovalUrl",
    validator: validate_AndroidenterpriseProductsGenerateApprovalUrl_589243,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseProductsGenerateApprovalUrl_589244,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationssettingsList_589259 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseManagedconfigurationssettingsList_589261(
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

proc validate_AndroidenterpriseManagedconfigurationssettingsList_589260(
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
  var valid_589262 = path.getOrDefault("enterpriseId")
  valid_589262 = validateParameter(valid_589262, JString, required = true,
                                 default = nil)
  if valid_589262 != nil:
    section.add "enterpriseId", valid_589262
  var valid_589263 = path.getOrDefault("productId")
  valid_589263 = validateParameter(valid_589263, JString, required = true,
                                 default = nil)
  if valid_589263 != nil:
    section.add "productId", valid_589263
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
  var valid_589264 = query.getOrDefault("fields")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "fields", valid_589264
  var valid_589265 = query.getOrDefault("quotaUser")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "quotaUser", valid_589265
  var valid_589266 = query.getOrDefault("alt")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = newJString("json"))
  if valid_589266 != nil:
    section.add "alt", valid_589266
  var valid_589267 = query.getOrDefault("oauth_token")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "oauth_token", valid_589267
  var valid_589268 = query.getOrDefault("userIp")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "userIp", valid_589268
  var valid_589269 = query.getOrDefault("key")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "key", valid_589269
  var valid_589270 = query.getOrDefault("prettyPrint")
  valid_589270 = validateParameter(valid_589270, JBool, required = false,
                                 default = newJBool(true))
  if valid_589270 != nil:
    section.add "prettyPrint", valid_589270
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589271: Call_AndroidenterpriseManagedconfigurationssettingsList_589259;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the managed configurations settings for the specified app.
  ## 
  let valid = call_589271.validator(path, query, header, formData, body)
  let scheme = call_589271.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589271.url(scheme.get, call_589271.host, call_589271.base,
                         call_589271.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589271, url, valid)

proc call*(call_589272: Call_AndroidenterpriseManagedconfigurationssettingsList_589259;
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
  var path_589273 = newJObject()
  var query_589274 = newJObject()
  add(query_589274, "fields", newJString(fields))
  add(query_589274, "quotaUser", newJString(quotaUser))
  add(query_589274, "alt", newJString(alt))
  add(query_589274, "oauth_token", newJString(oauthToken))
  add(query_589274, "userIp", newJString(userIp))
  add(query_589274, "key", newJString(key))
  add(path_589273, "enterpriseId", newJString(enterpriseId))
  add(path_589273, "productId", newJString(productId))
  add(query_589274, "prettyPrint", newJBool(prettyPrint))
  result = call_589272.call(path_589273, query_589274, nil, nil, nil)

var androidenterpriseManagedconfigurationssettingsList* = Call_AndroidenterpriseManagedconfigurationssettingsList_589259(
    name: "androidenterpriseManagedconfigurationssettingsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/products/{productId}/managedConfigurationsSettings",
    validator: validate_AndroidenterpriseManagedconfigurationssettingsList_589260,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationssettingsList_589261,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsGetPermissions_589275 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseProductsGetPermissions_589277(protocol: Scheme;
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

proc validate_AndroidenterpriseProductsGetPermissions_589276(path: JsonNode;
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
  var valid_589278 = path.getOrDefault("enterpriseId")
  valid_589278 = validateParameter(valid_589278, JString, required = true,
                                 default = nil)
  if valid_589278 != nil:
    section.add "enterpriseId", valid_589278
  var valid_589279 = path.getOrDefault("productId")
  valid_589279 = validateParameter(valid_589279, JString, required = true,
                                 default = nil)
  if valid_589279 != nil:
    section.add "productId", valid_589279
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
  var valid_589280 = query.getOrDefault("fields")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "fields", valid_589280
  var valid_589281 = query.getOrDefault("quotaUser")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "quotaUser", valid_589281
  var valid_589282 = query.getOrDefault("alt")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = newJString("json"))
  if valid_589282 != nil:
    section.add "alt", valid_589282
  var valid_589283 = query.getOrDefault("oauth_token")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "oauth_token", valid_589283
  var valid_589284 = query.getOrDefault("userIp")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "userIp", valid_589284
  var valid_589285 = query.getOrDefault("key")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "key", valid_589285
  var valid_589286 = query.getOrDefault("prettyPrint")
  valid_589286 = validateParameter(valid_589286, JBool, required = false,
                                 default = newJBool(true))
  if valid_589286 != nil:
    section.add "prettyPrint", valid_589286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589287: Call_AndroidenterpriseProductsGetPermissions_589275;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the Android app permissions required by this app.
  ## 
  let valid = call_589287.validator(path, query, header, formData, body)
  let scheme = call_589287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589287.url(scheme.get, call_589287.host, call_589287.base,
                         call_589287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589287, url, valid)

proc call*(call_589288: Call_AndroidenterpriseProductsGetPermissions_589275;
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
  var path_589289 = newJObject()
  var query_589290 = newJObject()
  add(query_589290, "fields", newJString(fields))
  add(query_589290, "quotaUser", newJString(quotaUser))
  add(query_589290, "alt", newJString(alt))
  add(query_589290, "oauth_token", newJString(oauthToken))
  add(query_589290, "userIp", newJString(userIp))
  add(query_589290, "key", newJString(key))
  add(path_589289, "enterpriseId", newJString(enterpriseId))
  add(path_589289, "productId", newJString(productId))
  add(query_589290, "prettyPrint", newJBool(prettyPrint))
  result = call_589288.call(path_589289, query_589290, nil, nil, nil)

var androidenterpriseProductsGetPermissions* = Call_AndroidenterpriseProductsGetPermissions_589275(
    name: "androidenterpriseProductsGetPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}/permissions",
    validator: validate_AndroidenterpriseProductsGetPermissions_589276,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseProductsGetPermissions_589277,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseProductsUnapprove_589291 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseProductsUnapprove_589293(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseProductsUnapprove_589292(path: JsonNode;
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
  var valid_589294 = path.getOrDefault("enterpriseId")
  valid_589294 = validateParameter(valid_589294, JString, required = true,
                                 default = nil)
  if valid_589294 != nil:
    section.add "enterpriseId", valid_589294
  var valid_589295 = path.getOrDefault("productId")
  valid_589295 = validateParameter(valid_589295, JString, required = true,
                                 default = nil)
  if valid_589295 != nil:
    section.add "productId", valid_589295
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
  var valid_589296 = query.getOrDefault("fields")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "fields", valid_589296
  var valid_589297 = query.getOrDefault("quotaUser")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "quotaUser", valid_589297
  var valid_589298 = query.getOrDefault("alt")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = newJString("json"))
  if valid_589298 != nil:
    section.add "alt", valid_589298
  var valid_589299 = query.getOrDefault("oauth_token")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "oauth_token", valid_589299
  var valid_589300 = query.getOrDefault("userIp")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "userIp", valid_589300
  var valid_589301 = query.getOrDefault("key")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "key", valid_589301
  var valid_589302 = query.getOrDefault("prettyPrint")
  valid_589302 = validateParameter(valid_589302, JBool, required = false,
                                 default = newJBool(true))
  if valid_589302 != nil:
    section.add "prettyPrint", valid_589302
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589303: Call_AndroidenterpriseProductsUnapprove_589291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unapproves the specified product (and the relevant app permissions, if any)
  ## 
  let valid = call_589303.validator(path, query, header, formData, body)
  let scheme = call_589303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589303.url(scheme.get, call_589303.host, call_589303.base,
                         call_589303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589303, url, valid)

proc call*(call_589304: Call_AndroidenterpriseProductsUnapprove_589291;
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
  var path_589305 = newJObject()
  var query_589306 = newJObject()
  add(query_589306, "fields", newJString(fields))
  add(query_589306, "quotaUser", newJString(quotaUser))
  add(query_589306, "alt", newJString(alt))
  add(query_589306, "oauth_token", newJString(oauthToken))
  add(query_589306, "userIp", newJString(userIp))
  add(query_589306, "key", newJString(key))
  add(path_589305, "enterpriseId", newJString(enterpriseId))
  add(path_589305, "productId", newJString(productId))
  add(query_589306, "prettyPrint", newJBool(prettyPrint))
  result = call_589304.call(path_589305, query_589306, nil, nil, nil)

var androidenterpriseProductsUnapprove* = Call_AndroidenterpriseProductsUnapprove_589291(
    name: "androidenterpriseProductsUnapprove", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/products/{productId}/unapprove",
    validator: validate_AndroidenterpriseProductsUnapprove_589292,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseProductsUnapprove_589293,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesSendTestPushNotification_589307 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesSendTestPushNotification_589309(
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

proc validate_AndroidenterpriseEnterprisesSendTestPushNotification_589308(
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
  var valid_589310 = path.getOrDefault("enterpriseId")
  valid_589310 = validateParameter(valid_589310, JString, required = true,
                                 default = nil)
  if valid_589310 != nil:
    section.add "enterpriseId", valid_589310
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
  var valid_589311 = query.getOrDefault("fields")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "fields", valid_589311
  var valid_589312 = query.getOrDefault("quotaUser")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "quotaUser", valid_589312
  var valid_589313 = query.getOrDefault("alt")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = newJString("json"))
  if valid_589313 != nil:
    section.add "alt", valid_589313
  var valid_589314 = query.getOrDefault("oauth_token")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "oauth_token", valid_589314
  var valid_589315 = query.getOrDefault("userIp")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "userIp", valid_589315
  var valid_589316 = query.getOrDefault("key")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "key", valid_589316
  var valid_589317 = query.getOrDefault("prettyPrint")
  valid_589317 = validateParameter(valid_589317, JBool, required = false,
                                 default = newJBool(true))
  if valid_589317 != nil:
    section.add "prettyPrint", valid_589317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589318: Call_AndroidenterpriseEnterprisesSendTestPushNotification_589307;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sends a test notification to validate the EMM integration with the Google Cloud Pub/Sub service for this enterprise.
  ## 
  let valid = call_589318.validator(path, query, header, formData, body)
  let scheme = call_589318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589318.url(scheme.get, call_589318.host, call_589318.base,
                         call_589318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589318, url, valid)

proc call*(call_589319: Call_AndroidenterpriseEnterprisesSendTestPushNotification_589307;
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
  var path_589320 = newJObject()
  var query_589321 = newJObject()
  add(query_589321, "fields", newJString(fields))
  add(query_589321, "quotaUser", newJString(quotaUser))
  add(query_589321, "alt", newJString(alt))
  add(query_589321, "oauth_token", newJString(oauthToken))
  add(query_589321, "userIp", newJString(userIp))
  add(query_589321, "key", newJString(key))
  add(path_589320, "enterpriseId", newJString(enterpriseId))
  add(query_589321, "prettyPrint", newJBool(prettyPrint))
  result = call_589319.call(path_589320, query_589321, nil, nil, nil)

var androidenterpriseEnterprisesSendTestPushNotification* = Call_AndroidenterpriseEnterprisesSendTestPushNotification_589307(
    name: "androidenterpriseEnterprisesSendTestPushNotification",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/sendTestPushNotification",
    validator: validate_AndroidenterpriseEnterprisesSendTestPushNotification_589308,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesSendTestPushNotification_589309,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGetServiceAccount_589322 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesGetServiceAccount_589324(protocol: Scheme;
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

proc validate_AndroidenterpriseEnterprisesGetServiceAccount_589323(
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
  var valid_589325 = path.getOrDefault("enterpriseId")
  valid_589325 = validateParameter(valid_589325, JString, required = true,
                                 default = nil)
  if valid_589325 != nil:
    section.add "enterpriseId", valid_589325
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
  var valid_589326 = query.getOrDefault("keyType")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = newJString("googleCredentials"))
  if valid_589326 != nil:
    section.add "keyType", valid_589326
  var valid_589327 = query.getOrDefault("fields")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = nil)
  if valid_589327 != nil:
    section.add "fields", valid_589327
  var valid_589328 = query.getOrDefault("quotaUser")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "quotaUser", valid_589328
  var valid_589329 = query.getOrDefault("alt")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = newJString("json"))
  if valid_589329 != nil:
    section.add "alt", valid_589329
  var valid_589330 = query.getOrDefault("oauth_token")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "oauth_token", valid_589330
  var valid_589331 = query.getOrDefault("userIp")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "userIp", valid_589331
  var valid_589332 = query.getOrDefault("key")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "key", valid_589332
  var valid_589333 = query.getOrDefault("prettyPrint")
  valid_589333 = validateParameter(valid_589333, JBool, required = false,
                                 default = newJBool(true))
  if valid_589333 != nil:
    section.add "prettyPrint", valid_589333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589334: Call_AndroidenterpriseEnterprisesGetServiceAccount_589322;
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
  let valid = call_589334.validator(path, query, header, formData, body)
  let scheme = call_589334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589334.url(scheme.get, call_589334.host, call_589334.base,
                         call_589334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589334, url, valid)

proc call*(call_589335: Call_AndroidenterpriseEnterprisesGetServiceAccount_589322;
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
  var path_589336 = newJObject()
  var query_589337 = newJObject()
  add(query_589337, "keyType", newJString(keyType))
  add(query_589337, "fields", newJString(fields))
  add(query_589337, "quotaUser", newJString(quotaUser))
  add(query_589337, "alt", newJString(alt))
  add(query_589337, "oauth_token", newJString(oauthToken))
  add(query_589337, "userIp", newJString(userIp))
  add(query_589337, "key", newJString(key))
  add(path_589336, "enterpriseId", newJString(enterpriseId))
  add(query_589337, "prettyPrint", newJBool(prettyPrint))
  result = call_589335.call(path_589336, query_589337, nil, nil, nil)

var androidenterpriseEnterprisesGetServiceAccount* = Call_AndroidenterpriseEnterprisesGetServiceAccount_589322(
    name: "androidenterpriseEnterprisesGetServiceAccount",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccount",
    validator: validate_AndroidenterpriseEnterprisesGetServiceAccount_589323,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesGetServiceAccount_589324,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseServiceaccountkeysInsert_589353 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseServiceaccountkeysInsert_589355(protocol: Scheme;
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

proc validate_AndroidenterpriseServiceaccountkeysInsert_589354(path: JsonNode;
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
  var valid_589356 = path.getOrDefault("enterpriseId")
  valid_589356 = validateParameter(valid_589356, JString, required = true,
                                 default = nil)
  if valid_589356 != nil:
    section.add "enterpriseId", valid_589356
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
  var valid_589357 = query.getOrDefault("fields")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "fields", valid_589357
  var valid_589358 = query.getOrDefault("quotaUser")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "quotaUser", valid_589358
  var valid_589359 = query.getOrDefault("alt")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = newJString("json"))
  if valid_589359 != nil:
    section.add "alt", valid_589359
  var valid_589360 = query.getOrDefault("oauth_token")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "oauth_token", valid_589360
  var valid_589361 = query.getOrDefault("userIp")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "userIp", valid_589361
  var valid_589362 = query.getOrDefault("key")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "key", valid_589362
  var valid_589363 = query.getOrDefault("prettyPrint")
  valid_589363 = validateParameter(valid_589363, JBool, required = false,
                                 default = newJBool(true))
  if valid_589363 != nil:
    section.add "prettyPrint", valid_589363
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

proc call*(call_589365: Call_AndroidenterpriseServiceaccountkeysInsert_589353;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates new credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  ## Only the type of the key should be populated in the resource to be inserted.
  ## 
  let valid = call_589365.validator(path, query, header, formData, body)
  let scheme = call_589365.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589365.url(scheme.get, call_589365.host, call_589365.base,
                         call_589365.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589365, url, valid)

proc call*(call_589366: Call_AndroidenterpriseServiceaccountkeysInsert_589353;
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
  var path_589367 = newJObject()
  var query_589368 = newJObject()
  var body_589369 = newJObject()
  add(query_589368, "fields", newJString(fields))
  add(query_589368, "quotaUser", newJString(quotaUser))
  add(query_589368, "alt", newJString(alt))
  add(query_589368, "oauth_token", newJString(oauthToken))
  add(query_589368, "userIp", newJString(userIp))
  add(query_589368, "key", newJString(key))
  add(path_589367, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589369 = body
  add(query_589368, "prettyPrint", newJBool(prettyPrint))
  result = call_589366.call(path_589367, query_589368, nil, nil, body_589369)

var androidenterpriseServiceaccountkeysInsert* = Call_AndroidenterpriseServiceaccountkeysInsert_589353(
    name: "androidenterpriseServiceaccountkeysInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccountKeys",
    validator: validate_AndroidenterpriseServiceaccountkeysInsert_589354,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseServiceaccountkeysInsert_589355,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseServiceaccountkeysList_589338 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseServiceaccountkeysList_589340(protocol: Scheme;
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

proc validate_AndroidenterpriseServiceaccountkeysList_589339(path: JsonNode;
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
  var valid_589341 = path.getOrDefault("enterpriseId")
  valid_589341 = validateParameter(valid_589341, JString, required = true,
                                 default = nil)
  if valid_589341 != nil:
    section.add "enterpriseId", valid_589341
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
  var valid_589342 = query.getOrDefault("fields")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "fields", valid_589342
  var valid_589343 = query.getOrDefault("quotaUser")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "quotaUser", valid_589343
  var valid_589344 = query.getOrDefault("alt")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = newJString("json"))
  if valid_589344 != nil:
    section.add "alt", valid_589344
  var valid_589345 = query.getOrDefault("oauth_token")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "oauth_token", valid_589345
  var valid_589346 = query.getOrDefault("userIp")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "userIp", valid_589346
  var valid_589347 = query.getOrDefault("key")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "key", valid_589347
  var valid_589348 = query.getOrDefault("prettyPrint")
  valid_589348 = validateParameter(valid_589348, JBool, required = false,
                                 default = newJBool(true))
  if valid_589348 != nil:
    section.add "prettyPrint", valid_589348
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589349: Call_AndroidenterpriseServiceaccountkeysList_589338;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all active credentials for the service account associated with this enterprise. Only the ID and key type are returned. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  let valid = call_589349.validator(path, query, header, formData, body)
  let scheme = call_589349.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589349.url(scheme.get, call_589349.host, call_589349.base,
                         call_589349.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589349, url, valid)

proc call*(call_589350: Call_AndroidenterpriseServiceaccountkeysList_589338;
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
  var path_589351 = newJObject()
  var query_589352 = newJObject()
  add(query_589352, "fields", newJString(fields))
  add(query_589352, "quotaUser", newJString(quotaUser))
  add(query_589352, "alt", newJString(alt))
  add(query_589352, "oauth_token", newJString(oauthToken))
  add(query_589352, "userIp", newJString(userIp))
  add(query_589352, "key", newJString(key))
  add(path_589351, "enterpriseId", newJString(enterpriseId))
  add(query_589352, "prettyPrint", newJBool(prettyPrint))
  result = call_589350.call(path_589351, query_589352, nil, nil, nil)

var androidenterpriseServiceaccountkeysList* = Call_AndroidenterpriseServiceaccountkeysList_589338(
    name: "androidenterpriseServiceaccountkeysList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccountKeys",
    validator: validate_AndroidenterpriseServiceaccountkeysList_589339,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseServiceaccountkeysList_589340,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseServiceaccountkeysDelete_589370 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseServiceaccountkeysDelete_589372(protocol: Scheme;
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

proc validate_AndroidenterpriseServiceaccountkeysDelete_589371(path: JsonNode;
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
  var valid_589373 = path.getOrDefault("keyId")
  valid_589373 = validateParameter(valid_589373, JString, required = true,
                                 default = nil)
  if valid_589373 != nil:
    section.add "keyId", valid_589373
  var valid_589374 = path.getOrDefault("enterpriseId")
  valid_589374 = validateParameter(valid_589374, JString, required = true,
                                 default = nil)
  if valid_589374 != nil:
    section.add "enterpriseId", valid_589374
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
  var valid_589375 = query.getOrDefault("fields")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "fields", valid_589375
  var valid_589376 = query.getOrDefault("quotaUser")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "quotaUser", valid_589376
  var valid_589377 = query.getOrDefault("alt")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = newJString("json"))
  if valid_589377 != nil:
    section.add "alt", valid_589377
  var valid_589378 = query.getOrDefault("oauth_token")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "oauth_token", valid_589378
  var valid_589379 = query.getOrDefault("userIp")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "userIp", valid_589379
  var valid_589380 = query.getOrDefault("key")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "key", valid_589380
  var valid_589381 = query.getOrDefault("prettyPrint")
  valid_589381 = validateParameter(valid_589381, JBool, required = false,
                                 default = newJBool(true))
  if valid_589381 != nil:
    section.add "prettyPrint", valid_589381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589382: Call_AndroidenterpriseServiceaccountkeysDelete_589370;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes and invalidates the specified credentials for the service account associated with this enterprise. The calling service account must have been retrieved by calling Enterprises.GetServiceAccount and must have been set as the enterprise service account by calling Enterprises.SetAccount.
  ## 
  let valid = call_589382.validator(path, query, header, formData, body)
  let scheme = call_589382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589382.url(scheme.get, call_589382.host, call_589382.base,
                         call_589382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589382, url, valid)

proc call*(call_589383: Call_AndroidenterpriseServiceaccountkeysDelete_589370;
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
  var path_589384 = newJObject()
  var query_589385 = newJObject()
  add(path_589384, "keyId", newJString(keyId))
  add(query_589385, "fields", newJString(fields))
  add(query_589385, "quotaUser", newJString(quotaUser))
  add(query_589385, "alt", newJString(alt))
  add(query_589385, "oauth_token", newJString(oauthToken))
  add(query_589385, "userIp", newJString(userIp))
  add(query_589385, "key", newJString(key))
  add(path_589384, "enterpriseId", newJString(enterpriseId))
  add(query_589385, "prettyPrint", newJBool(prettyPrint))
  result = call_589383.call(path_589384, query_589385, nil, nil, nil)

var androidenterpriseServiceaccountkeysDelete* = Call_AndroidenterpriseServiceaccountkeysDelete_589370(
    name: "androidenterpriseServiceaccountkeysDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/serviceAccountKeys/{keyId}",
    validator: validate_AndroidenterpriseServiceaccountkeysDelete_589371,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseServiceaccountkeysDelete_589372,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesSetStoreLayout_589401 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesSetStoreLayout_589403(protocol: Scheme;
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

proc validate_AndroidenterpriseEnterprisesSetStoreLayout_589402(path: JsonNode;
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
  var valid_589404 = path.getOrDefault("enterpriseId")
  valid_589404 = validateParameter(valid_589404, JString, required = true,
                                 default = nil)
  if valid_589404 != nil:
    section.add "enterpriseId", valid_589404
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
  var valid_589405 = query.getOrDefault("fields")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "fields", valid_589405
  var valid_589406 = query.getOrDefault("quotaUser")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "quotaUser", valid_589406
  var valid_589407 = query.getOrDefault("alt")
  valid_589407 = validateParameter(valid_589407, JString, required = false,
                                 default = newJString("json"))
  if valid_589407 != nil:
    section.add "alt", valid_589407
  var valid_589408 = query.getOrDefault("oauth_token")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "oauth_token", valid_589408
  var valid_589409 = query.getOrDefault("userIp")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "userIp", valid_589409
  var valid_589410 = query.getOrDefault("key")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "key", valid_589410
  var valid_589411 = query.getOrDefault("prettyPrint")
  valid_589411 = validateParameter(valid_589411, JBool, required = false,
                                 default = newJBool(true))
  if valid_589411 != nil:
    section.add "prettyPrint", valid_589411
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

proc call*(call_589413: Call_AndroidenterpriseEnterprisesSetStoreLayout_589401;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the store layout for the enterprise. By default, storeLayoutType is set to "basic" and the basic store layout is enabled. The basic layout only contains apps approved by the admin, and that have been added to the available product set for a user (using the  setAvailableProductSet call). Apps on the page are sorted in order of their product ID value. If you create a custom store layout (by setting storeLayoutType = "custom" and setting a homepage), the basic store layout is disabled.
  ## 
  let valid = call_589413.validator(path, query, header, formData, body)
  let scheme = call_589413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589413.url(scheme.get, call_589413.host, call_589413.base,
                         call_589413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589413, url, valid)

proc call*(call_589414: Call_AndroidenterpriseEnterprisesSetStoreLayout_589401;
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
  var path_589415 = newJObject()
  var query_589416 = newJObject()
  var body_589417 = newJObject()
  add(query_589416, "fields", newJString(fields))
  add(query_589416, "quotaUser", newJString(quotaUser))
  add(query_589416, "alt", newJString(alt))
  add(query_589416, "oauth_token", newJString(oauthToken))
  add(query_589416, "userIp", newJString(userIp))
  add(query_589416, "key", newJString(key))
  add(path_589415, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589417 = body
  add(query_589416, "prettyPrint", newJBool(prettyPrint))
  result = call_589414.call(path_589415, query_589416, nil, nil, body_589417)

var androidenterpriseEnterprisesSetStoreLayout* = Call_AndroidenterpriseEnterprisesSetStoreLayout_589401(
    name: "androidenterpriseEnterprisesSetStoreLayout", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout",
    validator: validate_AndroidenterpriseEnterprisesSetStoreLayout_589402,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesSetStoreLayout_589403,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesGetStoreLayout_589386 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesGetStoreLayout_589388(protocol: Scheme;
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

proc validate_AndroidenterpriseEnterprisesGetStoreLayout_589387(path: JsonNode;
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
  var valid_589389 = path.getOrDefault("enterpriseId")
  valid_589389 = validateParameter(valid_589389, JString, required = true,
                                 default = nil)
  if valid_589389 != nil:
    section.add "enterpriseId", valid_589389
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
  var valid_589390 = query.getOrDefault("fields")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "fields", valid_589390
  var valid_589391 = query.getOrDefault("quotaUser")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "quotaUser", valid_589391
  var valid_589392 = query.getOrDefault("alt")
  valid_589392 = validateParameter(valid_589392, JString, required = false,
                                 default = newJString("json"))
  if valid_589392 != nil:
    section.add "alt", valid_589392
  var valid_589393 = query.getOrDefault("oauth_token")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "oauth_token", valid_589393
  var valid_589394 = query.getOrDefault("userIp")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "userIp", valid_589394
  var valid_589395 = query.getOrDefault("key")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "key", valid_589395
  var valid_589396 = query.getOrDefault("prettyPrint")
  valid_589396 = validateParameter(valid_589396, JBool, required = false,
                                 default = newJBool(true))
  if valid_589396 != nil:
    section.add "prettyPrint", valid_589396
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589397: Call_AndroidenterpriseEnterprisesGetStoreLayout_589386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the store layout for the enterprise. If the store layout has not been set, returns "basic" as the store layout type and no homepage.
  ## 
  let valid = call_589397.validator(path, query, header, formData, body)
  let scheme = call_589397.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589397.url(scheme.get, call_589397.host, call_589397.base,
                         call_589397.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589397, url, valid)

proc call*(call_589398: Call_AndroidenterpriseEnterprisesGetStoreLayout_589386;
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
  var path_589399 = newJObject()
  var query_589400 = newJObject()
  add(query_589400, "fields", newJString(fields))
  add(query_589400, "quotaUser", newJString(quotaUser))
  add(query_589400, "alt", newJString(alt))
  add(query_589400, "oauth_token", newJString(oauthToken))
  add(query_589400, "userIp", newJString(userIp))
  add(query_589400, "key", newJString(key))
  add(path_589399, "enterpriseId", newJString(enterpriseId))
  add(query_589400, "prettyPrint", newJBool(prettyPrint))
  result = call_589398.call(path_589399, query_589400, nil, nil, nil)

var androidenterpriseEnterprisesGetStoreLayout* = Call_AndroidenterpriseEnterprisesGetStoreLayout_589386(
    name: "androidenterpriseEnterprisesGetStoreLayout", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout",
    validator: validate_AndroidenterpriseEnterprisesGetStoreLayout_589387,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseEnterprisesGetStoreLayout_589388,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesInsert_589433 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseStorelayoutpagesInsert_589435(protocol: Scheme;
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

proc validate_AndroidenterpriseStorelayoutpagesInsert_589434(path: JsonNode;
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
  var valid_589436 = path.getOrDefault("enterpriseId")
  valid_589436 = validateParameter(valid_589436, JString, required = true,
                                 default = nil)
  if valid_589436 != nil:
    section.add "enterpriseId", valid_589436
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
  var valid_589437 = query.getOrDefault("fields")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "fields", valid_589437
  var valid_589438 = query.getOrDefault("quotaUser")
  valid_589438 = validateParameter(valid_589438, JString, required = false,
                                 default = nil)
  if valid_589438 != nil:
    section.add "quotaUser", valid_589438
  var valid_589439 = query.getOrDefault("alt")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = newJString("json"))
  if valid_589439 != nil:
    section.add "alt", valid_589439
  var valid_589440 = query.getOrDefault("oauth_token")
  valid_589440 = validateParameter(valid_589440, JString, required = false,
                                 default = nil)
  if valid_589440 != nil:
    section.add "oauth_token", valid_589440
  var valid_589441 = query.getOrDefault("userIp")
  valid_589441 = validateParameter(valid_589441, JString, required = false,
                                 default = nil)
  if valid_589441 != nil:
    section.add "userIp", valid_589441
  var valid_589442 = query.getOrDefault("key")
  valid_589442 = validateParameter(valid_589442, JString, required = false,
                                 default = nil)
  if valid_589442 != nil:
    section.add "key", valid_589442
  var valid_589443 = query.getOrDefault("prettyPrint")
  valid_589443 = validateParameter(valid_589443, JBool, required = false,
                                 default = newJBool(true))
  if valid_589443 != nil:
    section.add "prettyPrint", valid_589443
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

proc call*(call_589445: Call_AndroidenterpriseStorelayoutpagesInsert_589433;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new store page.
  ## 
  let valid = call_589445.validator(path, query, header, formData, body)
  let scheme = call_589445.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589445.url(scheme.get, call_589445.host, call_589445.base,
                         call_589445.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589445, url, valid)

proc call*(call_589446: Call_AndroidenterpriseStorelayoutpagesInsert_589433;
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
  var path_589447 = newJObject()
  var query_589448 = newJObject()
  var body_589449 = newJObject()
  add(query_589448, "fields", newJString(fields))
  add(query_589448, "quotaUser", newJString(quotaUser))
  add(query_589448, "alt", newJString(alt))
  add(query_589448, "oauth_token", newJString(oauthToken))
  add(query_589448, "userIp", newJString(userIp))
  add(query_589448, "key", newJString(key))
  add(path_589447, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589449 = body
  add(query_589448, "prettyPrint", newJBool(prettyPrint))
  result = call_589446.call(path_589447, query_589448, nil, nil, body_589449)

var androidenterpriseStorelayoutpagesInsert* = Call_AndroidenterpriseStorelayoutpagesInsert_589433(
    name: "androidenterpriseStorelayoutpagesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages",
    validator: validate_AndroidenterpriseStorelayoutpagesInsert_589434,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesInsert_589435,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesList_589418 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseStorelayoutpagesList_589420(protocol: Scheme;
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

proc validate_AndroidenterpriseStorelayoutpagesList_589419(path: JsonNode;
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
  var valid_589421 = path.getOrDefault("enterpriseId")
  valid_589421 = validateParameter(valid_589421, JString, required = true,
                                 default = nil)
  if valid_589421 != nil:
    section.add "enterpriseId", valid_589421
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
  var valid_589422 = query.getOrDefault("fields")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "fields", valid_589422
  var valid_589423 = query.getOrDefault("quotaUser")
  valid_589423 = validateParameter(valid_589423, JString, required = false,
                                 default = nil)
  if valid_589423 != nil:
    section.add "quotaUser", valid_589423
  var valid_589424 = query.getOrDefault("alt")
  valid_589424 = validateParameter(valid_589424, JString, required = false,
                                 default = newJString("json"))
  if valid_589424 != nil:
    section.add "alt", valid_589424
  var valid_589425 = query.getOrDefault("oauth_token")
  valid_589425 = validateParameter(valid_589425, JString, required = false,
                                 default = nil)
  if valid_589425 != nil:
    section.add "oauth_token", valid_589425
  var valid_589426 = query.getOrDefault("userIp")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "userIp", valid_589426
  var valid_589427 = query.getOrDefault("key")
  valid_589427 = validateParameter(valid_589427, JString, required = false,
                                 default = nil)
  if valid_589427 != nil:
    section.add "key", valid_589427
  var valid_589428 = query.getOrDefault("prettyPrint")
  valid_589428 = validateParameter(valid_589428, JBool, required = false,
                                 default = newJBool(true))
  if valid_589428 != nil:
    section.add "prettyPrint", valid_589428
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589429: Call_AndroidenterpriseStorelayoutpagesList_589418;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all pages in the store.
  ## 
  let valid = call_589429.validator(path, query, header, formData, body)
  let scheme = call_589429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589429.url(scheme.get, call_589429.host, call_589429.base,
                         call_589429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589429, url, valid)

proc call*(call_589430: Call_AndroidenterpriseStorelayoutpagesList_589418;
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
  var path_589431 = newJObject()
  var query_589432 = newJObject()
  add(query_589432, "fields", newJString(fields))
  add(query_589432, "quotaUser", newJString(quotaUser))
  add(query_589432, "alt", newJString(alt))
  add(query_589432, "oauth_token", newJString(oauthToken))
  add(query_589432, "userIp", newJString(userIp))
  add(query_589432, "key", newJString(key))
  add(path_589431, "enterpriseId", newJString(enterpriseId))
  add(query_589432, "prettyPrint", newJBool(prettyPrint))
  result = call_589430.call(path_589431, query_589432, nil, nil, nil)

var androidenterpriseStorelayoutpagesList* = Call_AndroidenterpriseStorelayoutpagesList_589418(
    name: "androidenterpriseStorelayoutpagesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages",
    validator: validate_AndroidenterpriseStorelayoutpagesList_589419,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseStorelayoutpagesList_589420,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesUpdate_589466 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseStorelayoutpagesUpdate_589468(protocol: Scheme;
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

proc validate_AndroidenterpriseStorelayoutpagesUpdate_589467(path: JsonNode;
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
  var valid_589469 = path.getOrDefault("enterpriseId")
  valid_589469 = validateParameter(valid_589469, JString, required = true,
                                 default = nil)
  if valid_589469 != nil:
    section.add "enterpriseId", valid_589469
  var valid_589470 = path.getOrDefault("pageId")
  valid_589470 = validateParameter(valid_589470, JString, required = true,
                                 default = nil)
  if valid_589470 != nil:
    section.add "pageId", valid_589470
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
  var valid_589471 = query.getOrDefault("fields")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "fields", valid_589471
  var valid_589472 = query.getOrDefault("quotaUser")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "quotaUser", valid_589472
  var valid_589473 = query.getOrDefault("alt")
  valid_589473 = validateParameter(valid_589473, JString, required = false,
                                 default = newJString("json"))
  if valid_589473 != nil:
    section.add "alt", valid_589473
  var valid_589474 = query.getOrDefault("oauth_token")
  valid_589474 = validateParameter(valid_589474, JString, required = false,
                                 default = nil)
  if valid_589474 != nil:
    section.add "oauth_token", valid_589474
  var valid_589475 = query.getOrDefault("userIp")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "userIp", valid_589475
  var valid_589476 = query.getOrDefault("key")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "key", valid_589476
  var valid_589477 = query.getOrDefault("prettyPrint")
  valid_589477 = validateParameter(valid_589477, JBool, required = false,
                                 default = newJBool(true))
  if valid_589477 != nil:
    section.add "prettyPrint", valid_589477
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

proc call*(call_589479: Call_AndroidenterpriseStorelayoutpagesUpdate_589466;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the content of a store page.
  ## 
  let valid = call_589479.validator(path, query, header, formData, body)
  let scheme = call_589479.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589479.url(scheme.get, call_589479.host, call_589479.base,
                         call_589479.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589479, url, valid)

proc call*(call_589480: Call_AndroidenterpriseStorelayoutpagesUpdate_589466;
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
  var path_589481 = newJObject()
  var query_589482 = newJObject()
  var body_589483 = newJObject()
  add(query_589482, "fields", newJString(fields))
  add(query_589482, "quotaUser", newJString(quotaUser))
  add(query_589482, "alt", newJString(alt))
  add(query_589482, "oauth_token", newJString(oauthToken))
  add(query_589482, "userIp", newJString(userIp))
  add(query_589482, "key", newJString(key))
  add(path_589481, "enterpriseId", newJString(enterpriseId))
  add(path_589481, "pageId", newJString(pageId))
  if body != nil:
    body_589483 = body
  add(query_589482, "prettyPrint", newJBool(prettyPrint))
  result = call_589480.call(path_589481, query_589482, nil, nil, body_589483)

var androidenterpriseStorelayoutpagesUpdate* = Call_AndroidenterpriseStorelayoutpagesUpdate_589466(
    name: "androidenterpriseStorelayoutpagesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesUpdate_589467,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesUpdate_589468,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesGet_589450 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseStorelayoutpagesGet_589452(protocol: Scheme;
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

proc validate_AndroidenterpriseStorelayoutpagesGet_589451(path: JsonNode;
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
  var valid_589453 = path.getOrDefault("enterpriseId")
  valid_589453 = validateParameter(valid_589453, JString, required = true,
                                 default = nil)
  if valid_589453 != nil:
    section.add "enterpriseId", valid_589453
  var valid_589454 = path.getOrDefault("pageId")
  valid_589454 = validateParameter(valid_589454, JString, required = true,
                                 default = nil)
  if valid_589454 != nil:
    section.add "pageId", valid_589454
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
  var valid_589455 = query.getOrDefault("fields")
  valid_589455 = validateParameter(valid_589455, JString, required = false,
                                 default = nil)
  if valid_589455 != nil:
    section.add "fields", valid_589455
  var valid_589456 = query.getOrDefault("quotaUser")
  valid_589456 = validateParameter(valid_589456, JString, required = false,
                                 default = nil)
  if valid_589456 != nil:
    section.add "quotaUser", valid_589456
  var valid_589457 = query.getOrDefault("alt")
  valid_589457 = validateParameter(valid_589457, JString, required = false,
                                 default = newJString("json"))
  if valid_589457 != nil:
    section.add "alt", valid_589457
  var valid_589458 = query.getOrDefault("oauth_token")
  valid_589458 = validateParameter(valid_589458, JString, required = false,
                                 default = nil)
  if valid_589458 != nil:
    section.add "oauth_token", valid_589458
  var valid_589459 = query.getOrDefault("userIp")
  valid_589459 = validateParameter(valid_589459, JString, required = false,
                                 default = nil)
  if valid_589459 != nil:
    section.add "userIp", valid_589459
  var valid_589460 = query.getOrDefault("key")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "key", valid_589460
  var valid_589461 = query.getOrDefault("prettyPrint")
  valid_589461 = validateParameter(valid_589461, JBool, required = false,
                                 default = newJBool(true))
  if valid_589461 != nil:
    section.add "prettyPrint", valid_589461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589462: Call_AndroidenterpriseStorelayoutpagesGet_589450;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a store page.
  ## 
  let valid = call_589462.validator(path, query, header, formData, body)
  let scheme = call_589462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589462.url(scheme.get, call_589462.host, call_589462.base,
                         call_589462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589462, url, valid)

proc call*(call_589463: Call_AndroidenterpriseStorelayoutpagesGet_589450;
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
  var path_589464 = newJObject()
  var query_589465 = newJObject()
  add(query_589465, "fields", newJString(fields))
  add(query_589465, "quotaUser", newJString(quotaUser))
  add(query_589465, "alt", newJString(alt))
  add(query_589465, "oauth_token", newJString(oauthToken))
  add(query_589465, "userIp", newJString(userIp))
  add(query_589465, "key", newJString(key))
  add(path_589464, "enterpriseId", newJString(enterpriseId))
  add(path_589464, "pageId", newJString(pageId))
  add(query_589465, "prettyPrint", newJBool(prettyPrint))
  result = call_589463.call(path_589464, query_589465, nil, nil, nil)

var androidenterpriseStorelayoutpagesGet* = Call_AndroidenterpriseStorelayoutpagesGet_589450(
    name: "androidenterpriseStorelayoutpagesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesGet_589451,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseStorelayoutpagesGet_589452,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesPatch_589500 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseStorelayoutpagesPatch_589502(protocol: Scheme;
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

proc validate_AndroidenterpriseStorelayoutpagesPatch_589501(path: JsonNode;
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
  var valid_589503 = path.getOrDefault("enterpriseId")
  valid_589503 = validateParameter(valid_589503, JString, required = true,
                                 default = nil)
  if valid_589503 != nil:
    section.add "enterpriseId", valid_589503
  var valid_589504 = path.getOrDefault("pageId")
  valid_589504 = validateParameter(valid_589504, JString, required = true,
                                 default = nil)
  if valid_589504 != nil:
    section.add "pageId", valid_589504
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
  var valid_589505 = query.getOrDefault("fields")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "fields", valid_589505
  var valid_589506 = query.getOrDefault("quotaUser")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = nil)
  if valid_589506 != nil:
    section.add "quotaUser", valid_589506
  var valid_589507 = query.getOrDefault("alt")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = newJString("json"))
  if valid_589507 != nil:
    section.add "alt", valid_589507
  var valid_589508 = query.getOrDefault("oauth_token")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = nil)
  if valid_589508 != nil:
    section.add "oauth_token", valid_589508
  var valid_589509 = query.getOrDefault("userIp")
  valid_589509 = validateParameter(valid_589509, JString, required = false,
                                 default = nil)
  if valid_589509 != nil:
    section.add "userIp", valid_589509
  var valid_589510 = query.getOrDefault("key")
  valid_589510 = validateParameter(valid_589510, JString, required = false,
                                 default = nil)
  if valid_589510 != nil:
    section.add "key", valid_589510
  var valid_589511 = query.getOrDefault("prettyPrint")
  valid_589511 = validateParameter(valid_589511, JBool, required = false,
                                 default = newJBool(true))
  if valid_589511 != nil:
    section.add "prettyPrint", valid_589511
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

proc call*(call_589513: Call_AndroidenterpriseStorelayoutpagesPatch_589500;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the content of a store page. This method supports patch semantics.
  ## 
  let valid = call_589513.validator(path, query, header, formData, body)
  let scheme = call_589513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589513.url(scheme.get, call_589513.host, call_589513.base,
                         call_589513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589513, url, valid)

proc call*(call_589514: Call_AndroidenterpriseStorelayoutpagesPatch_589500;
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
  var path_589515 = newJObject()
  var query_589516 = newJObject()
  var body_589517 = newJObject()
  add(query_589516, "fields", newJString(fields))
  add(query_589516, "quotaUser", newJString(quotaUser))
  add(query_589516, "alt", newJString(alt))
  add(query_589516, "oauth_token", newJString(oauthToken))
  add(query_589516, "userIp", newJString(userIp))
  add(query_589516, "key", newJString(key))
  add(path_589515, "enterpriseId", newJString(enterpriseId))
  add(path_589515, "pageId", newJString(pageId))
  if body != nil:
    body_589517 = body
  add(query_589516, "prettyPrint", newJBool(prettyPrint))
  result = call_589514.call(path_589515, query_589516, nil, nil, body_589517)

var androidenterpriseStorelayoutpagesPatch* = Call_AndroidenterpriseStorelayoutpagesPatch_589500(
    name: "androidenterpriseStorelayoutpagesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesPatch_589501,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesPatch_589502,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutpagesDelete_589484 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseStorelayoutpagesDelete_589486(protocol: Scheme;
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

proc validate_AndroidenterpriseStorelayoutpagesDelete_589485(path: JsonNode;
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
  var valid_589487 = path.getOrDefault("enterpriseId")
  valid_589487 = validateParameter(valid_589487, JString, required = true,
                                 default = nil)
  if valid_589487 != nil:
    section.add "enterpriseId", valid_589487
  var valid_589488 = path.getOrDefault("pageId")
  valid_589488 = validateParameter(valid_589488, JString, required = true,
                                 default = nil)
  if valid_589488 != nil:
    section.add "pageId", valid_589488
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
  var valid_589489 = query.getOrDefault("fields")
  valid_589489 = validateParameter(valid_589489, JString, required = false,
                                 default = nil)
  if valid_589489 != nil:
    section.add "fields", valid_589489
  var valid_589490 = query.getOrDefault("quotaUser")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = nil)
  if valid_589490 != nil:
    section.add "quotaUser", valid_589490
  var valid_589491 = query.getOrDefault("alt")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = newJString("json"))
  if valid_589491 != nil:
    section.add "alt", valid_589491
  var valid_589492 = query.getOrDefault("oauth_token")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = nil)
  if valid_589492 != nil:
    section.add "oauth_token", valid_589492
  var valid_589493 = query.getOrDefault("userIp")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = nil)
  if valid_589493 != nil:
    section.add "userIp", valid_589493
  var valid_589494 = query.getOrDefault("key")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "key", valid_589494
  var valid_589495 = query.getOrDefault("prettyPrint")
  valid_589495 = validateParameter(valid_589495, JBool, required = false,
                                 default = newJBool(true))
  if valid_589495 != nil:
    section.add "prettyPrint", valid_589495
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589496: Call_AndroidenterpriseStorelayoutpagesDelete_589484;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a store page.
  ## 
  let valid = call_589496.validator(path, query, header, formData, body)
  let scheme = call_589496.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589496.url(scheme.get, call_589496.host, call_589496.base,
                         call_589496.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589496, url, valid)

proc call*(call_589497: Call_AndroidenterpriseStorelayoutpagesDelete_589484;
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
  var path_589498 = newJObject()
  var query_589499 = newJObject()
  add(query_589499, "fields", newJString(fields))
  add(query_589499, "quotaUser", newJString(quotaUser))
  add(query_589499, "alt", newJString(alt))
  add(query_589499, "oauth_token", newJString(oauthToken))
  add(query_589499, "userIp", newJString(userIp))
  add(query_589499, "key", newJString(key))
  add(path_589498, "enterpriseId", newJString(enterpriseId))
  add(path_589498, "pageId", newJString(pageId))
  add(query_589499, "prettyPrint", newJBool(prettyPrint))
  result = call_589497.call(path_589498, query_589499, nil, nil, nil)

var androidenterpriseStorelayoutpagesDelete* = Call_AndroidenterpriseStorelayoutpagesDelete_589484(
    name: "androidenterpriseStorelayoutpagesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}",
    validator: validate_AndroidenterpriseStorelayoutpagesDelete_589485,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutpagesDelete_589486,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersInsert_589534 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseStorelayoutclustersInsert_589536(protocol: Scheme;
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

proc validate_AndroidenterpriseStorelayoutclustersInsert_589535(path: JsonNode;
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
  var valid_589537 = path.getOrDefault("enterpriseId")
  valid_589537 = validateParameter(valid_589537, JString, required = true,
                                 default = nil)
  if valid_589537 != nil:
    section.add "enterpriseId", valid_589537
  var valid_589538 = path.getOrDefault("pageId")
  valid_589538 = validateParameter(valid_589538, JString, required = true,
                                 default = nil)
  if valid_589538 != nil:
    section.add "pageId", valid_589538
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
  var valid_589539 = query.getOrDefault("fields")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "fields", valid_589539
  var valid_589540 = query.getOrDefault("quotaUser")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "quotaUser", valid_589540
  var valid_589541 = query.getOrDefault("alt")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = newJString("json"))
  if valid_589541 != nil:
    section.add "alt", valid_589541
  var valid_589542 = query.getOrDefault("oauth_token")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = nil)
  if valid_589542 != nil:
    section.add "oauth_token", valid_589542
  var valid_589543 = query.getOrDefault("userIp")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "userIp", valid_589543
  var valid_589544 = query.getOrDefault("key")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "key", valid_589544
  var valid_589545 = query.getOrDefault("prettyPrint")
  valid_589545 = validateParameter(valid_589545, JBool, required = false,
                                 default = newJBool(true))
  if valid_589545 != nil:
    section.add "prettyPrint", valid_589545
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

proc call*(call_589547: Call_AndroidenterpriseStorelayoutclustersInsert_589534;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a new cluster in a page.
  ## 
  let valid = call_589547.validator(path, query, header, formData, body)
  let scheme = call_589547.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589547.url(scheme.get, call_589547.host, call_589547.base,
                         call_589547.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589547, url, valid)

proc call*(call_589548: Call_AndroidenterpriseStorelayoutclustersInsert_589534;
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
  var path_589549 = newJObject()
  var query_589550 = newJObject()
  var body_589551 = newJObject()
  add(query_589550, "fields", newJString(fields))
  add(query_589550, "quotaUser", newJString(quotaUser))
  add(query_589550, "alt", newJString(alt))
  add(query_589550, "oauth_token", newJString(oauthToken))
  add(query_589550, "userIp", newJString(userIp))
  add(query_589550, "key", newJString(key))
  add(path_589549, "enterpriseId", newJString(enterpriseId))
  add(path_589549, "pageId", newJString(pageId))
  if body != nil:
    body_589551 = body
  add(query_589550, "prettyPrint", newJBool(prettyPrint))
  result = call_589548.call(path_589549, query_589550, nil, nil, body_589551)

var androidenterpriseStorelayoutclustersInsert* = Call_AndroidenterpriseStorelayoutclustersInsert_589534(
    name: "androidenterpriseStorelayoutclustersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters",
    validator: validate_AndroidenterpriseStorelayoutclustersInsert_589535,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersInsert_589536,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersList_589518 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseStorelayoutclustersList_589520(protocol: Scheme;
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

proc validate_AndroidenterpriseStorelayoutclustersList_589519(path: JsonNode;
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
  var valid_589521 = path.getOrDefault("enterpriseId")
  valid_589521 = validateParameter(valid_589521, JString, required = true,
                                 default = nil)
  if valid_589521 != nil:
    section.add "enterpriseId", valid_589521
  var valid_589522 = path.getOrDefault("pageId")
  valid_589522 = validateParameter(valid_589522, JString, required = true,
                                 default = nil)
  if valid_589522 != nil:
    section.add "pageId", valid_589522
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
  var valid_589523 = query.getOrDefault("fields")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "fields", valid_589523
  var valid_589524 = query.getOrDefault("quotaUser")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "quotaUser", valid_589524
  var valid_589525 = query.getOrDefault("alt")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = newJString("json"))
  if valid_589525 != nil:
    section.add "alt", valid_589525
  var valid_589526 = query.getOrDefault("oauth_token")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "oauth_token", valid_589526
  var valid_589527 = query.getOrDefault("userIp")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "userIp", valid_589527
  var valid_589528 = query.getOrDefault("key")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = nil)
  if valid_589528 != nil:
    section.add "key", valid_589528
  var valid_589529 = query.getOrDefault("prettyPrint")
  valid_589529 = validateParameter(valid_589529, JBool, required = false,
                                 default = newJBool(true))
  if valid_589529 != nil:
    section.add "prettyPrint", valid_589529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589530: Call_AndroidenterpriseStorelayoutclustersList_589518;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the details of all clusters on the specified page.
  ## 
  let valid = call_589530.validator(path, query, header, formData, body)
  let scheme = call_589530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589530.url(scheme.get, call_589530.host, call_589530.base,
                         call_589530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589530, url, valid)

proc call*(call_589531: Call_AndroidenterpriseStorelayoutclustersList_589518;
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
  var path_589532 = newJObject()
  var query_589533 = newJObject()
  add(query_589533, "fields", newJString(fields))
  add(query_589533, "quotaUser", newJString(quotaUser))
  add(query_589533, "alt", newJString(alt))
  add(query_589533, "oauth_token", newJString(oauthToken))
  add(query_589533, "userIp", newJString(userIp))
  add(query_589533, "key", newJString(key))
  add(path_589532, "enterpriseId", newJString(enterpriseId))
  add(path_589532, "pageId", newJString(pageId))
  add(query_589533, "prettyPrint", newJBool(prettyPrint))
  result = call_589531.call(path_589532, query_589533, nil, nil, nil)

var androidenterpriseStorelayoutclustersList* = Call_AndroidenterpriseStorelayoutclustersList_589518(
    name: "androidenterpriseStorelayoutclustersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters",
    validator: validate_AndroidenterpriseStorelayoutclustersList_589519,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersList_589520,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersUpdate_589569 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseStorelayoutclustersUpdate_589571(protocol: Scheme;
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

proc validate_AndroidenterpriseStorelayoutclustersUpdate_589570(path: JsonNode;
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
  var valid_589572 = path.getOrDefault("enterpriseId")
  valid_589572 = validateParameter(valid_589572, JString, required = true,
                                 default = nil)
  if valid_589572 != nil:
    section.add "enterpriseId", valid_589572
  var valid_589573 = path.getOrDefault("pageId")
  valid_589573 = validateParameter(valid_589573, JString, required = true,
                                 default = nil)
  if valid_589573 != nil:
    section.add "pageId", valid_589573
  var valid_589574 = path.getOrDefault("clusterId")
  valid_589574 = validateParameter(valid_589574, JString, required = true,
                                 default = nil)
  if valid_589574 != nil:
    section.add "clusterId", valid_589574
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
  var valid_589575 = query.getOrDefault("fields")
  valid_589575 = validateParameter(valid_589575, JString, required = false,
                                 default = nil)
  if valid_589575 != nil:
    section.add "fields", valid_589575
  var valid_589576 = query.getOrDefault("quotaUser")
  valid_589576 = validateParameter(valid_589576, JString, required = false,
                                 default = nil)
  if valid_589576 != nil:
    section.add "quotaUser", valid_589576
  var valid_589577 = query.getOrDefault("alt")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = newJString("json"))
  if valid_589577 != nil:
    section.add "alt", valid_589577
  var valid_589578 = query.getOrDefault("oauth_token")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "oauth_token", valid_589578
  var valid_589579 = query.getOrDefault("userIp")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = nil)
  if valid_589579 != nil:
    section.add "userIp", valid_589579
  var valid_589580 = query.getOrDefault("key")
  valid_589580 = validateParameter(valid_589580, JString, required = false,
                                 default = nil)
  if valid_589580 != nil:
    section.add "key", valid_589580
  var valid_589581 = query.getOrDefault("prettyPrint")
  valid_589581 = validateParameter(valid_589581, JBool, required = false,
                                 default = newJBool(true))
  if valid_589581 != nil:
    section.add "prettyPrint", valid_589581
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

proc call*(call_589583: Call_AndroidenterpriseStorelayoutclustersUpdate_589569;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster.
  ## 
  let valid = call_589583.validator(path, query, header, formData, body)
  let scheme = call_589583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589583.url(scheme.get, call_589583.host, call_589583.base,
                         call_589583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589583, url, valid)

proc call*(call_589584: Call_AndroidenterpriseStorelayoutclustersUpdate_589569;
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
  var path_589585 = newJObject()
  var query_589586 = newJObject()
  var body_589587 = newJObject()
  add(query_589586, "fields", newJString(fields))
  add(query_589586, "quotaUser", newJString(quotaUser))
  add(query_589586, "alt", newJString(alt))
  add(query_589586, "oauth_token", newJString(oauthToken))
  add(query_589586, "userIp", newJString(userIp))
  add(query_589586, "key", newJString(key))
  add(path_589585, "enterpriseId", newJString(enterpriseId))
  add(path_589585, "pageId", newJString(pageId))
  if body != nil:
    body_589587 = body
  add(query_589586, "prettyPrint", newJBool(prettyPrint))
  add(path_589585, "clusterId", newJString(clusterId))
  result = call_589584.call(path_589585, query_589586, nil, nil, body_589587)

var androidenterpriseStorelayoutclustersUpdate* = Call_AndroidenterpriseStorelayoutclustersUpdate_589569(
    name: "androidenterpriseStorelayoutclustersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersUpdate_589570,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersUpdate_589571,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersGet_589552 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseStorelayoutclustersGet_589554(protocol: Scheme;
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

proc validate_AndroidenterpriseStorelayoutclustersGet_589553(path: JsonNode;
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
  var valid_589555 = path.getOrDefault("enterpriseId")
  valid_589555 = validateParameter(valid_589555, JString, required = true,
                                 default = nil)
  if valid_589555 != nil:
    section.add "enterpriseId", valid_589555
  var valid_589556 = path.getOrDefault("pageId")
  valid_589556 = validateParameter(valid_589556, JString, required = true,
                                 default = nil)
  if valid_589556 != nil:
    section.add "pageId", valid_589556
  var valid_589557 = path.getOrDefault("clusterId")
  valid_589557 = validateParameter(valid_589557, JString, required = true,
                                 default = nil)
  if valid_589557 != nil:
    section.add "clusterId", valid_589557
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
  var valid_589558 = query.getOrDefault("fields")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "fields", valid_589558
  var valid_589559 = query.getOrDefault("quotaUser")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "quotaUser", valid_589559
  var valid_589560 = query.getOrDefault("alt")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = newJString("json"))
  if valid_589560 != nil:
    section.add "alt", valid_589560
  var valid_589561 = query.getOrDefault("oauth_token")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "oauth_token", valid_589561
  var valid_589562 = query.getOrDefault("userIp")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "userIp", valid_589562
  var valid_589563 = query.getOrDefault("key")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "key", valid_589563
  var valid_589564 = query.getOrDefault("prettyPrint")
  valid_589564 = validateParameter(valid_589564, JBool, required = false,
                                 default = newJBool(true))
  if valid_589564 != nil:
    section.add "prettyPrint", valid_589564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589565: Call_AndroidenterpriseStorelayoutclustersGet_589552;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a cluster.
  ## 
  let valid = call_589565.validator(path, query, header, formData, body)
  let scheme = call_589565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589565.url(scheme.get, call_589565.host, call_589565.base,
                         call_589565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589565, url, valid)

proc call*(call_589566: Call_AndroidenterpriseStorelayoutclustersGet_589552;
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
  var path_589567 = newJObject()
  var query_589568 = newJObject()
  add(query_589568, "fields", newJString(fields))
  add(query_589568, "quotaUser", newJString(quotaUser))
  add(query_589568, "alt", newJString(alt))
  add(query_589568, "oauth_token", newJString(oauthToken))
  add(query_589568, "userIp", newJString(userIp))
  add(query_589568, "key", newJString(key))
  add(path_589567, "enterpriseId", newJString(enterpriseId))
  add(path_589567, "pageId", newJString(pageId))
  add(query_589568, "prettyPrint", newJBool(prettyPrint))
  add(path_589567, "clusterId", newJString(clusterId))
  result = call_589566.call(path_589567, query_589568, nil, nil, nil)

var androidenterpriseStorelayoutclustersGet* = Call_AndroidenterpriseStorelayoutclustersGet_589552(
    name: "androidenterpriseStorelayoutclustersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersGet_589553,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersGet_589554,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersPatch_589605 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseStorelayoutclustersPatch_589607(protocol: Scheme;
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

proc validate_AndroidenterpriseStorelayoutclustersPatch_589606(path: JsonNode;
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
  var valid_589608 = path.getOrDefault("enterpriseId")
  valid_589608 = validateParameter(valid_589608, JString, required = true,
                                 default = nil)
  if valid_589608 != nil:
    section.add "enterpriseId", valid_589608
  var valid_589609 = path.getOrDefault("pageId")
  valid_589609 = validateParameter(valid_589609, JString, required = true,
                                 default = nil)
  if valid_589609 != nil:
    section.add "pageId", valid_589609
  var valid_589610 = path.getOrDefault("clusterId")
  valid_589610 = validateParameter(valid_589610, JString, required = true,
                                 default = nil)
  if valid_589610 != nil:
    section.add "clusterId", valid_589610
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
  var valid_589611 = query.getOrDefault("fields")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = nil)
  if valid_589611 != nil:
    section.add "fields", valid_589611
  var valid_589612 = query.getOrDefault("quotaUser")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "quotaUser", valid_589612
  var valid_589613 = query.getOrDefault("alt")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = newJString("json"))
  if valid_589613 != nil:
    section.add "alt", valid_589613
  var valid_589614 = query.getOrDefault("oauth_token")
  valid_589614 = validateParameter(valid_589614, JString, required = false,
                                 default = nil)
  if valid_589614 != nil:
    section.add "oauth_token", valid_589614
  var valid_589615 = query.getOrDefault("userIp")
  valid_589615 = validateParameter(valid_589615, JString, required = false,
                                 default = nil)
  if valid_589615 != nil:
    section.add "userIp", valid_589615
  var valid_589616 = query.getOrDefault("key")
  valid_589616 = validateParameter(valid_589616, JString, required = false,
                                 default = nil)
  if valid_589616 != nil:
    section.add "key", valid_589616
  var valid_589617 = query.getOrDefault("prettyPrint")
  valid_589617 = validateParameter(valid_589617, JBool, required = false,
                                 default = newJBool(true))
  if valid_589617 != nil:
    section.add "prettyPrint", valid_589617
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

proc call*(call_589619: Call_AndroidenterpriseStorelayoutclustersPatch_589605;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster. This method supports patch semantics.
  ## 
  let valid = call_589619.validator(path, query, header, formData, body)
  let scheme = call_589619.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589619.url(scheme.get, call_589619.host, call_589619.base,
                         call_589619.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589619, url, valid)

proc call*(call_589620: Call_AndroidenterpriseStorelayoutclustersPatch_589605;
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
  var path_589621 = newJObject()
  var query_589622 = newJObject()
  var body_589623 = newJObject()
  add(query_589622, "fields", newJString(fields))
  add(query_589622, "quotaUser", newJString(quotaUser))
  add(query_589622, "alt", newJString(alt))
  add(query_589622, "oauth_token", newJString(oauthToken))
  add(query_589622, "userIp", newJString(userIp))
  add(query_589622, "key", newJString(key))
  add(path_589621, "enterpriseId", newJString(enterpriseId))
  add(path_589621, "pageId", newJString(pageId))
  if body != nil:
    body_589623 = body
  add(query_589622, "prettyPrint", newJBool(prettyPrint))
  add(path_589621, "clusterId", newJString(clusterId))
  result = call_589620.call(path_589621, query_589622, nil, nil, body_589623)

var androidenterpriseStorelayoutclustersPatch* = Call_AndroidenterpriseStorelayoutclustersPatch_589605(
    name: "androidenterpriseStorelayoutclustersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersPatch_589606,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersPatch_589607,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseStorelayoutclustersDelete_589588 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseStorelayoutclustersDelete_589590(protocol: Scheme;
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

proc validate_AndroidenterpriseStorelayoutclustersDelete_589589(path: JsonNode;
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
  var valid_589591 = path.getOrDefault("enterpriseId")
  valid_589591 = validateParameter(valid_589591, JString, required = true,
                                 default = nil)
  if valid_589591 != nil:
    section.add "enterpriseId", valid_589591
  var valid_589592 = path.getOrDefault("pageId")
  valid_589592 = validateParameter(valid_589592, JString, required = true,
                                 default = nil)
  if valid_589592 != nil:
    section.add "pageId", valid_589592
  var valid_589593 = path.getOrDefault("clusterId")
  valid_589593 = validateParameter(valid_589593, JString, required = true,
                                 default = nil)
  if valid_589593 != nil:
    section.add "clusterId", valid_589593
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
  var valid_589594 = query.getOrDefault("fields")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = nil)
  if valid_589594 != nil:
    section.add "fields", valid_589594
  var valid_589595 = query.getOrDefault("quotaUser")
  valid_589595 = validateParameter(valid_589595, JString, required = false,
                                 default = nil)
  if valid_589595 != nil:
    section.add "quotaUser", valid_589595
  var valid_589596 = query.getOrDefault("alt")
  valid_589596 = validateParameter(valid_589596, JString, required = false,
                                 default = newJString("json"))
  if valid_589596 != nil:
    section.add "alt", valid_589596
  var valid_589597 = query.getOrDefault("oauth_token")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = nil)
  if valid_589597 != nil:
    section.add "oauth_token", valid_589597
  var valid_589598 = query.getOrDefault("userIp")
  valid_589598 = validateParameter(valid_589598, JString, required = false,
                                 default = nil)
  if valid_589598 != nil:
    section.add "userIp", valid_589598
  var valid_589599 = query.getOrDefault("key")
  valid_589599 = validateParameter(valid_589599, JString, required = false,
                                 default = nil)
  if valid_589599 != nil:
    section.add "key", valid_589599
  var valid_589600 = query.getOrDefault("prettyPrint")
  valid_589600 = validateParameter(valid_589600, JBool, required = false,
                                 default = newJBool(true))
  if valid_589600 != nil:
    section.add "prettyPrint", valid_589600
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589601: Call_AndroidenterpriseStorelayoutclustersDelete_589588;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a cluster.
  ## 
  let valid = call_589601.validator(path, query, header, formData, body)
  let scheme = call_589601.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589601.url(scheme.get, call_589601.host, call_589601.base,
                         call_589601.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589601, url, valid)

proc call*(call_589602: Call_AndroidenterpriseStorelayoutclustersDelete_589588;
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
  var path_589603 = newJObject()
  var query_589604 = newJObject()
  add(query_589604, "fields", newJString(fields))
  add(query_589604, "quotaUser", newJString(quotaUser))
  add(query_589604, "alt", newJString(alt))
  add(query_589604, "oauth_token", newJString(oauthToken))
  add(query_589604, "userIp", newJString(userIp))
  add(query_589604, "key", newJString(key))
  add(path_589603, "enterpriseId", newJString(enterpriseId))
  add(path_589603, "pageId", newJString(pageId))
  add(query_589604, "prettyPrint", newJBool(prettyPrint))
  add(path_589603, "clusterId", newJString(clusterId))
  result = call_589602.call(path_589603, query_589604, nil, nil, nil)

var androidenterpriseStorelayoutclustersDelete* = Call_AndroidenterpriseStorelayoutclustersDelete_589588(
    name: "androidenterpriseStorelayoutclustersDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/storeLayout/pages/{pageId}/clusters/{clusterId}",
    validator: validate_AndroidenterpriseStorelayoutclustersDelete_589589,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseStorelayoutclustersDelete_589590,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEnterprisesUnenroll_589624 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEnterprisesUnenroll_589626(protocol: Scheme;
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

proc validate_AndroidenterpriseEnterprisesUnenroll_589625(path: JsonNode;
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
  var valid_589627 = path.getOrDefault("enterpriseId")
  valid_589627 = validateParameter(valid_589627, JString, required = true,
                                 default = nil)
  if valid_589627 != nil:
    section.add "enterpriseId", valid_589627
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
  var valid_589628 = query.getOrDefault("fields")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = nil)
  if valid_589628 != nil:
    section.add "fields", valid_589628
  var valid_589629 = query.getOrDefault("quotaUser")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = nil)
  if valid_589629 != nil:
    section.add "quotaUser", valid_589629
  var valid_589630 = query.getOrDefault("alt")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = newJString("json"))
  if valid_589630 != nil:
    section.add "alt", valid_589630
  var valid_589631 = query.getOrDefault("oauth_token")
  valid_589631 = validateParameter(valid_589631, JString, required = false,
                                 default = nil)
  if valid_589631 != nil:
    section.add "oauth_token", valid_589631
  var valid_589632 = query.getOrDefault("userIp")
  valid_589632 = validateParameter(valid_589632, JString, required = false,
                                 default = nil)
  if valid_589632 != nil:
    section.add "userIp", valid_589632
  var valid_589633 = query.getOrDefault("key")
  valid_589633 = validateParameter(valid_589633, JString, required = false,
                                 default = nil)
  if valid_589633 != nil:
    section.add "key", valid_589633
  var valid_589634 = query.getOrDefault("prettyPrint")
  valid_589634 = validateParameter(valid_589634, JBool, required = false,
                                 default = newJBool(true))
  if valid_589634 != nil:
    section.add "prettyPrint", valid_589634
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589635: Call_AndroidenterpriseEnterprisesUnenroll_589624;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Unenrolls an enterprise from the calling EMM.
  ## 
  let valid = call_589635.validator(path, query, header, formData, body)
  let scheme = call_589635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589635.url(scheme.get, call_589635.host, call_589635.base,
                         call_589635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589635, url, valid)

proc call*(call_589636: Call_AndroidenterpriseEnterprisesUnenroll_589624;
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
  var path_589637 = newJObject()
  var query_589638 = newJObject()
  add(query_589638, "fields", newJString(fields))
  add(query_589638, "quotaUser", newJString(quotaUser))
  add(query_589638, "alt", newJString(alt))
  add(query_589638, "oauth_token", newJString(oauthToken))
  add(query_589638, "userIp", newJString(userIp))
  add(query_589638, "key", newJString(key))
  add(path_589637, "enterpriseId", newJString(enterpriseId))
  add(query_589638, "prettyPrint", newJBool(prettyPrint))
  result = call_589636.call(path_589637, query_589638, nil, nil, nil)

var androidenterpriseEnterprisesUnenroll* = Call_AndroidenterpriseEnterprisesUnenroll_589624(
    name: "androidenterpriseEnterprisesUnenroll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/unenroll",
    validator: validate_AndroidenterpriseEnterprisesUnenroll_589625,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEnterprisesUnenroll_589626,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersInsert_589655 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseUsersInsert_589657(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseUsersInsert_589656(path: JsonNode; query: JsonNode;
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
  var valid_589658 = path.getOrDefault("enterpriseId")
  valid_589658 = validateParameter(valid_589658, JString, required = true,
                                 default = nil)
  if valid_589658 != nil:
    section.add "enterpriseId", valid_589658
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
  var valid_589659 = query.getOrDefault("fields")
  valid_589659 = validateParameter(valid_589659, JString, required = false,
                                 default = nil)
  if valid_589659 != nil:
    section.add "fields", valid_589659
  var valid_589660 = query.getOrDefault("quotaUser")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = nil)
  if valid_589660 != nil:
    section.add "quotaUser", valid_589660
  var valid_589661 = query.getOrDefault("alt")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = newJString("json"))
  if valid_589661 != nil:
    section.add "alt", valid_589661
  var valid_589662 = query.getOrDefault("oauth_token")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "oauth_token", valid_589662
  var valid_589663 = query.getOrDefault("userIp")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = nil)
  if valid_589663 != nil:
    section.add "userIp", valid_589663
  var valid_589664 = query.getOrDefault("key")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = nil)
  if valid_589664 != nil:
    section.add "key", valid_589664
  var valid_589665 = query.getOrDefault("prettyPrint")
  valid_589665 = validateParameter(valid_589665, JBool, required = false,
                                 default = newJBool(true))
  if valid_589665 != nil:
    section.add "prettyPrint", valid_589665
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

proc call*(call_589667: Call_AndroidenterpriseUsersInsert_589655; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new EMM-managed user.
  ## 
  ## The Users resource passed in the body of the request should include an accountIdentifier and an accountType.
  ## If a corresponding user already exists with the same account identifier, the user will be updated with the resource. In this case only the displayName field can be changed.
  ## 
  let valid = call_589667.validator(path, query, header, formData, body)
  let scheme = call_589667.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589667.url(scheme.get, call_589667.host, call_589667.base,
                         call_589667.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589667, url, valid)

proc call*(call_589668: Call_AndroidenterpriseUsersInsert_589655;
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
  var path_589669 = newJObject()
  var query_589670 = newJObject()
  var body_589671 = newJObject()
  add(query_589670, "fields", newJString(fields))
  add(query_589670, "quotaUser", newJString(quotaUser))
  add(query_589670, "alt", newJString(alt))
  add(query_589670, "oauth_token", newJString(oauthToken))
  add(query_589670, "userIp", newJString(userIp))
  add(query_589670, "key", newJString(key))
  add(path_589669, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589671 = body
  add(query_589670, "prettyPrint", newJBool(prettyPrint))
  result = call_589668.call(path_589669, query_589670, nil, nil, body_589671)

var androidenterpriseUsersInsert* = Call_AndroidenterpriseUsersInsert_589655(
    name: "androidenterpriseUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users",
    validator: validate_AndroidenterpriseUsersInsert_589656,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersInsert_589657,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersList_589639 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseUsersList_589641(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseUsersList_589640(path: JsonNode; query: JsonNode;
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
  var valid_589642 = path.getOrDefault("enterpriseId")
  valid_589642 = validateParameter(valid_589642, JString, required = true,
                                 default = nil)
  if valid_589642 != nil:
    section.add "enterpriseId", valid_589642
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
  var valid_589643 = query.getOrDefault("fields")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "fields", valid_589643
  var valid_589644 = query.getOrDefault("quotaUser")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = nil)
  if valid_589644 != nil:
    section.add "quotaUser", valid_589644
  var valid_589645 = query.getOrDefault("alt")
  valid_589645 = validateParameter(valid_589645, JString, required = false,
                                 default = newJString("json"))
  if valid_589645 != nil:
    section.add "alt", valid_589645
  var valid_589646 = query.getOrDefault("oauth_token")
  valid_589646 = validateParameter(valid_589646, JString, required = false,
                                 default = nil)
  if valid_589646 != nil:
    section.add "oauth_token", valid_589646
  var valid_589647 = query.getOrDefault("userIp")
  valid_589647 = validateParameter(valid_589647, JString, required = false,
                                 default = nil)
  if valid_589647 != nil:
    section.add "userIp", valid_589647
  assert query != nil, "query argument is necessary due to required `email` field"
  var valid_589648 = query.getOrDefault("email")
  valid_589648 = validateParameter(valid_589648, JString, required = true,
                                 default = nil)
  if valid_589648 != nil:
    section.add "email", valid_589648
  var valid_589649 = query.getOrDefault("key")
  valid_589649 = validateParameter(valid_589649, JString, required = false,
                                 default = nil)
  if valid_589649 != nil:
    section.add "key", valid_589649
  var valid_589650 = query.getOrDefault("prettyPrint")
  valid_589650 = validateParameter(valid_589650, JBool, required = false,
                                 default = newJBool(true))
  if valid_589650 != nil:
    section.add "prettyPrint", valid_589650
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589651: Call_AndroidenterpriseUsersList_589639; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Looks up a user by primary email address. This is only supported for Google-managed users. Lookup of the id is not needed for EMM-managed users because the id is already returned in the result of the Users.insert call.
  ## 
  let valid = call_589651.validator(path, query, header, formData, body)
  let scheme = call_589651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589651.url(scheme.get, call_589651.host, call_589651.base,
                         call_589651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589651, url, valid)

proc call*(call_589652: Call_AndroidenterpriseUsersList_589639; email: string;
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
  var path_589653 = newJObject()
  var query_589654 = newJObject()
  add(query_589654, "fields", newJString(fields))
  add(query_589654, "quotaUser", newJString(quotaUser))
  add(query_589654, "alt", newJString(alt))
  add(query_589654, "oauth_token", newJString(oauthToken))
  add(query_589654, "userIp", newJString(userIp))
  add(query_589654, "email", newJString(email))
  add(query_589654, "key", newJString(key))
  add(path_589653, "enterpriseId", newJString(enterpriseId))
  add(query_589654, "prettyPrint", newJBool(prettyPrint))
  result = call_589652.call(path_589653, query_589654, nil, nil, nil)

var androidenterpriseUsersList* = Call_AndroidenterpriseUsersList_589639(
    name: "androidenterpriseUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users",
    validator: validate_AndroidenterpriseUsersList_589640,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersList_589641,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersUpdate_589688 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseUsersUpdate_589690(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseUsersUpdate_589689(path: JsonNode; query: JsonNode;
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
  var valid_589691 = path.getOrDefault("enterpriseId")
  valid_589691 = validateParameter(valid_589691, JString, required = true,
                                 default = nil)
  if valid_589691 != nil:
    section.add "enterpriseId", valid_589691
  var valid_589692 = path.getOrDefault("userId")
  valid_589692 = validateParameter(valid_589692, JString, required = true,
                                 default = nil)
  if valid_589692 != nil:
    section.add "userId", valid_589692
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
  var valid_589693 = query.getOrDefault("fields")
  valid_589693 = validateParameter(valid_589693, JString, required = false,
                                 default = nil)
  if valid_589693 != nil:
    section.add "fields", valid_589693
  var valid_589694 = query.getOrDefault("quotaUser")
  valid_589694 = validateParameter(valid_589694, JString, required = false,
                                 default = nil)
  if valid_589694 != nil:
    section.add "quotaUser", valid_589694
  var valid_589695 = query.getOrDefault("alt")
  valid_589695 = validateParameter(valid_589695, JString, required = false,
                                 default = newJString("json"))
  if valid_589695 != nil:
    section.add "alt", valid_589695
  var valid_589696 = query.getOrDefault("oauth_token")
  valid_589696 = validateParameter(valid_589696, JString, required = false,
                                 default = nil)
  if valid_589696 != nil:
    section.add "oauth_token", valid_589696
  var valid_589697 = query.getOrDefault("userIp")
  valid_589697 = validateParameter(valid_589697, JString, required = false,
                                 default = nil)
  if valid_589697 != nil:
    section.add "userIp", valid_589697
  var valid_589698 = query.getOrDefault("key")
  valid_589698 = validateParameter(valid_589698, JString, required = false,
                                 default = nil)
  if valid_589698 != nil:
    section.add "key", valid_589698
  var valid_589699 = query.getOrDefault("prettyPrint")
  valid_589699 = validateParameter(valid_589699, JBool, required = false,
                                 default = newJBool(true))
  if valid_589699 != nil:
    section.add "prettyPrint", valid_589699
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

proc call*(call_589701: Call_AndroidenterpriseUsersUpdate_589688; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value.
  ## 
  let valid = call_589701.validator(path, query, header, formData, body)
  let scheme = call_589701.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589701.url(scheme.get, call_589701.host, call_589701.base,
                         call_589701.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589701, url, valid)

proc call*(call_589702: Call_AndroidenterpriseUsersUpdate_589688;
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
  var path_589703 = newJObject()
  var query_589704 = newJObject()
  var body_589705 = newJObject()
  add(query_589704, "fields", newJString(fields))
  add(query_589704, "quotaUser", newJString(quotaUser))
  add(query_589704, "alt", newJString(alt))
  add(query_589704, "oauth_token", newJString(oauthToken))
  add(query_589704, "userIp", newJString(userIp))
  add(query_589704, "key", newJString(key))
  add(path_589703, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589705 = body
  add(query_589704, "prettyPrint", newJBool(prettyPrint))
  add(path_589703, "userId", newJString(userId))
  result = call_589702.call(path_589703, query_589704, nil, nil, body_589705)

var androidenterpriseUsersUpdate* = Call_AndroidenterpriseUsersUpdate_589688(
    name: "androidenterpriseUsersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersUpdate_589689,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersUpdate_589690,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGet_589672 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseUsersGet_589674(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseUsersGet_589673(path: JsonNode; query: JsonNode;
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
  var valid_589675 = path.getOrDefault("enterpriseId")
  valid_589675 = validateParameter(valid_589675, JString, required = true,
                                 default = nil)
  if valid_589675 != nil:
    section.add "enterpriseId", valid_589675
  var valid_589676 = path.getOrDefault("userId")
  valid_589676 = validateParameter(valid_589676, JString, required = true,
                                 default = nil)
  if valid_589676 != nil:
    section.add "userId", valid_589676
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
  var valid_589677 = query.getOrDefault("fields")
  valid_589677 = validateParameter(valid_589677, JString, required = false,
                                 default = nil)
  if valid_589677 != nil:
    section.add "fields", valid_589677
  var valid_589678 = query.getOrDefault("quotaUser")
  valid_589678 = validateParameter(valid_589678, JString, required = false,
                                 default = nil)
  if valid_589678 != nil:
    section.add "quotaUser", valid_589678
  var valid_589679 = query.getOrDefault("alt")
  valid_589679 = validateParameter(valid_589679, JString, required = false,
                                 default = newJString("json"))
  if valid_589679 != nil:
    section.add "alt", valid_589679
  var valid_589680 = query.getOrDefault("oauth_token")
  valid_589680 = validateParameter(valid_589680, JString, required = false,
                                 default = nil)
  if valid_589680 != nil:
    section.add "oauth_token", valid_589680
  var valid_589681 = query.getOrDefault("userIp")
  valid_589681 = validateParameter(valid_589681, JString, required = false,
                                 default = nil)
  if valid_589681 != nil:
    section.add "userIp", valid_589681
  var valid_589682 = query.getOrDefault("key")
  valid_589682 = validateParameter(valid_589682, JString, required = false,
                                 default = nil)
  if valid_589682 != nil:
    section.add "key", valid_589682
  var valid_589683 = query.getOrDefault("prettyPrint")
  valid_589683 = validateParameter(valid_589683, JBool, required = false,
                                 default = newJBool(true))
  if valid_589683 != nil:
    section.add "prettyPrint", valid_589683
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589684: Call_AndroidenterpriseUsersGet_589672; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a user's details.
  ## 
  let valid = call_589684.validator(path, query, header, formData, body)
  let scheme = call_589684.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589684.url(scheme.get, call_589684.host, call_589684.base,
                         call_589684.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589684, url, valid)

proc call*(call_589685: Call_AndroidenterpriseUsersGet_589672;
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
  var path_589686 = newJObject()
  var query_589687 = newJObject()
  add(query_589687, "fields", newJString(fields))
  add(query_589687, "quotaUser", newJString(quotaUser))
  add(query_589687, "alt", newJString(alt))
  add(query_589687, "oauth_token", newJString(oauthToken))
  add(query_589687, "userIp", newJString(userIp))
  add(query_589687, "key", newJString(key))
  add(path_589686, "enterpriseId", newJString(enterpriseId))
  add(query_589687, "prettyPrint", newJBool(prettyPrint))
  add(path_589686, "userId", newJString(userId))
  result = call_589685.call(path_589686, query_589687, nil, nil, nil)

var androidenterpriseUsersGet* = Call_AndroidenterpriseUsersGet_589672(
    name: "androidenterpriseUsersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersGet_589673,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersGet_589674,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersPatch_589722 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseUsersPatch_589724(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseUsersPatch_589723(path: JsonNode; query: JsonNode;
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
  var valid_589725 = path.getOrDefault("enterpriseId")
  valid_589725 = validateParameter(valid_589725, JString, required = true,
                                 default = nil)
  if valid_589725 != nil:
    section.add "enterpriseId", valid_589725
  var valid_589726 = path.getOrDefault("userId")
  valid_589726 = validateParameter(valid_589726, JString, required = true,
                                 default = nil)
  if valid_589726 != nil:
    section.add "userId", valid_589726
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
  var valid_589727 = query.getOrDefault("fields")
  valid_589727 = validateParameter(valid_589727, JString, required = false,
                                 default = nil)
  if valid_589727 != nil:
    section.add "fields", valid_589727
  var valid_589728 = query.getOrDefault("quotaUser")
  valid_589728 = validateParameter(valid_589728, JString, required = false,
                                 default = nil)
  if valid_589728 != nil:
    section.add "quotaUser", valid_589728
  var valid_589729 = query.getOrDefault("alt")
  valid_589729 = validateParameter(valid_589729, JString, required = false,
                                 default = newJString("json"))
  if valid_589729 != nil:
    section.add "alt", valid_589729
  var valid_589730 = query.getOrDefault("oauth_token")
  valid_589730 = validateParameter(valid_589730, JString, required = false,
                                 default = nil)
  if valid_589730 != nil:
    section.add "oauth_token", valid_589730
  var valid_589731 = query.getOrDefault("userIp")
  valid_589731 = validateParameter(valid_589731, JString, required = false,
                                 default = nil)
  if valid_589731 != nil:
    section.add "userIp", valid_589731
  var valid_589732 = query.getOrDefault("key")
  valid_589732 = validateParameter(valid_589732, JString, required = false,
                                 default = nil)
  if valid_589732 != nil:
    section.add "key", valid_589732
  var valid_589733 = query.getOrDefault("prettyPrint")
  valid_589733 = validateParameter(valid_589733, JBool, required = false,
                                 default = newJBool(true))
  if valid_589733 != nil:
    section.add "prettyPrint", valid_589733
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

proc call*(call_589735: Call_AndroidenterpriseUsersPatch_589722; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the details of an EMM-managed user.
  ## 
  ## Can be used with EMM-managed users only (not Google managed users). Pass the new details in the Users resource in the request body. Only the displayName field can be changed. Other fields must either be unset or have the currently active value. This method supports patch semantics.
  ## 
  let valid = call_589735.validator(path, query, header, formData, body)
  let scheme = call_589735.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589735.url(scheme.get, call_589735.host, call_589735.base,
                         call_589735.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589735, url, valid)

proc call*(call_589736: Call_AndroidenterpriseUsersPatch_589722;
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
  var path_589737 = newJObject()
  var query_589738 = newJObject()
  var body_589739 = newJObject()
  add(query_589738, "fields", newJString(fields))
  add(query_589738, "quotaUser", newJString(quotaUser))
  add(query_589738, "alt", newJString(alt))
  add(query_589738, "oauth_token", newJString(oauthToken))
  add(query_589738, "userIp", newJString(userIp))
  add(query_589738, "key", newJString(key))
  add(path_589737, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589739 = body
  add(query_589738, "prettyPrint", newJBool(prettyPrint))
  add(path_589737, "userId", newJString(userId))
  result = call_589736.call(path_589737, query_589738, nil, nil, body_589739)

var androidenterpriseUsersPatch* = Call_AndroidenterpriseUsersPatch_589722(
    name: "androidenterpriseUsersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersPatch_589723,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersPatch_589724,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersDelete_589706 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseUsersDelete_589708(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseUsersDelete_589707(path: JsonNode; query: JsonNode;
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
  var valid_589709 = path.getOrDefault("enterpriseId")
  valid_589709 = validateParameter(valid_589709, JString, required = true,
                                 default = nil)
  if valid_589709 != nil:
    section.add "enterpriseId", valid_589709
  var valid_589710 = path.getOrDefault("userId")
  valid_589710 = validateParameter(valid_589710, JString, required = true,
                                 default = nil)
  if valid_589710 != nil:
    section.add "userId", valid_589710
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
  var valid_589711 = query.getOrDefault("fields")
  valid_589711 = validateParameter(valid_589711, JString, required = false,
                                 default = nil)
  if valid_589711 != nil:
    section.add "fields", valid_589711
  var valid_589712 = query.getOrDefault("quotaUser")
  valid_589712 = validateParameter(valid_589712, JString, required = false,
                                 default = nil)
  if valid_589712 != nil:
    section.add "quotaUser", valid_589712
  var valid_589713 = query.getOrDefault("alt")
  valid_589713 = validateParameter(valid_589713, JString, required = false,
                                 default = newJString("json"))
  if valid_589713 != nil:
    section.add "alt", valid_589713
  var valid_589714 = query.getOrDefault("oauth_token")
  valid_589714 = validateParameter(valid_589714, JString, required = false,
                                 default = nil)
  if valid_589714 != nil:
    section.add "oauth_token", valid_589714
  var valid_589715 = query.getOrDefault("userIp")
  valid_589715 = validateParameter(valid_589715, JString, required = false,
                                 default = nil)
  if valid_589715 != nil:
    section.add "userIp", valid_589715
  var valid_589716 = query.getOrDefault("key")
  valid_589716 = validateParameter(valid_589716, JString, required = false,
                                 default = nil)
  if valid_589716 != nil:
    section.add "key", valid_589716
  var valid_589717 = query.getOrDefault("prettyPrint")
  valid_589717 = validateParameter(valid_589717, JBool, required = false,
                                 default = newJBool(true))
  if valid_589717 != nil:
    section.add "prettyPrint", valid_589717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589718: Call_AndroidenterpriseUsersDelete_589706; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deleted an EMM-managed user.
  ## 
  let valid = call_589718.validator(path, query, header, formData, body)
  let scheme = call_589718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589718.url(scheme.get, call_589718.host, call_589718.base,
                         call_589718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589718, url, valid)

proc call*(call_589719: Call_AndroidenterpriseUsersDelete_589706;
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
  var path_589720 = newJObject()
  var query_589721 = newJObject()
  add(query_589721, "fields", newJString(fields))
  add(query_589721, "quotaUser", newJString(quotaUser))
  add(query_589721, "alt", newJString(alt))
  add(query_589721, "oauth_token", newJString(oauthToken))
  add(query_589721, "userIp", newJString(userIp))
  add(query_589721, "key", newJString(key))
  add(path_589720, "enterpriseId", newJString(enterpriseId))
  add(query_589721, "prettyPrint", newJBool(prettyPrint))
  add(path_589720, "userId", newJString(userId))
  result = call_589719.call(path_589720, query_589721, nil, nil, nil)

var androidenterpriseUsersDelete* = Call_AndroidenterpriseUsersDelete_589706(
    name: "androidenterpriseUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}",
    validator: validate_AndroidenterpriseUsersDelete_589707,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersDelete_589708,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGenerateAuthenticationToken_589740 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseUsersGenerateAuthenticationToken_589742(
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

proc validate_AndroidenterpriseUsersGenerateAuthenticationToken_589741(
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
  var valid_589743 = path.getOrDefault("enterpriseId")
  valid_589743 = validateParameter(valid_589743, JString, required = true,
                                 default = nil)
  if valid_589743 != nil:
    section.add "enterpriseId", valid_589743
  var valid_589744 = path.getOrDefault("userId")
  valid_589744 = validateParameter(valid_589744, JString, required = true,
                                 default = nil)
  if valid_589744 != nil:
    section.add "userId", valid_589744
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
  var valid_589745 = query.getOrDefault("fields")
  valid_589745 = validateParameter(valid_589745, JString, required = false,
                                 default = nil)
  if valid_589745 != nil:
    section.add "fields", valid_589745
  var valid_589746 = query.getOrDefault("quotaUser")
  valid_589746 = validateParameter(valid_589746, JString, required = false,
                                 default = nil)
  if valid_589746 != nil:
    section.add "quotaUser", valid_589746
  var valid_589747 = query.getOrDefault("alt")
  valid_589747 = validateParameter(valid_589747, JString, required = false,
                                 default = newJString("json"))
  if valid_589747 != nil:
    section.add "alt", valid_589747
  var valid_589748 = query.getOrDefault("oauth_token")
  valid_589748 = validateParameter(valid_589748, JString, required = false,
                                 default = nil)
  if valid_589748 != nil:
    section.add "oauth_token", valid_589748
  var valid_589749 = query.getOrDefault("userIp")
  valid_589749 = validateParameter(valid_589749, JString, required = false,
                                 default = nil)
  if valid_589749 != nil:
    section.add "userIp", valid_589749
  var valid_589750 = query.getOrDefault("key")
  valid_589750 = validateParameter(valid_589750, JString, required = false,
                                 default = nil)
  if valid_589750 != nil:
    section.add "key", valid_589750
  var valid_589751 = query.getOrDefault("prettyPrint")
  valid_589751 = validateParameter(valid_589751, JBool, required = false,
                                 default = newJBool(true))
  if valid_589751 != nil:
    section.add "prettyPrint", valid_589751
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589752: Call_AndroidenterpriseUsersGenerateAuthenticationToken_589740;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates an authentication token which the device policy client can use to provision the given EMM-managed user account on a device. The generated token is single-use and expires after a few minutes.
  ## 
  ## You can provision a maximum of 10 devices per user.
  ## 
  ## This call only works with EMM-managed accounts.
  ## 
  let valid = call_589752.validator(path, query, header, formData, body)
  let scheme = call_589752.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589752.url(scheme.get, call_589752.host, call_589752.base,
                         call_589752.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589752, url, valid)

proc call*(call_589753: Call_AndroidenterpriseUsersGenerateAuthenticationToken_589740;
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
  var path_589754 = newJObject()
  var query_589755 = newJObject()
  add(query_589755, "fields", newJString(fields))
  add(query_589755, "quotaUser", newJString(quotaUser))
  add(query_589755, "alt", newJString(alt))
  add(query_589755, "oauth_token", newJString(oauthToken))
  add(query_589755, "userIp", newJString(userIp))
  add(query_589755, "key", newJString(key))
  add(path_589754, "enterpriseId", newJString(enterpriseId))
  add(query_589755, "prettyPrint", newJBool(prettyPrint))
  add(path_589754, "userId", newJString(userId))
  result = call_589753.call(path_589754, query_589755, nil, nil, nil)

var androidenterpriseUsersGenerateAuthenticationToken* = Call_AndroidenterpriseUsersGenerateAuthenticationToken_589740(
    name: "androidenterpriseUsersGenerateAuthenticationToken",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/authenticationToken",
    validator: validate_AndroidenterpriseUsersGenerateAuthenticationToken_589741,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersGenerateAuthenticationToken_589742,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersSetAvailableProductSet_589772 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseUsersSetAvailableProductSet_589774(protocol: Scheme;
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

proc validate_AndroidenterpriseUsersSetAvailableProductSet_589773(path: JsonNode;
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
  var valid_589775 = path.getOrDefault("enterpriseId")
  valid_589775 = validateParameter(valid_589775, JString, required = true,
                                 default = nil)
  if valid_589775 != nil:
    section.add "enterpriseId", valid_589775
  var valid_589776 = path.getOrDefault("userId")
  valid_589776 = validateParameter(valid_589776, JString, required = true,
                                 default = nil)
  if valid_589776 != nil:
    section.add "userId", valid_589776
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
  var valid_589777 = query.getOrDefault("fields")
  valid_589777 = validateParameter(valid_589777, JString, required = false,
                                 default = nil)
  if valid_589777 != nil:
    section.add "fields", valid_589777
  var valid_589778 = query.getOrDefault("quotaUser")
  valid_589778 = validateParameter(valid_589778, JString, required = false,
                                 default = nil)
  if valid_589778 != nil:
    section.add "quotaUser", valid_589778
  var valid_589779 = query.getOrDefault("alt")
  valid_589779 = validateParameter(valid_589779, JString, required = false,
                                 default = newJString("json"))
  if valid_589779 != nil:
    section.add "alt", valid_589779
  var valid_589780 = query.getOrDefault("oauth_token")
  valid_589780 = validateParameter(valid_589780, JString, required = false,
                                 default = nil)
  if valid_589780 != nil:
    section.add "oauth_token", valid_589780
  var valid_589781 = query.getOrDefault("userIp")
  valid_589781 = validateParameter(valid_589781, JString, required = false,
                                 default = nil)
  if valid_589781 != nil:
    section.add "userIp", valid_589781
  var valid_589782 = query.getOrDefault("key")
  valid_589782 = validateParameter(valid_589782, JString, required = false,
                                 default = nil)
  if valid_589782 != nil:
    section.add "key", valid_589782
  var valid_589783 = query.getOrDefault("prettyPrint")
  valid_589783 = validateParameter(valid_589783, JBool, required = false,
                                 default = newJBool(true))
  if valid_589783 != nil:
    section.add "prettyPrint", valid_589783
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

proc call*(call_589785: Call_AndroidenterpriseUsersSetAvailableProductSet_589772;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Modifies the set of products that a user is entitled to access (referred to as whitelisted products). Only products that are approved or products that were previously approved (products with revoked approval) can be whitelisted.
  ## 
  let valid = call_589785.validator(path, query, header, formData, body)
  let scheme = call_589785.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589785.url(scheme.get, call_589785.host, call_589785.base,
                         call_589785.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589785, url, valid)

proc call*(call_589786: Call_AndroidenterpriseUsersSetAvailableProductSet_589772;
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
  var path_589787 = newJObject()
  var query_589788 = newJObject()
  var body_589789 = newJObject()
  add(query_589788, "fields", newJString(fields))
  add(query_589788, "quotaUser", newJString(quotaUser))
  add(query_589788, "alt", newJString(alt))
  add(query_589788, "oauth_token", newJString(oauthToken))
  add(query_589788, "userIp", newJString(userIp))
  add(query_589788, "key", newJString(key))
  add(path_589787, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589789 = body
  add(query_589788, "prettyPrint", newJBool(prettyPrint))
  add(path_589787, "userId", newJString(userId))
  result = call_589786.call(path_589787, query_589788, nil, nil, body_589789)

var androidenterpriseUsersSetAvailableProductSet* = Call_AndroidenterpriseUsersSetAvailableProductSet_589772(
    name: "androidenterpriseUsersSetAvailableProductSet",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/availableProductSet",
    validator: validate_AndroidenterpriseUsersSetAvailableProductSet_589773,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersSetAvailableProductSet_589774,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGetAvailableProductSet_589756 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseUsersGetAvailableProductSet_589758(protocol: Scheme;
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

proc validate_AndroidenterpriseUsersGetAvailableProductSet_589757(path: JsonNode;
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
  var valid_589759 = path.getOrDefault("enterpriseId")
  valid_589759 = validateParameter(valid_589759, JString, required = true,
                                 default = nil)
  if valid_589759 != nil:
    section.add "enterpriseId", valid_589759
  var valid_589760 = path.getOrDefault("userId")
  valid_589760 = validateParameter(valid_589760, JString, required = true,
                                 default = nil)
  if valid_589760 != nil:
    section.add "userId", valid_589760
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
  var valid_589761 = query.getOrDefault("fields")
  valid_589761 = validateParameter(valid_589761, JString, required = false,
                                 default = nil)
  if valid_589761 != nil:
    section.add "fields", valid_589761
  var valid_589762 = query.getOrDefault("quotaUser")
  valid_589762 = validateParameter(valid_589762, JString, required = false,
                                 default = nil)
  if valid_589762 != nil:
    section.add "quotaUser", valid_589762
  var valid_589763 = query.getOrDefault("alt")
  valid_589763 = validateParameter(valid_589763, JString, required = false,
                                 default = newJString("json"))
  if valid_589763 != nil:
    section.add "alt", valid_589763
  var valid_589764 = query.getOrDefault("oauth_token")
  valid_589764 = validateParameter(valid_589764, JString, required = false,
                                 default = nil)
  if valid_589764 != nil:
    section.add "oauth_token", valid_589764
  var valid_589765 = query.getOrDefault("userIp")
  valid_589765 = validateParameter(valid_589765, JString, required = false,
                                 default = nil)
  if valid_589765 != nil:
    section.add "userIp", valid_589765
  var valid_589766 = query.getOrDefault("key")
  valid_589766 = validateParameter(valid_589766, JString, required = false,
                                 default = nil)
  if valid_589766 != nil:
    section.add "key", valid_589766
  var valid_589767 = query.getOrDefault("prettyPrint")
  valid_589767 = validateParameter(valid_589767, JBool, required = false,
                                 default = newJBool(true))
  if valid_589767 != nil:
    section.add "prettyPrint", valid_589767
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589768: Call_AndroidenterpriseUsersGetAvailableProductSet_589756;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the set of products a user is entitled to access.
  ## 
  let valid = call_589768.validator(path, query, header, formData, body)
  let scheme = call_589768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589768.url(scheme.get, call_589768.host, call_589768.base,
                         call_589768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589768, url, valid)

proc call*(call_589769: Call_AndroidenterpriseUsersGetAvailableProductSet_589756;
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
  var path_589770 = newJObject()
  var query_589771 = newJObject()
  add(query_589771, "fields", newJString(fields))
  add(query_589771, "quotaUser", newJString(quotaUser))
  add(query_589771, "alt", newJString(alt))
  add(query_589771, "oauth_token", newJString(oauthToken))
  add(query_589771, "userIp", newJString(userIp))
  add(query_589771, "key", newJString(key))
  add(path_589770, "enterpriseId", newJString(enterpriseId))
  add(query_589771, "prettyPrint", newJBool(prettyPrint))
  add(path_589770, "userId", newJString(userId))
  result = call_589769.call(path_589770, query_589771, nil, nil, nil)

var androidenterpriseUsersGetAvailableProductSet* = Call_AndroidenterpriseUsersGetAvailableProductSet_589756(
    name: "androidenterpriseUsersGetAvailableProductSet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/availableProductSet",
    validator: validate_AndroidenterpriseUsersGetAvailableProductSet_589757,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersGetAvailableProductSet_589758,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersRevokeDeviceAccess_589790 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseUsersRevokeDeviceAccess_589792(protocol: Scheme;
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

proc validate_AndroidenterpriseUsersRevokeDeviceAccess_589791(path: JsonNode;
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
  var valid_589793 = path.getOrDefault("enterpriseId")
  valid_589793 = validateParameter(valid_589793, JString, required = true,
                                 default = nil)
  if valid_589793 != nil:
    section.add "enterpriseId", valid_589793
  var valid_589794 = path.getOrDefault("userId")
  valid_589794 = validateParameter(valid_589794, JString, required = true,
                                 default = nil)
  if valid_589794 != nil:
    section.add "userId", valid_589794
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
  var valid_589795 = query.getOrDefault("fields")
  valid_589795 = validateParameter(valid_589795, JString, required = false,
                                 default = nil)
  if valid_589795 != nil:
    section.add "fields", valid_589795
  var valid_589796 = query.getOrDefault("quotaUser")
  valid_589796 = validateParameter(valid_589796, JString, required = false,
                                 default = nil)
  if valid_589796 != nil:
    section.add "quotaUser", valid_589796
  var valid_589797 = query.getOrDefault("alt")
  valid_589797 = validateParameter(valid_589797, JString, required = false,
                                 default = newJString("json"))
  if valid_589797 != nil:
    section.add "alt", valid_589797
  var valid_589798 = query.getOrDefault("oauth_token")
  valid_589798 = validateParameter(valid_589798, JString, required = false,
                                 default = nil)
  if valid_589798 != nil:
    section.add "oauth_token", valid_589798
  var valid_589799 = query.getOrDefault("userIp")
  valid_589799 = validateParameter(valid_589799, JString, required = false,
                                 default = nil)
  if valid_589799 != nil:
    section.add "userIp", valid_589799
  var valid_589800 = query.getOrDefault("key")
  valid_589800 = validateParameter(valid_589800, JString, required = false,
                                 default = nil)
  if valid_589800 != nil:
    section.add "key", valid_589800
  var valid_589801 = query.getOrDefault("prettyPrint")
  valid_589801 = validateParameter(valid_589801, JBool, required = false,
                                 default = newJBool(true))
  if valid_589801 != nil:
    section.add "prettyPrint", valid_589801
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589802: Call_AndroidenterpriseUsersRevokeDeviceAccess_589790;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes access to all devices currently provisioned to the user. The user will no longer be able to use the managed Play store on any of their managed devices.
  ## 
  ## This call only works with EMM-managed accounts.
  ## 
  let valid = call_589802.validator(path, query, header, formData, body)
  let scheme = call_589802.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589802.url(scheme.get, call_589802.host, call_589802.base,
                         call_589802.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589802, url, valid)

proc call*(call_589803: Call_AndroidenterpriseUsersRevokeDeviceAccess_589790;
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
  var path_589804 = newJObject()
  var query_589805 = newJObject()
  add(query_589805, "fields", newJString(fields))
  add(query_589805, "quotaUser", newJString(quotaUser))
  add(query_589805, "alt", newJString(alt))
  add(query_589805, "oauth_token", newJString(oauthToken))
  add(query_589805, "userIp", newJString(userIp))
  add(query_589805, "key", newJString(key))
  add(path_589804, "enterpriseId", newJString(enterpriseId))
  add(query_589805, "prettyPrint", newJBool(prettyPrint))
  add(path_589804, "userId", newJString(userId))
  result = call_589803.call(path_589804, query_589805, nil, nil, nil)

var androidenterpriseUsersRevokeDeviceAccess* = Call_AndroidenterpriseUsersRevokeDeviceAccess_589790(
    name: "androidenterpriseUsersRevokeDeviceAccess", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/deviceAccess",
    validator: validate_AndroidenterpriseUsersRevokeDeviceAccess_589791,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseUsersRevokeDeviceAccess_589792,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesList_589806 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseDevicesList_589808(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseDevicesList_589807(path: JsonNode; query: JsonNode;
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
  var valid_589809 = path.getOrDefault("enterpriseId")
  valid_589809 = validateParameter(valid_589809, JString, required = true,
                                 default = nil)
  if valid_589809 != nil:
    section.add "enterpriseId", valid_589809
  var valid_589810 = path.getOrDefault("userId")
  valid_589810 = validateParameter(valid_589810, JString, required = true,
                                 default = nil)
  if valid_589810 != nil:
    section.add "userId", valid_589810
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
  var valid_589811 = query.getOrDefault("fields")
  valid_589811 = validateParameter(valid_589811, JString, required = false,
                                 default = nil)
  if valid_589811 != nil:
    section.add "fields", valid_589811
  var valid_589812 = query.getOrDefault("quotaUser")
  valid_589812 = validateParameter(valid_589812, JString, required = false,
                                 default = nil)
  if valid_589812 != nil:
    section.add "quotaUser", valid_589812
  var valid_589813 = query.getOrDefault("alt")
  valid_589813 = validateParameter(valid_589813, JString, required = false,
                                 default = newJString("json"))
  if valid_589813 != nil:
    section.add "alt", valid_589813
  var valid_589814 = query.getOrDefault("oauth_token")
  valid_589814 = validateParameter(valid_589814, JString, required = false,
                                 default = nil)
  if valid_589814 != nil:
    section.add "oauth_token", valid_589814
  var valid_589815 = query.getOrDefault("userIp")
  valid_589815 = validateParameter(valid_589815, JString, required = false,
                                 default = nil)
  if valid_589815 != nil:
    section.add "userIp", valid_589815
  var valid_589816 = query.getOrDefault("key")
  valid_589816 = validateParameter(valid_589816, JString, required = false,
                                 default = nil)
  if valid_589816 != nil:
    section.add "key", valid_589816
  var valid_589817 = query.getOrDefault("prettyPrint")
  valid_589817 = validateParameter(valid_589817, JBool, required = false,
                                 default = newJBool(true))
  if valid_589817 != nil:
    section.add "prettyPrint", valid_589817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589818: Call_AndroidenterpriseDevicesList_589806; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the IDs of all of a user's devices.
  ## 
  let valid = call_589818.validator(path, query, header, formData, body)
  let scheme = call_589818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589818.url(scheme.get, call_589818.host, call_589818.base,
                         call_589818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589818, url, valid)

proc call*(call_589819: Call_AndroidenterpriseDevicesList_589806;
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
  var path_589820 = newJObject()
  var query_589821 = newJObject()
  add(query_589821, "fields", newJString(fields))
  add(query_589821, "quotaUser", newJString(quotaUser))
  add(query_589821, "alt", newJString(alt))
  add(query_589821, "oauth_token", newJString(oauthToken))
  add(query_589821, "userIp", newJString(userIp))
  add(query_589821, "key", newJString(key))
  add(path_589820, "enterpriseId", newJString(enterpriseId))
  add(query_589821, "prettyPrint", newJBool(prettyPrint))
  add(path_589820, "userId", newJString(userId))
  result = call_589819.call(path_589820, query_589821, nil, nil, nil)

var androidenterpriseDevicesList* = Call_AndroidenterpriseDevicesList_589806(
    name: "androidenterpriseDevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices",
    validator: validate_AndroidenterpriseDevicesList_589807,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesList_589808,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesUpdate_589839 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseDevicesUpdate_589841(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseDevicesUpdate_589840(path: JsonNode;
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
  var valid_589842 = path.getOrDefault("deviceId")
  valid_589842 = validateParameter(valid_589842, JString, required = true,
                                 default = nil)
  if valid_589842 != nil:
    section.add "deviceId", valid_589842
  var valid_589843 = path.getOrDefault("enterpriseId")
  valid_589843 = validateParameter(valid_589843, JString, required = true,
                                 default = nil)
  if valid_589843 != nil:
    section.add "enterpriseId", valid_589843
  var valid_589844 = path.getOrDefault("userId")
  valid_589844 = validateParameter(valid_589844, JString, required = true,
                                 default = nil)
  if valid_589844 != nil:
    section.add "userId", valid_589844
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
  var valid_589845 = query.getOrDefault("fields")
  valid_589845 = validateParameter(valid_589845, JString, required = false,
                                 default = nil)
  if valid_589845 != nil:
    section.add "fields", valid_589845
  var valid_589846 = query.getOrDefault("quotaUser")
  valid_589846 = validateParameter(valid_589846, JString, required = false,
                                 default = nil)
  if valid_589846 != nil:
    section.add "quotaUser", valid_589846
  var valid_589847 = query.getOrDefault("alt")
  valid_589847 = validateParameter(valid_589847, JString, required = false,
                                 default = newJString("json"))
  if valid_589847 != nil:
    section.add "alt", valid_589847
  var valid_589848 = query.getOrDefault("oauth_token")
  valid_589848 = validateParameter(valid_589848, JString, required = false,
                                 default = nil)
  if valid_589848 != nil:
    section.add "oauth_token", valid_589848
  var valid_589849 = query.getOrDefault("userIp")
  valid_589849 = validateParameter(valid_589849, JString, required = false,
                                 default = nil)
  if valid_589849 != nil:
    section.add "userIp", valid_589849
  var valid_589850 = query.getOrDefault("key")
  valid_589850 = validateParameter(valid_589850, JString, required = false,
                                 default = nil)
  if valid_589850 != nil:
    section.add "key", valid_589850
  var valid_589851 = query.getOrDefault("prettyPrint")
  valid_589851 = validateParameter(valid_589851, JBool, required = false,
                                 default = newJBool(true))
  if valid_589851 != nil:
    section.add "prettyPrint", valid_589851
  var valid_589852 = query.getOrDefault("updateMask")
  valid_589852 = validateParameter(valid_589852, JString, required = false,
                                 default = nil)
  if valid_589852 != nil:
    section.add "updateMask", valid_589852
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

proc call*(call_589854: Call_AndroidenterpriseDevicesUpdate_589839; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the device policy
  ## 
  let valid = call_589854.validator(path, query, header, formData, body)
  let scheme = call_589854.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589854.url(scheme.get, call_589854.host, call_589854.base,
                         call_589854.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589854, url, valid)

proc call*(call_589855: Call_AndroidenterpriseDevicesUpdate_589839;
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
  var path_589856 = newJObject()
  var query_589857 = newJObject()
  var body_589858 = newJObject()
  add(query_589857, "fields", newJString(fields))
  add(query_589857, "quotaUser", newJString(quotaUser))
  add(query_589857, "alt", newJString(alt))
  add(path_589856, "deviceId", newJString(deviceId))
  add(query_589857, "oauth_token", newJString(oauthToken))
  add(query_589857, "userIp", newJString(userIp))
  add(query_589857, "key", newJString(key))
  add(path_589856, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589858 = body
  add(query_589857, "prettyPrint", newJBool(prettyPrint))
  add(query_589857, "updateMask", newJString(updateMask))
  add(path_589856, "userId", newJString(userId))
  result = call_589855.call(path_589856, query_589857, nil, nil, body_589858)

var androidenterpriseDevicesUpdate* = Call_AndroidenterpriseDevicesUpdate_589839(
    name: "androidenterpriseDevicesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}",
    validator: validate_AndroidenterpriseDevicesUpdate_589840,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesUpdate_589841,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesGet_589822 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseDevicesGet_589824(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseDevicesGet_589823(path: JsonNode; query: JsonNode;
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
  var valid_589825 = path.getOrDefault("deviceId")
  valid_589825 = validateParameter(valid_589825, JString, required = true,
                                 default = nil)
  if valid_589825 != nil:
    section.add "deviceId", valid_589825
  var valid_589826 = path.getOrDefault("enterpriseId")
  valid_589826 = validateParameter(valid_589826, JString, required = true,
                                 default = nil)
  if valid_589826 != nil:
    section.add "enterpriseId", valid_589826
  var valid_589827 = path.getOrDefault("userId")
  valid_589827 = validateParameter(valid_589827, JString, required = true,
                                 default = nil)
  if valid_589827 != nil:
    section.add "userId", valid_589827
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
  var valid_589828 = query.getOrDefault("fields")
  valid_589828 = validateParameter(valid_589828, JString, required = false,
                                 default = nil)
  if valid_589828 != nil:
    section.add "fields", valid_589828
  var valid_589829 = query.getOrDefault("quotaUser")
  valid_589829 = validateParameter(valid_589829, JString, required = false,
                                 default = nil)
  if valid_589829 != nil:
    section.add "quotaUser", valid_589829
  var valid_589830 = query.getOrDefault("alt")
  valid_589830 = validateParameter(valid_589830, JString, required = false,
                                 default = newJString("json"))
  if valid_589830 != nil:
    section.add "alt", valid_589830
  var valid_589831 = query.getOrDefault("oauth_token")
  valid_589831 = validateParameter(valid_589831, JString, required = false,
                                 default = nil)
  if valid_589831 != nil:
    section.add "oauth_token", valid_589831
  var valid_589832 = query.getOrDefault("userIp")
  valid_589832 = validateParameter(valid_589832, JString, required = false,
                                 default = nil)
  if valid_589832 != nil:
    section.add "userIp", valid_589832
  var valid_589833 = query.getOrDefault("key")
  valid_589833 = validateParameter(valid_589833, JString, required = false,
                                 default = nil)
  if valid_589833 != nil:
    section.add "key", valid_589833
  var valid_589834 = query.getOrDefault("prettyPrint")
  valid_589834 = validateParameter(valid_589834, JBool, required = false,
                                 default = newJBool(true))
  if valid_589834 != nil:
    section.add "prettyPrint", valid_589834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589835: Call_AndroidenterpriseDevicesGet_589822; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of a device.
  ## 
  let valid = call_589835.validator(path, query, header, formData, body)
  let scheme = call_589835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589835.url(scheme.get, call_589835.host, call_589835.base,
                         call_589835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589835, url, valid)

proc call*(call_589836: Call_AndroidenterpriseDevicesGet_589822; deviceId: string;
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
  var path_589837 = newJObject()
  var query_589838 = newJObject()
  add(query_589838, "fields", newJString(fields))
  add(query_589838, "quotaUser", newJString(quotaUser))
  add(query_589838, "alt", newJString(alt))
  add(path_589837, "deviceId", newJString(deviceId))
  add(query_589838, "oauth_token", newJString(oauthToken))
  add(query_589838, "userIp", newJString(userIp))
  add(query_589838, "key", newJString(key))
  add(path_589837, "enterpriseId", newJString(enterpriseId))
  add(query_589838, "prettyPrint", newJBool(prettyPrint))
  add(path_589837, "userId", newJString(userId))
  result = call_589836.call(path_589837, query_589838, nil, nil, nil)

var androidenterpriseDevicesGet* = Call_AndroidenterpriseDevicesGet_589822(
    name: "androidenterpriseDevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}",
    validator: validate_AndroidenterpriseDevicesGet_589823,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesGet_589824,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesPatch_589859 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseDevicesPatch_589861(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseDevicesPatch_589860(path: JsonNode; query: JsonNode;
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
  var valid_589862 = path.getOrDefault("deviceId")
  valid_589862 = validateParameter(valid_589862, JString, required = true,
                                 default = nil)
  if valid_589862 != nil:
    section.add "deviceId", valid_589862
  var valid_589863 = path.getOrDefault("enterpriseId")
  valid_589863 = validateParameter(valid_589863, JString, required = true,
                                 default = nil)
  if valid_589863 != nil:
    section.add "enterpriseId", valid_589863
  var valid_589864 = path.getOrDefault("userId")
  valid_589864 = validateParameter(valid_589864, JString, required = true,
                                 default = nil)
  if valid_589864 != nil:
    section.add "userId", valid_589864
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
  var valid_589865 = query.getOrDefault("fields")
  valid_589865 = validateParameter(valid_589865, JString, required = false,
                                 default = nil)
  if valid_589865 != nil:
    section.add "fields", valid_589865
  var valid_589866 = query.getOrDefault("quotaUser")
  valid_589866 = validateParameter(valid_589866, JString, required = false,
                                 default = nil)
  if valid_589866 != nil:
    section.add "quotaUser", valid_589866
  var valid_589867 = query.getOrDefault("alt")
  valid_589867 = validateParameter(valid_589867, JString, required = false,
                                 default = newJString("json"))
  if valid_589867 != nil:
    section.add "alt", valid_589867
  var valid_589868 = query.getOrDefault("oauth_token")
  valid_589868 = validateParameter(valid_589868, JString, required = false,
                                 default = nil)
  if valid_589868 != nil:
    section.add "oauth_token", valid_589868
  var valid_589869 = query.getOrDefault("userIp")
  valid_589869 = validateParameter(valid_589869, JString, required = false,
                                 default = nil)
  if valid_589869 != nil:
    section.add "userIp", valid_589869
  var valid_589870 = query.getOrDefault("key")
  valid_589870 = validateParameter(valid_589870, JString, required = false,
                                 default = nil)
  if valid_589870 != nil:
    section.add "key", valid_589870
  var valid_589871 = query.getOrDefault("prettyPrint")
  valid_589871 = validateParameter(valid_589871, JBool, required = false,
                                 default = newJBool(true))
  if valid_589871 != nil:
    section.add "prettyPrint", valid_589871
  var valid_589872 = query.getOrDefault("updateMask")
  valid_589872 = validateParameter(valid_589872, JString, required = false,
                                 default = nil)
  if valid_589872 != nil:
    section.add "updateMask", valid_589872
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

proc call*(call_589874: Call_AndroidenterpriseDevicesPatch_589859; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the device policy. This method supports patch semantics.
  ## 
  let valid = call_589874.validator(path, query, header, formData, body)
  let scheme = call_589874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589874.url(scheme.get, call_589874.host, call_589874.base,
                         call_589874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589874, url, valid)

proc call*(call_589875: Call_AndroidenterpriseDevicesPatch_589859;
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
  var path_589876 = newJObject()
  var query_589877 = newJObject()
  var body_589878 = newJObject()
  add(query_589877, "fields", newJString(fields))
  add(query_589877, "quotaUser", newJString(quotaUser))
  add(query_589877, "alt", newJString(alt))
  add(path_589876, "deviceId", newJString(deviceId))
  add(query_589877, "oauth_token", newJString(oauthToken))
  add(query_589877, "userIp", newJString(userIp))
  add(query_589877, "key", newJString(key))
  add(path_589876, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589878 = body
  add(query_589877, "prettyPrint", newJBool(prettyPrint))
  add(query_589877, "updateMask", newJString(updateMask))
  add(path_589876, "userId", newJString(userId))
  result = call_589875.call(path_589876, query_589877, nil, nil, body_589878)

var androidenterpriseDevicesPatch* = Call_AndroidenterpriseDevicesPatch_589859(
    name: "androidenterpriseDevicesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}",
    validator: validate_AndroidenterpriseDevicesPatch_589860,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesPatch_589861,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesForceReportUpload_589879 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseDevicesForceReportUpload_589881(protocol: Scheme;
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

proc validate_AndroidenterpriseDevicesForceReportUpload_589880(path: JsonNode;
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
  var valid_589882 = path.getOrDefault("deviceId")
  valid_589882 = validateParameter(valid_589882, JString, required = true,
                                 default = nil)
  if valid_589882 != nil:
    section.add "deviceId", valid_589882
  var valid_589883 = path.getOrDefault("enterpriseId")
  valid_589883 = validateParameter(valid_589883, JString, required = true,
                                 default = nil)
  if valid_589883 != nil:
    section.add "enterpriseId", valid_589883
  var valid_589884 = path.getOrDefault("userId")
  valid_589884 = validateParameter(valid_589884, JString, required = true,
                                 default = nil)
  if valid_589884 != nil:
    section.add "userId", valid_589884
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
  var valid_589885 = query.getOrDefault("fields")
  valid_589885 = validateParameter(valid_589885, JString, required = false,
                                 default = nil)
  if valid_589885 != nil:
    section.add "fields", valid_589885
  var valid_589886 = query.getOrDefault("quotaUser")
  valid_589886 = validateParameter(valid_589886, JString, required = false,
                                 default = nil)
  if valid_589886 != nil:
    section.add "quotaUser", valid_589886
  var valid_589887 = query.getOrDefault("alt")
  valid_589887 = validateParameter(valid_589887, JString, required = false,
                                 default = newJString("json"))
  if valid_589887 != nil:
    section.add "alt", valid_589887
  var valid_589888 = query.getOrDefault("oauth_token")
  valid_589888 = validateParameter(valid_589888, JString, required = false,
                                 default = nil)
  if valid_589888 != nil:
    section.add "oauth_token", valid_589888
  var valid_589889 = query.getOrDefault("userIp")
  valid_589889 = validateParameter(valid_589889, JString, required = false,
                                 default = nil)
  if valid_589889 != nil:
    section.add "userIp", valid_589889
  var valid_589890 = query.getOrDefault("key")
  valid_589890 = validateParameter(valid_589890, JString, required = false,
                                 default = nil)
  if valid_589890 != nil:
    section.add "key", valid_589890
  var valid_589891 = query.getOrDefault("prettyPrint")
  valid_589891 = validateParameter(valid_589891, JBool, required = false,
                                 default = newJBool(true))
  if valid_589891 != nil:
    section.add "prettyPrint", valid_589891
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589892: Call_AndroidenterpriseDevicesForceReportUpload_589879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads a report containing any changes in app states on the device since the last report was generated. You can call this method up to 3 times every 24 hours for a given device.
  ## 
  let valid = call_589892.validator(path, query, header, formData, body)
  let scheme = call_589892.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589892.url(scheme.get, call_589892.host, call_589892.base,
                         call_589892.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589892, url, valid)

proc call*(call_589893: Call_AndroidenterpriseDevicesForceReportUpload_589879;
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
  var path_589894 = newJObject()
  var query_589895 = newJObject()
  add(query_589895, "fields", newJString(fields))
  add(query_589895, "quotaUser", newJString(quotaUser))
  add(query_589895, "alt", newJString(alt))
  add(path_589894, "deviceId", newJString(deviceId))
  add(query_589895, "oauth_token", newJString(oauthToken))
  add(query_589895, "userIp", newJString(userIp))
  add(query_589895, "key", newJString(key))
  add(path_589894, "enterpriseId", newJString(enterpriseId))
  add(query_589895, "prettyPrint", newJBool(prettyPrint))
  add(path_589894, "userId", newJString(userId))
  result = call_589893.call(path_589894, query_589895, nil, nil, nil)

var androidenterpriseDevicesForceReportUpload* = Call_AndroidenterpriseDevicesForceReportUpload_589879(
    name: "androidenterpriseDevicesForceReportUpload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/forceReportUpload",
    validator: validate_AndroidenterpriseDevicesForceReportUpload_589880,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseDevicesForceReportUpload_589881,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsList_589896 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseInstallsList_589898(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseInstallsList_589897(path: JsonNode; query: JsonNode;
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
  var valid_589899 = path.getOrDefault("deviceId")
  valid_589899 = validateParameter(valid_589899, JString, required = true,
                                 default = nil)
  if valid_589899 != nil:
    section.add "deviceId", valid_589899
  var valid_589900 = path.getOrDefault("enterpriseId")
  valid_589900 = validateParameter(valid_589900, JString, required = true,
                                 default = nil)
  if valid_589900 != nil:
    section.add "enterpriseId", valid_589900
  var valid_589901 = path.getOrDefault("userId")
  valid_589901 = validateParameter(valid_589901, JString, required = true,
                                 default = nil)
  if valid_589901 != nil:
    section.add "userId", valid_589901
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
  var valid_589902 = query.getOrDefault("fields")
  valid_589902 = validateParameter(valid_589902, JString, required = false,
                                 default = nil)
  if valid_589902 != nil:
    section.add "fields", valid_589902
  var valid_589903 = query.getOrDefault("quotaUser")
  valid_589903 = validateParameter(valid_589903, JString, required = false,
                                 default = nil)
  if valid_589903 != nil:
    section.add "quotaUser", valid_589903
  var valid_589904 = query.getOrDefault("alt")
  valid_589904 = validateParameter(valid_589904, JString, required = false,
                                 default = newJString("json"))
  if valid_589904 != nil:
    section.add "alt", valid_589904
  var valid_589905 = query.getOrDefault("oauth_token")
  valid_589905 = validateParameter(valid_589905, JString, required = false,
                                 default = nil)
  if valid_589905 != nil:
    section.add "oauth_token", valid_589905
  var valid_589906 = query.getOrDefault("userIp")
  valid_589906 = validateParameter(valid_589906, JString, required = false,
                                 default = nil)
  if valid_589906 != nil:
    section.add "userIp", valid_589906
  var valid_589907 = query.getOrDefault("key")
  valid_589907 = validateParameter(valid_589907, JString, required = false,
                                 default = nil)
  if valid_589907 != nil:
    section.add "key", valid_589907
  var valid_589908 = query.getOrDefault("prettyPrint")
  valid_589908 = validateParameter(valid_589908, JBool, required = false,
                                 default = newJBool(true))
  if valid_589908 != nil:
    section.add "prettyPrint", valid_589908
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589909: Call_AndroidenterpriseInstallsList_589896; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of all apps installed on the specified device.
  ## 
  let valid = call_589909.validator(path, query, header, formData, body)
  let scheme = call_589909.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589909.url(scheme.get, call_589909.host, call_589909.base,
                         call_589909.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589909, url, valid)

proc call*(call_589910: Call_AndroidenterpriseInstallsList_589896;
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
  var path_589911 = newJObject()
  var query_589912 = newJObject()
  add(query_589912, "fields", newJString(fields))
  add(query_589912, "quotaUser", newJString(quotaUser))
  add(query_589912, "alt", newJString(alt))
  add(path_589911, "deviceId", newJString(deviceId))
  add(query_589912, "oauth_token", newJString(oauthToken))
  add(query_589912, "userIp", newJString(userIp))
  add(query_589912, "key", newJString(key))
  add(path_589911, "enterpriseId", newJString(enterpriseId))
  add(query_589912, "prettyPrint", newJBool(prettyPrint))
  add(path_589911, "userId", newJString(userId))
  result = call_589910.call(path_589911, query_589912, nil, nil, nil)

var androidenterpriseInstallsList* = Call_AndroidenterpriseInstallsList_589896(
    name: "androidenterpriseInstallsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs",
    validator: validate_AndroidenterpriseInstallsList_589897,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsList_589898,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsUpdate_589931 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseInstallsUpdate_589933(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseInstallsUpdate_589932(path: JsonNode;
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
  var valid_589934 = path.getOrDefault("installId")
  valid_589934 = validateParameter(valid_589934, JString, required = true,
                                 default = nil)
  if valid_589934 != nil:
    section.add "installId", valid_589934
  var valid_589935 = path.getOrDefault("deviceId")
  valid_589935 = validateParameter(valid_589935, JString, required = true,
                                 default = nil)
  if valid_589935 != nil:
    section.add "deviceId", valid_589935
  var valid_589936 = path.getOrDefault("enterpriseId")
  valid_589936 = validateParameter(valid_589936, JString, required = true,
                                 default = nil)
  if valid_589936 != nil:
    section.add "enterpriseId", valid_589936
  var valid_589937 = path.getOrDefault("userId")
  valid_589937 = validateParameter(valid_589937, JString, required = true,
                                 default = nil)
  if valid_589937 != nil:
    section.add "userId", valid_589937
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
  var valid_589938 = query.getOrDefault("fields")
  valid_589938 = validateParameter(valid_589938, JString, required = false,
                                 default = nil)
  if valid_589938 != nil:
    section.add "fields", valid_589938
  var valid_589939 = query.getOrDefault("quotaUser")
  valid_589939 = validateParameter(valid_589939, JString, required = false,
                                 default = nil)
  if valid_589939 != nil:
    section.add "quotaUser", valid_589939
  var valid_589940 = query.getOrDefault("alt")
  valid_589940 = validateParameter(valid_589940, JString, required = false,
                                 default = newJString("json"))
  if valid_589940 != nil:
    section.add "alt", valid_589940
  var valid_589941 = query.getOrDefault("oauth_token")
  valid_589941 = validateParameter(valid_589941, JString, required = false,
                                 default = nil)
  if valid_589941 != nil:
    section.add "oauth_token", valid_589941
  var valid_589942 = query.getOrDefault("userIp")
  valid_589942 = validateParameter(valid_589942, JString, required = false,
                                 default = nil)
  if valid_589942 != nil:
    section.add "userIp", valid_589942
  var valid_589943 = query.getOrDefault("key")
  valid_589943 = validateParameter(valid_589943, JString, required = false,
                                 default = nil)
  if valid_589943 != nil:
    section.add "key", valid_589943
  var valid_589944 = query.getOrDefault("prettyPrint")
  valid_589944 = validateParameter(valid_589944, JBool, required = false,
                                 default = newJBool(true))
  if valid_589944 != nil:
    section.add "prettyPrint", valid_589944
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

proc call*(call_589946: Call_AndroidenterpriseInstallsUpdate_589931;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary.
  ## 
  let valid = call_589946.validator(path, query, header, formData, body)
  let scheme = call_589946.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589946.url(scheme.get, call_589946.host, call_589946.base,
                         call_589946.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589946, url, valid)

proc call*(call_589947: Call_AndroidenterpriseInstallsUpdate_589931;
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
  var path_589948 = newJObject()
  var query_589949 = newJObject()
  var body_589950 = newJObject()
  add(query_589949, "fields", newJString(fields))
  add(query_589949, "quotaUser", newJString(quotaUser))
  add(path_589948, "installId", newJString(installId))
  add(query_589949, "alt", newJString(alt))
  add(path_589948, "deviceId", newJString(deviceId))
  add(query_589949, "oauth_token", newJString(oauthToken))
  add(query_589949, "userIp", newJString(userIp))
  add(query_589949, "key", newJString(key))
  add(path_589948, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589950 = body
  add(query_589949, "prettyPrint", newJBool(prettyPrint))
  add(path_589948, "userId", newJString(userId))
  result = call_589947.call(path_589948, query_589949, nil, nil, body_589950)

var androidenterpriseInstallsUpdate* = Call_AndroidenterpriseInstallsUpdate_589931(
    name: "androidenterpriseInstallsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsUpdate_589932,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsUpdate_589933,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsGet_589913 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseInstallsGet_589915(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseInstallsGet_589914(path: JsonNode; query: JsonNode;
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
  var valid_589916 = path.getOrDefault("installId")
  valid_589916 = validateParameter(valid_589916, JString, required = true,
                                 default = nil)
  if valid_589916 != nil:
    section.add "installId", valid_589916
  var valid_589917 = path.getOrDefault("deviceId")
  valid_589917 = validateParameter(valid_589917, JString, required = true,
                                 default = nil)
  if valid_589917 != nil:
    section.add "deviceId", valid_589917
  var valid_589918 = path.getOrDefault("enterpriseId")
  valid_589918 = validateParameter(valid_589918, JString, required = true,
                                 default = nil)
  if valid_589918 != nil:
    section.add "enterpriseId", valid_589918
  var valid_589919 = path.getOrDefault("userId")
  valid_589919 = validateParameter(valid_589919, JString, required = true,
                                 default = nil)
  if valid_589919 != nil:
    section.add "userId", valid_589919
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
  var valid_589920 = query.getOrDefault("fields")
  valid_589920 = validateParameter(valid_589920, JString, required = false,
                                 default = nil)
  if valid_589920 != nil:
    section.add "fields", valid_589920
  var valid_589921 = query.getOrDefault("quotaUser")
  valid_589921 = validateParameter(valid_589921, JString, required = false,
                                 default = nil)
  if valid_589921 != nil:
    section.add "quotaUser", valid_589921
  var valid_589922 = query.getOrDefault("alt")
  valid_589922 = validateParameter(valid_589922, JString, required = false,
                                 default = newJString("json"))
  if valid_589922 != nil:
    section.add "alt", valid_589922
  var valid_589923 = query.getOrDefault("oauth_token")
  valid_589923 = validateParameter(valid_589923, JString, required = false,
                                 default = nil)
  if valid_589923 != nil:
    section.add "oauth_token", valid_589923
  var valid_589924 = query.getOrDefault("userIp")
  valid_589924 = validateParameter(valid_589924, JString, required = false,
                                 default = nil)
  if valid_589924 != nil:
    section.add "userIp", valid_589924
  var valid_589925 = query.getOrDefault("key")
  valid_589925 = validateParameter(valid_589925, JString, required = false,
                                 default = nil)
  if valid_589925 != nil:
    section.add "key", valid_589925
  var valid_589926 = query.getOrDefault("prettyPrint")
  valid_589926 = validateParameter(valid_589926, JBool, required = false,
                                 default = newJBool(true))
  if valid_589926 != nil:
    section.add "prettyPrint", valid_589926
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589927: Call_AndroidenterpriseInstallsGet_589913; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves details of an installation of an app on a device.
  ## 
  let valid = call_589927.validator(path, query, header, formData, body)
  let scheme = call_589927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589927.url(scheme.get, call_589927.host, call_589927.base,
                         call_589927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589927, url, valid)

proc call*(call_589928: Call_AndroidenterpriseInstallsGet_589913;
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
  var path_589929 = newJObject()
  var query_589930 = newJObject()
  add(query_589930, "fields", newJString(fields))
  add(query_589930, "quotaUser", newJString(quotaUser))
  add(path_589929, "installId", newJString(installId))
  add(query_589930, "alt", newJString(alt))
  add(path_589929, "deviceId", newJString(deviceId))
  add(query_589930, "oauth_token", newJString(oauthToken))
  add(query_589930, "userIp", newJString(userIp))
  add(query_589930, "key", newJString(key))
  add(path_589929, "enterpriseId", newJString(enterpriseId))
  add(query_589930, "prettyPrint", newJBool(prettyPrint))
  add(path_589929, "userId", newJString(userId))
  result = call_589928.call(path_589929, query_589930, nil, nil, nil)

var androidenterpriseInstallsGet* = Call_AndroidenterpriseInstallsGet_589913(
    name: "androidenterpriseInstallsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsGet_589914,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsGet_589915,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsPatch_589969 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseInstallsPatch_589971(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseInstallsPatch_589970(path: JsonNode;
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
  var valid_589972 = path.getOrDefault("installId")
  valid_589972 = validateParameter(valid_589972, JString, required = true,
                                 default = nil)
  if valid_589972 != nil:
    section.add "installId", valid_589972
  var valid_589973 = path.getOrDefault("deviceId")
  valid_589973 = validateParameter(valid_589973, JString, required = true,
                                 default = nil)
  if valid_589973 != nil:
    section.add "deviceId", valid_589973
  var valid_589974 = path.getOrDefault("enterpriseId")
  valid_589974 = validateParameter(valid_589974, JString, required = true,
                                 default = nil)
  if valid_589974 != nil:
    section.add "enterpriseId", valid_589974
  var valid_589975 = path.getOrDefault("userId")
  valid_589975 = validateParameter(valid_589975, JString, required = true,
                                 default = nil)
  if valid_589975 != nil:
    section.add "userId", valid_589975
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
  var valid_589976 = query.getOrDefault("fields")
  valid_589976 = validateParameter(valid_589976, JString, required = false,
                                 default = nil)
  if valid_589976 != nil:
    section.add "fields", valid_589976
  var valid_589977 = query.getOrDefault("quotaUser")
  valid_589977 = validateParameter(valid_589977, JString, required = false,
                                 default = nil)
  if valid_589977 != nil:
    section.add "quotaUser", valid_589977
  var valid_589978 = query.getOrDefault("alt")
  valid_589978 = validateParameter(valid_589978, JString, required = false,
                                 default = newJString("json"))
  if valid_589978 != nil:
    section.add "alt", valid_589978
  var valid_589979 = query.getOrDefault("oauth_token")
  valid_589979 = validateParameter(valid_589979, JString, required = false,
                                 default = nil)
  if valid_589979 != nil:
    section.add "oauth_token", valid_589979
  var valid_589980 = query.getOrDefault("userIp")
  valid_589980 = validateParameter(valid_589980, JString, required = false,
                                 default = nil)
  if valid_589980 != nil:
    section.add "userIp", valid_589980
  var valid_589981 = query.getOrDefault("key")
  valid_589981 = validateParameter(valid_589981, JString, required = false,
                                 default = nil)
  if valid_589981 != nil:
    section.add "key", valid_589981
  var valid_589982 = query.getOrDefault("prettyPrint")
  valid_589982 = validateParameter(valid_589982, JBool, required = false,
                                 default = newJBool(true))
  if valid_589982 != nil:
    section.add "prettyPrint", valid_589982
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

proc call*(call_589984: Call_AndroidenterpriseInstallsPatch_589969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Requests to install the latest version of an app to a device. If the app is already installed, then it is updated to the latest version if necessary. This method supports patch semantics.
  ## 
  let valid = call_589984.validator(path, query, header, formData, body)
  let scheme = call_589984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589984.url(scheme.get, call_589984.host, call_589984.base,
                         call_589984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589984, url, valid)

proc call*(call_589985: Call_AndroidenterpriseInstallsPatch_589969;
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
  var path_589986 = newJObject()
  var query_589987 = newJObject()
  var body_589988 = newJObject()
  add(query_589987, "fields", newJString(fields))
  add(query_589987, "quotaUser", newJString(quotaUser))
  add(path_589986, "installId", newJString(installId))
  add(query_589987, "alt", newJString(alt))
  add(path_589986, "deviceId", newJString(deviceId))
  add(query_589987, "oauth_token", newJString(oauthToken))
  add(query_589987, "userIp", newJString(userIp))
  add(query_589987, "key", newJString(key))
  add(path_589986, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_589988 = body
  add(query_589987, "prettyPrint", newJBool(prettyPrint))
  add(path_589986, "userId", newJString(userId))
  result = call_589985.call(path_589986, query_589987, nil, nil, body_589988)

var androidenterpriseInstallsPatch* = Call_AndroidenterpriseInstallsPatch_589969(
    name: "androidenterpriseInstallsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsPatch_589970,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsPatch_589971,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseInstallsDelete_589951 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseInstallsDelete_589953(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseInstallsDelete_589952(path: JsonNode;
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
  var valid_589954 = path.getOrDefault("installId")
  valid_589954 = validateParameter(valid_589954, JString, required = true,
                                 default = nil)
  if valid_589954 != nil:
    section.add "installId", valid_589954
  var valid_589955 = path.getOrDefault("deviceId")
  valid_589955 = validateParameter(valid_589955, JString, required = true,
                                 default = nil)
  if valid_589955 != nil:
    section.add "deviceId", valid_589955
  var valid_589956 = path.getOrDefault("enterpriseId")
  valid_589956 = validateParameter(valid_589956, JString, required = true,
                                 default = nil)
  if valid_589956 != nil:
    section.add "enterpriseId", valid_589956
  var valid_589957 = path.getOrDefault("userId")
  valid_589957 = validateParameter(valid_589957, JString, required = true,
                                 default = nil)
  if valid_589957 != nil:
    section.add "userId", valid_589957
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
  var valid_589958 = query.getOrDefault("fields")
  valid_589958 = validateParameter(valid_589958, JString, required = false,
                                 default = nil)
  if valid_589958 != nil:
    section.add "fields", valid_589958
  var valid_589959 = query.getOrDefault("quotaUser")
  valid_589959 = validateParameter(valid_589959, JString, required = false,
                                 default = nil)
  if valid_589959 != nil:
    section.add "quotaUser", valid_589959
  var valid_589960 = query.getOrDefault("alt")
  valid_589960 = validateParameter(valid_589960, JString, required = false,
                                 default = newJString("json"))
  if valid_589960 != nil:
    section.add "alt", valid_589960
  var valid_589961 = query.getOrDefault("oauth_token")
  valid_589961 = validateParameter(valid_589961, JString, required = false,
                                 default = nil)
  if valid_589961 != nil:
    section.add "oauth_token", valid_589961
  var valid_589962 = query.getOrDefault("userIp")
  valid_589962 = validateParameter(valid_589962, JString, required = false,
                                 default = nil)
  if valid_589962 != nil:
    section.add "userIp", valid_589962
  var valid_589963 = query.getOrDefault("key")
  valid_589963 = validateParameter(valid_589963, JString, required = false,
                                 default = nil)
  if valid_589963 != nil:
    section.add "key", valid_589963
  var valid_589964 = query.getOrDefault("prettyPrint")
  valid_589964 = validateParameter(valid_589964, JBool, required = false,
                                 default = newJBool(true))
  if valid_589964 != nil:
    section.add "prettyPrint", valid_589964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589965: Call_AndroidenterpriseInstallsDelete_589951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Requests to remove an app from a device. A call to get or list will still show the app as installed on the device until it is actually removed.
  ## 
  let valid = call_589965.validator(path, query, header, formData, body)
  let scheme = call_589965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589965.url(scheme.get, call_589965.host, call_589965.base,
                         call_589965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589965, url, valid)

proc call*(call_589966: Call_AndroidenterpriseInstallsDelete_589951;
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
  var path_589967 = newJObject()
  var query_589968 = newJObject()
  add(query_589968, "fields", newJString(fields))
  add(query_589968, "quotaUser", newJString(quotaUser))
  add(path_589967, "installId", newJString(installId))
  add(query_589968, "alt", newJString(alt))
  add(path_589967, "deviceId", newJString(deviceId))
  add(query_589968, "oauth_token", newJString(oauthToken))
  add(query_589968, "userIp", newJString(userIp))
  add(query_589968, "key", newJString(key))
  add(path_589967, "enterpriseId", newJString(enterpriseId))
  add(query_589968, "prettyPrint", newJBool(prettyPrint))
  add(path_589967, "userId", newJString(userId))
  result = call_589966.call(path_589967, query_589968, nil, nil, nil)

var androidenterpriseInstallsDelete* = Call_AndroidenterpriseInstallsDelete_589951(
    name: "androidenterpriseInstallsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/installs/{installId}",
    validator: validate_AndroidenterpriseInstallsDelete_589952,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseInstallsDelete_589953,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceList_589989 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseManagedconfigurationsfordeviceList_589991(
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

proc validate_AndroidenterpriseManagedconfigurationsfordeviceList_589990(
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
  var valid_589992 = path.getOrDefault("deviceId")
  valid_589992 = validateParameter(valid_589992, JString, required = true,
                                 default = nil)
  if valid_589992 != nil:
    section.add "deviceId", valid_589992
  var valid_589993 = path.getOrDefault("enterpriseId")
  valid_589993 = validateParameter(valid_589993, JString, required = true,
                                 default = nil)
  if valid_589993 != nil:
    section.add "enterpriseId", valid_589993
  var valid_589994 = path.getOrDefault("userId")
  valid_589994 = validateParameter(valid_589994, JString, required = true,
                                 default = nil)
  if valid_589994 != nil:
    section.add "userId", valid_589994
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
  var valid_589995 = query.getOrDefault("fields")
  valid_589995 = validateParameter(valid_589995, JString, required = false,
                                 default = nil)
  if valid_589995 != nil:
    section.add "fields", valid_589995
  var valid_589996 = query.getOrDefault("quotaUser")
  valid_589996 = validateParameter(valid_589996, JString, required = false,
                                 default = nil)
  if valid_589996 != nil:
    section.add "quotaUser", valid_589996
  var valid_589997 = query.getOrDefault("alt")
  valid_589997 = validateParameter(valid_589997, JString, required = false,
                                 default = newJString("json"))
  if valid_589997 != nil:
    section.add "alt", valid_589997
  var valid_589998 = query.getOrDefault("oauth_token")
  valid_589998 = validateParameter(valid_589998, JString, required = false,
                                 default = nil)
  if valid_589998 != nil:
    section.add "oauth_token", valid_589998
  var valid_589999 = query.getOrDefault("userIp")
  valid_589999 = validateParameter(valid_589999, JString, required = false,
                                 default = nil)
  if valid_589999 != nil:
    section.add "userIp", valid_589999
  var valid_590000 = query.getOrDefault("key")
  valid_590000 = validateParameter(valid_590000, JString, required = false,
                                 default = nil)
  if valid_590000 != nil:
    section.add "key", valid_590000
  var valid_590001 = query.getOrDefault("prettyPrint")
  valid_590001 = validateParameter(valid_590001, JBool, required = false,
                                 default = newJBool(true))
  if valid_590001 != nil:
    section.add "prettyPrint", valid_590001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590002: Call_AndroidenterpriseManagedconfigurationsfordeviceList_589989;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the per-device managed configurations for the specified device. Only the ID is set.
  ## 
  let valid = call_590002.validator(path, query, header, formData, body)
  let scheme = call_590002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590002.url(scheme.get, call_590002.host, call_590002.base,
                         call_590002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590002, url, valid)

proc call*(call_590003: Call_AndroidenterpriseManagedconfigurationsfordeviceList_589989;
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
  var path_590004 = newJObject()
  var query_590005 = newJObject()
  add(query_590005, "fields", newJString(fields))
  add(query_590005, "quotaUser", newJString(quotaUser))
  add(query_590005, "alt", newJString(alt))
  add(path_590004, "deviceId", newJString(deviceId))
  add(query_590005, "oauth_token", newJString(oauthToken))
  add(query_590005, "userIp", newJString(userIp))
  add(query_590005, "key", newJString(key))
  add(path_590004, "enterpriseId", newJString(enterpriseId))
  add(query_590005, "prettyPrint", newJBool(prettyPrint))
  add(path_590004, "userId", newJString(userId))
  result = call_590003.call(path_590004, query_590005, nil, nil, nil)

var androidenterpriseManagedconfigurationsfordeviceList* = Call_AndroidenterpriseManagedconfigurationsfordeviceList_589989(
    name: "androidenterpriseManagedconfigurationsfordeviceList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceList_589990,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceList_589991,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_590024 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseManagedconfigurationsfordeviceUpdate_590026(
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

proc validate_AndroidenterpriseManagedconfigurationsfordeviceUpdate_590025(
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
  var valid_590027 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_590027 = validateParameter(valid_590027, JString, required = true,
                                 default = nil)
  if valid_590027 != nil:
    section.add "managedConfigurationForDeviceId", valid_590027
  var valid_590028 = path.getOrDefault("deviceId")
  valid_590028 = validateParameter(valid_590028, JString, required = true,
                                 default = nil)
  if valid_590028 != nil:
    section.add "deviceId", valid_590028
  var valid_590029 = path.getOrDefault("enterpriseId")
  valid_590029 = validateParameter(valid_590029, JString, required = true,
                                 default = nil)
  if valid_590029 != nil:
    section.add "enterpriseId", valid_590029
  var valid_590030 = path.getOrDefault("userId")
  valid_590030 = validateParameter(valid_590030, JString, required = true,
                                 default = nil)
  if valid_590030 != nil:
    section.add "userId", valid_590030
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
  var valid_590031 = query.getOrDefault("fields")
  valid_590031 = validateParameter(valid_590031, JString, required = false,
                                 default = nil)
  if valid_590031 != nil:
    section.add "fields", valid_590031
  var valid_590032 = query.getOrDefault("quotaUser")
  valid_590032 = validateParameter(valid_590032, JString, required = false,
                                 default = nil)
  if valid_590032 != nil:
    section.add "quotaUser", valid_590032
  var valid_590033 = query.getOrDefault("alt")
  valid_590033 = validateParameter(valid_590033, JString, required = false,
                                 default = newJString("json"))
  if valid_590033 != nil:
    section.add "alt", valid_590033
  var valid_590034 = query.getOrDefault("oauth_token")
  valid_590034 = validateParameter(valid_590034, JString, required = false,
                                 default = nil)
  if valid_590034 != nil:
    section.add "oauth_token", valid_590034
  var valid_590035 = query.getOrDefault("userIp")
  valid_590035 = validateParameter(valid_590035, JString, required = false,
                                 default = nil)
  if valid_590035 != nil:
    section.add "userIp", valid_590035
  var valid_590036 = query.getOrDefault("key")
  valid_590036 = validateParameter(valid_590036, JString, required = false,
                                 default = nil)
  if valid_590036 != nil:
    section.add "key", valid_590036
  var valid_590037 = query.getOrDefault("prettyPrint")
  valid_590037 = validateParameter(valid_590037, JBool, required = false,
                                 default = newJBool(true))
  if valid_590037 != nil:
    section.add "prettyPrint", valid_590037
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

proc call*(call_590039: Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_590024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates a per-device managed configuration for an app for the specified device.
  ## 
  let valid = call_590039.validator(path, query, header, formData, body)
  let scheme = call_590039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590039.url(scheme.get, call_590039.host, call_590039.base,
                         call_590039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590039, url, valid)

proc call*(call_590040: Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_590024;
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
  var path_590041 = newJObject()
  var query_590042 = newJObject()
  var body_590043 = newJObject()
  add(query_590042, "fields", newJString(fields))
  add(query_590042, "quotaUser", newJString(quotaUser))
  add(path_590041, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_590042, "alt", newJString(alt))
  add(path_590041, "deviceId", newJString(deviceId))
  add(query_590042, "oauth_token", newJString(oauthToken))
  add(query_590042, "userIp", newJString(userIp))
  add(query_590042, "key", newJString(key))
  add(path_590041, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_590043 = body
  add(query_590042, "prettyPrint", newJBool(prettyPrint))
  add(path_590041, "userId", newJString(userId))
  result = call_590040.call(path_590041, query_590042, nil, nil, body_590043)

var androidenterpriseManagedconfigurationsfordeviceUpdate* = Call_AndroidenterpriseManagedconfigurationsfordeviceUpdate_590024(
    name: "androidenterpriseManagedconfigurationsfordeviceUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceUpdate_590025,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceUpdate_590026,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceGet_590006 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseManagedconfigurationsfordeviceGet_590008(
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

proc validate_AndroidenterpriseManagedconfigurationsfordeviceGet_590007(
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
  var valid_590009 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_590009 = validateParameter(valid_590009, JString, required = true,
                                 default = nil)
  if valid_590009 != nil:
    section.add "managedConfigurationForDeviceId", valid_590009
  var valid_590010 = path.getOrDefault("deviceId")
  valid_590010 = validateParameter(valid_590010, JString, required = true,
                                 default = nil)
  if valid_590010 != nil:
    section.add "deviceId", valid_590010
  var valid_590011 = path.getOrDefault("enterpriseId")
  valid_590011 = validateParameter(valid_590011, JString, required = true,
                                 default = nil)
  if valid_590011 != nil:
    section.add "enterpriseId", valid_590011
  var valid_590012 = path.getOrDefault("userId")
  valid_590012 = validateParameter(valid_590012, JString, required = true,
                                 default = nil)
  if valid_590012 != nil:
    section.add "userId", valid_590012
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
  var valid_590013 = query.getOrDefault("fields")
  valid_590013 = validateParameter(valid_590013, JString, required = false,
                                 default = nil)
  if valid_590013 != nil:
    section.add "fields", valid_590013
  var valid_590014 = query.getOrDefault("quotaUser")
  valid_590014 = validateParameter(valid_590014, JString, required = false,
                                 default = nil)
  if valid_590014 != nil:
    section.add "quotaUser", valid_590014
  var valid_590015 = query.getOrDefault("alt")
  valid_590015 = validateParameter(valid_590015, JString, required = false,
                                 default = newJString("json"))
  if valid_590015 != nil:
    section.add "alt", valid_590015
  var valid_590016 = query.getOrDefault("oauth_token")
  valid_590016 = validateParameter(valid_590016, JString, required = false,
                                 default = nil)
  if valid_590016 != nil:
    section.add "oauth_token", valid_590016
  var valid_590017 = query.getOrDefault("userIp")
  valid_590017 = validateParameter(valid_590017, JString, required = false,
                                 default = nil)
  if valid_590017 != nil:
    section.add "userIp", valid_590017
  var valid_590018 = query.getOrDefault("key")
  valid_590018 = validateParameter(valid_590018, JString, required = false,
                                 default = nil)
  if valid_590018 != nil:
    section.add "key", valid_590018
  var valid_590019 = query.getOrDefault("prettyPrint")
  valid_590019 = validateParameter(valid_590019, JBool, required = false,
                                 default = newJBool(true))
  if valid_590019 != nil:
    section.add "prettyPrint", valid_590019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590020: Call_AndroidenterpriseManagedconfigurationsfordeviceGet_590006;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a per-device managed configuration.
  ## 
  let valid = call_590020.validator(path, query, header, formData, body)
  let scheme = call_590020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590020.url(scheme.get, call_590020.host, call_590020.base,
                         call_590020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590020, url, valid)

proc call*(call_590021: Call_AndroidenterpriseManagedconfigurationsfordeviceGet_590006;
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
  var path_590022 = newJObject()
  var query_590023 = newJObject()
  add(query_590023, "fields", newJString(fields))
  add(query_590023, "quotaUser", newJString(quotaUser))
  add(path_590022, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_590023, "alt", newJString(alt))
  add(path_590022, "deviceId", newJString(deviceId))
  add(query_590023, "oauth_token", newJString(oauthToken))
  add(query_590023, "userIp", newJString(userIp))
  add(query_590023, "key", newJString(key))
  add(path_590022, "enterpriseId", newJString(enterpriseId))
  add(query_590023, "prettyPrint", newJBool(prettyPrint))
  add(path_590022, "userId", newJString(userId))
  result = call_590021.call(path_590022, query_590023, nil, nil, nil)

var androidenterpriseManagedconfigurationsfordeviceGet* = Call_AndroidenterpriseManagedconfigurationsfordeviceGet_590006(
    name: "androidenterpriseManagedconfigurationsfordeviceGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceGet_590007,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceGet_590008,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordevicePatch_590062 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseManagedconfigurationsfordevicePatch_590064(
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

proc validate_AndroidenterpriseManagedconfigurationsfordevicePatch_590063(
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
  var valid_590065 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_590065 = validateParameter(valid_590065, JString, required = true,
                                 default = nil)
  if valid_590065 != nil:
    section.add "managedConfigurationForDeviceId", valid_590065
  var valid_590066 = path.getOrDefault("deviceId")
  valid_590066 = validateParameter(valid_590066, JString, required = true,
                                 default = nil)
  if valid_590066 != nil:
    section.add "deviceId", valid_590066
  var valid_590067 = path.getOrDefault("enterpriseId")
  valid_590067 = validateParameter(valid_590067, JString, required = true,
                                 default = nil)
  if valid_590067 != nil:
    section.add "enterpriseId", valid_590067
  var valid_590068 = path.getOrDefault("userId")
  valid_590068 = validateParameter(valid_590068, JString, required = true,
                                 default = nil)
  if valid_590068 != nil:
    section.add "userId", valid_590068
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
  var valid_590069 = query.getOrDefault("fields")
  valid_590069 = validateParameter(valid_590069, JString, required = false,
                                 default = nil)
  if valid_590069 != nil:
    section.add "fields", valid_590069
  var valid_590070 = query.getOrDefault("quotaUser")
  valid_590070 = validateParameter(valid_590070, JString, required = false,
                                 default = nil)
  if valid_590070 != nil:
    section.add "quotaUser", valid_590070
  var valid_590071 = query.getOrDefault("alt")
  valid_590071 = validateParameter(valid_590071, JString, required = false,
                                 default = newJString("json"))
  if valid_590071 != nil:
    section.add "alt", valid_590071
  var valid_590072 = query.getOrDefault("oauth_token")
  valid_590072 = validateParameter(valid_590072, JString, required = false,
                                 default = nil)
  if valid_590072 != nil:
    section.add "oauth_token", valid_590072
  var valid_590073 = query.getOrDefault("userIp")
  valid_590073 = validateParameter(valid_590073, JString, required = false,
                                 default = nil)
  if valid_590073 != nil:
    section.add "userIp", valid_590073
  var valid_590074 = query.getOrDefault("key")
  valid_590074 = validateParameter(valid_590074, JString, required = false,
                                 default = nil)
  if valid_590074 != nil:
    section.add "key", valid_590074
  var valid_590075 = query.getOrDefault("prettyPrint")
  valid_590075 = validateParameter(valid_590075, JBool, required = false,
                                 default = newJBool(true))
  if valid_590075 != nil:
    section.add "prettyPrint", valid_590075
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

proc call*(call_590077: Call_AndroidenterpriseManagedconfigurationsfordevicePatch_590062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates a per-device managed configuration for an app for the specified device. This method supports patch semantics.
  ## 
  let valid = call_590077.validator(path, query, header, formData, body)
  let scheme = call_590077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590077.url(scheme.get, call_590077.host, call_590077.base,
                         call_590077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590077, url, valid)

proc call*(call_590078: Call_AndroidenterpriseManagedconfigurationsfordevicePatch_590062;
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
  var path_590079 = newJObject()
  var query_590080 = newJObject()
  var body_590081 = newJObject()
  add(query_590080, "fields", newJString(fields))
  add(query_590080, "quotaUser", newJString(quotaUser))
  add(path_590079, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_590080, "alt", newJString(alt))
  add(path_590079, "deviceId", newJString(deviceId))
  add(query_590080, "oauth_token", newJString(oauthToken))
  add(query_590080, "userIp", newJString(userIp))
  add(query_590080, "key", newJString(key))
  add(path_590079, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_590081 = body
  add(query_590080, "prettyPrint", newJBool(prettyPrint))
  add(path_590079, "userId", newJString(userId))
  result = call_590078.call(path_590079, query_590080, nil, nil, body_590081)

var androidenterpriseManagedconfigurationsfordevicePatch* = Call_AndroidenterpriseManagedconfigurationsfordevicePatch_590062(
    name: "androidenterpriseManagedconfigurationsfordevicePatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordevicePatch_590063,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordevicePatch_590064,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_590044 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseManagedconfigurationsfordeviceDelete_590046(
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

proc validate_AndroidenterpriseManagedconfigurationsfordeviceDelete_590045(
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
  var valid_590047 = path.getOrDefault("managedConfigurationForDeviceId")
  valid_590047 = validateParameter(valid_590047, JString, required = true,
                                 default = nil)
  if valid_590047 != nil:
    section.add "managedConfigurationForDeviceId", valid_590047
  var valid_590048 = path.getOrDefault("deviceId")
  valid_590048 = validateParameter(valid_590048, JString, required = true,
                                 default = nil)
  if valid_590048 != nil:
    section.add "deviceId", valid_590048
  var valid_590049 = path.getOrDefault("enterpriseId")
  valid_590049 = validateParameter(valid_590049, JString, required = true,
                                 default = nil)
  if valid_590049 != nil:
    section.add "enterpriseId", valid_590049
  var valid_590050 = path.getOrDefault("userId")
  valid_590050 = validateParameter(valid_590050, JString, required = true,
                                 default = nil)
  if valid_590050 != nil:
    section.add "userId", valid_590050
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
  var valid_590051 = query.getOrDefault("fields")
  valid_590051 = validateParameter(valid_590051, JString, required = false,
                                 default = nil)
  if valid_590051 != nil:
    section.add "fields", valid_590051
  var valid_590052 = query.getOrDefault("quotaUser")
  valid_590052 = validateParameter(valid_590052, JString, required = false,
                                 default = nil)
  if valid_590052 != nil:
    section.add "quotaUser", valid_590052
  var valid_590053 = query.getOrDefault("alt")
  valid_590053 = validateParameter(valid_590053, JString, required = false,
                                 default = newJString("json"))
  if valid_590053 != nil:
    section.add "alt", valid_590053
  var valid_590054 = query.getOrDefault("oauth_token")
  valid_590054 = validateParameter(valid_590054, JString, required = false,
                                 default = nil)
  if valid_590054 != nil:
    section.add "oauth_token", valid_590054
  var valid_590055 = query.getOrDefault("userIp")
  valid_590055 = validateParameter(valid_590055, JString, required = false,
                                 default = nil)
  if valid_590055 != nil:
    section.add "userIp", valid_590055
  var valid_590056 = query.getOrDefault("key")
  valid_590056 = validateParameter(valid_590056, JString, required = false,
                                 default = nil)
  if valid_590056 != nil:
    section.add "key", valid_590056
  var valid_590057 = query.getOrDefault("prettyPrint")
  valid_590057 = validateParameter(valid_590057, JBool, required = false,
                                 default = newJBool(true))
  if valid_590057 != nil:
    section.add "prettyPrint", valid_590057
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590058: Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_590044;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a per-device managed configuration for an app for the specified device.
  ## 
  let valid = call_590058.validator(path, query, header, formData, body)
  let scheme = call_590058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590058.url(scheme.get, call_590058.host, call_590058.base,
                         call_590058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590058, url, valid)

proc call*(call_590059: Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_590044;
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
  var path_590060 = newJObject()
  var query_590061 = newJObject()
  add(query_590061, "fields", newJString(fields))
  add(query_590061, "quotaUser", newJString(quotaUser))
  add(path_590060, "managedConfigurationForDeviceId",
      newJString(managedConfigurationForDeviceId))
  add(query_590061, "alt", newJString(alt))
  add(path_590060, "deviceId", newJString(deviceId))
  add(query_590061, "oauth_token", newJString(oauthToken))
  add(query_590061, "userIp", newJString(userIp))
  add(query_590061, "key", newJString(key))
  add(path_590060, "enterpriseId", newJString(enterpriseId))
  add(query_590061, "prettyPrint", newJBool(prettyPrint))
  add(path_590060, "userId", newJString(userId))
  result = call_590059.call(path_590060, query_590061, nil, nil, nil)

var androidenterpriseManagedconfigurationsfordeviceDelete* = Call_AndroidenterpriseManagedconfigurationsfordeviceDelete_590044(
    name: "androidenterpriseManagedconfigurationsfordeviceDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/managedConfigurationsForDevice/{managedConfigurationForDeviceId}",
    validator: validate_AndroidenterpriseManagedconfigurationsfordeviceDelete_590045,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsfordeviceDelete_590046,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesSetState_590099 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseDevicesSetState_590101(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseDevicesSetState_590100(path: JsonNode;
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
  var valid_590102 = path.getOrDefault("deviceId")
  valid_590102 = validateParameter(valid_590102, JString, required = true,
                                 default = nil)
  if valid_590102 != nil:
    section.add "deviceId", valid_590102
  var valid_590103 = path.getOrDefault("enterpriseId")
  valid_590103 = validateParameter(valid_590103, JString, required = true,
                                 default = nil)
  if valid_590103 != nil:
    section.add "enterpriseId", valid_590103
  var valid_590104 = path.getOrDefault("userId")
  valid_590104 = validateParameter(valid_590104, JString, required = true,
                                 default = nil)
  if valid_590104 != nil:
    section.add "userId", valid_590104
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
  var valid_590105 = query.getOrDefault("fields")
  valid_590105 = validateParameter(valid_590105, JString, required = false,
                                 default = nil)
  if valid_590105 != nil:
    section.add "fields", valid_590105
  var valid_590106 = query.getOrDefault("quotaUser")
  valid_590106 = validateParameter(valid_590106, JString, required = false,
                                 default = nil)
  if valid_590106 != nil:
    section.add "quotaUser", valid_590106
  var valid_590107 = query.getOrDefault("alt")
  valid_590107 = validateParameter(valid_590107, JString, required = false,
                                 default = newJString("json"))
  if valid_590107 != nil:
    section.add "alt", valid_590107
  var valid_590108 = query.getOrDefault("oauth_token")
  valid_590108 = validateParameter(valid_590108, JString, required = false,
                                 default = nil)
  if valid_590108 != nil:
    section.add "oauth_token", valid_590108
  var valid_590109 = query.getOrDefault("userIp")
  valid_590109 = validateParameter(valid_590109, JString, required = false,
                                 default = nil)
  if valid_590109 != nil:
    section.add "userIp", valid_590109
  var valid_590110 = query.getOrDefault("key")
  valid_590110 = validateParameter(valid_590110, JString, required = false,
                                 default = nil)
  if valid_590110 != nil:
    section.add "key", valid_590110
  var valid_590111 = query.getOrDefault("prettyPrint")
  valid_590111 = validateParameter(valid_590111, JBool, required = false,
                                 default = newJBool(true))
  if valid_590111 != nil:
    section.add "prettyPrint", valid_590111
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

proc call*(call_590113: Call_AndroidenterpriseDevicesSetState_590099;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ## 
  let valid = call_590113.validator(path, query, header, formData, body)
  let scheme = call_590113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590113.url(scheme.get, call_590113.host, call_590113.base,
                         call_590113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590113, url, valid)

proc call*(call_590114: Call_AndroidenterpriseDevicesSetState_590099;
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
  var path_590115 = newJObject()
  var query_590116 = newJObject()
  var body_590117 = newJObject()
  add(query_590116, "fields", newJString(fields))
  add(query_590116, "quotaUser", newJString(quotaUser))
  add(query_590116, "alt", newJString(alt))
  add(path_590115, "deviceId", newJString(deviceId))
  add(query_590116, "oauth_token", newJString(oauthToken))
  add(query_590116, "userIp", newJString(userIp))
  add(query_590116, "key", newJString(key))
  add(path_590115, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_590117 = body
  add(query_590116, "prettyPrint", newJBool(prettyPrint))
  add(path_590115, "userId", newJString(userId))
  result = call_590114.call(path_590115, query_590116, nil, nil, body_590117)

var androidenterpriseDevicesSetState* = Call_AndroidenterpriseDevicesSetState_590099(
    name: "androidenterpriseDevicesSetState", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/state",
    validator: validate_AndroidenterpriseDevicesSetState_590100,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesSetState_590101,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseDevicesGetState_590082 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseDevicesGetState_590084(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseDevicesGetState_590083(path: JsonNode;
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
  var valid_590085 = path.getOrDefault("deviceId")
  valid_590085 = validateParameter(valid_590085, JString, required = true,
                                 default = nil)
  if valid_590085 != nil:
    section.add "deviceId", valid_590085
  var valid_590086 = path.getOrDefault("enterpriseId")
  valid_590086 = validateParameter(valid_590086, JString, required = true,
                                 default = nil)
  if valid_590086 != nil:
    section.add "enterpriseId", valid_590086
  var valid_590087 = path.getOrDefault("userId")
  valid_590087 = validateParameter(valid_590087, JString, required = true,
                                 default = nil)
  if valid_590087 != nil:
    section.add "userId", valid_590087
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
  var valid_590088 = query.getOrDefault("fields")
  valid_590088 = validateParameter(valid_590088, JString, required = false,
                                 default = nil)
  if valid_590088 != nil:
    section.add "fields", valid_590088
  var valid_590089 = query.getOrDefault("quotaUser")
  valid_590089 = validateParameter(valid_590089, JString, required = false,
                                 default = nil)
  if valid_590089 != nil:
    section.add "quotaUser", valid_590089
  var valid_590090 = query.getOrDefault("alt")
  valid_590090 = validateParameter(valid_590090, JString, required = false,
                                 default = newJString("json"))
  if valid_590090 != nil:
    section.add "alt", valid_590090
  var valid_590091 = query.getOrDefault("oauth_token")
  valid_590091 = validateParameter(valid_590091, JString, required = false,
                                 default = nil)
  if valid_590091 != nil:
    section.add "oauth_token", valid_590091
  var valid_590092 = query.getOrDefault("userIp")
  valid_590092 = validateParameter(valid_590092, JString, required = false,
                                 default = nil)
  if valid_590092 != nil:
    section.add "userIp", valid_590092
  var valid_590093 = query.getOrDefault("key")
  valid_590093 = validateParameter(valid_590093, JString, required = false,
                                 default = nil)
  if valid_590093 != nil:
    section.add "key", valid_590093
  var valid_590094 = query.getOrDefault("prettyPrint")
  valid_590094 = validateParameter(valid_590094, JBool, required = false,
                                 default = newJBool(true))
  if valid_590094 != nil:
    section.add "prettyPrint", valid_590094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590095: Call_AndroidenterpriseDevicesGetState_590082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves whether a device's access to Google services is enabled or disabled. The device state takes effect only if enforcing EMM policies on Android devices is enabled in the Google Admin Console. Otherwise, the device state is ignored and all devices are allowed access to Google services. This is only supported for Google-managed users.
  ## 
  let valid = call_590095.validator(path, query, header, formData, body)
  let scheme = call_590095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590095.url(scheme.get, call_590095.host, call_590095.base,
                         call_590095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590095, url, valid)

proc call*(call_590096: Call_AndroidenterpriseDevicesGetState_590082;
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
  var path_590097 = newJObject()
  var query_590098 = newJObject()
  add(query_590098, "fields", newJString(fields))
  add(query_590098, "quotaUser", newJString(quotaUser))
  add(query_590098, "alt", newJString(alt))
  add(path_590097, "deviceId", newJString(deviceId))
  add(query_590098, "oauth_token", newJString(oauthToken))
  add(query_590098, "userIp", newJString(userIp))
  add(query_590098, "key", newJString(key))
  add(path_590097, "enterpriseId", newJString(enterpriseId))
  add(query_590098, "prettyPrint", newJBool(prettyPrint))
  add(path_590097, "userId", newJString(userId))
  result = call_590096.call(path_590097, query_590098, nil, nil, nil)

var androidenterpriseDevicesGetState* = Call_AndroidenterpriseDevicesGetState_590082(
    name: "androidenterpriseDevicesGetState", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/devices/{deviceId}/state",
    validator: validate_AndroidenterpriseDevicesGetState_590083,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseDevicesGetState_590084,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsList_590118 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEntitlementsList_590120(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseEntitlementsList_590119(path: JsonNode;
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
  var valid_590121 = path.getOrDefault("enterpriseId")
  valid_590121 = validateParameter(valid_590121, JString, required = true,
                                 default = nil)
  if valid_590121 != nil:
    section.add "enterpriseId", valid_590121
  var valid_590122 = path.getOrDefault("userId")
  valid_590122 = validateParameter(valid_590122, JString, required = true,
                                 default = nil)
  if valid_590122 != nil:
    section.add "userId", valid_590122
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
  var valid_590123 = query.getOrDefault("fields")
  valid_590123 = validateParameter(valid_590123, JString, required = false,
                                 default = nil)
  if valid_590123 != nil:
    section.add "fields", valid_590123
  var valid_590124 = query.getOrDefault("quotaUser")
  valid_590124 = validateParameter(valid_590124, JString, required = false,
                                 default = nil)
  if valid_590124 != nil:
    section.add "quotaUser", valid_590124
  var valid_590125 = query.getOrDefault("alt")
  valid_590125 = validateParameter(valid_590125, JString, required = false,
                                 default = newJString("json"))
  if valid_590125 != nil:
    section.add "alt", valid_590125
  var valid_590126 = query.getOrDefault("oauth_token")
  valid_590126 = validateParameter(valid_590126, JString, required = false,
                                 default = nil)
  if valid_590126 != nil:
    section.add "oauth_token", valid_590126
  var valid_590127 = query.getOrDefault("userIp")
  valid_590127 = validateParameter(valid_590127, JString, required = false,
                                 default = nil)
  if valid_590127 != nil:
    section.add "userIp", valid_590127
  var valid_590128 = query.getOrDefault("key")
  valid_590128 = validateParameter(valid_590128, JString, required = false,
                                 default = nil)
  if valid_590128 != nil:
    section.add "key", valid_590128
  var valid_590129 = query.getOrDefault("prettyPrint")
  valid_590129 = validateParameter(valid_590129, JBool, required = false,
                                 default = newJBool(true))
  if valid_590129 != nil:
    section.add "prettyPrint", valid_590129
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590130: Call_AndroidenterpriseEntitlementsList_590118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all entitlements for the specified user. Only the ID is set.
  ## 
  let valid = call_590130.validator(path, query, header, formData, body)
  let scheme = call_590130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590130.url(scheme.get, call_590130.host, call_590130.base,
                         call_590130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590130, url, valid)

proc call*(call_590131: Call_AndroidenterpriseEntitlementsList_590118;
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
  var path_590132 = newJObject()
  var query_590133 = newJObject()
  add(query_590133, "fields", newJString(fields))
  add(query_590133, "quotaUser", newJString(quotaUser))
  add(query_590133, "alt", newJString(alt))
  add(query_590133, "oauth_token", newJString(oauthToken))
  add(query_590133, "userIp", newJString(userIp))
  add(query_590133, "key", newJString(key))
  add(path_590132, "enterpriseId", newJString(enterpriseId))
  add(query_590133, "prettyPrint", newJBool(prettyPrint))
  add(path_590132, "userId", newJString(userId))
  result = call_590131.call(path_590132, query_590133, nil, nil, nil)

var androidenterpriseEntitlementsList* = Call_AndroidenterpriseEntitlementsList_590118(
    name: "androidenterpriseEntitlementsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/entitlements",
    validator: validate_AndroidenterpriseEntitlementsList_590119,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsList_590120,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsUpdate_590151 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEntitlementsUpdate_590153(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseEntitlementsUpdate_590152(path: JsonNode;
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
  var valid_590154 = path.getOrDefault("enterpriseId")
  valid_590154 = validateParameter(valid_590154, JString, required = true,
                                 default = nil)
  if valid_590154 != nil:
    section.add "enterpriseId", valid_590154
  var valid_590155 = path.getOrDefault("entitlementId")
  valid_590155 = validateParameter(valid_590155, JString, required = true,
                                 default = nil)
  if valid_590155 != nil:
    section.add "entitlementId", valid_590155
  var valid_590156 = path.getOrDefault("userId")
  valid_590156 = validateParameter(valid_590156, JString, required = true,
                                 default = nil)
  if valid_590156 != nil:
    section.add "userId", valid_590156
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
  var valid_590157 = query.getOrDefault("fields")
  valid_590157 = validateParameter(valid_590157, JString, required = false,
                                 default = nil)
  if valid_590157 != nil:
    section.add "fields", valid_590157
  var valid_590158 = query.getOrDefault("quotaUser")
  valid_590158 = validateParameter(valid_590158, JString, required = false,
                                 default = nil)
  if valid_590158 != nil:
    section.add "quotaUser", valid_590158
  var valid_590159 = query.getOrDefault("alt")
  valid_590159 = validateParameter(valid_590159, JString, required = false,
                                 default = newJString("json"))
  if valid_590159 != nil:
    section.add "alt", valid_590159
  var valid_590160 = query.getOrDefault("install")
  valid_590160 = validateParameter(valid_590160, JBool, required = false, default = nil)
  if valid_590160 != nil:
    section.add "install", valid_590160
  var valid_590161 = query.getOrDefault("oauth_token")
  valid_590161 = validateParameter(valid_590161, JString, required = false,
                                 default = nil)
  if valid_590161 != nil:
    section.add "oauth_token", valid_590161
  var valid_590162 = query.getOrDefault("userIp")
  valid_590162 = validateParameter(valid_590162, JString, required = false,
                                 default = nil)
  if valid_590162 != nil:
    section.add "userIp", valid_590162
  var valid_590163 = query.getOrDefault("key")
  valid_590163 = validateParameter(valid_590163, JString, required = false,
                                 default = nil)
  if valid_590163 != nil:
    section.add "key", valid_590163
  var valid_590164 = query.getOrDefault("prettyPrint")
  valid_590164 = validateParameter(valid_590164, JBool, required = false,
                                 default = newJBool(true))
  if valid_590164 != nil:
    section.add "prettyPrint", valid_590164
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

proc call*(call_590166: Call_AndroidenterpriseEntitlementsUpdate_590151;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates an entitlement to an app for a user.
  ## 
  let valid = call_590166.validator(path, query, header, formData, body)
  let scheme = call_590166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590166.url(scheme.get, call_590166.host, call_590166.base,
                         call_590166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590166, url, valid)

proc call*(call_590167: Call_AndroidenterpriseEntitlementsUpdate_590151;
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
  var path_590168 = newJObject()
  var query_590169 = newJObject()
  var body_590170 = newJObject()
  add(query_590169, "fields", newJString(fields))
  add(query_590169, "quotaUser", newJString(quotaUser))
  add(query_590169, "alt", newJString(alt))
  add(query_590169, "install", newJBool(install))
  add(query_590169, "oauth_token", newJString(oauthToken))
  add(query_590169, "userIp", newJString(userIp))
  add(query_590169, "key", newJString(key))
  add(path_590168, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_590170 = body
  add(query_590169, "prettyPrint", newJBool(prettyPrint))
  add(path_590168, "entitlementId", newJString(entitlementId))
  add(path_590168, "userId", newJString(userId))
  result = call_590167.call(path_590168, query_590169, nil, nil, body_590170)

var androidenterpriseEntitlementsUpdate* = Call_AndroidenterpriseEntitlementsUpdate_590151(
    name: "androidenterpriseEntitlementsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsUpdate_590152,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsUpdate_590153,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsGet_590134 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEntitlementsGet_590136(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseEntitlementsGet_590135(path: JsonNode;
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
  var valid_590137 = path.getOrDefault("enterpriseId")
  valid_590137 = validateParameter(valid_590137, JString, required = true,
                                 default = nil)
  if valid_590137 != nil:
    section.add "enterpriseId", valid_590137
  var valid_590138 = path.getOrDefault("entitlementId")
  valid_590138 = validateParameter(valid_590138, JString, required = true,
                                 default = nil)
  if valid_590138 != nil:
    section.add "entitlementId", valid_590138
  var valid_590139 = path.getOrDefault("userId")
  valid_590139 = validateParameter(valid_590139, JString, required = true,
                                 default = nil)
  if valid_590139 != nil:
    section.add "userId", valid_590139
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
  var valid_590140 = query.getOrDefault("fields")
  valid_590140 = validateParameter(valid_590140, JString, required = false,
                                 default = nil)
  if valid_590140 != nil:
    section.add "fields", valid_590140
  var valid_590141 = query.getOrDefault("quotaUser")
  valid_590141 = validateParameter(valid_590141, JString, required = false,
                                 default = nil)
  if valid_590141 != nil:
    section.add "quotaUser", valid_590141
  var valid_590142 = query.getOrDefault("alt")
  valid_590142 = validateParameter(valid_590142, JString, required = false,
                                 default = newJString("json"))
  if valid_590142 != nil:
    section.add "alt", valid_590142
  var valid_590143 = query.getOrDefault("oauth_token")
  valid_590143 = validateParameter(valid_590143, JString, required = false,
                                 default = nil)
  if valid_590143 != nil:
    section.add "oauth_token", valid_590143
  var valid_590144 = query.getOrDefault("userIp")
  valid_590144 = validateParameter(valid_590144, JString, required = false,
                                 default = nil)
  if valid_590144 != nil:
    section.add "userIp", valid_590144
  var valid_590145 = query.getOrDefault("key")
  valid_590145 = validateParameter(valid_590145, JString, required = false,
                                 default = nil)
  if valid_590145 != nil:
    section.add "key", valid_590145
  var valid_590146 = query.getOrDefault("prettyPrint")
  valid_590146 = validateParameter(valid_590146, JBool, required = false,
                                 default = newJBool(true))
  if valid_590146 != nil:
    section.add "prettyPrint", valid_590146
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590147: Call_AndroidenterpriseEntitlementsGet_590134;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of an entitlement.
  ## 
  let valid = call_590147.validator(path, query, header, formData, body)
  let scheme = call_590147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590147.url(scheme.get, call_590147.host, call_590147.base,
                         call_590147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590147, url, valid)

proc call*(call_590148: Call_AndroidenterpriseEntitlementsGet_590134;
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
  var path_590149 = newJObject()
  var query_590150 = newJObject()
  add(query_590150, "fields", newJString(fields))
  add(query_590150, "quotaUser", newJString(quotaUser))
  add(query_590150, "alt", newJString(alt))
  add(query_590150, "oauth_token", newJString(oauthToken))
  add(query_590150, "userIp", newJString(userIp))
  add(query_590150, "key", newJString(key))
  add(path_590149, "enterpriseId", newJString(enterpriseId))
  add(query_590150, "prettyPrint", newJBool(prettyPrint))
  add(path_590149, "entitlementId", newJString(entitlementId))
  add(path_590149, "userId", newJString(userId))
  result = call_590148.call(path_590149, query_590150, nil, nil, nil)

var androidenterpriseEntitlementsGet* = Call_AndroidenterpriseEntitlementsGet_590134(
    name: "androidenterpriseEntitlementsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsGet_590135,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsGet_590136,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsPatch_590188 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEntitlementsPatch_590190(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseEntitlementsPatch_590189(path: JsonNode;
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
  var valid_590191 = path.getOrDefault("enterpriseId")
  valid_590191 = validateParameter(valid_590191, JString, required = true,
                                 default = nil)
  if valid_590191 != nil:
    section.add "enterpriseId", valid_590191
  var valid_590192 = path.getOrDefault("entitlementId")
  valid_590192 = validateParameter(valid_590192, JString, required = true,
                                 default = nil)
  if valid_590192 != nil:
    section.add "entitlementId", valid_590192
  var valid_590193 = path.getOrDefault("userId")
  valid_590193 = validateParameter(valid_590193, JString, required = true,
                                 default = nil)
  if valid_590193 != nil:
    section.add "userId", valid_590193
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
  var valid_590194 = query.getOrDefault("fields")
  valid_590194 = validateParameter(valid_590194, JString, required = false,
                                 default = nil)
  if valid_590194 != nil:
    section.add "fields", valid_590194
  var valid_590195 = query.getOrDefault("quotaUser")
  valid_590195 = validateParameter(valid_590195, JString, required = false,
                                 default = nil)
  if valid_590195 != nil:
    section.add "quotaUser", valid_590195
  var valid_590196 = query.getOrDefault("alt")
  valid_590196 = validateParameter(valid_590196, JString, required = false,
                                 default = newJString("json"))
  if valid_590196 != nil:
    section.add "alt", valid_590196
  var valid_590197 = query.getOrDefault("install")
  valid_590197 = validateParameter(valid_590197, JBool, required = false, default = nil)
  if valid_590197 != nil:
    section.add "install", valid_590197
  var valid_590198 = query.getOrDefault("oauth_token")
  valid_590198 = validateParameter(valid_590198, JString, required = false,
                                 default = nil)
  if valid_590198 != nil:
    section.add "oauth_token", valid_590198
  var valid_590199 = query.getOrDefault("userIp")
  valid_590199 = validateParameter(valid_590199, JString, required = false,
                                 default = nil)
  if valid_590199 != nil:
    section.add "userIp", valid_590199
  var valid_590200 = query.getOrDefault("key")
  valid_590200 = validateParameter(valid_590200, JString, required = false,
                                 default = nil)
  if valid_590200 != nil:
    section.add "key", valid_590200
  var valid_590201 = query.getOrDefault("prettyPrint")
  valid_590201 = validateParameter(valid_590201, JBool, required = false,
                                 default = newJBool(true))
  if valid_590201 != nil:
    section.add "prettyPrint", valid_590201
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

proc call*(call_590203: Call_AndroidenterpriseEntitlementsPatch_590188;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates an entitlement to an app for a user. This method supports patch semantics.
  ## 
  let valid = call_590203.validator(path, query, header, formData, body)
  let scheme = call_590203.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590203.url(scheme.get, call_590203.host, call_590203.base,
                         call_590203.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590203, url, valid)

proc call*(call_590204: Call_AndroidenterpriseEntitlementsPatch_590188;
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
  var path_590205 = newJObject()
  var query_590206 = newJObject()
  var body_590207 = newJObject()
  add(query_590206, "fields", newJString(fields))
  add(query_590206, "quotaUser", newJString(quotaUser))
  add(query_590206, "alt", newJString(alt))
  add(query_590206, "install", newJBool(install))
  add(query_590206, "oauth_token", newJString(oauthToken))
  add(query_590206, "userIp", newJString(userIp))
  add(query_590206, "key", newJString(key))
  add(path_590205, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_590207 = body
  add(query_590206, "prettyPrint", newJBool(prettyPrint))
  add(path_590205, "entitlementId", newJString(entitlementId))
  add(path_590205, "userId", newJString(userId))
  result = call_590204.call(path_590205, query_590206, nil, nil, body_590207)

var androidenterpriseEntitlementsPatch* = Call_AndroidenterpriseEntitlementsPatch_590188(
    name: "androidenterpriseEntitlementsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsPatch_590189,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsPatch_590190,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseEntitlementsDelete_590171 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseEntitlementsDelete_590173(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseEntitlementsDelete_590172(path: JsonNode;
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
  var valid_590174 = path.getOrDefault("enterpriseId")
  valid_590174 = validateParameter(valid_590174, JString, required = true,
                                 default = nil)
  if valid_590174 != nil:
    section.add "enterpriseId", valid_590174
  var valid_590175 = path.getOrDefault("entitlementId")
  valid_590175 = validateParameter(valid_590175, JString, required = true,
                                 default = nil)
  if valid_590175 != nil:
    section.add "entitlementId", valid_590175
  var valid_590176 = path.getOrDefault("userId")
  valid_590176 = validateParameter(valid_590176, JString, required = true,
                                 default = nil)
  if valid_590176 != nil:
    section.add "userId", valid_590176
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
  var valid_590177 = query.getOrDefault("fields")
  valid_590177 = validateParameter(valid_590177, JString, required = false,
                                 default = nil)
  if valid_590177 != nil:
    section.add "fields", valid_590177
  var valid_590178 = query.getOrDefault("quotaUser")
  valid_590178 = validateParameter(valid_590178, JString, required = false,
                                 default = nil)
  if valid_590178 != nil:
    section.add "quotaUser", valid_590178
  var valid_590179 = query.getOrDefault("alt")
  valid_590179 = validateParameter(valid_590179, JString, required = false,
                                 default = newJString("json"))
  if valid_590179 != nil:
    section.add "alt", valid_590179
  var valid_590180 = query.getOrDefault("oauth_token")
  valid_590180 = validateParameter(valid_590180, JString, required = false,
                                 default = nil)
  if valid_590180 != nil:
    section.add "oauth_token", valid_590180
  var valid_590181 = query.getOrDefault("userIp")
  valid_590181 = validateParameter(valid_590181, JString, required = false,
                                 default = nil)
  if valid_590181 != nil:
    section.add "userIp", valid_590181
  var valid_590182 = query.getOrDefault("key")
  valid_590182 = validateParameter(valid_590182, JString, required = false,
                                 default = nil)
  if valid_590182 != nil:
    section.add "key", valid_590182
  var valid_590183 = query.getOrDefault("prettyPrint")
  valid_590183 = validateParameter(valid_590183, JBool, required = false,
                                 default = newJBool(true))
  if valid_590183 != nil:
    section.add "prettyPrint", valid_590183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590184: Call_AndroidenterpriseEntitlementsDelete_590171;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes an entitlement to an app for a user.
  ## 
  let valid = call_590184.validator(path, query, header, formData, body)
  let scheme = call_590184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590184.url(scheme.get, call_590184.host, call_590184.base,
                         call_590184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590184, url, valid)

proc call*(call_590185: Call_AndroidenterpriseEntitlementsDelete_590171;
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
  var path_590186 = newJObject()
  var query_590187 = newJObject()
  add(query_590187, "fields", newJString(fields))
  add(query_590187, "quotaUser", newJString(quotaUser))
  add(query_590187, "alt", newJString(alt))
  add(query_590187, "oauth_token", newJString(oauthToken))
  add(query_590187, "userIp", newJString(userIp))
  add(query_590187, "key", newJString(key))
  add(path_590186, "enterpriseId", newJString(enterpriseId))
  add(query_590187, "prettyPrint", newJBool(prettyPrint))
  add(path_590186, "entitlementId", newJString(entitlementId))
  add(path_590186, "userId", newJString(userId))
  result = call_590185.call(path_590186, query_590187, nil, nil, nil)

var androidenterpriseEntitlementsDelete* = Call_AndroidenterpriseEntitlementsDelete_590171(
    name: "androidenterpriseEntitlementsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/entitlements/{entitlementId}",
    validator: validate_AndroidenterpriseEntitlementsDelete_590172,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseEntitlementsDelete_590173,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserList_590208 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseManagedconfigurationsforuserList_590210(
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

proc validate_AndroidenterpriseManagedconfigurationsforuserList_590209(
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
  var valid_590211 = path.getOrDefault("enterpriseId")
  valid_590211 = validateParameter(valid_590211, JString, required = true,
                                 default = nil)
  if valid_590211 != nil:
    section.add "enterpriseId", valid_590211
  var valid_590212 = path.getOrDefault("userId")
  valid_590212 = validateParameter(valid_590212, JString, required = true,
                                 default = nil)
  if valid_590212 != nil:
    section.add "userId", valid_590212
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
  var valid_590213 = query.getOrDefault("fields")
  valid_590213 = validateParameter(valid_590213, JString, required = false,
                                 default = nil)
  if valid_590213 != nil:
    section.add "fields", valid_590213
  var valid_590214 = query.getOrDefault("quotaUser")
  valid_590214 = validateParameter(valid_590214, JString, required = false,
                                 default = nil)
  if valid_590214 != nil:
    section.add "quotaUser", valid_590214
  var valid_590215 = query.getOrDefault("alt")
  valid_590215 = validateParameter(valid_590215, JString, required = false,
                                 default = newJString("json"))
  if valid_590215 != nil:
    section.add "alt", valid_590215
  var valid_590216 = query.getOrDefault("oauth_token")
  valid_590216 = validateParameter(valid_590216, JString, required = false,
                                 default = nil)
  if valid_590216 != nil:
    section.add "oauth_token", valid_590216
  var valid_590217 = query.getOrDefault("userIp")
  valid_590217 = validateParameter(valid_590217, JString, required = false,
                                 default = nil)
  if valid_590217 != nil:
    section.add "userIp", valid_590217
  var valid_590218 = query.getOrDefault("key")
  valid_590218 = validateParameter(valid_590218, JString, required = false,
                                 default = nil)
  if valid_590218 != nil:
    section.add "key", valid_590218
  var valid_590219 = query.getOrDefault("prettyPrint")
  valid_590219 = validateParameter(valid_590219, JBool, required = false,
                                 default = newJBool(true))
  if valid_590219 != nil:
    section.add "prettyPrint", valid_590219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590220: Call_AndroidenterpriseManagedconfigurationsforuserList_590208;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all the per-user managed configurations for the specified user. Only the ID is set.
  ## 
  let valid = call_590220.validator(path, query, header, formData, body)
  let scheme = call_590220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590220.url(scheme.get, call_590220.host, call_590220.base,
                         call_590220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590220, url, valid)

proc call*(call_590221: Call_AndroidenterpriseManagedconfigurationsforuserList_590208;
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
  var path_590222 = newJObject()
  var query_590223 = newJObject()
  add(query_590223, "fields", newJString(fields))
  add(query_590223, "quotaUser", newJString(quotaUser))
  add(query_590223, "alt", newJString(alt))
  add(query_590223, "oauth_token", newJString(oauthToken))
  add(query_590223, "userIp", newJString(userIp))
  add(query_590223, "key", newJString(key))
  add(path_590222, "enterpriseId", newJString(enterpriseId))
  add(query_590223, "prettyPrint", newJBool(prettyPrint))
  add(path_590222, "userId", newJString(userId))
  result = call_590221.call(path_590222, query_590223, nil, nil, nil)

var androidenterpriseManagedconfigurationsforuserList* = Call_AndroidenterpriseManagedconfigurationsforuserList_590208(
    name: "androidenterpriseManagedconfigurationsforuserList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserList_590209,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserList_590210,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserUpdate_590241 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseManagedconfigurationsforuserUpdate_590243(
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

proc validate_AndroidenterpriseManagedconfigurationsforuserUpdate_590242(
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
  var valid_590244 = path.getOrDefault("enterpriseId")
  valid_590244 = validateParameter(valid_590244, JString, required = true,
                                 default = nil)
  if valid_590244 != nil:
    section.add "enterpriseId", valid_590244
  var valid_590245 = path.getOrDefault("managedConfigurationForUserId")
  valid_590245 = validateParameter(valid_590245, JString, required = true,
                                 default = nil)
  if valid_590245 != nil:
    section.add "managedConfigurationForUserId", valid_590245
  var valid_590246 = path.getOrDefault("userId")
  valid_590246 = validateParameter(valid_590246, JString, required = true,
                                 default = nil)
  if valid_590246 != nil:
    section.add "userId", valid_590246
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
  var valid_590247 = query.getOrDefault("fields")
  valid_590247 = validateParameter(valid_590247, JString, required = false,
                                 default = nil)
  if valid_590247 != nil:
    section.add "fields", valid_590247
  var valid_590248 = query.getOrDefault("quotaUser")
  valid_590248 = validateParameter(valid_590248, JString, required = false,
                                 default = nil)
  if valid_590248 != nil:
    section.add "quotaUser", valid_590248
  var valid_590249 = query.getOrDefault("alt")
  valid_590249 = validateParameter(valid_590249, JString, required = false,
                                 default = newJString("json"))
  if valid_590249 != nil:
    section.add "alt", valid_590249
  var valid_590250 = query.getOrDefault("oauth_token")
  valid_590250 = validateParameter(valid_590250, JString, required = false,
                                 default = nil)
  if valid_590250 != nil:
    section.add "oauth_token", valid_590250
  var valid_590251 = query.getOrDefault("userIp")
  valid_590251 = validateParameter(valid_590251, JString, required = false,
                                 default = nil)
  if valid_590251 != nil:
    section.add "userIp", valid_590251
  var valid_590252 = query.getOrDefault("key")
  valid_590252 = validateParameter(valid_590252, JString, required = false,
                                 default = nil)
  if valid_590252 != nil:
    section.add "key", valid_590252
  var valid_590253 = query.getOrDefault("prettyPrint")
  valid_590253 = validateParameter(valid_590253, JBool, required = false,
                                 default = newJBool(true))
  if valid_590253 != nil:
    section.add "prettyPrint", valid_590253
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

proc call*(call_590255: Call_AndroidenterpriseManagedconfigurationsforuserUpdate_590241;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties.
  ## 
  let valid = call_590255.validator(path, query, header, formData, body)
  let scheme = call_590255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590255.url(scheme.get, call_590255.host, call_590255.base,
                         call_590255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590255, url, valid)

proc call*(call_590256: Call_AndroidenterpriseManagedconfigurationsforuserUpdate_590241;
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
  var path_590257 = newJObject()
  var query_590258 = newJObject()
  var body_590259 = newJObject()
  add(query_590258, "fields", newJString(fields))
  add(query_590258, "quotaUser", newJString(quotaUser))
  add(query_590258, "alt", newJString(alt))
  add(query_590258, "oauth_token", newJString(oauthToken))
  add(query_590258, "userIp", newJString(userIp))
  add(query_590258, "key", newJString(key))
  add(path_590257, "enterpriseId", newJString(enterpriseId))
  add(path_590257, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  if body != nil:
    body_590259 = body
  add(query_590258, "prettyPrint", newJBool(prettyPrint))
  add(path_590257, "userId", newJString(userId))
  result = call_590256.call(path_590257, query_590258, nil, nil, body_590259)

var androidenterpriseManagedconfigurationsforuserUpdate* = Call_AndroidenterpriseManagedconfigurationsforuserUpdate_590241(
    name: "androidenterpriseManagedconfigurationsforuserUpdate",
    meth: HttpMethod.HttpPut, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserUpdate_590242,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserUpdate_590243,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserGet_590224 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseManagedconfigurationsforuserGet_590226(
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

proc validate_AndroidenterpriseManagedconfigurationsforuserGet_590225(
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
  var valid_590227 = path.getOrDefault("enterpriseId")
  valid_590227 = validateParameter(valid_590227, JString, required = true,
                                 default = nil)
  if valid_590227 != nil:
    section.add "enterpriseId", valid_590227
  var valid_590228 = path.getOrDefault("managedConfigurationForUserId")
  valid_590228 = validateParameter(valid_590228, JString, required = true,
                                 default = nil)
  if valid_590228 != nil:
    section.add "managedConfigurationForUserId", valid_590228
  var valid_590229 = path.getOrDefault("userId")
  valid_590229 = validateParameter(valid_590229, JString, required = true,
                                 default = nil)
  if valid_590229 != nil:
    section.add "userId", valid_590229
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
  var valid_590230 = query.getOrDefault("fields")
  valid_590230 = validateParameter(valid_590230, JString, required = false,
                                 default = nil)
  if valid_590230 != nil:
    section.add "fields", valid_590230
  var valid_590231 = query.getOrDefault("quotaUser")
  valid_590231 = validateParameter(valid_590231, JString, required = false,
                                 default = nil)
  if valid_590231 != nil:
    section.add "quotaUser", valid_590231
  var valid_590232 = query.getOrDefault("alt")
  valid_590232 = validateParameter(valid_590232, JString, required = false,
                                 default = newJString("json"))
  if valid_590232 != nil:
    section.add "alt", valid_590232
  var valid_590233 = query.getOrDefault("oauth_token")
  valid_590233 = validateParameter(valid_590233, JString, required = false,
                                 default = nil)
  if valid_590233 != nil:
    section.add "oauth_token", valid_590233
  var valid_590234 = query.getOrDefault("userIp")
  valid_590234 = validateParameter(valid_590234, JString, required = false,
                                 default = nil)
  if valid_590234 != nil:
    section.add "userIp", valid_590234
  var valid_590235 = query.getOrDefault("key")
  valid_590235 = validateParameter(valid_590235, JString, required = false,
                                 default = nil)
  if valid_590235 != nil:
    section.add "key", valid_590235
  var valid_590236 = query.getOrDefault("prettyPrint")
  valid_590236 = validateParameter(valid_590236, JBool, required = false,
                                 default = newJBool(true))
  if valid_590236 != nil:
    section.add "prettyPrint", valid_590236
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590237: Call_AndroidenterpriseManagedconfigurationsforuserGet_590224;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of a per-user managed configuration for an app for the specified user.
  ## 
  let valid = call_590237.validator(path, query, header, formData, body)
  let scheme = call_590237.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590237.url(scheme.get, call_590237.host, call_590237.base,
                         call_590237.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590237, url, valid)

proc call*(call_590238: Call_AndroidenterpriseManagedconfigurationsforuserGet_590224;
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
  var path_590239 = newJObject()
  var query_590240 = newJObject()
  add(query_590240, "fields", newJString(fields))
  add(query_590240, "quotaUser", newJString(quotaUser))
  add(query_590240, "alt", newJString(alt))
  add(query_590240, "oauth_token", newJString(oauthToken))
  add(query_590240, "userIp", newJString(userIp))
  add(query_590240, "key", newJString(key))
  add(path_590239, "enterpriseId", newJString(enterpriseId))
  add(path_590239, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  add(query_590240, "prettyPrint", newJBool(prettyPrint))
  add(path_590239, "userId", newJString(userId))
  result = call_590238.call(path_590239, query_590240, nil, nil, nil)

var androidenterpriseManagedconfigurationsforuserGet* = Call_AndroidenterpriseManagedconfigurationsforuserGet_590224(
    name: "androidenterpriseManagedconfigurationsforuserGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserGet_590225,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserGet_590226,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserPatch_590277 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseManagedconfigurationsforuserPatch_590279(
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

proc validate_AndroidenterpriseManagedconfigurationsforuserPatch_590278(
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
  var valid_590280 = path.getOrDefault("enterpriseId")
  valid_590280 = validateParameter(valid_590280, JString, required = true,
                                 default = nil)
  if valid_590280 != nil:
    section.add "enterpriseId", valid_590280
  var valid_590281 = path.getOrDefault("managedConfigurationForUserId")
  valid_590281 = validateParameter(valid_590281, JString, required = true,
                                 default = nil)
  if valid_590281 != nil:
    section.add "managedConfigurationForUserId", valid_590281
  var valid_590282 = path.getOrDefault("userId")
  valid_590282 = validateParameter(valid_590282, JString, required = true,
                                 default = nil)
  if valid_590282 != nil:
    section.add "userId", valid_590282
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
  var valid_590283 = query.getOrDefault("fields")
  valid_590283 = validateParameter(valid_590283, JString, required = false,
                                 default = nil)
  if valid_590283 != nil:
    section.add "fields", valid_590283
  var valid_590284 = query.getOrDefault("quotaUser")
  valid_590284 = validateParameter(valid_590284, JString, required = false,
                                 default = nil)
  if valid_590284 != nil:
    section.add "quotaUser", valid_590284
  var valid_590285 = query.getOrDefault("alt")
  valid_590285 = validateParameter(valid_590285, JString, required = false,
                                 default = newJString("json"))
  if valid_590285 != nil:
    section.add "alt", valid_590285
  var valid_590286 = query.getOrDefault("oauth_token")
  valid_590286 = validateParameter(valid_590286, JString, required = false,
                                 default = nil)
  if valid_590286 != nil:
    section.add "oauth_token", valid_590286
  var valid_590287 = query.getOrDefault("userIp")
  valid_590287 = validateParameter(valid_590287, JString, required = false,
                                 default = nil)
  if valid_590287 != nil:
    section.add "userIp", valid_590287
  var valid_590288 = query.getOrDefault("key")
  valid_590288 = validateParameter(valid_590288, JString, required = false,
                                 default = nil)
  if valid_590288 != nil:
    section.add "key", valid_590288
  var valid_590289 = query.getOrDefault("prettyPrint")
  valid_590289 = validateParameter(valid_590289, JBool, required = false,
                                 default = newJBool(true))
  if valid_590289 != nil:
    section.add "prettyPrint", valid_590289
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

proc call*(call_590291: Call_AndroidenterpriseManagedconfigurationsforuserPatch_590277;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Adds or updates the managed configuration settings for an app for the specified user. If you support the Managed configurations iframe, you can apply managed configurations to a user by specifying an mcmId and its associated configuration variables (if any) in the request. Alternatively, all EMMs can apply managed configurations by passing a list of managed properties. This method supports patch semantics.
  ## 
  let valid = call_590291.validator(path, query, header, formData, body)
  let scheme = call_590291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590291.url(scheme.get, call_590291.host, call_590291.base,
                         call_590291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590291, url, valid)

proc call*(call_590292: Call_AndroidenterpriseManagedconfigurationsforuserPatch_590277;
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
  var path_590293 = newJObject()
  var query_590294 = newJObject()
  var body_590295 = newJObject()
  add(query_590294, "fields", newJString(fields))
  add(query_590294, "quotaUser", newJString(quotaUser))
  add(query_590294, "alt", newJString(alt))
  add(query_590294, "oauth_token", newJString(oauthToken))
  add(query_590294, "userIp", newJString(userIp))
  add(query_590294, "key", newJString(key))
  add(path_590293, "enterpriseId", newJString(enterpriseId))
  add(path_590293, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  if body != nil:
    body_590295 = body
  add(query_590294, "prettyPrint", newJBool(prettyPrint))
  add(path_590293, "userId", newJString(userId))
  result = call_590292.call(path_590293, query_590294, nil, nil, body_590295)

var androidenterpriseManagedconfigurationsforuserPatch* = Call_AndroidenterpriseManagedconfigurationsforuserPatch_590277(
    name: "androidenterpriseManagedconfigurationsforuserPatch",
    meth: HttpMethod.HttpPatch, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserPatch_590278,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserPatch_590279,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseManagedconfigurationsforuserDelete_590260 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseManagedconfigurationsforuserDelete_590262(
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

proc validate_AndroidenterpriseManagedconfigurationsforuserDelete_590261(
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
  var valid_590263 = path.getOrDefault("enterpriseId")
  valid_590263 = validateParameter(valid_590263, JString, required = true,
                                 default = nil)
  if valid_590263 != nil:
    section.add "enterpriseId", valid_590263
  var valid_590264 = path.getOrDefault("managedConfigurationForUserId")
  valid_590264 = validateParameter(valid_590264, JString, required = true,
                                 default = nil)
  if valid_590264 != nil:
    section.add "managedConfigurationForUserId", valid_590264
  var valid_590265 = path.getOrDefault("userId")
  valid_590265 = validateParameter(valid_590265, JString, required = true,
                                 default = nil)
  if valid_590265 != nil:
    section.add "userId", valid_590265
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
  var valid_590266 = query.getOrDefault("fields")
  valid_590266 = validateParameter(valid_590266, JString, required = false,
                                 default = nil)
  if valid_590266 != nil:
    section.add "fields", valid_590266
  var valid_590267 = query.getOrDefault("quotaUser")
  valid_590267 = validateParameter(valid_590267, JString, required = false,
                                 default = nil)
  if valid_590267 != nil:
    section.add "quotaUser", valid_590267
  var valid_590268 = query.getOrDefault("alt")
  valid_590268 = validateParameter(valid_590268, JString, required = false,
                                 default = newJString("json"))
  if valid_590268 != nil:
    section.add "alt", valid_590268
  var valid_590269 = query.getOrDefault("oauth_token")
  valid_590269 = validateParameter(valid_590269, JString, required = false,
                                 default = nil)
  if valid_590269 != nil:
    section.add "oauth_token", valid_590269
  var valid_590270 = query.getOrDefault("userIp")
  valid_590270 = validateParameter(valid_590270, JString, required = false,
                                 default = nil)
  if valid_590270 != nil:
    section.add "userIp", valid_590270
  var valid_590271 = query.getOrDefault("key")
  valid_590271 = validateParameter(valid_590271, JString, required = false,
                                 default = nil)
  if valid_590271 != nil:
    section.add "key", valid_590271
  var valid_590272 = query.getOrDefault("prettyPrint")
  valid_590272 = validateParameter(valid_590272, JBool, required = false,
                                 default = newJBool(true))
  if valid_590272 != nil:
    section.add "prettyPrint", valid_590272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590273: Call_AndroidenterpriseManagedconfigurationsforuserDelete_590260;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Removes a per-user managed configuration for an app for the specified user.
  ## 
  let valid = call_590273.validator(path, query, header, formData, body)
  let scheme = call_590273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590273.url(scheme.get, call_590273.host, call_590273.base,
                         call_590273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590273, url, valid)

proc call*(call_590274: Call_AndroidenterpriseManagedconfigurationsforuserDelete_590260;
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
  var path_590275 = newJObject()
  var query_590276 = newJObject()
  add(query_590276, "fields", newJString(fields))
  add(query_590276, "quotaUser", newJString(quotaUser))
  add(query_590276, "alt", newJString(alt))
  add(query_590276, "oauth_token", newJString(oauthToken))
  add(query_590276, "userIp", newJString(userIp))
  add(query_590276, "key", newJString(key))
  add(path_590275, "enterpriseId", newJString(enterpriseId))
  add(path_590275, "managedConfigurationForUserId",
      newJString(managedConfigurationForUserId))
  add(query_590276, "prettyPrint", newJBool(prettyPrint))
  add(path_590275, "userId", newJString(userId))
  result = call_590274.call(path_590275, query_590276, nil, nil, nil)

var androidenterpriseManagedconfigurationsforuserDelete* = Call_AndroidenterpriseManagedconfigurationsforuserDelete_590260(
    name: "androidenterpriseManagedconfigurationsforuserDelete",
    meth: HttpMethod.HttpDelete, host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/users/{userId}/managedConfigurationsForUser/{managedConfigurationForUserId}",
    validator: validate_AndroidenterpriseManagedconfigurationsforuserDelete_590261,
    base: "/androidenterprise/v1",
    url: url_AndroidenterpriseManagedconfigurationsforuserDelete_590262,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersGenerateToken_590296 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseUsersGenerateToken_590298(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseUsersGenerateToken_590297(path: JsonNode;
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
  var valid_590299 = path.getOrDefault("enterpriseId")
  valid_590299 = validateParameter(valid_590299, JString, required = true,
                                 default = nil)
  if valid_590299 != nil:
    section.add "enterpriseId", valid_590299
  var valid_590300 = path.getOrDefault("userId")
  valid_590300 = validateParameter(valid_590300, JString, required = true,
                                 default = nil)
  if valid_590300 != nil:
    section.add "userId", valid_590300
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
  var valid_590301 = query.getOrDefault("fields")
  valid_590301 = validateParameter(valid_590301, JString, required = false,
                                 default = nil)
  if valid_590301 != nil:
    section.add "fields", valid_590301
  var valid_590302 = query.getOrDefault("quotaUser")
  valid_590302 = validateParameter(valid_590302, JString, required = false,
                                 default = nil)
  if valid_590302 != nil:
    section.add "quotaUser", valid_590302
  var valid_590303 = query.getOrDefault("alt")
  valid_590303 = validateParameter(valid_590303, JString, required = false,
                                 default = newJString("json"))
  if valid_590303 != nil:
    section.add "alt", valid_590303
  var valid_590304 = query.getOrDefault("oauth_token")
  valid_590304 = validateParameter(valid_590304, JString, required = false,
                                 default = nil)
  if valid_590304 != nil:
    section.add "oauth_token", valid_590304
  var valid_590305 = query.getOrDefault("userIp")
  valid_590305 = validateParameter(valid_590305, JString, required = false,
                                 default = nil)
  if valid_590305 != nil:
    section.add "userIp", valid_590305
  var valid_590306 = query.getOrDefault("key")
  valid_590306 = validateParameter(valid_590306, JString, required = false,
                                 default = nil)
  if valid_590306 != nil:
    section.add "key", valid_590306
  var valid_590307 = query.getOrDefault("prettyPrint")
  valid_590307 = validateParameter(valid_590307, JBool, required = false,
                                 default = newJBool(true))
  if valid_590307 != nil:
    section.add "prettyPrint", valid_590307
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590308: Call_AndroidenterpriseUsersGenerateToken_590296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a token (activation code) to allow this user to configure their managed account in the Android Setup Wizard. Revokes any previously generated token.
  ## 
  ## This call only works with Google managed accounts.
  ## 
  let valid = call_590308.validator(path, query, header, formData, body)
  let scheme = call_590308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590308.url(scheme.get, call_590308.host, call_590308.base,
                         call_590308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590308, url, valid)

proc call*(call_590309: Call_AndroidenterpriseUsersGenerateToken_590296;
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
  var path_590310 = newJObject()
  var query_590311 = newJObject()
  add(query_590311, "fields", newJString(fields))
  add(query_590311, "quotaUser", newJString(quotaUser))
  add(query_590311, "alt", newJString(alt))
  add(query_590311, "oauth_token", newJString(oauthToken))
  add(query_590311, "userIp", newJString(userIp))
  add(query_590311, "key", newJString(key))
  add(path_590310, "enterpriseId", newJString(enterpriseId))
  add(query_590311, "prettyPrint", newJBool(prettyPrint))
  add(path_590310, "userId", newJString(userId))
  result = call_590309.call(path_590310, query_590311, nil, nil, nil)

var androidenterpriseUsersGenerateToken* = Call_AndroidenterpriseUsersGenerateToken_590296(
    name: "androidenterpriseUsersGenerateToken", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/token",
    validator: validate_AndroidenterpriseUsersGenerateToken_590297,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersGenerateToken_590298,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseUsersRevokeToken_590312 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseUsersRevokeToken_590314(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseUsersRevokeToken_590313(path: JsonNode;
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
  var valid_590315 = path.getOrDefault("enterpriseId")
  valid_590315 = validateParameter(valid_590315, JString, required = true,
                                 default = nil)
  if valid_590315 != nil:
    section.add "enterpriseId", valid_590315
  var valid_590316 = path.getOrDefault("userId")
  valid_590316 = validateParameter(valid_590316, JString, required = true,
                                 default = nil)
  if valid_590316 != nil:
    section.add "userId", valid_590316
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
  var valid_590317 = query.getOrDefault("fields")
  valid_590317 = validateParameter(valid_590317, JString, required = false,
                                 default = nil)
  if valid_590317 != nil:
    section.add "fields", valid_590317
  var valid_590318 = query.getOrDefault("quotaUser")
  valid_590318 = validateParameter(valid_590318, JString, required = false,
                                 default = nil)
  if valid_590318 != nil:
    section.add "quotaUser", valid_590318
  var valid_590319 = query.getOrDefault("alt")
  valid_590319 = validateParameter(valid_590319, JString, required = false,
                                 default = newJString("json"))
  if valid_590319 != nil:
    section.add "alt", valid_590319
  var valid_590320 = query.getOrDefault("oauth_token")
  valid_590320 = validateParameter(valid_590320, JString, required = false,
                                 default = nil)
  if valid_590320 != nil:
    section.add "oauth_token", valid_590320
  var valid_590321 = query.getOrDefault("userIp")
  valid_590321 = validateParameter(valid_590321, JString, required = false,
                                 default = nil)
  if valid_590321 != nil:
    section.add "userIp", valid_590321
  var valid_590322 = query.getOrDefault("key")
  valid_590322 = validateParameter(valid_590322, JString, required = false,
                                 default = nil)
  if valid_590322 != nil:
    section.add "key", valid_590322
  var valid_590323 = query.getOrDefault("prettyPrint")
  valid_590323 = validateParameter(valid_590323, JBool, required = false,
                                 default = newJBool(true))
  if valid_590323 != nil:
    section.add "prettyPrint", valid_590323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590324: Call_AndroidenterpriseUsersRevokeToken_590312;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Revokes a previously generated token (activation code) for the user.
  ## 
  let valid = call_590324.validator(path, query, header, formData, body)
  let scheme = call_590324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590324.url(scheme.get, call_590324.host, call_590324.base,
                         call_590324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590324, url, valid)

proc call*(call_590325: Call_AndroidenterpriseUsersRevokeToken_590312;
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
  var path_590326 = newJObject()
  var query_590327 = newJObject()
  add(query_590327, "fields", newJString(fields))
  add(query_590327, "quotaUser", newJString(quotaUser))
  add(query_590327, "alt", newJString(alt))
  add(query_590327, "oauth_token", newJString(oauthToken))
  add(query_590327, "userIp", newJString(userIp))
  add(query_590327, "key", newJString(key))
  add(path_590326, "enterpriseId", newJString(enterpriseId))
  add(query_590327, "prettyPrint", newJBool(prettyPrint))
  add(path_590326, "userId", newJString(userId))
  result = call_590325.call(path_590326, query_590327, nil, nil, nil)

var androidenterpriseUsersRevokeToken* = Call_AndroidenterpriseUsersRevokeToken_590312(
    name: "androidenterpriseUsersRevokeToken", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/users/{userId}/token",
    validator: validate_AndroidenterpriseUsersRevokeToken_590313,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseUsersRevokeToken_590314,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsInsert_590343 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseWebappsInsert_590345(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseWebappsInsert_590344(path: JsonNode;
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
  var valid_590346 = path.getOrDefault("enterpriseId")
  valid_590346 = validateParameter(valid_590346, JString, required = true,
                                 default = nil)
  if valid_590346 != nil:
    section.add "enterpriseId", valid_590346
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
  var valid_590347 = query.getOrDefault("fields")
  valid_590347 = validateParameter(valid_590347, JString, required = false,
                                 default = nil)
  if valid_590347 != nil:
    section.add "fields", valid_590347
  var valid_590348 = query.getOrDefault("quotaUser")
  valid_590348 = validateParameter(valid_590348, JString, required = false,
                                 default = nil)
  if valid_590348 != nil:
    section.add "quotaUser", valid_590348
  var valid_590349 = query.getOrDefault("alt")
  valid_590349 = validateParameter(valid_590349, JString, required = false,
                                 default = newJString("json"))
  if valid_590349 != nil:
    section.add "alt", valid_590349
  var valid_590350 = query.getOrDefault("oauth_token")
  valid_590350 = validateParameter(valid_590350, JString, required = false,
                                 default = nil)
  if valid_590350 != nil:
    section.add "oauth_token", valid_590350
  var valid_590351 = query.getOrDefault("userIp")
  valid_590351 = validateParameter(valid_590351, JString, required = false,
                                 default = nil)
  if valid_590351 != nil:
    section.add "userIp", valid_590351
  var valid_590352 = query.getOrDefault("key")
  valid_590352 = validateParameter(valid_590352, JString, required = false,
                                 default = nil)
  if valid_590352 != nil:
    section.add "key", valid_590352
  var valid_590353 = query.getOrDefault("prettyPrint")
  valid_590353 = validateParameter(valid_590353, JBool, required = false,
                                 default = newJBool(true))
  if valid_590353 != nil:
    section.add "prettyPrint", valid_590353
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

proc call*(call_590355: Call_AndroidenterpriseWebappsInsert_590343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new web app for the enterprise.
  ## 
  let valid = call_590355.validator(path, query, header, formData, body)
  let scheme = call_590355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590355.url(scheme.get, call_590355.host, call_590355.base,
                         call_590355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590355, url, valid)

proc call*(call_590356: Call_AndroidenterpriseWebappsInsert_590343;
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
  var path_590357 = newJObject()
  var query_590358 = newJObject()
  var body_590359 = newJObject()
  add(query_590358, "fields", newJString(fields))
  add(query_590358, "quotaUser", newJString(quotaUser))
  add(query_590358, "alt", newJString(alt))
  add(query_590358, "oauth_token", newJString(oauthToken))
  add(query_590358, "userIp", newJString(userIp))
  add(query_590358, "key", newJString(key))
  add(path_590357, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_590359 = body
  add(query_590358, "prettyPrint", newJBool(prettyPrint))
  result = call_590356.call(path_590357, query_590358, nil, nil, body_590359)

var androidenterpriseWebappsInsert* = Call_AndroidenterpriseWebappsInsert_590343(
    name: "androidenterpriseWebappsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/webApps",
    validator: validate_AndroidenterpriseWebappsInsert_590344,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsInsert_590345,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsList_590328 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseWebappsList_590330(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseWebappsList_590329(path: JsonNode; query: JsonNode;
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
  var valid_590331 = path.getOrDefault("enterpriseId")
  valid_590331 = validateParameter(valid_590331, JString, required = true,
                                 default = nil)
  if valid_590331 != nil:
    section.add "enterpriseId", valid_590331
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
  var valid_590332 = query.getOrDefault("fields")
  valid_590332 = validateParameter(valid_590332, JString, required = false,
                                 default = nil)
  if valid_590332 != nil:
    section.add "fields", valid_590332
  var valid_590333 = query.getOrDefault("quotaUser")
  valid_590333 = validateParameter(valid_590333, JString, required = false,
                                 default = nil)
  if valid_590333 != nil:
    section.add "quotaUser", valid_590333
  var valid_590334 = query.getOrDefault("alt")
  valid_590334 = validateParameter(valid_590334, JString, required = false,
                                 default = newJString("json"))
  if valid_590334 != nil:
    section.add "alt", valid_590334
  var valid_590335 = query.getOrDefault("oauth_token")
  valid_590335 = validateParameter(valid_590335, JString, required = false,
                                 default = nil)
  if valid_590335 != nil:
    section.add "oauth_token", valid_590335
  var valid_590336 = query.getOrDefault("userIp")
  valid_590336 = validateParameter(valid_590336, JString, required = false,
                                 default = nil)
  if valid_590336 != nil:
    section.add "userIp", valid_590336
  var valid_590337 = query.getOrDefault("key")
  valid_590337 = validateParameter(valid_590337, JString, required = false,
                                 default = nil)
  if valid_590337 != nil:
    section.add "key", valid_590337
  var valid_590338 = query.getOrDefault("prettyPrint")
  valid_590338 = validateParameter(valid_590338, JBool, required = false,
                                 default = newJBool(true))
  if valid_590338 != nil:
    section.add "prettyPrint", valid_590338
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590339: Call_AndroidenterpriseWebappsList_590328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves the details of all web apps for a given enterprise.
  ## 
  let valid = call_590339.validator(path, query, header, formData, body)
  let scheme = call_590339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590339.url(scheme.get, call_590339.host, call_590339.base,
                         call_590339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590339, url, valid)

proc call*(call_590340: Call_AndroidenterpriseWebappsList_590328;
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
  var path_590341 = newJObject()
  var query_590342 = newJObject()
  add(query_590342, "fields", newJString(fields))
  add(query_590342, "quotaUser", newJString(quotaUser))
  add(query_590342, "alt", newJString(alt))
  add(query_590342, "oauth_token", newJString(oauthToken))
  add(query_590342, "userIp", newJString(userIp))
  add(query_590342, "key", newJString(key))
  add(path_590341, "enterpriseId", newJString(enterpriseId))
  add(query_590342, "prettyPrint", newJBool(prettyPrint))
  result = call_590340.call(path_590341, query_590342, nil, nil, nil)

var androidenterpriseWebappsList* = Call_AndroidenterpriseWebappsList_590328(
    name: "androidenterpriseWebappsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/enterprises/{enterpriseId}/webApps",
    validator: validate_AndroidenterpriseWebappsList_590329,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsList_590330,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsUpdate_590376 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseWebappsUpdate_590378(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseWebappsUpdate_590377(path: JsonNode;
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
  var valid_590379 = path.getOrDefault("webAppId")
  valid_590379 = validateParameter(valid_590379, JString, required = true,
                                 default = nil)
  if valid_590379 != nil:
    section.add "webAppId", valid_590379
  var valid_590380 = path.getOrDefault("enterpriseId")
  valid_590380 = validateParameter(valid_590380, JString, required = true,
                                 default = nil)
  if valid_590380 != nil:
    section.add "enterpriseId", valid_590380
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
  var valid_590381 = query.getOrDefault("fields")
  valid_590381 = validateParameter(valid_590381, JString, required = false,
                                 default = nil)
  if valid_590381 != nil:
    section.add "fields", valid_590381
  var valid_590382 = query.getOrDefault("quotaUser")
  valid_590382 = validateParameter(valid_590382, JString, required = false,
                                 default = nil)
  if valid_590382 != nil:
    section.add "quotaUser", valid_590382
  var valid_590383 = query.getOrDefault("alt")
  valid_590383 = validateParameter(valid_590383, JString, required = false,
                                 default = newJString("json"))
  if valid_590383 != nil:
    section.add "alt", valid_590383
  var valid_590384 = query.getOrDefault("oauth_token")
  valid_590384 = validateParameter(valid_590384, JString, required = false,
                                 default = nil)
  if valid_590384 != nil:
    section.add "oauth_token", valid_590384
  var valid_590385 = query.getOrDefault("userIp")
  valid_590385 = validateParameter(valid_590385, JString, required = false,
                                 default = nil)
  if valid_590385 != nil:
    section.add "userIp", valid_590385
  var valid_590386 = query.getOrDefault("key")
  valid_590386 = validateParameter(valid_590386, JString, required = false,
                                 default = nil)
  if valid_590386 != nil:
    section.add "key", valid_590386
  var valid_590387 = query.getOrDefault("prettyPrint")
  valid_590387 = validateParameter(valid_590387, JBool, required = false,
                                 default = newJBool(true))
  if valid_590387 != nil:
    section.add "prettyPrint", valid_590387
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

proc call*(call_590389: Call_AndroidenterpriseWebappsUpdate_590376; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing web app.
  ## 
  let valid = call_590389.validator(path, query, header, formData, body)
  let scheme = call_590389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590389.url(scheme.get, call_590389.host, call_590389.base,
                         call_590389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590389, url, valid)

proc call*(call_590390: Call_AndroidenterpriseWebappsUpdate_590376;
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
  var path_590391 = newJObject()
  var query_590392 = newJObject()
  var body_590393 = newJObject()
  add(query_590392, "fields", newJString(fields))
  add(query_590392, "quotaUser", newJString(quotaUser))
  add(query_590392, "alt", newJString(alt))
  add(path_590391, "webAppId", newJString(webAppId))
  add(query_590392, "oauth_token", newJString(oauthToken))
  add(query_590392, "userIp", newJString(userIp))
  add(query_590392, "key", newJString(key))
  add(path_590391, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_590393 = body
  add(query_590392, "prettyPrint", newJBool(prettyPrint))
  result = call_590390.call(path_590391, query_590392, nil, nil, body_590393)

var androidenterpriseWebappsUpdate* = Call_AndroidenterpriseWebappsUpdate_590376(
    name: "androidenterpriseWebappsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsUpdate_590377,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsUpdate_590378,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsGet_590360 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseWebappsGet_590362(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseWebappsGet_590361(path: JsonNode; query: JsonNode;
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
  var valid_590363 = path.getOrDefault("webAppId")
  valid_590363 = validateParameter(valid_590363, JString, required = true,
                                 default = nil)
  if valid_590363 != nil:
    section.add "webAppId", valid_590363
  var valid_590364 = path.getOrDefault("enterpriseId")
  valid_590364 = validateParameter(valid_590364, JString, required = true,
                                 default = nil)
  if valid_590364 != nil:
    section.add "enterpriseId", valid_590364
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
  var valid_590365 = query.getOrDefault("fields")
  valid_590365 = validateParameter(valid_590365, JString, required = false,
                                 default = nil)
  if valid_590365 != nil:
    section.add "fields", valid_590365
  var valid_590366 = query.getOrDefault("quotaUser")
  valid_590366 = validateParameter(valid_590366, JString, required = false,
                                 default = nil)
  if valid_590366 != nil:
    section.add "quotaUser", valid_590366
  var valid_590367 = query.getOrDefault("alt")
  valid_590367 = validateParameter(valid_590367, JString, required = false,
                                 default = newJString("json"))
  if valid_590367 != nil:
    section.add "alt", valid_590367
  var valid_590368 = query.getOrDefault("oauth_token")
  valid_590368 = validateParameter(valid_590368, JString, required = false,
                                 default = nil)
  if valid_590368 != nil:
    section.add "oauth_token", valid_590368
  var valid_590369 = query.getOrDefault("userIp")
  valid_590369 = validateParameter(valid_590369, JString, required = false,
                                 default = nil)
  if valid_590369 != nil:
    section.add "userIp", valid_590369
  var valid_590370 = query.getOrDefault("key")
  valid_590370 = validateParameter(valid_590370, JString, required = false,
                                 default = nil)
  if valid_590370 != nil:
    section.add "key", valid_590370
  var valid_590371 = query.getOrDefault("prettyPrint")
  valid_590371 = validateParameter(valid_590371, JBool, required = false,
                                 default = newJBool(true))
  if valid_590371 != nil:
    section.add "prettyPrint", valid_590371
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590372: Call_AndroidenterpriseWebappsGet_590360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets an existing web app.
  ## 
  let valid = call_590372.validator(path, query, header, formData, body)
  let scheme = call_590372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590372.url(scheme.get, call_590372.host, call_590372.base,
                         call_590372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590372, url, valid)

proc call*(call_590373: Call_AndroidenterpriseWebappsGet_590360; webAppId: string;
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
  var path_590374 = newJObject()
  var query_590375 = newJObject()
  add(query_590375, "fields", newJString(fields))
  add(query_590375, "quotaUser", newJString(quotaUser))
  add(query_590375, "alt", newJString(alt))
  add(path_590374, "webAppId", newJString(webAppId))
  add(query_590375, "oauth_token", newJString(oauthToken))
  add(query_590375, "userIp", newJString(userIp))
  add(query_590375, "key", newJString(key))
  add(path_590374, "enterpriseId", newJString(enterpriseId))
  add(query_590375, "prettyPrint", newJBool(prettyPrint))
  result = call_590373.call(path_590374, query_590375, nil, nil, nil)

var androidenterpriseWebappsGet* = Call_AndroidenterpriseWebappsGet_590360(
    name: "androidenterpriseWebappsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsGet_590361,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsGet_590362,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsPatch_590410 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseWebappsPatch_590412(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseWebappsPatch_590411(path: JsonNode; query: JsonNode;
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
  var valid_590413 = path.getOrDefault("webAppId")
  valid_590413 = validateParameter(valid_590413, JString, required = true,
                                 default = nil)
  if valid_590413 != nil:
    section.add "webAppId", valid_590413
  var valid_590414 = path.getOrDefault("enterpriseId")
  valid_590414 = validateParameter(valid_590414, JString, required = true,
                                 default = nil)
  if valid_590414 != nil:
    section.add "enterpriseId", valid_590414
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
  var valid_590415 = query.getOrDefault("fields")
  valid_590415 = validateParameter(valid_590415, JString, required = false,
                                 default = nil)
  if valid_590415 != nil:
    section.add "fields", valid_590415
  var valid_590416 = query.getOrDefault("quotaUser")
  valid_590416 = validateParameter(valid_590416, JString, required = false,
                                 default = nil)
  if valid_590416 != nil:
    section.add "quotaUser", valid_590416
  var valid_590417 = query.getOrDefault("alt")
  valid_590417 = validateParameter(valid_590417, JString, required = false,
                                 default = newJString("json"))
  if valid_590417 != nil:
    section.add "alt", valid_590417
  var valid_590418 = query.getOrDefault("oauth_token")
  valid_590418 = validateParameter(valid_590418, JString, required = false,
                                 default = nil)
  if valid_590418 != nil:
    section.add "oauth_token", valid_590418
  var valid_590419 = query.getOrDefault("userIp")
  valid_590419 = validateParameter(valid_590419, JString, required = false,
                                 default = nil)
  if valid_590419 != nil:
    section.add "userIp", valid_590419
  var valid_590420 = query.getOrDefault("key")
  valid_590420 = validateParameter(valid_590420, JString, required = false,
                                 default = nil)
  if valid_590420 != nil:
    section.add "key", valid_590420
  var valid_590421 = query.getOrDefault("prettyPrint")
  valid_590421 = validateParameter(valid_590421, JBool, required = false,
                                 default = newJBool(true))
  if valid_590421 != nil:
    section.add "prettyPrint", valid_590421
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

proc call*(call_590423: Call_AndroidenterpriseWebappsPatch_590410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing web app. This method supports patch semantics.
  ## 
  let valid = call_590423.validator(path, query, header, formData, body)
  let scheme = call_590423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590423.url(scheme.get, call_590423.host, call_590423.base,
                         call_590423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590423, url, valid)

proc call*(call_590424: Call_AndroidenterpriseWebappsPatch_590410;
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
  var path_590425 = newJObject()
  var query_590426 = newJObject()
  var body_590427 = newJObject()
  add(query_590426, "fields", newJString(fields))
  add(query_590426, "quotaUser", newJString(quotaUser))
  add(query_590426, "alt", newJString(alt))
  add(path_590425, "webAppId", newJString(webAppId))
  add(query_590426, "oauth_token", newJString(oauthToken))
  add(query_590426, "userIp", newJString(userIp))
  add(query_590426, "key", newJString(key))
  add(path_590425, "enterpriseId", newJString(enterpriseId))
  if body != nil:
    body_590427 = body
  add(query_590426, "prettyPrint", newJBool(prettyPrint))
  result = call_590424.call(path_590425, query_590426, nil, nil, body_590427)

var androidenterpriseWebappsPatch* = Call_AndroidenterpriseWebappsPatch_590410(
    name: "androidenterpriseWebappsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsPatch_590411,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsPatch_590412,
    schemes: {Scheme.Https})
type
  Call_AndroidenterpriseWebappsDelete_590394 = ref object of OpenApiRestCall_588450
proc url_AndroidenterpriseWebappsDelete_590396(protocol: Scheme; host: string;
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

proc validate_AndroidenterpriseWebappsDelete_590395(path: JsonNode;
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
  var valid_590397 = path.getOrDefault("webAppId")
  valid_590397 = validateParameter(valid_590397, JString, required = true,
                                 default = nil)
  if valid_590397 != nil:
    section.add "webAppId", valid_590397
  var valid_590398 = path.getOrDefault("enterpriseId")
  valid_590398 = validateParameter(valid_590398, JString, required = true,
                                 default = nil)
  if valid_590398 != nil:
    section.add "enterpriseId", valid_590398
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
  var valid_590399 = query.getOrDefault("fields")
  valid_590399 = validateParameter(valid_590399, JString, required = false,
                                 default = nil)
  if valid_590399 != nil:
    section.add "fields", valid_590399
  var valid_590400 = query.getOrDefault("quotaUser")
  valid_590400 = validateParameter(valid_590400, JString, required = false,
                                 default = nil)
  if valid_590400 != nil:
    section.add "quotaUser", valid_590400
  var valid_590401 = query.getOrDefault("alt")
  valid_590401 = validateParameter(valid_590401, JString, required = false,
                                 default = newJString("json"))
  if valid_590401 != nil:
    section.add "alt", valid_590401
  var valid_590402 = query.getOrDefault("oauth_token")
  valid_590402 = validateParameter(valid_590402, JString, required = false,
                                 default = nil)
  if valid_590402 != nil:
    section.add "oauth_token", valid_590402
  var valid_590403 = query.getOrDefault("userIp")
  valid_590403 = validateParameter(valid_590403, JString, required = false,
                                 default = nil)
  if valid_590403 != nil:
    section.add "userIp", valid_590403
  var valid_590404 = query.getOrDefault("key")
  valid_590404 = validateParameter(valid_590404, JString, required = false,
                                 default = nil)
  if valid_590404 != nil:
    section.add "key", valid_590404
  var valid_590405 = query.getOrDefault("prettyPrint")
  valid_590405 = validateParameter(valid_590405, JBool, required = false,
                                 default = newJBool(true))
  if valid_590405 != nil:
    section.add "prettyPrint", valid_590405
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590406: Call_AndroidenterpriseWebappsDelete_590394; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an existing web app.
  ## 
  let valid = call_590406.validator(path, query, header, formData, body)
  let scheme = call_590406.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590406.url(scheme.get, call_590406.host, call_590406.base,
                         call_590406.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590406, url, valid)

proc call*(call_590407: Call_AndroidenterpriseWebappsDelete_590394;
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
  var path_590408 = newJObject()
  var query_590409 = newJObject()
  add(query_590409, "fields", newJString(fields))
  add(query_590409, "quotaUser", newJString(quotaUser))
  add(query_590409, "alt", newJString(alt))
  add(path_590408, "webAppId", newJString(webAppId))
  add(query_590409, "oauth_token", newJString(oauthToken))
  add(query_590409, "userIp", newJString(userIp))
  add(query_590409, "key", newJString(key))
  add(path_590408, "enterpriseId", newJString(enterpriseId))
  add(query_590409, "prettyPrint", newJBool(prettyPrint))
  result = call_590407.call(path_590408, query_590409, nil, nil, nil)

var androidenterpriseWebappsDelete* = Call_AndroidenterpriseWebappsDelete_590394(
    name: "androidenterpriseWebappsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/enterprises/{enterpriseId}/webApps/{webAppId}",
    validator: validate_AndroidenterpriseWebappsDelete_590395,
    base: "/androidenterprise/v1", url: url_AndroidenterpriseWebappsDelete_590396,
    schemes: {Scheme.Https})
type
  Call_AndroidenterprisePermissionsGet_590428 = ref object of OpenApiRestCall_588450
proc url_AndroidenterprisePermissionsGet_590430(protocol: Scheme; host: string;
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

proc validate_AndroidenterprisePermissionsGet_590429(path: JsonNode;
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
  var valid_590431 = path.getOrDefault("permissionId")
  valid_590431 = validateParameter(valid_590431, JString, required = true,
                                 default = nil)
  if valid_590431 != nil:
    section.add "permissionId", valid_590431
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
  var valid_590432 = query.getOrDefault("fields")
  valid_590432 = validateParameter(valid_590432, JString, required = false,
                                 default = nil)
  if valid_590432 != nil:
    section.add "fields", valid_590432
  var valid_590433 = query.getOrDefault("quotaUser")
  valid_590433 = validateParameter(valid_590433, JString, required = false,
                                 default = nil)
  if valid_590433 != nil:
    section.add "quotaUser", valid_590433
  var valid_590434 = query.getOrDefault("alt")
  valid_590434 = validateParameter(valid_590434, JString, required = false,
                                 default = newJString("json"))
  if valid_590434 != nil:
    section.add "alt", valid_590434
  var valid_590435 = query.getOrDefault("language")
  valid_590435 = validateParameter(valid_590435, JString, required = false,
                                 default = nil)
  if valid_590435 != nil:
    section.add "language", valid_590435
  var valid_590436 = query.getOrDefault("oauth_token")
  valid_590436 = validateParameter(valid_590436, JString, required = false,
                                 default = nil)
  if valid_590436 != nil:
    section.add "oauth_token", valid_590436
  var valid_590437 = query.getOrDefault("userIp")
  valid_590437 = validateParameter(valid_590437, JString, required = false,
                                 default = nil)
  if valid_590437 != nil:
    section.add "userIp", valid_590437
  var valid_590438 = query.getOrDefault("key")
  valid_590438 = validateParameter(valid_590438, JString, required = false,
                                 default = nil)
  if valid_590438 != nil:
    section.add "key", valid_590438
  var valid_590439 = query.getOrDefault("prettyPrint")
  valid_590439 = validateParameter(valid_590439, JBool, required = false,
                                 default = newJBool(true))
  if valid_590439 != nil:
    section.add "prettyPrint", valid_590439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590440: Call_AndroidenterprisePermissionsGet_590428;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves details of an Android app permission for display to an enterprise admin.
  ## 
  let valid = call_590440.validator(path, query, header, formData, body)
  let scheme = call_590440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590440.url(scheme.get, call_590440.host, call_590440.base,
                         call_590440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590440, url, valid)

proc call*(call_590441: Call_AndroidenterprisePermissionsGet_590428;
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
  var path_590442 = newJObject()
  var query_590443 = newJObject()
  add(query_590443, "fields", newJString(fields))
  add(query_590443, "quotaUser", newJString(quotaUser))
  add(query_590443, "alt", newJString(alt))
  add(query_590443, "language", newJString(language))
  add(query_590443, "oauth_token", newJString(oauthToken))
  add(path_590442, "permissionId", newJString(permissionId))
  add(query_590443, "userIp", newJString(userIp))
  add(query_590443, "key", newJString(key))
  add(query_590443, "prettyPrint", newJBool(prettyPrint))
  result = call_590441.call(path_590442, query_590443, nil, nil, nil)

var androidenterprisePermissionsGet* = Call_AndroidenterprisePermissionsGet_590428(
    name: "androidenterprisePermissionsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/permissions/{permissionId}",
    validator: validate_AndroidenterprisePermissionsGet_590429,
    base: "/androidenterprise/v1", url: url_AndroidenterprisePermissionsGet_590430,
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
